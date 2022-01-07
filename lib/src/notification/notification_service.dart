import 'dart:convert';

// import 'package:appventure/bloc/AppStateBloc.dart';
// import 'package:appventure/models/notification_model.dart';
// import 'package:appventure/models/schedule_notification.dart';
// import 'package:appventure/screens/main_screen/components/main_screen_parameter.dart';
// import 'package:appventure/screens/main_screen/main_screen.dart';
// import 'package:appventure/screens/notifications/notifications_screen.dart';
// import 'package:appventure/screens/vendor/vendor_booking_overview_screen/booking_overview_screen.dart';
// import 'package:appventure/services/notification_service/notification_actions.dart';
// import 'package:appventure/services/response/user_login_response.dart';
// import 'package:appventure/services/user_provider.dart';
// import 'package:appventure/services/user_service.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:marketplace_service_provider/src/components/dashboard/dashboard_pages/home_screen.dart';
import 'package:marketplace_service_provider/src/notification/notification_model.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/callbacks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static NotificationService _instance;
  GlobalKey<NavigatorState> _navigatorKey;
  static FirebaseMessaging _firebaseMessaging;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationService._(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  static Future<NotificationService> initialize(
      GlobalKey<NavigatorState> navigatorKey) async {
    if (_instance == null) {
      _instance = NotificationService._(navigatorKey);

      await _initFirebaseMessaging();
      await _initLocalNotification();
      _initTimeZone();
    }

    return _instance;
  }

  static void _initTimeZone() async {
    try {
      String _timezone = await FlutterNativeTimezone.getLocalTimezone();
      print('Time:: $_timezone');
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation(_timezone));
    } catch (e) {
      print(e);
    }
  }

  static Future<void> _initFirebaseMessaging() async {
    _firebaseMessaging = FirebaseMessaging.instance;

    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    var fcmToken = await _firebaseMessaging.getToken();
    _instance._saveFcmToken(fcmToken);

    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        _instance._handlePushWhileClosed(message);
      }
    });

    _firebaseMessaging.onTokenRefresh.listen(_instance._saveFcmToken);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _instance._handlePushWhileOpen(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _instance._handlePushWhileClosed(message);
    });

    return Future.sync(() => null);
  }

  // Future<void> scheduleNotification(ScheduleNotification notification) async {
  //   var scheduledNotificationDateTime =
  //       tz.TZDateTime.from(notification.dateTime, tz.local);
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     'appventure',
  //     'appventure_channel',
  //     'description',
  //     priority: Priority.max,
  //     importance: Importance.max,
  //     fullScreenIntent: true,
  //   );
  //   var iOSPlatformChannelSpecifics =
  //       IOSNotificationDetails(presentAlert: true);
  //   var platformChannelSpecifics = NotificationDetails(
  //       android: androidPlatformChannelSpecifics,
  //       iOS: iOSPlatformChannelSpecifics);
  //   //TODO : Notification Message Required
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       notification.notificationId,
  //       '${notification.bookingTitle}',
  //       'Notification message required!',
  //       scheduledNotificationDateTime,
  //       platformChannelSpecifics,
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime);
  // }

  // void cancelScheduleNotification(int notificationId) async {
  //   await flutterLocalNotificationsPlugin.cancel(notificationId);
  // }

  static Future<void> _initLocalNotification() {
    // For local push notification
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_notification');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _instance._onSelectNotification);

    return Future.sync(() => null);
  }

  void _saveFcmToken(String token) async {
    await AppSharedPref.instance.setDeviceToken(token);
  }

  void _handlePushWhileOpen(RemoteMessage message) {
    // appStateBloc.getNotifications();
    print('---------handlePushWhileOpen---------=${message.data}');
    eventBus.fire(FCMNotificationEvent( parseNotificationData(message.data, false)));
    //Log firebase event
    // FirebaseAnalytics().logEvent(
    //   name: 'fcm_notification_foreground',
    //   parameters: <String, dynamic>{
    //     'message_id': message.messageId,
    //     'message_name': message.notification?.title,
    //     'message_time': message.sentTime?.toIso8601String(),
    //     'message_device_time': DateTime.now().toIso8601String(),
    //     'topic': message.from,
    //   },
    // );

    //Show push message
    _showNotification(message);
  }

  Future<void> _handlePushWhileClosed(RemoteMessage message) {
    // appStateBloc.getNotifications();
    print('---------handlePushWhileClosed---------=${message.data}');

    //Log firebase event
    // FirebaseAnalytics().logEvent(
    //   name: 'fcm_notification_open',
    //   parameters: <String, dynamic>{
    //     'message_id': message.messageId,
    //     'message_name': message.notification?.title,
    //     'message_time': message.sentTime?.toIso8601String(),
    //     'message_device_time': DateTime.now().toIso8601String(),
    //     'topic': message.from,
    //   },
    // );

    NotificationData notificationData =
        parseBackgroundNotificationData(message.data);

    //Handle action
    _handleAction(notificationData, false);

    return Future.sync(() => null);
  }

  void _handleLocal(Map<String, dynamic> data) {
    // appStateBloc.getNotifications();
    NotificationData notificationData = parseNotificationData(data, false);

    //Handle action
    _handleAction(notificationData, true);
  }

  void _handleAction(NotificationData notificationData, bool inApp) async {
    eventBus.fire(FCMNotificationEvent(notificationData));
    // switch (notificationData.notifyType) {
    //   case "runner_allocation":
    //     //TODO:
    //     break;
    //     case "user_runner_assigned":
    //     //TODO: refresh page and open order detail page
    //     break;
    //     case "ORDER_READY_DELIVERYBOY":
    //     //TODO: refresh page Home page and open order detail page
    //     break;
    // }
  }

  void _showNotification(RemoteMessage message) async {
    String title = message.notification.title;
    String body = message.notification.body;

    var android = AndroidNotificationDetails(
      'apprunner',
      'apprunner_channel ',
      'description',
      priority: Priority.high,
      importance: Importance.high,
      fullScreenIntent: true,
    );

    var iOS = IOSNotificationDetails(presentAlert: true);
    var platform = new NotificationDetails(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.show(0, '$title', '$body', platform,
        payload: jsonEncode(message.data));
  }

  Future _onSelectNotification(String payload) {
    print('----------onSelectNotification-------$payload');
    _handleLocal(json.decode(payload));

    return Future.sync(() => true);
  }

  NotificationData parseNotificationData(
      Map<String, dynamic> data, bool inApp) {
    try {
      if (inApp) return NotificationData.fromJson(data);

      return NotificationData.fromJson(data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  NotificationData parseBackgroundNotificationData(Map<String, dynamic> data) {
    try {
      return NotificationData.fromJson(data);
    } catch (e) {
      print(e);
    }
  }
}
