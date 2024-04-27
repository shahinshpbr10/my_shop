import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'package:my_shop/app.dart';

void main() async {
  // final WidgetsBinding widgetsBinding =
  WidgetsFlutterBinding.ensureInitialized();

  // Set the app to portrait mode only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
// //Get-x Local storage
//   await GetStorage.init();
// //Await splash screen until other item load
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

