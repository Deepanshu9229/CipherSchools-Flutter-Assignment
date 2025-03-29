import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color bgColor;
  final Color textColor;

  const StatCard({
    Key? key,
    required this.label,
    required this.amount,
    required this.bgColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
          ),
          SizedBox(height: 8),
          Text(
            '\Rs. ${amount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16, color: textColor),
          ),
        ],
      ),
    );
  }
}
