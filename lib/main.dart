import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokemon/constants.dart';
import 'general_utility_functions.dart';
import 'notification_utility.dart';
import 'splash_screen.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: const FirebaseOptions(apiKey: "AIzaSyBWtuw0Zs_GqeXzpGVMgNBbk5tEkIteny8", appId: "1:735878722236:android:fa06bf7662a9cf4a1f56b9", messagingSenderId: "735878722236", projectId: "manish-tiranga"));
  final androidInfo = await DeviceInfoPlugin().androidInfo;

  if (androidInfo.version.sdkInt <= 32)
  {
    await NotificationUtility.initializeAwesomeNotification();
  }
  else
  {
    PermissionStatus permissionStatus = await Permission.notification.status;
    if(permissionStatus.isGranted)
    {
      await NotificationUtility.initializeAwesomeNotification();
    }
    else
    {
      await Permission.notification.request();
      PermissionStatus permissionStatus = await Permission.notification.status;
      if(permissionStatus.isGranted)
      {
        await NotificationUtility.initializeAwesomeNotification();
      }
      else
      {
        showToast("NOTIFICATION PERMISSION DENIED. KINDLY ENABLE NOTIFICATION PERMISSION TO RECEIVE LATEST UPDATES.");
      }
    }
  }
  await NotificationUtility.initializeAwesomeNotification();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness:Brightness.dark));
  runApp(MaterialApp(
    title: Constants.AppName,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.deepOrange, fontFamily: Constants.AppFont, appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark
    )),
    home: const SplashScreen(),
  ));
}
