import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'onboarding_screen.dart';

void main() {
  runApp(const KawanTumbuhApp());
}

class KawanTumbuhApp extends StatelessWidget {
  const KawanTumbuhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KawanTumbuh',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5F8F8A),
        ),
        useMaterial3: true,
      ),
      // Splash screen sebagai halaman pertama
      home: const SplashScreen(),
      // Daftarkan route untuk halaman berikutnya
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const PlaceholderHomePage(),
      },
    );
  }
}

// Placeholder sementara — ganti dengan halaman utama kamu nanti
class PlaceholderHomePage extends StatelessWidget {
  const PlaceholderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: Center(
        child: Text(
          'Halaman Utama\nKawanTumbuh',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5F8F8A),
          ),
        ),
      ),
    );
  }
}
