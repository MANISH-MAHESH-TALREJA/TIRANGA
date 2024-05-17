import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:pokemon/Constants.dart';
import 'package:pokemon/GeneralUtilityFunctions.dart';
import 'package:pokemon/MainPages/Other/AppBarDrawer.dart';

// ignore: must_be_immutable
class ImageOutput extends StatefulWidget
{
  String image;
  String imageType;
  ImageOutput({required this.image, required this.imageType});
  @override
  _ImageOutputState createState() => _ImageOutputState();
}

class _ImageOutputState extends State<ImageOutput>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: RepublicDrawer().RepublicAppBar(context,Constants.OutputAppBarTitle),
      body: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width-25,
            height: MediaQuery.of(context).size.height - 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: FadeInImage(
                image: NetworkImage(widget.image),
                fit: BoxFit.fill,
                placeholder:
                AssetImage('assets/images/my_india.gif'),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        //marginEnd: 20,
        //marginBottom: 20,
        icon: Icons.file_download,
        activeIcon: Icons.close,
        animatedIconTheme: IconThemeData(size: 22.0),
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.0,
        tooltip: 'SHARE OPTIONS',
        heroTag: 'SHARE OPTIONS - DIAL',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.image),
              backgroundColor: Colors.yellow,
              label: 'SAVE TO GALLERY',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () async => saveMedia(context, widget.image, "IMAGES",'Pictures')
          ),
          SpeedDialChild(
              child: Icon(Icons.share),
              backgroundColor: Colors.red,
              label: 'SHARE '+widget.imageType,
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => mediaShare(context, widget.image, widget.imageType, "image")
          ),
          SpeedDialChild(
            child: Icon(Icons.home),
            backgroundColor: Colors.blue,
            label: 'SET AS HOME SCREEN',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async => setWallpaper(context, widget.image, "HOME SCREEN", WallpaperManager.HOME_SCREEN)
          ),
          SpeedDialChild(
            child: Icon(Icons.lock),
            backgroundColor: Constants.GreenColor,
            label: 'SET AS LOCK SCREEN',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async => setWallpaper(context, widget.image, "LOCK SCREEN", WallpaperManager.LOCK_SCREEN)
          ),
          SpeedDialChild(
            child: Icon(Icons.mobile_friendly),
            backgroundColor: Colors.pinkAccent,
            label: 'SET AS BOTH SCREENS',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async => setWallpaper(context, widget.image, "HOME SCREEN AND LOCK SCREEN", WallpaperManager.BOTH_SCREEN)
          ),
        ],
      ),
    );
  }
}