import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/prefs_helper.dart';
import '../onboarding/onboarding_screen.dart';
import '../login/login_screen.dart';
import '../home/home_screen.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideUp;
  late Animation<double> _fadeIn;

  bool _showSecondImage = false;

  @override
  void initState() {
    super.initState();

    // slide animation (الصورة الأولى)
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _slideUp = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.6), // ترفع الصورة الأولى
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    // fade animation (الصورة الثالثة)
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _slideController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showSecondImage = true;
        });
        _fadeController.forward();
      }
    });

    // بعد ما يخلص fade → ينقل حسب الشرط
    _fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goNext();
      }
    });

    _slideController.forward();
  }

  Future<void> _goNext() async {
    final seen = await PrefsHelper.getSeenOnboarding();
    final auth = context.read<AuthProvider>();
    if (!mounted) return;

    if (!seen) {
      Navigator.pushReplacementNamed(context, OnboardingScreen.routeName);
    } else if (auth.isAuthenticated) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: !_showSecondImage
            ? SlideTransition(
                position: _slideUp,
                child: Image.asset(
                  "images/img1.png",
                  width: screenWidth * 0.7,
                  height: screenWidth * 0.7,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // الصورة الثانية (اللوجو)
                  Image.asset(
                    "images/img2.png",
                    width: screenWidth * 0.9,
                    height: screenWidth * 0.9,
                  ),

                  const SizedBox(height: 50), // ← هنا المسافة بينهم

                  // الصورة الثالثة (الكلمة)
                  FadeTransition(
                    opacity: _fadeIn,
                    child: Image.asset(
                      "images/img3.png",
                      width: screenWidth * 0.7,
                      height: screenWidth * 0.7,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
