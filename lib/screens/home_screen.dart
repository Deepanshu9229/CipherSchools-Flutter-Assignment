import 'package:expense_tracker_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/budget_provider.dart';
import '../models/expense.dart';
import '../widgets/expense_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedCategory = 'Food';
  bool isIncome = false;
  final List<String> categories = ['Food', 'Transport', 'Shopping', 'Bills'];

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final budgetProvider = Provider.of<BudgetProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    double totalIncome = expenseProvider.expenses
        .where((e) => e.isIncome)
        .fold(0, (prev, e) => prev + e.amount);
    double totalExpense = expenseProvider.expenses
        .where((e) => !e.isIncome)
        .fold(0, (prev, e) => prev + e.amount);
    double budgetLimit = budgetProvider.monthlyBudget;
    double budgetUsedPercentage =
        budgetLimit > 0 ? (totalExpense / budgetLimit) * 100 : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
  icon: const Icon(Icons.logout),
  onPressed: () async {
    await Provider.of<AuthProvider>(context, listen: false).signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  },
)
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 5),
          _buildSummary(totalIncome, totalExpense, budgetUsedPercentage),
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // attach the scroll controller
              reverse: false,
              itemCount: expenseProvider.expenses.length,
              itemBuilder: (context, index) {
                Expense expense = expenseProvider.expenses[index];
                return Dismissible(
                  key: Key(expense.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    expenseProvider.deleteExpense(expense);
                    // After deletion, scroll to the top
                    _scrollController.animateTo(
                      0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ExpenseItem(expense: expense),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseDialog(context, expenseProvider),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF7F3DFF),
      ),
    );
  }

  Widget _buildSummary(
      double totalIncome, double totalExpense, double budgetUsedPercentage) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Top Row: Account Balance, Circular Progress, and Set Budget Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Account Balance Column
              Column(
                children: [
                  Text('Account Balance',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Text('₹${(totalIncome - totalExpense).toStringAsFixed(2)}',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7F3DFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Set Budget',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),

              SizedBox(width: 20),
              // Circular Progress Indicator with Percentage and "Used"
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: budgetUsedPercentage / 100,
                      backgroundColor: Colors.grey[300],
                      color: budgetUsedPercentage >= 80
                          ? Colors.red
                          : Colors.green,
                      strokeWidth: 8,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${budgetUsedPercentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text("Used", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 20),
          // Middle Row: Income & Expense Boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                  'Income', '₹${totalIncome.toStringAsFixed(2)}', Colors.green),
              _buildStatCard('Expenses', '₹${totalExpense.toStringAsFixed(2)}',
                  Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog(
      BuildContext context, ExpenseProvider expenseProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text('Add Expense/Income'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
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
                      setStateDialog(() => selectedCategory = newValue);
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

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
