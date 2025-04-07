import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ibamedt/Screen/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:ibamedt/Provider/navigation_provider.dart';
import 'package:ibamedt/Login Signup/Screen/connexion.dart';
import 'package:ibamedt/bottom_nav_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialiser Firebase une seule fois
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'IBAMEDT',
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.systemIndigo,
        brightness: Brightness.light,
      ),
      // Ajouter les localisations pour Material
      localizationsDelegates: const [
        // Délégués pour Cupertino
        DefaultCupertinoLocalizations.delegate,
        // Délégués pour Material
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'US')],
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const BottomNavWrapper(initialIndex: 0),
        '/edt': (context) => const BottomNavWrapper(initialIndex: 1),
        '/notifications': (context) => const BottomNavWrapper(initialIndex: 2),
        '/profile': (context) => const BottomNavWrapper(initialIndex: 3),
        '/settings': (context) => const BottomNavWrapper(initialIndex: 4),
      },
    );
  }
}
