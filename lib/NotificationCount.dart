import 'package:flutter/foundation.dart';

class NotificationCount extends ChangeNotifier {
  int count = 0;

  void updateCount(int newCount) {
    count = newCount;
    notifyListeners();
  }
}
