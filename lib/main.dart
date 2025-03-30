import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'providers/auth_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/budget_provider.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/local_storage_service.dart';
import 'screens/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
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
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ExpenseProvider>(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider<BudgetProvider>(create: (_) => BudgetProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, 
        title: 'Expense Tracker',
        theme: ThemeData(
          primaryColor: Color(0xFF7F3DFF),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            // If user is authenticated, show HomeScreen; otherwise, show SignupScreen.
            return authProvider.isAuthenticated ? HomeScreen() : SignupScreen();
          },
        ),
        routes: {
          '/settings': (context) => SettingsScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/home':(context) => HomeScreen(),
        },
      ),
    );
  }
}
