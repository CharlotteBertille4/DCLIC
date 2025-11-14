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
        // When navigating to the "/" route, build the FirstScreen widget.
        '/register': (context) => const RegisterScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/login': (context) => const LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: RegisterScreen(),
    );
  }
}
