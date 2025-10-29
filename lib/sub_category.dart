import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:pokemon/second_tab_pages/parent_pages/ringtones_list.dart';
import 'package:pokemon/second_tab_pages/parent_pages/video_files.dart';
import 'package:toast/toast.dart';
import 'constants.dart';
import 'first_tab_pages/parent_pages/image_files.dart';
import 'first_tab_pages/parent_pages/national_songs_list.dart';
import 'general_utility_functions.dart';
import 'main_pages/other/app_bar_drawer.dart';
import 'main_pages/portrait_pages/second_page.dart';

class SubCategory extends StatefulWidget 
{
  const SubCategory({super.key});

  @override
  SubCategoryState createState() => SubCategoryState();
}

class SubCategoryState extends State<SubCategory>
{
  @override
  Widget build(BuildContext context) 
  {
    ToastContext().init(context);
    return Scaffold(
      appBar: const RepublicDrawer().RepublicAppBar(context, Constants.OutputAppBarTitle),
      body: OrientationBuilder(
        builder : (context, orientation)
            {
              return orientation==Orientation.portrait? const SecondPage(): Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>
                  [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>
                      [
                        LandScapeCard("assets/images/butterfly.gif", "SONGS", NationalSongsList(Constants.NationalSongsAPI, Constants.AppBarSongs), true),
                        LandScapeCard("assets/images/heart.gif", "WALLPAPER", ImageFiles(Constants.WallpaperAPI, Constants.AppBarWallpaper,"WALLPAPERS"), false),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>
                      [
                        LandScapeCard("assets/images/circle.gif", "STATUS", VideoFiles(Constants.VideoStatusAPI, Constants.AppBarStatus), false),
                        LandScapeCard("assets/images/box.gif", "RINGTONE", RingtonesList(Constants.RingtoneAPI, Constants.AppBarRingtone), true),
                      ],
                    ),
                  ],
                ),
              );
            }
      )
    );
  }

  // ignore: non_constant_identifier_names
  Widget LandScapeCard(String image, String title, Widget ReturnWidget, bool fill)
  {
    return GestureDetector(
      onTap: () async => await check() ? Future.delayed(Duration.zero, () {

        Navigator.push(context, MaterialPageRoute(builder : (BuildContext context)=>ReturnWidget));

      }): showToast("KINDLY CHECK YOUR INTERNET CONNECTION"),
      child: Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height/2-55,
          width: MediaQuery.of(context).size.width/2-25,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: LinearGradient(colors: fill?[Constants.OrangeColor, Constants.OrangeColor]:[Constants.GreenColor, Constants.GreenColor])),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
            [
              Image.asset(
                image,
                height: MediaQuery.of(context).size.height*0.25,
                width: MediaQuery.of(context).size.height*0.25,
                fit: BoxFit.fill,
              ),
              Container(
                height: MediaQuery.of(context).size.height/2-45,
                width: MediaQuery.of(context).size.width/4-25,
                alignment: Alignment.center,
                child: Text(title,style: const TextStyle(color: Colors.white, letterSpacing:1,fontWeight: FontWeight.bold,fontSize: 20,),
                  maxLines: 4,),
              ),
            ],
          )
      ),
    );
  }
}

