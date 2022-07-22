import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:pokemon/constants.dart';
import 'splash_screen.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness:Brightness.dark));
  runApp(MaterialApp(
    title: Constants.AppName,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.deepOrange, fontFamily: Constants.AppFont, appBarTheme: const AppBarTheme(
    brightness: Brightness.light
    )),
    home: const SplashScreen(),
  ));
}
