import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:pokemon/Constants.dart';
import 'SplashScreen.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness:Brightness.dark));
  runApp(MaterialApp(
    title: Constants.AppName,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.deepOrange, fontFamily: Constants.AppFont, appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark
    )),
    home: SplashScreen(),
  ));
}
