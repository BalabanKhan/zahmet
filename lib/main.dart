import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.initialize();
  await NotificationService.initialize();
  
  runApp(const ProviderScope(child: ZahmetApp()));
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
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          surface: Colors.white,
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
