import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
          macOS: initializationSettingsDarwin,
        );

    // v20 uses named argument 'settings' usually? or first positional?
    // Based on error 'The named parameter settings is required', it is named.
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap
      },
    );
  }

  Future<bool> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return result ?? false;
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      final bool? granted = await androidImplementation
          ?.requestNotificationsPermission();
      return granted ?? false;
    }
    return false;
  }

  /// Schedules a notification to appear [minutes] from now
  Future<void> scheduleReminder(int minutes) async {
    await cancelAllNotifications(); // Cancel previous schedules to avoid clutter

    // Safety check for invalid interval
    if (minutes <= 0) return;

    // Calculate how many notifications to schedule to cover ~12 hours
    // But cap at 50 to avoid hitting OS limits (iOS limit is 64 pending, Android varies)
    const int maxDurationMinutes = 12 * 60; // 12 hours coverage
    final int calculatedCount = (maxDurationMinutes / minutes).ceil();
    final int count = calculatedCount > 50 ? 50 : calculatedCount;

    for (int i = 1; i <= count; i++) {
      final scheduledDate = tz.TZDateTime.now(
        tz.local,
      ).add(Duration(minutes: minutes * i));

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: i, // Distinct ID for each scheduled reminder
        title: 'Time to Hydrate! 💧',
        body: 'Your gravity is weakening. Take a sip to stay grounded.',
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'hydration_reminders',
            'Hydration Reminders',
            channelDescription: 'Reminders to drink water',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents:
            null, // Don't repeat individually; let the loop handle the sequence
      );
    }
  }

  /// Shows an instant notification for testing purposes
  Future<void> showInstantNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'hydration_reminders',
          'Hydration Reminders',
          channelDescription: 'Reminders to drink water',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id: 1, // Distinct ID for test notification
      title: 'Test Notification 🧪',
      body: 'This is how your hydration reminders will look!',
      notificationDetails: notificationDetails,
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
