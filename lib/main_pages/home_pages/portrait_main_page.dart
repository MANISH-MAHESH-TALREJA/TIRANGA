import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:pokemon/general_utility_functions.dart';
import 'package:toast/toast.dart';
import '../../bottom_navy_bar.dart';
import '../../constants.dart';
import '../other/app_bar_drawer.dart';
//import 'package:in_app_update/in_app_update.dart';

import '../portrait_pages/first_page.dart';
import '../portrait_pages/second_page.dart';

class PortraitMainPage extends StatefulWidget
{
  const PortraitMainPage({super.key});

  @override
  PortraitMainPageState createState() => PortraitMainPageState();
}

class PortraitMainPageState extends State<PortraitMainPage>
{
  int _currentIndex = 0;

  @override
  void initState()
  {
    super.initState();
    ToastContext().init(context);
    InAppUpdate.checkForUpdate();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: const RepublicDrawer().RepublicAppBar(context, Constants.OutputAppBarTitle),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          showElevation: false,
          backgroundColor: Colors.transparent,
          itemCornerRadius: 10,
          animationDuration: const Duration(milliseconds: 500),
          curve: Curves.slowMiddle,
          onItemSelected: (index) => setState(() => _currentIndex = index),
          items: <BottomNavyBarItem>
          [
            BottomNavyBarItem(
              icon: Image.asset("assets/images/circle.gif", height: 32.5, width: 32.5,),
              title: const Text('INDIA'),
              inactiveColor: Constants.GreenColor,
              activeColor: Constants.OrangeColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Image.asset("assets/images/butterfly.gif" , height: 32.5, width: 32.5,),
              title: const Text('MEDIA'),
              inactiveColor: Constants.GreenColor,
              activeColor: Constants.OrangeColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Image.asset("assets/images/military.gif" , height: 32.5, width: 32.5,),
              title: const Text("PROFILE"),
              inactiveColor: Constants.GreenColor,
              activeColor: Constants.OrangeColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        body: PopScope(
            canPop: canPopNow,
            onPopInvoked: onPopInvoked,
            child: changePage()
        )
    );
  }

  DateTime? currentBackPressTime;
  bool canPopNow = false;
  int requiredSeconds = 2;
  void onPopInvoked(bool didPop) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) >
            Duration(seconds: requiredSeconds)) {
      currentBackPressTime = now;
      showToast("PRESS BACK BUTTON AGAIN TO EXIT");
      Future.delayed(
        Duration(seconds: requiredSeconds),
            () {
          // Disable pop invoke and close the toast after 2s timeout
          setState(() {
            canPopNow = false;
          });
        },
      );
      // Ok, let user exit app on the next back press
      setState(() {
        canPopNow = true;
      });
    }
  }
  Widget changePage()
  {
    if(_currentIndex==0)
    {
      return const FirstPage();
    }
    else if(_currentIndex==1)
    {
      return const SecondPage();
    }
    else
    {
      return  Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30,),
              AvatarGlow(
                //endRadius: 75,
                  glowCount: 2,
                  glowRadiusFactor: 0.4,
                  glowColor: Colors.orangeAccent,
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  // repeatPauseDuration: Duration(seconds: 2),
                  startDelay: const Duration(seconds: 1),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 50,
                    child: Image.asset(
                      "assets/images/app_icon.png",
                      height: 125,
                      fit: BoxFit.fill,
                      width: 300,
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(bottom:20.0, top: 50.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width-25,
                  child: TyperAnimatedTextKit(
                    onTap: () => showToast("HAPPY INDEPENDENCE DAY"),
                    speed: const Duration(milliseconds: 250),
                    isRepeatingAnimation: true,
                    repeatForever: true,
                    text: const [
                      "TIRANGA",
                      "MANISH MAHESH TALREJA",
                    ],
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: "Tahoma",
                      color: Constants.GreenColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.5),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                      title: const Text("ABOUT US", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                      leading: const Icon(Icons.info, color: Constants.OrangeColor),
                      onTap: () => showDialog
                        (
                        context: context,
                        builder: (BuildContext context)
                        {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            title: const Center(
                              child:Text("ABOUT DEVELOPERS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.00, color: Constants.GreenColor)),
                            ),
                            actions: [MaterialButton
                              (
                              child: const Text("CLOSE",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.00)),
                              onPressed: (){Navigator.of(context).pop();},
                            )],
                            content: const SingleChildScrollView(
                              child: Text("COMPANY : RAAM DEVELOPERS\n\nDEVELOPERS : \n\n1. RAVIRAJ KUNDEKAR\n2. AAYUSHMAN OJHA\n3. ADITI JAISWAL\n4. MANISH MAHESH TALREJA\n\nPURPOSE : \n   TIRANGA - A VIRTUAL INDEPENDENCE DAY APPLICATION.", style:TextStyle(fontFamily: Constants.AppFont, fontWeight: FontWeight.bold, color: Constants.OrangeColor, letterSpacing: 1)
                              ),
                            ),
                          );
                        },
                      ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 2.5),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                      title: const Text("CONTACT US", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                      leading: const Icon(Icons.email, color: Constants.OrangeColor),
                      onTap: () => _launchURL('manishtalreja189@gmail.com', 'DEVELOPER CONTACT', 'RESPECTED DEVELOPER,\n\n'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 2.5),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: const Text("RATE APP", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                    leading: const Icon(Icons.star, color: Constants.OrangeColor),
                    onTap: () => launchLink(Constants.AppPlayStoreLink),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 2.5),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                      title: const Text("SHARE APP",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                      leading: const Icon(Icons.share, color: Constants.OrangeColor),
                      onTap: () => shareMe()
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 2.5),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: const Text("PRIVACY POLICY",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                    leading: const Icon(Icons.lock, color: Constants.OrangeColor),
                    onTap: () => launchLink(Constants.AppPrivacyPolicyPage),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 2.5),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: const Text("MORE APPS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                    leading: const Icon(Icons.sentiment_satisfied, color: Constants.OrangeColor),
                    onTap: () => launchLink(Constants.AppDeveloperPage)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 2.5),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: const Text("EXIT APPLICATION", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                    leading: const Icon(Icons.cancel, color: Constants.OrangeColor),
                    onTap: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop')
                  ),
                ),
              ),
              const Divider(thickness: 2.00,color: Colors.transparent)
            ],
          ),
        ),
      );
    }
  }

  _launchURL(String toMailId, String subject, String body) async
  {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    launchLink(url);
  }

  Future<bool> onWillPop()
  {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2))
    {
      currentBackPressTime = now;
      showToast("PRESS BACK BUTTON AGAIN TO EXIT");
      return Future.value(false);
    }
    return Future.value(true);
  }
}