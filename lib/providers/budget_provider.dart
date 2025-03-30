import 'package:flutter/material.dart';

class BudgetProvider with ChangeNotifier {
  double _monthlyBudget = 20000; // Default budget

  double get monthlyBudget => _monthlyBudget;

  void setBudget(double newBudget) {
    _monthlyBudget = newBudget;
    notifyListeners();
  }
}
