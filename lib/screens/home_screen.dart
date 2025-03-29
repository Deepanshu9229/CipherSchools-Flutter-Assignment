import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';
import '../widgets/expense_item.dart';
import '../widgets/stat_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedCategory = 'Food';
  bool isIncome = false;
  final List<String> categories = ['Food', 'Travel', 'Subscriptions', 'Shopping'];

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Calculate total income, total expense, and net balance
    double totalIncome = expenseProvider.expenses
        .where((e) => e.isIncome)
        .fold(0, (sum, e) => sum + e.amount);
    double totalExpense = expenseProvider.expenses
        .where((e) => !e.isIncome)
        .fold(0, (sum, e) => sum + e.amount);
    double accountBalance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          // Centered Account Balance
          Text(
            'Account Balance',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 4),
          Text(
            '₹${accountBalance.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          // Two StatCards for Income & Expenses
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Income',
                    amount: totalIncome,
                    bgColor: Colors.green[50]!,
                    textColor: Colors.green[700]!,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'Expenses',
                    amount: totalExpense,
                    bgColor: Colors.red[50]!,
                    textColor: Colors.red[700]!,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Expanded list of transactions
          Expanded(
            child: ListView.builder(
              itemCount: expenseProvider.expenses.length,
              itemBuilder: (context, index) {
                final expense = expenseProvider.expenses[index];
                return Dismissible(
                  key: Key(expense.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => expenseProvider.deleteExpense(expense),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ExpenseItem(expense: expense),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddExpenseDialog(context, expenseProvider);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context, ExpenseProvider expenseProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text('Add Expense/Income'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                  ),
                  DropdownButton<String>(
                    value: selectedCategory,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setStateDialog(() {
                          selectedCategory = newValue;
                        });
                      }
                    },
                    items: categories
                        .map((value) => DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            ))
                        .toList(),
                  ),
                  SwitchListTile(
                    title: Text('Is Income'),
                    value: isIncome,
                    onChanged: (val) => setStateDialog(() => isIncome = val),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final newExpense = Expense(
                    id: DateTime.now().toString(),
                    title: titleController.text,
                    amount: double.tryParse(amountController.text) ?? 0,
                    category: selectedCategory,
                    date: DateTime.now(),
                    isIncome: isIncome,
                  );
                  expenseProvider.addExpense(newExpense);
                  titleController.clear();
                  amountController.clear();
                  Navigator.of(context).pop();
                },
                child: Text('Add'),
              ),
            ],
          );
        });
      },
    );
  }
}
