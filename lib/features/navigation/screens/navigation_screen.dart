import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart' show Position;
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/order_provider.dart';
import '../../../core/providers/tour_provider.dart';
import '../../../core/services/location_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../orders/models/order_model.dart';
import '../../tour/tour_keys.dart';

enum RouteTarget { pickup, dropoff }

class NavigationScreen extends StatefulWidget {
  final String orderId;

  const NavigationScreen({super.key, required this.orderId});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final MapController _mapController = MapController();
  final LocationService _locationService = LocationService();
  final _tourKeys = TourKeys.instance;

  OrderModel? _order;
  LatLng? _currentLocation;
  RouteTarget _routeTarget = RouteTarget.pickup;
  List<LatLng> _routePoints = [];
  String _currentInstruction = '';
  String _distanceRemaining = '--';
  String _timeRemaining = '--';
  bool _isLoading = true;
  bool _isUpdating = false;
  bool _locationError = false;
  String? _locationErrorMessage;
  bool _isTourMode = false;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  @override
  void dispose() {
    _locationService.stopLocationUpdates();
    super.dispose();
  }

  void _loadOrder() {
    final orderProvider = context.read<OrderProvider>();
    final tourProvider = context.read<TourProvider>();
    _isTourMode = tourProvider.isTourActive;

    // Check active order first
    if (orderProvider.activeOrder?.id == widget.orderId) {
      _order = orderProvider.activeOrder;
    }
    // Check pending order
    else if (orderProvider.pendingOrder?.id == widget.orderId) {
      _order = orderProvider.pendingOrder;
    }
    // Check order history
    else {
      final historyOrder = orderProvider.orderHistory
          .where((o) => o.id == widget.orderId)
          .firstOrNull;
      if (historyOrder != null) {
        _order = historyOrder;
      }
    }

    if (_order != null) {
      // Set initial route target based on order status:
      // - Before "on the way" (pending, accepted, etc.) → pickup
      // - "On the way" or later (delivered, completed) → dropoff
      final status = _order!.status;
      if (status == OrderStatus.onTheWay ||
          status == OrderStatus.delivered ||
          status == OrderStatus.completed) {
        _routeTarget = RouteTarget.dropoff;
      } else {
        _routeTarget = RouteTarget.pickup;
      }

      if (_isTourMode) {
        // During tour, skip real GPS and route fetching — use mock static data
        _currentLocation = LatLng(
          (_order!.pickupLat ?? 37.7749) + 0.002,
          (_order!.pickupLng ?? -122.4194) + 0.001,
        );
        _currentInstruction = 'Turn right onto Main Street';
        _distanceRemaining = _order!.formattedDistance;
        _timeRemaining = '${_order!.estimatedMinutes} min';
        _routePoints = [
          _currentLocation!,
          if (_pickupLocation != null) _pickupLocation!,
        ];
        setState(() => _isLoading = false);
      } else {
        // Get real GPS location
        _initLocation();
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _initLocation() async {
    final result = await _locationService.getCurrentLocation();

    if (result.success && result.position != null) {
      _currentLocation = LatLng(
        result.position!.latitude,
        result.position!.longitude,
      );
      _locationError = false;
      _locationErrorMessage = null;

      // Start continuous location updates
      _locationService.startLocationUpdates(
        onLocationUpdate: _onLocationUpdate,
        onError: (error) {
          debugPrint('Location update error: $error');
        },
      );

      _fetchRoute();
    } else {
      // Fallback to pickup location if GPS fails
      setState(() {
        _locationError = true;
        _locationErrorMessage = result.message ?? 'Could not get location';
        // Use pickup as fallback
        if (_order?.pickupLat != null && _order?.pickupLng != null) {
          _currentLocation = LatLng(
            _order!.pickupLat! + 0.001,
            _order!.pickupLng! + 0.001,
          );
        }
        _isLoading = false;
      });

      // Still try to fetch route with fallback location
      if (_currentLocation != null) {
        _fetchRoute();
      }
    }
  }

  void _onLocationUpdate(Position position) {
    final newLocation = LatLng(position.latitude, position.longitude);

    // Only update if location changed significantly (more than ~10 meters)
    if (_currentLocation == null ||
        _calculateDistance(_currentLocation!, newLocation) > 0.01) {
      setState(() {
        _currentLocation = newLocation;
        _locationError = false;
      });

      // Recalculate route with new location
      _fetchRoute();
    }
  }

  double _calculateDistance(LatLng from, LatLng to) {
    const distance = Distance();
    return distance.as(LengthUnit.Kilometer, from, to);
  }

  LatLng? get _pickupLocation {
    if (_order?.pickupLat != null && _order?.pickupLng != null) {
      return LatLng(_order!.pickupLat!, _order!.pickupLng!);
    }
    return null;
  }

  LatLng? get _dropoffLocation {
    if (_order?.dropoffLat != null && _order?.dropoffLng != null) {
      return LatLng(_order!.dropoffLat!, _order!.dropoffLng!);
    }
    return null;
  }

  LatLng? get _targetLocation {
    return _routeTarget == RouteTarget.pickup ? _pickupLocation : _dropoffLocation;
  }

  Future<void> _fetchRoute() async {
    if (_currentLocation == null || _targetLocation == null) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final start = _currentLocation!;
      final end = _targetLocation!;

      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}'
        '?overview=full&geometries=geojson&steps=true',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry']['coordinates'] as List;

          _routePoints = geometry.map<LatLng>((coord) {
            return LatLng(coord[1].toDouble(), coord[0].toDouble());
          }).toList();

          final distance = route['distance'] / 1000;
          final duration = route['duration'] / 60;

          _distanceRemaining = '${distance.toStringAsFixed(1)} km';
          _timeRemaining = '${duration.toInt()} min';

          if (route['legs'] != null && route['legs'].isNotEmpty) {
            final steps = route['legs'][0]['steps'] as List;
            if (steps.isNotEmpty && steps.length > 1) {
              final nextStep = steps[1];
              final maneuver = nextStep['maneuver'];
              final name = nextStep['name'] ?? 'the road';
              _currentInstruction = _formatInstruction(
                maneuver['type'],
                maneuver['modifier'],
                name,
              );
            } else {
              _currentInstruction = 'Continue straight';
            }
          }
        }
      }
    } catch (e) {
      _routePoints = [_currentLocation!, _targetLocation!];
      _currentInstruction = 'Head towards destination';
      _distanceRemaining = _order?.formattedDistance ?? '-- km';
      _timeRemaining = '${_order?.estimatedMinutes ?? '--'} min';
    }

