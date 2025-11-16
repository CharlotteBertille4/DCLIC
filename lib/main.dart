import 'package:flutter/material.dart';
import 'package:projet_dclic/screens/login_screen.dart';
import 'package:projet_dclic/screens/register_screen.dart';
import 'package:projet_dclic/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mes notes',
      // theme: appTheme,
      initialRoute: '/login',
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
