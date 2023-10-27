// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom actions

import 'dart:isolate';
import 'dart:ui';
import 'dart:async';
// import '../../backend/api_requests/api_calls.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

Future mainAction() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Request permission before starting the service
    //await requestPhonePermission();

    await initializeService();
  } catch (e) {
    FFAppState().update(() {
      FFAppState().error = "$e";
    });
  }
}

Future<void> initializeService() async {
  try {
    if (isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'your_notification_channel_id', // id
        'Your Notification Channel', // title
        importance: Importance.high,
      );

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      // Initialise the plugin. app_icon needs to be added as a drawable resource to the Android head project
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    final service = FlutterBackgroundService();
    //final now = DateTime.now();

    // Configure the service as necessary
    await service.configure(
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,

        // you have to enable background fetch capability on xcode project
        // onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        // This will be executed when the app is in foreground or background in a separate isolate
        onStart: onStart,

        // Auto start service
        autoStart: true,
        isForegroundMode: true,
      ),
    );
    service.startService();
  } catch (e) {
    FFAppState().update(() {
      FFAppState().error = "$e";
    });
  }
}

Future<void> onStart(ServiceInstance service) async {
  try {
    DartPluginRegistrant.ensureInitialized();
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }
    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "App in background...",
          content: "Update ${DateTime.now()}",
        );
      }

      final now = DateTime.now();
      Firebase.initializeApp().whenComplete(() {
        final firestore = FirebaseFirestore.instance;
        final collectionRef = firestore.collection("test");
        final doc = {'test': now.toString()};
        collectionRef.add(doc);
      });

      service.invoke(
        'update',
        {
          "current_date": DateTime.now().toIso8601String(),
        },
      );
    });
  } catch (e) {
    FFAppState().update(() {
      FFAppState().error = "$e";
    });
  }
}
