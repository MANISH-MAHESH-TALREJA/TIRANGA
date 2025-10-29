import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:pokemon/constants.dart';
import 'notification_utility.dart';
import 'splash_screen.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: const FirebaseOptions(apiKey: "AIzaSyBWtuw0Zs_GqeXzpGVMgNBbk5tEkIteny8", appId: "1:735878722236:android:fa06bf7662a9cf4a1f56b9", messagingSenderId: "735878722236", projectId: "manish-tiranga"));
  await NotificationUtility.initializeAwesomeNotification();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness:Brightness.dark));
  runApp(MaterialApp(
    title: Constants.AppName,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.deepOrange, fontFamily: Constants.AppFont, useMaterial3: false, appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark
    )),
    home: const SplashScreen(),
  ));
}
