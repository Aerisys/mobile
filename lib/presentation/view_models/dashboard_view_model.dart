import 'package:flutter/foundation.dart';
import '../../data/models/dashboard_widget_model.dart';

class DashboardViewModel extends ChangeNotifier {
  // Top slot is a wide widget (like Battery)
  DashboardWidgetType? topSlot = DashboardWidgetType.battery;

  // We have a 3x2 grid, so 6 slots.
  // Initially, let's put Pressure in the 3rd slot (index 2) as seen in screenshot
  final List<DashboardWidgetType?> smallSlots = [
    null,
    null,
    DashboardWidgetType.pressure,
    null,
    null,
    null,
  ];

  void setTopSlot(DashboardWidgetType? type) {
    topSlot = type;
    notifyListeners();
  }

  void setSmallSlot(int index, DashboardWidgetType? type) {
    if (index >= 0 && index < smallSlots.length) {
      smallSlots[index] = type;
      notifyListeners();
    }
  }

  void removeTopSlot() {
    topSlot = null;
    notifyListeners();
  }

  void removeSmallSlot(int index) {
    if (index >= 0 && index < smallSlots.length) {
      smallSlots[index] = null;
      notifyListeners();
    }
  }
}
