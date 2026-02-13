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
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

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

  Future<bool> requestExactAlarmPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      return true;
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      final bool? granted = await androidImplementation
          ?.requestExactAlarmsPermission();
      return granted ?? false;
    }
    return false;
  }

  /// Schedules smart reminders avoiding sleep hours
  Future<void> scheduleReminder(
    int intervalMinutes,
    int bedTimeHour,
    int wakeUpHour,
  ) async {
    await cancelAllNotifications();

    // Safety check
    if (intervalMinutes <= 0) return;

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = now;

    int scheduledCount = 0;
    const int maxNotifications = 40; // Stay well under limit (iOS 64)

    while (scheduledCount < maxNotifications) {
      // Advance by interval
      scheduledDate = scheduledDate.add(Duration(minutes: intervalMinutes));

      // Check quiet hours
      // If after bedTime, jump to next day wakeUpHour
      if (scheduledDate.hour >= bedTimeHour) {
        scheduledDate = tz.TZDateTime(
          tz.local,
          scheduledDate.year,
          scheduledDate.month,
          scheduledDate.day,
          wakeUpHour,
          0,
        ).add(const Duration(days: 1));
      }
      // If before wakeUpHour, jump to today wakeUpHour (only happens if 'now' was early morning)
      else if (scheduledDate.hour < wakeUpHour) {
        scheduledDate = tz.TZDateTime(
          tz.local,
          scheduledDate.year,
          scheduledDate.month,
          scheduledDate.day,
          wakeUpHour,
          0,
        );
      }

      // Schedule the notification
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: scheduledCount, // Distinct ID
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
            ticker: 'ticker',
          ),
          iOS: DarwinNotificationDetails(
            sound: 'default.wav',
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

        matchDateTimeComponents: DateTimeComponents
            .time, // Optional: repeat daily at this time? No, we are scheduling explicitly.
      );

      scheduledCount++;
    }
  }

  /// Shows an instant notification for testing purposes
  Future<void> showInstantNotification() async {
    await cancelAllNotifications(); // Cancel previous schedules to avoid clutter
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
      id: 2, // Distinct ID for test notification
      title: 'Test Notification 🧪',
      body: 'This is how your hydration reminders will look!',
      notificationDetails: notificationDetails,
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
