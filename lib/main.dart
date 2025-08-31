import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scisky_social_network/utils/app_theme.dart';
import 'package:scisky_social_network/screens/splash_screen.dart';
import 'package:scisky_social_network/providers/auth_provider.dart';
import 'package:scisky_social_network/providers/paper_provider.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

void main() {
  debugPrint('main.dart: main() called');
  // WidgetsFlutterBinding.ensureInitialized(); // Uncomment if using Firebase
  // await Firebase.initializeApp(); // Uncomment if using Firebase
  debugPrint('main.dart: About to call runApp()');
  runApp(const SciSkyApp());
  debugPrint('main.dart: runApp() finished'); // This might not be reached if runApp takes over
}

class SciSkyApp extends StatelessWidget {
  const SciSkyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('main.dart: SciSkyApp build() method called');
    // The following debugPrint calls are not valid as direct children of providers list.
    // We will rely on the print before this and the one from SplashScreen for now.
    return MultiProvider(
      providers: [
        // debugPrint('main.dart: SciSkyApp creating AuthProvider'), // Not valid here
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // debugPrint('main.dart: SciSkyApp creating PaperProvider'), // Not valid here
        ChangeNotifierProvider(create: (_) => PaperProvider()),
      ],
      child: MaterialApp(
        title: 'SciSky Social Network',
        theme: AppTheme.themeData,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        // Define routes here once we have more screens
        // routes: { 
        //   '/login': (context) => LoginScreen(),
        //   '/home': (context) => HomeScreen(),
        // },
      ),
    );
  }
}
