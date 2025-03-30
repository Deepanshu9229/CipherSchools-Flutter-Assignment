import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'providers/auth_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/budget_provider.dart'; // Added BudgetProvider
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/local_storage_service.dart';
import 'screens/settings_screen.dart'; // Fix file name (should be settings_screen.dart)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Hive (and open your expenses box)
  await Hive.initFlutter();
  await LocalStorageService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(
            create: (_) => BudgetProvider()), // Added BudgetProvider
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: ThemeData(
          primaryColor: Color(0xFF7F3DFF),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return authProvider.isAuthenticated ? HomeScreen() : LoginScreen();
          },
        ),
        routes: {
       
          '/settings': (context) => SettingsScreen(),
        },
      ),
    );
  }
}
