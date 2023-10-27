// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<void> updateFb() async {
  final now = DateTime.now();
  final firestore = FirebaseFirestore.instance;
  final collectionRef = firestore.collection("test");
  final doc = {'test': now.toString()};
  await collectionRef.add(doc);

  // Delay before the next iteration.
  await Future.delayed(Duration(seconds: 10));
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
