import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../l10n/app_texts.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    if (kIsWeb) return;
    tz.initializeTimeZones();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    
    await _notificationsPlugin.initialize(settings: initSettings);
  }

  static Future<void> scheduleTimeBomb() async {
    if (kIsWeb) return;
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = now.add(const Duration(hours: 3));

    await _notificationsPlugin.zonedSchedule(
      id: 0,
      title: AppTexts.notifTitle,
      body: AppTexts.notifBody,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'trip_channel',
          'Trip Notifications',
          channelDescription: 'passive aggressive reminders',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> scheduleDailyReminder() async {
    if (kIsWeb) return;
    
    // Schedule for 8:00 PM every day
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 20);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id: 1, // Use a different ID from time bomb
      title: 'Zahmet',
      body: AppTexts.kekstraDailyReminder ?? 'Hâlâ yapmadığın görevler var, umursamazlık seviyen göz yaşartıcı.',
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Reminders',
          channelDescription: 'daily passive aggressive reminders',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelTimeBomb() async {
    if (kIsWeb) return;
    await _notificationsPlugin.cancel(id: 0);
  }

  static Future<void> showNotification({required int id, required String title, required String body}) async {
    if (kIsWeb) return;
    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'trip_channel',
          'Trip Notifications',
          channelDescription: 'passive aggressive reminders',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
    );
  }
}
