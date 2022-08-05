import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pokemon/main_pages/Other/start_page.dart';
import 'package:toast/toast.dart';
import 'constants.dart';

class SplashScreen extends StatefulWidget
{
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin
{

  var _visible = true;
  AnimationController? animationController;
  Animation<double>? animation;
  startTime() async
  {
    var duration = const Duration(seconds: 5);
    return Timer(duration, navigationPage);
  }

  void navigationPage()
  {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  void initState()
  {
    super.initState();
    ToastContext().init(context);
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = CurvedAnimation(parent: animationController!, curve: Curves.easeOut);

    animation?.addListener(() => setState(() {}));
    animationController?.forward();

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
            Image.asset(
              'assets/images/wish_chakra.gif',
              width: animation!.value * 250,
              height: animation!.value * 250,
            ),
          ],
        ),
      ),
    );
  }
}
