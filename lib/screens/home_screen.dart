import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';
import '../widgets/expense_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controllers and default selections for the add expense dialog.
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedCategory = 'Food';
  bool isIncome = false;
  final List<String> categories = ['Food', 'Travel', 'Subscriptions', 'Shopping'];

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    double totalIncome = expenseProvider.expenses
        .where((e) => e.isIncome)
        .fold(0, (prev, e) => prev + e.amount);
    double totalExpense = expenseProvider.expenses
        .where((e) => !e.isIncome)
        .fold(0, (prev, e) => prev + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Summary Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Income',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('\$${totalIncome.toStringAsFixed(2)}'),
                  ],
                ),
                Column(
                  children: [
                    Text('Expenses',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('\$${totalExpense.toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ),
          ),
          // Expenses List
          Expanded(
            child: ListView.builder(
              itemCount: expenseProvider.expenses.length,
              itemBuilder: (context, index) {
                Expense expense = expenseProvider.expenses[index];
                return Dismissible(
                  key: Key(expense.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    expenseProvider.deleteExpense(expense);
                  },
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

  void _showAddExpenseDialog(BuildContext context, expenseProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setStateDialog(() {
                          selectedCategory = newValue;
                        });
                      }
                    },
                    items: categories.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SwitchListTile(
                    title: Text('Is Income'),
                    value: isIncome,
                    onChanged: (val) {
                      setStateDialog(() {
                        isIncome = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel')),
              ElevatedButton(
                  onPressed: () {
                    final expense = Expense(
                      id: DateTime.now().toString(),
                      title: titleController.text,
                      amount: double.tryParse(amountController.text) ?? 0,
                      category: selectedCategory,
                      date: DateTime.now(),
                      isIncome: isIncome,
                    );
                    expenseProvider.addExpense(expense);
                    titleController.clear();
                    amountController.clear();
                    Navigator.of(context).pop();
                  },
                  child: Text('Add'))
            ],
          );
        });
      },
    );
  }
}
