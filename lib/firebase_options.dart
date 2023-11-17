import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'

    show defaultTargetPlatform, kIsWeb, TargetPlatform;

FirebaseDatabase database = FirebaseDatabase.instance;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
final FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyCkftDjo16sN-qQhQS_NU-wdaTBfDcBkfk",
      authDomain: "bookstore-2b063.firebaseapp.com",
      databaseURL: "https://bookstore-2b063-default-rtdb.firebaseio.com",
      projectId: "bookstore-2b063",
      storageBucket: "bookstore-2b063.appspot.com",
      messagingSenderId: "455813346252",
      appId: "1:455813346252:web:c8ce68192c27d109bd6369"
);
