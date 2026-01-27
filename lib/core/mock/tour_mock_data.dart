import '../../features/orders/models/order_model.dart';
import '../models/driver_profile.dart';

class TourMockData {
  /// Creates a realistic mock food delivery order for tour demonstration
  static OrderModel createMockOrder() {
    return OrderModel(
      id: 'TOUR_MOCK_001',
      orderType: OrderType.food,
      status: OrderStatus.pending,

      // Pickup location - Restaurant
      pickupAddress: '123 Main Street, Downtown',
      pickupName: 'Tasty Bites Restaurant',
      pickupStreet: '123 Main Street',
      pickupCity: 'Downtown',
      pickupLat: 37.7749,
      pickupLng: -122.4194,

      // Dropoff location - Customer
      dropoffAddress: '456 Oak Avenue, Apartment 5B',
      dropoffStreet: '456 Oak Avenue',
      dropoffCity: 'Residential Area',
      dropoffLat: 37.7849,
      dropoffLng: -122.4094,

      // Customer info
      customerName: 'John Smith',
      customerPhone: '+1234567890',

      // Restaurant info
      restaurantId: 101,
      restaurantName: 'Tasty Bites Restaurant',

      // Pricing breakdown
      subtotal: 25.50,
      deliveryFee: 5.00,
      tip: 3.50,
      total: 34.00,

      // Distance and time
      distance: 2.5,
      estimatedMinutes: 15,

      // Order items
      items: [
        OrderItem(
          id: 1,
          name: 'Margherita Pizza',
          quantity: 1,
          price: 12.99,
        ),
        OrderItem(
          id: 2,
          name: 'Caesar Salad',
          quantity: 1,
          price: 8.99,
        ),
        OrderItem(
          id: 3,
          name: 'Coca Cola',
          quantity: 2,
          price: 1.76,
        ),
      ],

      // Timestamps
      createdAt: DateTime.now(),
    );
  }

  /// Creates a second mock order for variety
  static OrderModel createMockOrder2() {
    return OrderModel(
      id: 'TOUR_MOCK_002',
      orderType: OrderType.food,
      status: OrderStatus.pending,

      pickupAddress: '789 Restaurant Row',
      pickupName: 'Burger Palace',
      pickupStreet: '789 Restaurant Row',
      pickupCity: 'City Center',
      pickupLat: 37.7650,
      pickupLng: -122.4100,

      dropoffAddress: '321 Pine Street, Suite 12',
      dropoffStreet: '321 Pine Street',
      dropoffCity: 'Business District',
      dropoffLat: 37.7750,
      dropoffLng: -122.4000,

      customerName: 'Sarah Johnson',
      customerPhone: '+1234567891',

      restaurantId: 102,
      restaurantName: 'Burger Palace',

      subtotal: 18.99,
      deliveryFee: 4.50,
      tip: 2.50,
      total: 25.99,

      distance: 1.8,
      estimatedMinutes: 12,

      items: [
        OrderItem(
          id: 1,
          name: 'Classic Burger',
          quantity: 2,
          price: 9.99,
        ),
        OrderItem(
          id: 2,
          name: 'French Fries',
          quantity: 1,
          price: 4.99,
        ),
        OrderItem(
          id: 3,
          name: 'Milkshake',
          quantity: 1,
          price: 4.01,
        ),
      ],

      createdAt: DateTime.now(),
    );
  }

  /// Creates a mock driver profile for tour demonstrations
  static DriverProfile createMockProfile({
    bool isVerified = false,
    bool isOnline = false,
  }) {
    return DriverProfile(
      id: 999,
      firstName: 'Demo',
      lastName: 'Driver',
      phone: '+1234567890',
      email: 'demo@driver.com',
      avatarUrl: null,
      rating: 4.8,
      totalOrders: 42,
      totalEarnings: 450.00,
      isOnline: isOnline,
      isVerified: isVerified,
      vehicleType: 'CAR',
      vehiclePlate: 'DEMO123',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }

  /// Check if an order ID is from the tour/mock system
  static bool isMockOrder(String orderId) {
    return orderId.startsWith('TOUR_MOCK_');
  }

  /// Get all available mock orders
  static List<OrderModel> getAllMockOrders() {
    return [
      createMockOrder(),
      createMockOrder2(),
    ];
  }
}
