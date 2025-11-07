import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portofolio_website/HomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const apiKey = String.fromEnvironment('FLUTTER_PUBLIC_API_KEY');
  const authDomain = String.fromEnvironment('FLUTTER_PUBLIC_AUTH_DOMAIN');
  const projectId = String.fromEnvironment('FLUTTER_PUBLIC_PROJECT_ID');
  const storageBucket = String.fromEnvironment('FLUTTER_PUBLIC_STORAGE_BUCKET');
  const messagingSenderId = String.fromEnvironment('FLUTTER_PUBLIC_MESSAGING_SENDER_ID');
  const appId = String.fromEnvironment('FLUTTER_PUBLIC_APP_ID');
  const measurementId = String.fromEnvironment('FLUTTER_PUBLIC_MEASUREMENT_ID');

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: apiKey,
      authDomain: authDomain,
      projectId: projectId,
      storageBucket: storageBucket,
      messagingSenderId: messagingSenderId,
      appId: appId,
      measurementId: measurementId,
    ),
  );

  runApp(const PortofolioApp());
}

class PortofolioApp extends StatelessWidget {
  const PortofolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final headingTextTheme = GoogleFonts.playfairDisplayTextTheme();
    final bodyTextTheme = GoogleFonts.poppinsTextTheme();

    const Color primaryColor = Color(0xFF0D47A1);
    const Color charcoalColor = Color(0xFF333333);
    const Color beigeColor = Color(0xFFFBF9F6);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Portofolio - Muadz Haidar',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: beigeColor,
        primaryColor: primaryColor,

        textTheme: bodyTextTheme
            .copyWith(
              displayLarge: headingTextTheme.displayLarge?.copyWith(
                color: charcoalColor,
                fontWeight: FontWeight.bold,
              ),
              displayMedium: headingTextTheme.displayMedium?.copyWith(
                color: charcoalColor,
                fontWeight: FontWeight.bold,
              ),
              displaySmall: headingTextTheme.displaySmall?.copyWith(
                color: charcoalColor,
                fontWeight: FontWeight.bold,
              ),
              headlineLarge: headingTextTheme.headlineLarge?.copyWith(
                color: charcoalColor,
                fontWeight: FontWeight.bold,
              ),
              headlineMedium: headingTextTheme.headlineMedium?.copyWith(
                color: charcoalColor,
                fontWeight: FontWeight.bold,
              ),
              headlineSmall: headingTextTheme.headlineSmall?.copyWith(
                color: charcoalColor,
                fontWeight: FontWeight.bold,
              ),
            )
            .apply(
              bodyColor: charcoalColor.withOpacity(0.8),
              displayColor: charcoalColor,
            ),

        appBarTheme: const AppBarTheme(
          backgroundColor: beigeColor,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: charcoalColor),
          titleTextStyle: TextStyle(
            color: charcoalColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryColor,
            side: const BorderSide(color: primaryColor, width: 2),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: bodyTextTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      home: const Homepage(),
    );
  }
}
