import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../providers/auth_provider.dart';
import '../../app/app.dart';
import '../login/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final currentLocale = context.locale;

    return Scaffold(
      appBar: AppBar(title: Text('profile'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 32, child: Icon(auth.currentAvatar, size: 28)),
            const SizedBox(height: 8),
            Text(auth.username ?? 'Guest', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              children: [
                Text('change_language'.tr()),
                const Spacer(),
                DropdownButton<Locale>(
                  value: currentLocale,
                  items: const [
                    DropdownMenuItem(value: Locale('en'), child: Text('English')),
                    DropdownMenuItem(value: Locale('ar'), child: Text('العربية')),
                  ],
                  onChanged: (loc) async {
                    if (loc == null) return;
                    await context.setLocale(loc);
                  },
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () async {
                await context.read<AuthProvider>().logout();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (r) => false);
              },
              icon: const Icon(Icons.logout),
              label: Text('logout'.tr()),
            )
          ],
        ),
      ),
    );
  }
}



