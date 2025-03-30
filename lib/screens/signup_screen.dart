import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: size.height * 0.15),
              Text(
                "Sign Up",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                "Create a new account",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  await authProvider.signUpWithGoogle();
                  if (authProvider.isAuthenticated) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  } else {
                    print("User authentication failed");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7F3DFF),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Sign Up with Google",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: TextStyle(color: Color(0xFF7F3DFF), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
