import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final String email;
  final String phone;

  const ProfilePage({
    super.key,
    required this.username,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF073743),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة الحساب بدل Avatar
              const Icon(Icons.account_circle,
                  size: 120, color: Colors.white70),
              const SizedBox(height: 20),

              // Username
              Text(
                username,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),

              // Email
              _buildInfoRow(Icons.email, email),
              const SizedBox(height: 10),

              // Phone
              _buildInfoRow(Icons.phone, phone),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.redAccent),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
