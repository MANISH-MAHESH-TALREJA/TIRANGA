import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokemon/GeneralUtilityFunctions.dart';
import 'package:pokemon/MainPages/Other/AppBarDrawer.dart';
import 'package:pokemon/MainPages/PortraitPages/SecondPage.dart';
import 'package:pokemon/MainPages/PortraitPages/FirstPage.dart';
import '../../Constants.dart';
import 'package:in_app_update/in_app_update.dart';

import '../../bottom_navy_bar.dart';

class PortraitMainPage extends StatefulWidget
{
  @override
  _PortraitMainPageState createState() => _PortraitMainPageState();
}

class _PortraitMainPageState extends State<PortraitMainPage>
{
  DateTime? currentBackPressTime;
  int _currentIndex = 0;

  @override
  void initState()
  {
    super.initState();
    InAppUpdate.checkForUpdate();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: RepublicDrawer().RepublicAppBar(context, Constants.OutputAppBarTitle),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          showElevation: false,
          backgroundColor: Colors.transparent,
          itemCornerRadius: 10,
          animationDuration: Duration(milliseconds: 500),
          curve: Curves.slowMiddle,
          onItemSelected: (index) => setState(() => _currentIndex = index),
          items: <BottomNavyBarItem>
          [
            BottomNavyBarItem(
              icon: Image.asset("assets/images/circle.gif", height: 32.5, width: 32.5,),
              title: Text('INDIA'),
              inactiveColor: Constants.GreenColor,
              activeColor: Constants.OrangeColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Image.asset("assets/images/butterfly.gif" , height: 32.5, width: 32.5,),
              title: Text('MEDIA'),
              inactiveColor: Constants.GreenColor,
              activeColor: Constants.OrangeColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Image.asset("assets/images/military.gif" , height: 32.5, width: 32.5,),
              title: Text("PROFILE"),
              inactiveColor: Constants.GreenColor,
              activeColor: Constants.OrangeColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        body: WillPopScope(
            onWillPop: onWillPop,
            child: changePage()
        )
    );
  }

  Widget changePage()
  {
    if(_currentIndex==0)
    {
      return FirstPage();
    }
    else if(_currentIndex==1)
    {
      return SecondPage();
    }
    else
    {
      return  Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AvatarGlow(
                  //endRadius: 75,
                  glowCount: 2,
                  glowRadiusFactor: 0.4,
                  glowColor: Colors.orangeAccent,
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  // repeatPauseDuration: Duration(seconds: 2),
                  startDelay: Duration(seconds: 1),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      "assets/images/app_icon.png",
                      height: 100,
                      fit: BoxFit.fill,
                      width: 250,
                    ),
                    radius: 50,
                  )
              ),
            Padding(
              padding: const EdgeInsets.only(bottom:20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width-25,
                child: TyperAnimatedTextKit(
                  onTap: () => showToast(context, "HAPPY INDEPENDENCE DAY"),
                  speed: Duration(milliseconds: 250),
                  isRepeatingAnimation: true,
                  repeatForever: true,
                  text: [
                    "TIRANGA",
                    "MANISH MAHESH TALREJA",
                  ],
                  textStyle: TextStyle(
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
                      title: new Text("ABOUT US", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                      trailing: Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                      leading: Icon(Icons.info, color: Constants.OrangeColor),
                      onTap: () => showDialog
                        (
                        context: context,
                        builder: (BuildContext context)
                        {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            title: Center(
                              child:Text("ABOUT DEVELOPERS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.00, color: Constants.GreenColor)),
                            ),
                            actions: [MaterialButton
                              (
                              child: Text("CLOSE",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.00)),
                              onPressed: (){Navigator.of(context).pop();},
                            )],
                            content: SingleChildScrollView(
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
                      title: new Text("CONTACT US", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                      trailing: Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                      leading: Icon(Icons.email, color: Constants.OrangeColor),
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
                    title: new Text("RATE APP", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                    leading: Icon(Icons.star, color: Constants.OrangeColor),
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
                      title: new Text("SHARE APP",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                      trailing: Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                      leading: Icon(Icons.share, color: Constants.OrangeColor),
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
                    title: new Text("PRIVACY POLICY",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                    leading: Icon(Icons.lock, color: Constants.OrangeColor),
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
                    title: new Text("MORE APPS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                    leading: Icon(Icons.sentiment_satisfied, color: Constants.OrangeColor),
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
                    title: new Text("EXIT APPLICATION", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                    leading: Icon(Icons.cancel, color: Constants.OrangeColor),
                    onTap: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop')
                  ),
                ),
              ),
              Divider(thickness: 2.00,color: Colors.transparent)
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
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2))
    {
      currentBackPressTime = now;
      showToast(context, "PRESS BACK BUTTON AGAIN TO EXIT");
      return Future.value(false);
    }
    return Future.value(true);
  }
}