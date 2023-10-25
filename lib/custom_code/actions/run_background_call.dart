// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:http/http.dart' as http;

// Declare a variable to store the API response
String apiResponse = '';
bool? checkPeriodically;
Future<String?> runBackgroundCall(bool? checkPeriodically) async {
  mainAction();
  apiCallInBackground(checkPeriodically);
}

Future mainAction() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIOSStart,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,

      //code for sending a notifiction

      // notificationChannelId: 'your_notification_channel_id',
      // initialNotificationTitle: 'Your Service Title',
      // initialNotificationContent: 'Your Service Content',
      // foregroundServiceNotificationId: 1,
    ),
  );
}

Future<void> onStart(ServiceInstance service) async {
  while (true) {
    // Replace this block with your API call

    await apiCallInBackground(checkPeriodically);
  }
}

FutureOr<bool> onIOSStart(ServiceInstance service) async {
  while (true) {
    // Replace this block with your API call
    await apiCallInBackground(checkPeriodically);
  }
}

Future<String?> apiCallInBackground(bool? checkPeriodically) async {
  // Your API endpoint URL
  checkPeriodically = true;
  while (checkPeriodically) {
    final apiUrl = 'https://test.brightlingsea.info/wp-json/wp/v2/posts/10795';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      String responseBody = response.body;

      // Add the response to Firestore
      final firestore = FirebaseFirestore.instance;
      final collectionRef = firestore.collection("test");

      final doc = {'test': responseBody};
      await collectionRef.add(doc);

      FFAppState().update(() {
        FFAppState().apiResponse = responseBody;
      });

      return responseBody;
    } catch (e) {
      FFAppState().update(() {
        FFAppState().apiResponse = "$e";
      });
      // Handle any exceptions that may occur during the API call
      print("Error: $e");
    }

    // Wait for 10 seconds before making the next API call
    await Future.delayed(Duration(seconds: 5));
  }
}
