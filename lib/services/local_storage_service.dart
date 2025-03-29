import 'package:hive/hive.dart';
import '../models/expense.dart';

class LocalStorageService {
  static const String boxName = 'expensesBox';

  static Future<void> init() async {
    await Hive.openBox(boxName);
  }

  static Future<List<Expense>> getExpenses() async {
    final box = Hive.box(boxName);
    final expenses = box.get('expenses', defaultValue: []);
    if (expenses is List) {
      return expenses
          .map((e) => Expense.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  static Future<void> saveExpenses(List<Expense> expenses) async {
    final box = Hive.box(boxName);
    List<Map<String, dynamic>> expenseMaps =
        expenses.map((e) => e.toMap()).toList();
    await box.put('expenses', expenseMaps);
  }
}
