import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pokemon/MainPages/Other/StartPage.dart';
import 'Constants.dart';

class SplashScreen extends StatefulWidget
{
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin
{
  var _visible = true;
  AnimationController animationController;
  Animation<double> animation;
  startTime() async
  {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage()
  {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  void initState()
  {
    super.initState();
    animationController = new AnimationController(vsync: this, duration: new Duration(seconds: 2));
    animation = new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(()
    {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Constants.OrangeColor,
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
            new Image.asset(
              'assets/images/wish_chakra.gif',
              width: animation.value * 250,
              height: animation.value * 250,
            ),
          ],
        ),
      ),
    );
  }
}
