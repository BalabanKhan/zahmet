import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('[ZAHMET_GLOBAL_ERROR]: ${details.exception}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('[ZAHMET_PLATFORM_ERROR]: $error\n$stack');
    return true;
  };

  try {
    await DatabaseService.initialize();
    await NotificationService.initialize();
    
    runApp(const ProviderScope(child: ZahmetApp()));
  } catch (e, stackTrace) {
    debugPrint('[ZAHMET_INIT_ERROR]: $e\n$stackTrace');
    runApp(const InitializationErrorApp());
  }
}

class InitializationErrorApp extends StatelessWidget {
  const InitializationErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: Center(
          child: Text(
            'Sistem başlatılamadı.\nSiyah ekrana bakmaya devam et.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class ZahmetApp extends StatelessWidget {
  const ZahmetApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    if (brightness == Brightness.dark) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint("[ZAHMET_LOG]: başarısızlıklarını karanlıkta saklayamazsın.");
      });
    }

    return MaterialApp(
      title: 'zahmet.',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F7), // Premium off-white
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          surface: Color(0xFFFAFAFA),
          onSurface: Colors.black,
        ),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: Colors.black87,
          displayColor: Colors.black,
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87,
          contentTextStyle: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          behavior: HitTestBehavior.opaque,
          child: child,
        );
      },
      home: const SplashScreen(),
    );
  }
}
