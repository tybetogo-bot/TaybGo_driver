import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../models/order_model.dart';

extension OrderTypePresentation on OrderType {
  IconData get icon => switch (this) {
    OrderType.food => Icons.restaurant_outlined,
    OrderType.shipping => Icons.inventory_2_outlined,
    OrderType.taxi => Icons.local_taxi_outlined,
  };

  Color get color => switch (this) {
    OrderType.food => AppColors.warning,
    OrderType.shipping => AppColors.primary,
    OrderType.taxi => AppColors.info,
  };

  String label(AppLocalizations l10n) => switch (this) {
    OrderType.food => l10n.foodOrder,
    OrderType.shipping => l10n.shippingOrder,
    OrderType.taxi => l10n.taxiRide,
  };

  String acceptLabel(AppLocalizations l10n) => switch (this) {
    OrderType.food => l10n.acceptOrder,
    OrderType.shipping => l10n.acceptShippingOrder,
    OrderType.taxi => l10n.acceptRide,
  };

  String referenceLabel(AppLocalizations l10n, String id) =>
      '${label(l10n)} #$id';
}

extension OrderVehicleTypePresentation on OrderVehicleType {
  String label(AppLocalizations l10n) => switch (this) {
    OrderVehicleType.bike => l10n.bicycle,
    OrderVehicleType.motor => l10n.motorcycle,
    OrderVehicleType.car => l10n.car,
    OrderVehicleType.van => l10n.van,
  };
}

extension OrderCarSizePresentation on OrderCarSize {
  String label(AppLocalizations l10n) => switch (this) {
    OrderCarSize.x => l10n.carSizeX,
    OrderCarSize.comfort => l10n.carSizeComfort,
    OrderCarSize.xl => l10n.carSizeXL,
    OrderCarSize.black => l10n.carSizeBlack,
  };
}
