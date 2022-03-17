import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class LocalN {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            importance: Importance.max));
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final setting = InitializationSettings(android: android);
    await _notification.initialize(setting,
        onSelectNotification: (payload) async {
      onNotification.add(payload);
    });
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notification.show(id, title, body, await _notificationDetails());
}





/*
ADD THIS LINE IN ANDROIDMAINFEST 


ACTIVITY 


 android:showWhenLocked="true"
 android:turnScreenOn="true"

*/