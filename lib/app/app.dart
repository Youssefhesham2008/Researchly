import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../utils/app_theme.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/paper_details/paper_details_screen.dart';
import '../screens/forum_post/forum_post_screen.dart';

class SciSkyApp extends StatelessWidget {
  const SciSkyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SciSky',
      theme: AppTheme.darkTheme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/paper-details': (context) => const PaperDetailsScreen(),
        '/forum-post': (context) => const ForumPostScreen(),
      },
    );

  }
}








