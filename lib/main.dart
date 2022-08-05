import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokemon/constants.dart';
import 'splash_screen.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

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
