import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:scisky_social_network/providers/auth_provider.dart';
import 'package:scisky_social_network/screens/home_screen.dart';
import 'package:scisky_social_network/utils/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Widget _buildImage(String assetName, {double height = 200}) {
    IconData iconData = Icons.science;
    if (assetName == 'discover') iconData = Icons.search;
    if (assetName == 'discuss') iconData = Icons.forum;
    if (assetName == 'personalize') iconData = Icons.tune;
    return Icon(iconData, size: height, color: AppTheme.primaryColor);
  }

  PageViewModel _buildPage({
    required String title,
    required String body,
    required String imageName,
  }) {
    return PageViewModel(
      titleWidget: Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textColor),
        textAlign: TextAlign.center,
      ),
      bodyWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          body,
          style: GoogleFonts.poppins(fontSize: 16, color: AppTheme.subtleTextColor),
          textAlign: TextAlign.center,
        ),
      ),
      image: Center(child: _buildImage(imageName)),
      decoration: const PageDecoration(
        imagePadding: EdgeInsets.only(top: 60, bottom: 0),
        bodyAlignment: Alignment.center,
        bodyFlex: 2,
        imageFlex: 3,
        pageColor: AppTheme.backgroundColor,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return IntroductionScreen(
      key: GlobalKey<IntroductionScreenState>(),
      globalBackgroundColor: AppTheme.backgroundColor,
      pages: [
        _buildPage(
          title: "Discover Research",
          body:
          "Explore a vast library of scientific papers from various open-access sources.",
          imageName: "discover",
        ),
        _buildPage(
          title: "Join Discussions",
          body:
          "Connect with peers, share insights, and discuss the latest findings in dedicated forums.",
          imageName: "discuss",
        ),
        _buildPage(
          title: "Personalize Your Feed",
          body:
          "Tailor your experience by selecting your favorite research fields like AI, Medicine, and Physics.",
          imageName: "personalize",
        ),
      ],

      // ✅ Fixed: use async/await to avoid context disposal issues
      onDone: () async {
        await authProvider.continueAsGuest();
        if (!context.mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      },

      showSkipButton: true,
      skip: Text("Skip",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
      next: Icon(Icons.arrow_forward, color: AppTheme.primaryColor),
      done: Text("Get Started",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: AppTheme.primaryColor,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text("Sign in with Google"),
                onPressed: () async {
                  await authProvider.signInWithGoogle();
                  if (!context.mounted) return;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
