import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  int selectedAvatar = 0;

  final List<IconData> avatars = const [
    FontAwesomeIcons.userAstronaut,
    FontAwesomeIcons.userNinja,
    FontAwesomeIcons.userSecret,
  ];

  final List<Color> avatarColors = const [
    Colors.blue,
    Colors.green,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
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
                  Text("login".tr(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "username".tr(),
                      prefixIcon: const Icon(Icons.person, color: Colors.blueAccent, size: 30),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "password".tr(),
                      prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent, size: 30),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("choose_avatar".tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(avatars.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedAvatar = index);
                        },
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: selectedAvatar == index ? avatarColors[index].withOpacity(0.8) : Colors.grey[300],
                          child: Icon(
                            avatars[index],
                            size: 30,
                            color: selectedAvatar == index ? Colors.white : avatarColors[index],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final username = _usernameController.text.trim().isEmpty ? 'Guest' : _usernameController.text.trim();
                        await context.read<AuthProvider>().login(username, selectedAvatar);
                        if (!mounted) return;
                        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                      },
                      child: Text("login".tr()),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () async {
                      await context.read<AuthProvider>().continueAsGuest();
                      if (!mounted) return;
                      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                    },
                    child: Text("continue_guest".tr()),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
