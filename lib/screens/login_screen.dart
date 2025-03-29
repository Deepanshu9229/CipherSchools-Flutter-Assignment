import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker - Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await authProvider.signInWithGoogle();
            if (authProvider.isAuthenticated) {
              // Navigate to HomeScreen if sign-in was successful.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
