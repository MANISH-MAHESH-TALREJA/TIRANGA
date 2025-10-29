import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:permission_handler/permission_handler.dart';
import 'package:pokemon/main_pages/Other/start_page.dart';
import 'package:toast/toast.dart';
import 'constants.dart';
import 'notification_utility.dart';

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

  Future<void> navigationPage()
  async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if(androidInfo.version.sdkInt >= 33.0)
    {
      PermissionStatus permissionStatus = await Permission.notification.status;
      if(permissionStatus.isGranted)
      {
        debugPrint("PERMISSION GRANTED");
        // showToast(context, "HAPPY INDEPENDENCE DAY");
      }
      else
      {
        await Permission.notification.request();
      }
    }
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
    });

  }

  @override
  void initState()
  {
    super.initState();
    ToastContext().init(context);
    Future.delayed(Duration.zero, ()
    {
      NotificationUtility.setUpNotificationService(context);
    });
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
