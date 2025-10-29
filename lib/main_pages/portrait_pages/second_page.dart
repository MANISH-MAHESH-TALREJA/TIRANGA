import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:pokemon/constants.dart';
import 'package:toast/toast.dart';
import '../../first_tab_pages/parent_pages/image_files.dart';
import '../../first_tab_pages/parent_pages/national_songs_list.dart';
import '../../first_tab_pages/parent_pages/national_symbols.dart';
import '../../general_utility_functions.dart';
import '../../second_tab_pages/parent_pages/ringtones_list.dart';
import '../../second_tab_pages/parent_pages/video_files.dart';

class SecondPage extends StatefulWidget
{
  const SecondPage({super.key});

  @override
  SecondPageState createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage>
{
  @override
  Widget build(BuildContext context)
  {
    ToastContext().init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          [
            NavratriCard("assets/images/butterfly.gif", Constants.OrangeColor, "SONGS", NationalSongsList(Constants.NationalSongsAPI, Constants.AppBarSongs)),
            NavratriCard("assets/images/circle.gif", Constants.OrangeColor, "STATUS",VideoFiles(Constants.VideoStatusAPI, Constants.AppBarStatus)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: () async => await check() ? Future.delayed(Duration.zero, () {

              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> NationalSymbols(Constants.NationalSymbolsAPI, Constants.AppBarIndia)));

  }) : showToast("KINDLY CHECK YOUR INTERNET CONNECTION"),
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
                        child: SizedBox(
                            height: 75,
                            width: MediaQuery.of(context).size.width*0.2,
                            child: const Image(image: AssetImage("assets/images/ashoka_chakra.gif"), fit:BoxFit.scaleDown
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
                        child: SizedBox(
                            height: 75,
                            width: MediaQuery.of(context).size.width*0.2,
                            child: const Image(image: AssetImage("assets/images/ashoka_chakra.gif"), fit:BoxFit.scaleDown
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
            NavratriCard("assets/images/heart.gif", Constants.GreenColor, "WALLPAPER", ImageFiles(Constants.WallpaperAPI, Constants.AppBarWallpaper,"WALLPAPER")),
            NavratriCard("assets/images/jai_hind.gif", Constants.GreenColor, "RINGTONE", RingtonesList(Constants.RingtoneAPI, Constants.AppBarRingtone)),
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
        onTap: () async => await check() ? Future.delayed(Duration.zero, () {

          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> NavratriWidget));

        }) : showToast("KINDLY CHECK YOUR INTERNET CONNECTION"),
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
                          image: const DecorationImage(
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
                  child: SizedBox(
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