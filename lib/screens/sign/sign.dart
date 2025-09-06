import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../login/login_screen.dart';

class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: Text("sign_up".tr()),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "create_account".tr(),
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "username".tr(),
                      prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(
                      labelText: "email".tr(),
                      prefixIcon: const Icon(Icons.email, color: Colors.blueAccent),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "password".tr(),
                      prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 25),
                  // زر Create
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // هنا ممكن تضيف وظيفة إنشاء الحساب
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );

                        Future.delayed(const Duration(milliseconds: 300), () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("account_created_success".tr()),
                              backgroundColor: Colors.green,
                            ),
                          );
                        });
                      },
                      child: Text("create".tr()),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // زر العودة للـ Login
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      "already_have_account_login".tr(),
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
