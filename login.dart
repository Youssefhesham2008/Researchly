import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int selectedAvatar = 0;

  final List<IconData> avatars = [
    FontAwesomeIcons.userAstronaut,
    FontAwesomeIcons.userNinja,
    FontAwesomeIcons.userSecret,
  ];

  final List<Color> avatarColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Username
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Icons.person,color: Colors.blueAccent,size: 30,),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Password
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock,color: Colors.blueAccent,size: 30,),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Avatar selection
                  const Text(
                    "Choose your Avatar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(avatars.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAvatar = index;
                          });
                        },
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: selectedAvatar == index
                              ? avatarColors[index].withOpacity(0.8)
                              : Colors.grey[300],
                          child: Icon(
                            avatars[index],
                            size: 30,
                            color: selectedAvatar == index
                                ? Colors.white
                                : avatarColors[index],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 25),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final username = _usernameController.text;
                        final password = _passwordController.text;
                        debugPrint(
                            "Username: $username, Password: $password, Avatar: ${avatars[selectedAvatar]}");
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
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