    if (mounted) {
      setState(() => _isLoading = false);
      _fitMapToBounds();
    }
  }

  void _fitMapToBounds() {
    if (_routePoints.isEmpty) return;

    try {
      final bounds = LatLngBounds.fromPoints(_routePoints);
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(60),
        ),
      );
    } catch (_) {}
  }

  String _formatInstruction(String? type, String? modifier, String roadName) {
    String instruction;

    switch (type) {
      case 'turn':
        if (modifier == 'left') {
          instruction = 'Turn left';
        } else if (modifier == 'right') {
          instruction = 'Turn right';
        } else if (modifier == 'slight left') {
          instruction = 'Slight left';
        } else if (modifier == 'slight right') {
          instruction = 'Slight right';
        } else {
          instruction = 'Turn $modifier';
        }
        break;
      case 'continue':
        instruction = 'Continue straight';
        break;
      case 'roundabout':
        instruction = 'Enter roundabout';
        break;
      case 'arrive':
        instruction = 'Arrive at destination';
        break;
      case 'depart':
        instruction = 'Head towards';
        break;
      default:
        instruction = 'Continue';
    }

    if (roadName.isNotEmpty && roadName != 'the road') {
      instruction += ' onto $roadName';
    }

    return instruction;
  }

  IconData _getInstructionIcon() {
    if (_currentInstruction.toLowerCase().contains('left')) {
      return Icons.turn_left;
    } else if (_currentInstruction.toLowerCase().contains('right')) {
      return Icons.turn_right;
    } else if (_currentInstruction.toLowerCase().contains('roundabout')) {
      return Icons.roundabout_left;
    } else if (_currentInstruction.toLowerCase().contains('arrive')) {
      return Icons.flag;
    }
    return Icons.straight;
  }

  void _switchRoute(RouteTarget target) {
    if (_routeTarget != target) {
      setState(() => _routeTarget = target);
      _fetchRoute();
    }
  }

  Future<void> _openInExternalMaps() async {
    final target = _targetLocation;
    if (target == null) return;

    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${target.latitude},${target.longitude}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _confirmCompletion(AppLocalizations l10n) async {
    final order = _order;
    if (order == null) return;

    final message = order.needsCashCollection
        ? '${l10n.collectCashReminder}\n\n${l10n.completeOrderConfirmation}'
        : l10n.completeOrderConfirmation;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.completeOrder),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _updateOrderStatus(OrderStatus.completed);
    }
  }

  Future<void> _updateOrderStatus(OrderStatus newStatus) async {
    if (_isUpdating || _order == null) return;

    setState(() => _isUpdating = true);

    final orderProvider = context.read<OrderProvider>();
    bool success = false;

    switch (newStatus) {
      case OrderStatus.onTheWay:
        success = await orderProvider.startDelivery();
        break;
      case OrderStatus.delivered:
        success = await orderProvider.markDelivered();
        break;
      case OrderStatus.completed:
        success = await orderProvider.completeOrder();
        break;
      default:
        break;
    }

    if (mounted) {
      setState(() {
        _isUpdating = false;
        if (success) {
          _order = orderProvider.activeOrder ?? _order!.copyWith(status: newStatus);
          // Auto switch to dropoff after starting delivery
          if (newStatus == OrderStatus.onTheWay) {
            _switchRoute(RouteTarget.dropoff);
          }
        }
      });

      if (success && newStatus == OrderStatus.completed) {
        context.pop();
      } else if (!success) {
        final l10n = AppLocalizations.of(context)!;
        final error = orderProvider.error ?? l10n.failedToUpdateStatus;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final l10n = AppLocalizations.of(context)!;

    if (_order == null) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: secondaryColor),
              const SizedBox(height: 12),
              Text(l10n.orderNotFound, style: TextStyle(color: secondaryColor)),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(l10n.goBack),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation ?? const LatLng(0, 0),
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.tybetogo.driver',
              ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: _routeTarget == RouteTarget.pickup
                          ? AppColors.primary
                          : AppColors.error,
                      strokeWidth: 4,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  if (_currentLocation != null)
                    _buildMarker(_currentLocation!, Icons.navigation, AppColors.info),
                  if (_pickupLocation != null)
                    _buildMarker(_pickupLocation!, Icons.store, AppColors.primary),
                  if (_dropoffLocation != null)
                    _buildMarker(_dropoffLocation!, Icons.location_on, AppColors.error),
                ],
              ),
            ],
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildIconButton(
                    icon: Icons.close,
                    onPressed: () => context.pop(),
                    surfaceColor: surfaceColor,
                    iconColor: textColor,
                  ),
                  const Spacer(),
                  _buildIconButton(
                    icon: Icons.my_location,
                    onPressed: () {
                      if (_currentLocation != null) {
                        _mapController.move(_currentLocation!, 15);
                      }
                    },
                    surfaceColor: surfaceColor,
                    iconColor: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),

          // Location error banner (below top buttons)
          if (_locationError)
            Positioned(
              top: MediaQuery.of(context).padding.top + 65,
              left: 16,
              right: 16,
              child: _buildLocationErrorBanner(surfaceColor),
            ),

          // Instruction card (below top buttons)
          Positioned(
            key: _isTourMode ? _tourKeys.navigationInstructionCardKey : null,
            top: MediaQuery.of(context).padding.top + (_locationError ? 115 : 65),
            left: 16,
            right: 16,
            child: _buildInstructionCard(surfaceColor, textColor, secondaryColor),
          ),

          // Bottom panel
          Positioned(
            key: _isTourMode ? _tourKeys.navigationBottomPanelKey : null,
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomPanel(
              surfaceColor,
              textColor,
              secondaryColor,
              l10n,
            ),
          ),

          // Loading overlay
          if (_isUpdating)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationErrorBanner(Color surfaceColor) {
    return GestureDetector(
      onTap: () async {
        final status = await _locationService.checkPermission();
        if (status == LocationPermissionStatus.deniedForever) {
          await _locationService.openAppSettings();
        } else if (status == LocationPermissionStatus.serviceDisabled) {
          await _locationService.openLocationSettings();
        } else {
          // Retry getting location
          _initLocation();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_off, color: AppColors.warning, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _locationErrorMessage ?? AppLocalizations.of(context)!.gpsUnavailableTapRetry,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.warning,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.refresh, color: AppColors.warning, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color surfaceColor,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: 20),
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  Widget _buildInstructionCard(
    Color surfaceColor,
    Color textColor,
    Color secondaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : Icon(_getInstructionIcon(), color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentInstruction.isEmpty ? AppLocalizations.of(context)!.calculatingRoute : _currentInstruction,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildMiniChip(
                      Icons.route,
                      _distanceRemaining,
                      AppColors.info,
                    ),
                    const SizedBox(width: 6),
                    _buildMiniChip(
                      Icons.schedule,
                      _timeRemaining,
                      AppColors.warning,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(
    Color surfaceColor,
    Color textColor,
    Color secondaryColor,
    AppLocalizations l10n,
  ) {
    final order = _order!;
    final isPickupPhase = order.status == OrderStatus.accepted;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Order info row
              _buildOrderInfoRow(order, textColor, secondaryColor, l10n),
              const SizedBox(height: 12),

              // Route toggle buttons
              _buildRouteToggle(surfaceColor, textColor, secondaryColor, l10n),
              const SizedBox(height: 10),

              // Destination info with Google Maps button
              _buildDestinationInfo(textColor, secondaryColor, l10n),
              const SizedBox(height: 10),

              // Payment status banner
              _buildPaymentBanner(order, l10n),
              const SizedBox(height: 10),

              // Action buttons row
              _buildActionButtons(l10n, isPickupPhase),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderInfoRow(
    OrderModel order,
    Color textColor,
    Color secondaryColor,
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        // Order ID
        _buildMiniChip(Icons.tag, '#${order.id}', secondaryColor),
        const SizedBox(width: 8),
        // Status
        _buildStatusChip(order.status, l10n),
        const Spacer(),
        // Earnings
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            order.formattedTotal,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.success,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(OrderStatus status, AppLocalizations l10n) {
    Color color;
    String text;

    switch (status) {
      case OrderStatus.accepted:
        color = AppColors.info;
        break;
      case OrderStatus.onTheWay:
        color = AppColors.primary;
        break;
      case OrderStatus.delivered:
        color = AppColors.success;
        break;
      default:
        color = AppColors.warning;
    }

    text = status.localizedName(l10n);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPaymentBanner(OrderModel order, AppLocalizations l10n) {
    if (!order.hasPaymentInfo) return const SizedBox.shrink();

    final needsCash = order.needsCashCollection;
    final color = needsCash ? AppColors.error : AppColors.success;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            needsCash ? Icons.payments : Icons.check_circle,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            needsCash ? l10n.collectCash : l10n.orderPaid,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n, bool isPickupPhase) {
    return Row(
      key: _isTourMode ? _tourKeys.navigationActionButtonKey : null,
      children: [
        // Google Maps button
        SizedBox(
          height: 46,
          width: 46,
          child: OutlinedButton(
            onPressed: _openInExternalMaps,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.info,
              side: const BorderSide(color: AppColors.info),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.zero,
            ),
            child: const Icon(Icons.map_outlined, size: 20),
          ),
        ),
        const SizedBox(width: 10),
        // Action button
        Expanded(
          child: _buildActionButton(l10n, isPickupPhase),
        ),
      ],
    );
  }

  Widget _buildRouteToggle(
    Color surfaceColor,
    Color textColor,
    Color secondaryColor,
    AppLocalizations l10n,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              icon: Icons.store,
              label: l10n.pickup,
              subtitle: _order?.pickupName ?? '',
              isSelected: _routeTarget == RouteTarget.pickup,
              color: AppColors.primary,
              onTap: () => _switchRoute(RouteTarget.pickup),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _buildToggleButton(
              icon: Icons.location_on,
              label: l10n.dropoff,
              subtitle: _order?.customerName ?? '',
              isSelected: _routeTarget == RouteTarget.dropoff,
              color: AppColors.error,
              onTap: () => _switchRoute(RouteTarget.dropoff),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final secondaryColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? surfaceColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: color.withValues(alpha: 0.3)) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? color : secondaryColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? color : secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? textColor : secondaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationInfo(
    Color textColor,
    Color secondaryColor,
    AppLocalizations l10n,
  ) {
    final order = _order!;
    final isPickup = _routeTarget == RouteTarget.pickup;
    final color = isPickup ? AppColors.primary : AppColors.error;

    final title = isPickup ? order.pickupName : order.customerName;
    final address = isPickup
        ? (order.pickupStreet ?? order.pickupAddress)
        : (order.dropoffStreet ?? order.dropoffAddress);
    final city = isPickup ? order.pickupCity : order.dropoffCity;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isPickup ? Icons.store : Icons.location_on,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                if (!isPickup && order.customerPhone != null && order.customerPhone!.isNotEmpty) ...[
                  Text(
                    order.customerPhone!,
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  city ?? address,
                  style: TextStyle(fontSize: 12, color: secondaryColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _distanceRemaining,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                _timeRemaining,
                style: TextStyle(fontSize: 11, color: secondaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(AppLocalizations l10n, bool isPickupPhase) {
    final order = _order!;
    String text;
    IconData icon;
    Color color = AppColors.primary;
    VoidCallback? onPressed;

    switch (order.status) {
      case OrderStatus.accepted:
        text = l10n.onTheWay;
        icon = Icons.directions_car;
        onPressed = () => _updateOrderStatus(OrderStatus.onTheWay);
        break;
      case OrderStatus.onTheWay:
        text = l10n.markAsDelivered;
        icon = Icons.location_on;
        onPressed = () => _updateOrderStatus(OrderStatus.delivered);
        break;
      case OrderStatus.delivered:
        text = l10n.orderCompleted;
        icon = Icons.check_circle;
        color = AppColors.success;
        onPressed = () => _confirmCompletion(l10n);
        break;
      default:
        text = l10n.navigate;
        icon = Icons.navigation;
        onPressed = null;
    }

    return SizedBox(
      height: 46,
      child: ElevatedButton.icon(
        onPressed: _isUpdating ? null : onPressed,
        icon: _isUpdating
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(icon, size: 18),
        label: Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Marker _buildMarker(LatLng point, IconData icon, Color color) {
    return Marker(
      point: point,
      width: 36,
      height: 36,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
