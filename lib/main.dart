import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await DatabaseService.initialize();
    await NotificationService.initialize();
    
    runApp(const ProviderScope(child: ZahmetApp()));
  } catch (e, stackTrace) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Initialization Error:\n$e\n\n$stackTrace',
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    ));
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
