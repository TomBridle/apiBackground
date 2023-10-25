import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBnxgFc1x2Oa8uAcXO4ziY9RYoChDF0p-8",
            authDomain: "tradesmart-ebb4b.firebaseapp.com",
            projectId: "tradesmart-ebb4b",
            storageBucket: "tradesmart-ebb4b.appspot.com",
            messagingSenderId: "996993345043",
            appId: "1:996993345043:web:edda4ed0b8d081de06c1e6"));
  } else {
    await Firebase.initializeApp();
  }
}
