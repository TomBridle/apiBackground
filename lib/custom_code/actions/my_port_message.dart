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

Future myPortMessage(
  String? portName,
  String? value,
) async {
  // null safety
  portName ??= '';
  value ??= value;

  SendPort? sendPort = IsolateNameServer.lookupPortByName(portName);
  sendPort?.send(value);
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
