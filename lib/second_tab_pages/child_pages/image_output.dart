import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pokemon/constants.dart';
import 'package:pokemon/general_utility_functions.dart';
import 'package:toast/toast.dart';

import '../../main_pages/other/app_bar_drawer.dart';

// ignore: must_be_immutable
class ImageOutput extends StatefulWidget
{
  String image;
  String imageType;
  ImageOutput({super.key, required this.image, required this.imageType});
  @override
  ImageOutputState createState() => ImageOutputState();
}

class ImageOutputState extends State<ImageOutput>
{

  @override
  Widget build(BuildContext context) 
  {
    ToastContext().init(context);
    return Scaffold(
      appBar: const RepublicDrawer().RepublicAppBar(context,Constants.OutputAppBarTitle),
      body: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width-25,
            height: MediaQuery.of(context).size.height - 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: FadeInImage(
                image: NetworkImage(widget.image),
                fit: BoxFit.fill,
                placeholder:
                const AssetImage('assets/images/my_india.gif'),
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
        animatedIconTheme: const IconThemeData(size: 22.0),
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
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
              child: const Icon(Icons.image),
              backgroundColor: Colors.yellow,
              label: 'SAVE TO GALLERY',
              labelStyle: const TextStyle(fontSize: 18.0),
              onTap: () async => saveMedia(context, widget.image, widget.imageType,'Pictures')
          ),
          SpeedDialChild(
              child: const Icon(Icons.share),
              backgroundColor: Colors.red,
              label: 'SHARE ${widget.imageType}',
              labelStyle: const TextStyle(fontSize: 18.0),
              onTap: () => mediaShare(widget.image, widget.imageType, "image")
          ),
          SpeedDialChild(
            child: const Icon(Icons.home),
            backgroundColor: Colors.blue,
            label: 'SET AS HOME SCREEN',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () async => setWallpaper(context, widget.image, "HOME SCREEN", 1)
          ),
          SpeedDialChild(
            child: const Icon(Icons.lock),
            backgroundColor: Constants.GreenColor,
            label: 'SET AS LOCK SCREEN',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () async => setWallpaper(context, widget.image, "LOCK SCREEN", 2)
          ),
          SpeedDialChild(
            child: const Icon(Icons.mobile_friendly),
            backgroundColor: Colors.pinkAccent,
            label: 'SET AS BOTH SCREENS',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () async => setWallpaper(context, widget.image, "HOME SCREEN AND LOCK SCREEN", 3)
          ),
        ],
      ),
    );
  }
}