import 'package:flutter/material.dart';

/// A ChangeNotifier class that manages the current index for navigation.
class NavigationProvider extends ChangeNotifier {
  int currentIndex = 0;

  /// Changes the current index and notifies listeners about the change.
  ///
  /// [newIndex]: The new index to set as the current index.
  void changeIndex(int newIndex) {
    currentIndex = newIndex;
    notifyListeners(); // Notify listeners about the change
  }
}
