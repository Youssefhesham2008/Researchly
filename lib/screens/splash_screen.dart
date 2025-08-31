import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scisky_social_network/providers/auth_provider.dart';
import 'package:scisky_social_network/screens/home_screen.dart';
import 'package:scisky_social_network/screens/onboarding_screen.dart'; // Assuming this is the intended next screen for new users
import 'package:flutter/foundation.dart'; // For debugPrint

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint('SplashScreen: initState called');
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    debugPrint('SplashScreen: _checkAuthAndNavigate started');
    // Simulate a delay for splash screen
    await Future.delayed(const Duration(seconds: 2));
    debugPrint('SplashScreen: Delay finished');

    if (!mounted) {
      debugPrint('SplashScreen: Not mounted after delay. Aborting navigation.');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    debugPrint('SplashScreen: AuthProvider obtained. Checking isAuthenticated...');

    // Determine the next page based on authentication status
    Widget nextPage;
    String routeNameLog;

    // This logic needs to align with how AuthProvider is set up.
    // The log "Continuing as Guest" implies AuthProvider might set a guest status.
    // Let's assume if not explicitly authenticated, user goes to Onboarding or Login.
    // Given 'onboarding_screen.dart' was recently edited, let's assume it's the target for new/guest users.

    if (authProvider.isAuthenticated) {
      debugPrint('SplashScreen: User IS authenticated. Preparing to navigate to HomeScreen.');
      nextPage = const HomeScreen();
      routeNameLog = 'HomeScreen';
    } else {
      debugPrint('SplashScreen: User is NOT authenticated. Preparing to navigate to OnboardingScreen.');
      nextPage = const OnboardingScreen(); // Or LoginScreen, depending on your flow
      routeNameLog = 'OnboardingScreen';
    }

    if (mounted) {
      debugPrint('SplashScreen: Attempting navigation to $routeNameLog.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      );
      debugPrint('SplashScreen: Navigation call to $routeNameLog has been made.');
    } else {
      debugPrint('SplashScreen: Not mounted just before navigation. Navigation aborted.');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('SplashScreen: build method called');
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading SciSky... (v2 with more logs)'), // Added version marker
          ],
        ),
      ),
    );
  }
}
