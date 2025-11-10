import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Notification service for scheduling and managing reminders
class Notifs {
  Notifs._();
  /// Singleton instance
  static final instance = Notifs._();
  /// Local notifications plugin
  final _plugin = FlutterLocalNotificationsPlugin();

  /// Initializes notification channels and timezones
  Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const init = InitializationSettings(android: android);
    await _plugin.initialize(init);

    // Create notification channel for reminders
    const channel = AndroidNotificationChannel(
      'skitty_reminders',
      'Skitty Reminders',
      description: 'Meal time reminders',
      importance: Importance.defaultImportance,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Schedules a daily notification at the given time
  Future<void> scheduleDaily(String id, int hour, int minute, String title, String body) async {
    final details = NotificationDetails(
      android: const AndroidNotificationDetails(
        'skitty_reminders', 'Skitty Reminders',
        channelDescription: 'Meal time reminders',
      ),
    );

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id.hashCode, title, body, scheduled, details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // repeat daily
    );
  }

  /// Cancels a notification by id
  Future<void> cancel(String id) => _plugin.cancel(id.hashCode);
  /// Cancels all notifications
  Future<void> cancelAll() => _plugin.cancelAll();
}
