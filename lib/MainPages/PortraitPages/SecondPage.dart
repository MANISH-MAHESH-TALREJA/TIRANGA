import 'package:flutter/material.dart';
import 'package:pokemon/Constants.dart';
import 'package:pokemon/FirstTabPages/ParentPages/ImageFiles.dart';
import 'package:pokemon/FirstTabPages/ParentPages/NationalSymbols.dart';
import 'package:pokemon/SecondTabPages/ParentPages/RingtoneFiles.dart';
import 'package:pokemon/SecondTabPages/ParentPages/VideoFiles.dart';
import 'package:pokemon/FirstTabPages/ParentPages/NationalSongs.dart';
import '../../GeneralUtilityFunctions.dart';

class SecondPage extends StatefulWidget
{
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage>
{
  @override
  Widget build(BuildContext context)
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            NavratriCard("assets/images/butterfly.gif", Constants.OrangeColor, "SONGS",NationalSongs(Constants.NationalSongsAPI, Constants.AppBarSongs)),
            NavratriCard("assets/images/circle.gif", Constants.OrangeColor, "STATUS",VideoFiles(Constants.VideoStatusAPI, Constants.AppBarStatus)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: () async => await check() ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> NationalSymbols(Constants.NationalSymbolsAPI, Constants.AppBarIndia))) : showToast(context, "KINDLY CHECK YOUR INTERNET CONNECTION"),
            child: Stack(
              children:
              [
                Container(
                    height: MediaQuery.of(context).size.height*0.15,
                    width: MediaQuery.of(context).size.width*0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(color: Constants.BlueColor,width: 3),
                        color: Colors.transparent
                    )
                ),
                Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                            height: 75,
                            width: MediaQuery.of(context).size.width*0.2,
                            child: Image(image: AssetImage("assets/images/ashoka_chakra.gif"), fit:BoxFit.scaleDown
                            )
                        ),
                      ),
                    )
                ),
                Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                            height: 75,
                            width: MediaQuery.of(context).size.width*0.2,
                            child: Image(image: AssetImage("assets/images/ashoka_chakra.gif"), fit:BoxFit.scaleDown
                            )
                        ),
                      ),
                    )
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "MY INDIA",textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Constants.BlueColor, fontSize: MediaQuery.of(context).size.width*0.06, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            NavratriCard("assets/images/heart.gif", Constants.GreenColor, "WALLPAPER",ImageFiles(Constants.WallpaperAPI, Constants.AppBarWallpaper,"WALLPAPER")),
            NavratriCard("assets/images/jai_hind.gif", Constants.GreenColor, "RINGTONE",RingtoneFiles(Constants.RingtoneAPI, Constants.AppBarRingtone)),
          ],
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget NavratriCard(String image, Color backColor, String text, Widget NavratriWidget)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () async => await check() ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> NavratriWidget)) : showToast(context, "KINDLY CHECK YOUR INTERNET CONNECTION"),
        child: Stack(
          children:
          [
            Container(
                height: MediaQuery.of(context).size.height*0.25,
                width: MediaQuery.of(context).size.width*0.4,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.transparent
                )
            ),
            Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: MediaQuery.of(context).size.height*0.17,
                      width: MediaQuery.of(context).size.width*0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          image: DecorationImage(
                              image: AssetImage('assets/images/maa_tujhe_salaam.gif'),
                              fit: BoxFit.fill
                          )
                      )
                  ),
                )
            ),
            Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: MediaQuery.of(context).size.height*0.17,
                      width: MediaQuery.of(context).size.width*0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: backColor.withOpacity(0.9),
                      )
                  ),
                )
            ),
            Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      height: MediaQuery.of(context).size.height*0.13,
                      width: MediaQuery.of(context).size.width*0.25,
                      child: Image(image: AssetImage(image), fit:BoxFit.fill
                      )
                  ),
                )
            ),
            Positioned.fill(
              top: MediaQuery.of(context).size.height*0.17,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(text,textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontSize: MediaQuery.of(context).size.width*0.06, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}