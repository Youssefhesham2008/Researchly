import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../utils/prefs_helper.dart';
import '../login/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  void _next() {
    if (_index < 2) {
      _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await PrefsHelper.setSeenOnboarding(true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildPage('onboarding_1_title'.tr(), 'onboarding_1_body'.tr(), Icons.search),
      _buildPage('onboarding_2_title'.tr(), 'onboarding_2_body'.tr(), Icons.forum),
      _buildPage('onboarding_3_title'.tr(), 'onboarding_3_body'.tr(), Icons.favorite),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _finish,
            child: Text('skip'.tr()),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (i) => setState(() => _index = i),
              children: pages,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Row(
                  children: List.generate(
                    pages.length,
                        (i) => Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: i == _index ? Theme.of(context).colorScheme.primary : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _next,
                  child: Text(_index < 2 ? 'next'.tr() : 'get_started'.tr()),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPage(String title, String body, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: 24),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(body, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}





