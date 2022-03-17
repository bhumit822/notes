import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notes/localnotification.dart';

Future<void> onBackgroundmessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey("data")) {
    // handle data message
    final data = message.data["data"];
  }

  if (message.data.containsKey("notification")) {
    // handle notification message
    final notification = message.data["notification"];
  }

  // other ....
}

class FCM {
  final stremctrl = StreamController<String>.broadcast();
  final titlectrl = StreamController<String>.broadcast();
  final bodyctrl = StreamController<String>.broadcast();

  setNotification() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundmessage);
//handle notification whene app is active
    forgroundNotification();

    //handle whene app is in background
    backgroundNotification();

    //handle whene app is closed
    terminateNotifiaction();
  }

  forgroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // handle data message
      if (message.data.containsKey("data")) {
        stremctrl.sink.add(message.data["data"]);
      }

// handle notification message
      if (message.data.containsKey("notification")) {
        stremctrl.sink.add(message.data["notification"]);
      }

      titlectrl.sink.add(message.notification!.title!);
      bodyctrl.sink.add(message.notification!.body!);
      LocalN.showNotification(
          title: message.notification!.title, body: message.notification!.body);
    });
  }

  backgroundNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // handle data message
      if (message.data.containsKey("data")) {
        stremctrl.sink.add(message.data["data"]);
      }

// handle notification message
      if (message.data.containsKey("notification")) {
        stremctrl.sink.add(message.data["notification"]);
      }

      titlectrl.sink.add(message.notification!.title!);
      bodyctrl.sink.add(message.notification!.body!);
    });
  }

  terminateNotifiaction() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      if (initialMessage.data.containsKey("data")) {
        stremctrl.sink.add(initialMessage.data["data"]);
      }

// handle notification message
      if (initialMessage.data.containsKey("notification")) {
        stremctrl.sink.add(initialMessage.data["notification"]);
      }

      titlectrl.sink.add(initialMessage.notification!.title!);
      bodyctrl.sink.add(initialMessage.notification!.body!);
    }
  }

  dispose() {
    stremctrl.close();
    titlectrl.close();
    bodyctrl.close();
  }
}
