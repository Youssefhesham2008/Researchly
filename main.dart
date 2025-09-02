import 'package:flutter/material.dart';
import 'login.dart';  
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const LoginPage(), // هنا بيفتح صفحة اللوج ان
    );
  }
}
