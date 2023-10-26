// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// YouTube channel - https://www.youtube.com/@flutterflowexpert
// paid video - https://www.youtube.com/watch?v=oJDkoYfVA1g
// widgets - Cg9Db2x1bW5fd2ZjOWVlcHUS0AEKD0J1dHRvbl9qNTZ4MTN4bhgJIn1KeAoZCg1HZXQgUGhvbmUgbG9nOgYI/////w9ABRkAAAAAAAAIQDEAAAAAAABEQEkAAAAAAADwP1ICEAFaAggAciQJAAAAAAAAIEARAAAAAAAAIEAZAAAAAAAAIEAhAAAAAAAAIEB6EgkAAAAAAAA4QBkAAAAAAAA4QPoDAGIAigE5EjMKCHRvbDhyaDF2EifSARkKFQoMcmVhZFBob25lTG9nEgV4ZDhyYiIAqgIIN3ZiZmlxY2waAggBEkUKDVRleHRfdzkxNDVtMngYAiIwEhIKC0hlbGxvIFdvcmxkQAaoAQCaARYKAgIBKhAIDEIMIgoKBgoEdHlwZRAB+gMAYgASRwoNVGV4dF9jcW4zY241YRgCIjISEgoLSGVsbG8gV29ybGRABqgBAJoBGAoCAgEqEggMQg4iDAoICgZudW1iZXIQAfoDAGIAEkkKDVRleHRfamZ6bTc5cDQYAiI0EhIKC0hlbGxvIFdvcmxkQAaoAQCaARoKAgIBKhQIDEIQIg4KCgoIZHVyYXRpb24QAfoDAGIAEkoKDVRleHRfY2FsNHZ5N2QYAiI1EhIKC0hlbGxvIFdvcmxkQAaoAQCaARsKAgIBKhUIDEIRIg8KCwoJdGltZXN0YW1wEAH6AwBiABKfBAoPQnV0dG9uX2xrbDJldzdzGAkijgJKggEKIwoXc3RhcnQgYmFja2dyb3VuZCBhY3Rpb246Bgj/////D0AFGQAAAAAAAAhAMQAAAAAAAERASQAAAAAAAPA/UgIQAVoCCAByJAkAAAAAAAAgQBEAAAAAAAAgQBkAAAAAAAAgQCEAAAAAAAAgQHoSCQAAAAAAADhAGQAAAAAAADhAmgGCAQoDCQEBKnsIClJ3OnUKUAowCApSLBIcEhoIDEIWIhQKEAoOc2VydmljZVJ1bm5pbmcQARIICgYSBHRydWUiAggBEhwKGhIYU3RvcCBiYWNrZ3JvdW5kIHNlcnZpY2VzEh0KGxIZU3RhcnQgYmFja2dyb3VuZCBzZXJ2aWNlcxoCEAP6AwBiAIoB9QES7gEKCGNhdzdmeXVkGq4BGjwKCG54eXJrMWtyEjDiASJCHAoQCg5zZXJ2aWNlUnVubmluZxIICgYSBHRydWVQAlgBqgIIMjZhYXIzcTYibAoyCjAIClIsEhwSGggMQhYiFAoQCg5zZXJ2aWNlUnVubmluZxABEggKBhIEdHJ1ZSICCAESNgoIenE0OGJobGkSKuIBHEIWChAKDnNlcnZpY2VSdW5uaW5nEgIKAFACWAGqAgh0NzRmaWtseCgAKjEKCHJjOHczeGYxEiXSARcKEwoKbWFpbkFjdGlvbhIFNXV3amciAKoCCHR6a2l6cWN5GgIIARgEIgciAhAB+gMA
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import 'dart:isolate';
import 'dart:ui';

import '../../backend/api_requests/api_calls.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<String> mainAction() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Request permission before starting the service
    await requestPhonePermission();

    await initializeService();
    await makeAPICall();
    return ('Function Ended');
  } catch (e) {
    // Handle the error or log it as needed
    return ('Error in mainAction: $e');
  }
}

Future<void> initializeService() async {
  if (isAndroid) {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'your_notification_channel_id', // id
      'Your Notification Channel', // title
      importance: Importance.high,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Initialize the plugin. app_icon needs to be added as a drawable resource to the Android head project.
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('app_icon'),
      ),
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  final service = FlutterBackgroundService();

  // Configure the service as necessary
  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      // This will be executed when the app is in the foreground or background in a separate isolate
      onStart: onStart,

      // Auto start service
      autoStart: true,
      isForegroundMode: true,

      // Add necessary notification details
      notificationChannelId: 'your_notification_channel_id',
      initialNotificationTitle: 'Your Service Title',
      initialNotificationContent: 'Test',
      foregroundServiceNotificationId: 1,
    ),
  );

  await service.startService();
}

Future<void> onStart(ServiceInstance service) async {
  final service = FlutterBackgroundService();
  var isRunning = await service.isRunning();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final ReceivePort receivePort = ReceivePort();

  IsolateNameServer.removePortNameMapping('ServiceRunningPort');
  IsolateNameServer.registerPortWithName(
      receivePort.sendPort, 'ServiceRunningPort');

  // This loop will keep running in the background.
  while (isRunning) {
    try {
      final apiResponse = await makeAPICall();
      final notificationTitle = 'Your Service Title';
      final notificationContent = 'API Response: $apiResponse';

      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'your_notification_channel_id',
          'Your Notification Channel',
          importance: Importance.high,
        ),
      );

      await flutterLocalNotificationsPlugin.show(
        1, // Notification ID
        notificationTitle,
        notificationContent,
        notificationDetails,
      );

      // Delay before the next iteration.
      await Future.delayed(Duration(seconds: 10));
    } catch (e) {
      // Handle any errors, log them, and continue the loop.
      print('Error in onStart: $e');
    }
  }

  // Clean up and stop the service.
  receivePort.close();
  service.invoke("stopService");
}

Future makeAPICall() async {
  ApiCallResponse? apiCall;
  apiCall = await TestingGroup.postsCall.call();
  if ((apiCall.succeeded ?? true)) {
    return (apiCall.jsonBody ?? '').toString();
  }
  return 'error'; // Return an empty string if the API call fails.
}

Future<void> requestPhonePermission() async {
  var status = await Permission.phone.status;
  if (!status.isGranted) {
    status = await Permission.phone.request();
    if (!status.isGranted) {
      // Optionally, you can prompt a dialog here to inform user about the necessity of the permission
    }
  }
}
