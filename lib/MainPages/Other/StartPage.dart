import 'package:flutter/material.dart';
import 'package:pokemon/MainPages/HomePages/HorizontalMainPage.dart';
import 'package:pokemon/MainPages/HomePages/PortraitMainPage.dart';

class HomePage extends StatefulWidget
{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context)
  {
    return OrientationBuilder(
      builder: (context, orientation)
      {
        return orientation == Orientation.portrait ? PortraitMainPage() : HorizontalMainPage() ;
      },
    );
  }
}
