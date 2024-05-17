import 'package:flutter/material.dart';
import 'package:pokemon/Constants.dart';
import 'package:pokemon/FirstTabPages/ParentPages/ImageFiles.dart';
import 'package:pokemon/FirstTabPages/ParentPages/NationalSymbols.dart';
import 'package:pokemon/MainPages/Other/AppBarDrawer.dart';
import 'package:pokemon/MainPages/PortraitPages/ThirdPage.dart';
import 'package:pokemon/SubCategory.dart';
import 'package:shimmer/shimmer.dart';
import '../../GeneralUtilityFunctions.dart';
import 'package:in_app_update/in_app_update.dart';

class HorizontalMainPage extends StatefulWidget
{

  @override
  _HorizontalMainPageState createState() => _HorizontalMainPageState();
}

class _HorizontalMainPageState extends State<HorizontalMainPage>
{
  DateTime? currentBackPressTime;

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
      drawer: RepublicDrawer(),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>
            [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>
                [
                  GestureDetector(
                    onTap: () => celebrateAlert(context),
                    child: Container(
                        padding: EdgeInsets.all(8),
                        height: MediaQuery.of(context).size.height/2-55,
                        width: MediaQuery.of(context).size.width/2-25,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: LinearGradient(colors: [Constants.OrangeColor, Constants.OrangeColor])),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:
                          [
                            Image.asset(
                              'assets/images/military.gif',
                              height: MediaQuery.of(context).size.height*0.25,
                              width: MediaQuery.of(context).size.height*0.25,
                              fit: BoxFit.fill,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height/2-45,
                              width: MediaQuery.of(context).size.width/4-25,
                              alignment: Alignment.center,
                              child: Text('CELEBRATE INDEPENDENCE DAY',textAlign: TextAlign.center,style: TextStyle(color: Colors.white, letterSpacing:1, fontWeight: FontWeight.bold, fontSize: 17,),
                                maxLines: 4,),
                            ),
                          ],
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder : (BuildContext context)=>NationalSymbols(Constants.NationalSymbolsAPI, Constants.AppBarIndia))),
                    child: Container(
                        padding: EdgeInsets.all(8),
                        height: MediaQuery.of(context).size.height/2-55,
                        width: MediaQuery.of(context).size.width/2-25,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: LinearGradient(colors: [Constants.GreenColor, Constants.GreenColor])),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:
                          [
                            Image.asset(
                              'assets/images/map.gif',
                              height: MediaQuery.of(context).size.height*0.25,
                              width: MediaQuery.of(context).size.height*0.25,
                              fit: BoxFit.fill,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height/2-45,
                              width: MediaQuery.of(context).size.width/4-25,
                              alignment: Alignment.center,
                              child: Text('INCREDIBLE INDIA', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, letterSpacing:1,fontWeight: FontWeight.bold,fontSize: 17,),
                                maxLines: 4,),
                            ),
                          ],
                        )
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>
                  [
                    FirstHorizontalCard(context, "assets/images/butterfly.gif", "SHAYARI",ImageFiles(Constants.ShayariAPI, Constants.AppBarShayari,"SHAYARI")),
                    FirstHorizontalCard(context, "assets/images/circle.gif", "NAME LETTERS", ImageFiles(Constants.NameLettersAPI, Constants.AppBarNameLetters,"NAME LETTERS")),
                  ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>
                [
                  FirstHorizontalCard(context, "assets/images/heart.gif", "REAL HEROES",ThirdPage()),
                  FirstHorizontalCard(context, "assets/images/jai_hind.gif", "MEDIA", SubCategory()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop()
  {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2))
    {
      currentBackPressTime = now;
      showToast(context,"PRESS BACK BUTTON AGAIN TO EXIT");
      return Future.value(false);
    }
    return Future.value(true);
  }

  // ignore: non_constant_identifier_names
  Widget FirstHorizontalCard(BuildContext context, String image, String title, Widget nextPage)
  {
    return GestureDetector(
      onTap: () async => await check() ? Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage)) : showToast(context, "KINDLY CHECK YOUR INTERNET CONNECTION"),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
        child: Container(
          height: MediaQuery.of(context).size.height / 2 - 65,
          width: MediaQuery.of(context).size.width / 4 - 25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>
            [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height:
                  MediaQuery.of(context).size.height / 2 - 110,
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Shimmer.fromColors(
                  highlightColor: Constants.GreenColor,
                  baseColor: Colors.deepOrange,
                  child: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
