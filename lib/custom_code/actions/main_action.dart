// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

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

// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=oJDkoYfVA1g
// widgets - Cg9Db2x1bW5fd2ZjOWVlcHUS0AEKD0J1dHRvbl9qNTZ4MTN4bhgJIn1KeAoZCg1HZXQgUGhvbmUgbG9nOgYI/////w9ABRkAAAAAAAAIQDEAAAAAAABEQEkAAAAAAADwP1ICEAFaAggAciQJAAAAAAAAIEARAAAAAAAAIEAZAAAAAAAAIEAhAAAAAAAAIEB6EgkAAAAAAAA4QBkAAAAAAAA4QPoDAGIAigE5EjMKCHRvbDhyaDF2EifSARkKFQoMcmVhZFBob25lTG9nEgV4ZDhyYiIAqgIIN3ZiZmlxY2waAggBEkUKDVRleHRfdzkxNDVtMngYAiIwEhIKC0hlbGxvIFdvcmxkQAaoAQCaARYKAgIBKhAIDEIMIgoKBgoEdHlwZRAB+gMAYgASRwoNVGV4dF9jcW4zY241YRgCIjISEgoLSGVsbG8gV29ybGRABqgBAJoBGAoCAgEqEggMQg4iDAoICgZudW1iZXIQAfoDAGIAEkkKDVRleHRfamZ6bTc5cDQYAiI0EhIKC0hlbGxvIFdvcmxkQAaoAQCaARoKAgIBKhQIDEIQIg4KCgoIZHVyYXRpb24QAfoDAGIAEkoKDVRleHRfY2FsNHZ5N2QYAiI1EhIKC0hlbGxvIFdvcmxkQAaoAQCaARsKAgIBKhUIDEIRIg8KCwoJdGltZXN0YW1wEAH6AwBiABKfBAoPQnV0dG9uX2xrbDJldzdzGAkijgJKggEKIwoXc3RhcnQgYmFja2dyb3VuZCBhY3Rpb246Bgj/////D0AFGQAAAAAAAAhAMQAAAAAAAERASQAAAAAAAPA/UgIQAVoCCAByJAkAAAAAAAAgQBEAAAAAAAAgQBkAAAAAAAAgQCEAAAAAAAAgQHoSCQAAAAAAADhAGQAAAAAAADhAmgGCAQoDCQEBKnsIClJ3OnUKUAowCApSLBIcEhoIDEIWIhQKEAoOc2VydmljZVJ1bm5pbmcQARIICgYSBHRydWUiAggBEhwKGhIYU3RvcCBiYWNrZ3JvdW5kIHNlcnZpY2VzEh0KGxIZU3RhcnQgYmFja2dyb3VuZCBzZXJ2aWNlcxoCEAP6AwBiAIoB9QES7gEKCGNhdzdmeXVkGq4BGjwKCG54eXJrMWtyEjDiASJCHAoQCg5zZXJ2aWNlUnVubmluZxIICgYSBHRydWVQAlgBqgIIMjZhYXIzcTYibAoyCjAIClIsEhwSGggMQhYiFAoQCg5zZXJ2aWNlUnVubmluZxABEggKBhIEdHJ1ZSICCAESNgoIenE0OGJobGkSKuIBHEIWChAKDnNlcnZpY2VSdW5uaW5nEgIKAFACWAGqAgh0NzRmaWtseCgAKjEKCHJjOHczeGYxEiXSARcKEwoKbWFpbkFjdGlvbhIFNXV3amciAKoCCHR6a2l6cWN5GgIIARgEIgciAhAB+gMA
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

Future mainAction() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Request permission before starting the service
    await requestPhonePermission();

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
      iosConfiguration: IosConfiguration(),
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
