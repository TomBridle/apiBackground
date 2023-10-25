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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:http/http.dart' as http;

// Declare a variable to store the API response
String apiResponse = '';

Future mainAction() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'your_notification_channel_id',
      initialNotificationTitle: 'Your Service Title',
      initialNotificationContent: 'Your Service Content',
      foregroundServiceNotificationId: 1,
    ),
  );
}

Future<void> onStart(ServiceInstance service) async {
  ReceivePort receivePort = ReceivePort();
  IsolateNameServer.removePortNameMapping('ServiceRunningPort');
  IsolateNameServer.registerPortWithName(
      receivePort.sendPort, 'ServiceRunningPort');
  receivePort.listen((message) {
    if (message == 'STOP') {
      service.stopSelf();
      IsolateNameServer.removePortNameMapping('ServiceRunningPort');
    }
  });

  while (true) {
    // Replace this block with your API call

    apiResponse = await apiCallInBackground();
  }
}

Future<String> apiCallInBackground() async {
  // Your API endpoint URL
  final apiUrl = 'https://test.brightlingsea.info/wp-json/wp/v2/posts';

  await Future.delayed(Duration(seconds: 10));

  try {
    final response = await http.get(Uri.parse(apiUrl));

    // Store the API response in a variable
    String responseBody = response.body;

    // Add the response to Firestore
    // Get a reference to the Firestore database
    final firestore = FirebaseFirestore.instance;

    // Get a reference to the collection
    final collectionRef = firestore.collection("test");

    // old code
    // final doc = createOrdersRecordData(name: fieldValue1, date: fieldValue2, orderid: field3);

    // new code
    final doc = {'test': responseBody};
    await collectionRef.add(doc);

    FFAppState().update(() {
      FFAppState().apiResponse = responseBody;
    });

    // API call was successful, process the data here
    return responseBody;
  } catch (e) {
    // Handle any exceptions that may occur during the API call
    return ''; // Return an empty string in case of an exception
  }
}
