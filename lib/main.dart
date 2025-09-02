import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'app/app.dart';
import 'providers/auth_provider.dart';
import 'providers/paper_provider.dart';
import 'providers/forum_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/langs',
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()..load()),
          ChangeNotifierProvider(create: (_) => PaperProvider()..loadSaved()),
          ChangeNotifierProvider(create: (_) => ForumProvider()..loadSaved()),
        ],
        child: const SciSkyApp(),
      ),
    ),
  );
}





