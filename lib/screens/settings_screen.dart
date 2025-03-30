import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double _budget;

  @override
  void initState() {
    super.initState();
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
    _budget = budgetProvider.monthlyBudget;
  }

  @override
  Widget build(BuildContext context) {
    final budgetProvider = Provider.of<BudgetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Monthly Budget',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '₹${_budget.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _budget,
              min: 5000,
              max: 100000,
              divisions: 19,
              label: _budget.toStringAsFixed(0),
              onChanged: (value) {
                setState(() {
                  _budget = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                budgetProvider.setBudget(_budget);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Budget Updated to ₹${_budget.toStringAsFixed(0)}')),
                );
              },
              child: Text('Save Budget'),
            ),
          ],
        ),
      ),
    );
  }
}
