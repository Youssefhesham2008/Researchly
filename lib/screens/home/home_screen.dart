import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../providers/auth_provider.dart';
import '../../providers/paper_provider.dart';
import 'papers_tab.dart';
import 'forums_tab.dart';
import 'saved_tab.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PaperProvider>().fetch());
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final pages = [
      const PapersTab(),
      const ForumsTab(),
      const SavedTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('${'hi'.tr()}, ${auth.username ?? 'Guest'}'),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              child: Icon(auth.currentAvatar, size: 16),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'profile'.tr(),
            onPressed: () => Navigator.pushNamed(context, ProfileScreen.routeName),
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.article_outlined), selectedIcon: const Icon(Icons.article), label: 'papers'.tr()),
          NavigationDestination(icon: const Icon(Icons.forum_outlined), selectedIcon: const Icon(Icons.forum), label: 'forums'.tr()),
          NavigationDestination(icon: const Icon(Icons.bookmark_border), selectedIcon: const Icon(Icons.bookmark), label: 'saved'.tr()),
        ],
      ),
    );
  }
}









