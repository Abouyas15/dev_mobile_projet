import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ibamedt/Screen/Acceuil.dart';
import 'package:ibamedt/Screen/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:ibamedt/Provider/navigation_provider.dart';
import 'package:ibamedt/Login Signup/Screen/connexion.dart';

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
        '/edt': (context) => const HomeScreen(initialIndex: 0),
        '/notifications': (context) => const HomeScreen(initialIndex: 1),
        '/profile': (context) => const HomeScreen(initialIndex: 2),
        '/settings': (context) => const HomeScreen(initialIndex: 3),
      },
    );
  }
}
