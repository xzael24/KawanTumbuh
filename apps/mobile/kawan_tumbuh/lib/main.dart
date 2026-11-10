import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/add_profile/add_profile_screen.dart';
import 'screens/loading_profile_screen.dart';
import 'screens/assessment_overview_screen.dart';
import 'screens/countdown_screen.dart';
import 'screens/assessment_dyscalculia_screen.dart';
import 'screens/apresiasi_screen.dart';
import 'screens/apresiasi_dyslexia_screen.dart';
import 'screens/assessment_dyslexia_screen.dart';
import 'screens/assessment_dysgraphia_intro_screen.dart';
import 'screens/camera_capture_screen.dart';
import 'screens/apresiasi_dysgraphia_screen.dart';
import 'screens/hasil_assessment_screen.dart';
import 'screens/artikel_screen.dart';
import 'core/constants/app_constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: set ke false setelah font Quicksand di-bundle ke assets/fonts/
  GoogleFonts.config.allowRuntimeFetching = true;

  runApp(const KawanTumbuhApp());
}

class KawanTumbuhApp extends StatelessWidget {
  const KawanTumbuhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
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
        AppConstants.routeOnboarding : (context) => const OnboardingScreen(),
        AppConstants.routeHome       : (context) => const PlaceholderHomePage(),
        AppConstants.routeLogin      : (context) => const LoginScreen(),
        AppConstants.routeRegister   : (context) => const RegisterScreen(),
        AppConstants.routeForgotPass : (context) => const ForgotPasswordScreen(),
        AppConstants.routeAddProfile    : (context) => const AddProfileScreen(),
        AppConstants.routeLoadingProfile: (context) => const LoadingProfileScreen(),
        AppConstants.routeAssessmentOverview:   (context) => const AssessmentOverviewScreen(),
        AppConstants.routeCountdown:             (context) => const CountdownScreen(),
        AppConstants.routeAssessmentDyscalculia: (context) => const AssessmentDyscalculiaScreen(),
        AppConstants.routeApresiasi:             (context) => const ApresiasiScreen(),
        AppConstants.routeAssessmentDyslexia:    (context) => const AssessmentDyslexiaScreen(),
        AppConstants.routeApresiasiDyslexia:          (context) => const ApresiasiDyslexiaScreen(),
        AppConstants.routeAssessmentDysgraphiaIntro:  (context) => const AssessmentDysgraphiaIntroScreen(),
        AppConstants.routeDysgraphiaCamera:            (context) => const CameraCaptureScreen(),
        AppConstants.routeApresiasiDysgraphia:          (context) => const ApresiasiDysgraphiaScreen(),
        AppConstants.routeHasilAssessment:              (context) => const HasilAssessmentScreen(),
        AppConstants.routeArtikel:                       (context) => const ArtikelScreen(),
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
