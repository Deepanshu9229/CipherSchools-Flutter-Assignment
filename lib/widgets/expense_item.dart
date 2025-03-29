import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:intl/intl.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  ExpenseItem({required this.expense});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        expense.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
        color: expense.isIncome ? Colors.green : Colors.red,
      ),
      title: Text(expense.title),
      subtitle: Text('${expense.category} • ${DateFormat.yMMMd().format(expense.date)}'),
      trailing: Text('\Rs. ${expense.amount.toStringAsFixed(2)}'),
    );
  }
}
