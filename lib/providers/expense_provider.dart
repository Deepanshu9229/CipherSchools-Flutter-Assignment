import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/local_storage_service.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  ExpenseProvider() {
    _loadExpenses();
  }

  void _loadExpenses() async {
    _expenses = await LocalStorageService.getExpenses();
    notifyListeners();
  }

void addExpense(Expense expense) {
  _expenses.insert(0, expense); 
  notifyListeners();
}


  Future<void> deleteExpense(Expense expense) async {
    _expenses.remove(expense);
    await LocalStorageService.saveExpenses(_expenses);
    notifyListeners();
  }
}
