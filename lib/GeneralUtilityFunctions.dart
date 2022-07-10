import 'package:androidversion/androidversion.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'Constants.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'FirstTabPages/ParentPages/Celebrate.dart';

void showToast(BuildContext context, String message)
{
  Toast.show(message, gravity: 0, backgroundColor: Constants.OrangeColor, webTexColor: Constants.GreenColor);
}

Future<String> _findLocalPath() async
{
  var directory = await getExternalStorageDirectory();
  return directory.path;
}

Future<void> downloadMedia(BuildContext context, String url, String mediaFolder, String defaultFolder) async
{
  Directory savedDir;
  bool hasExisted;
  String _localPath/*, mediaPath*/;
  String mediaFileName  = DateTime.now().year.toString()+DateTime.now().month.toString()+DateTime.now().day.toString()+DateTime.now().hour.toString()+DateTime.now().minute.toString()+DateTime.now().second.toString()+DateTime.now().microsecond.toString()+".";
  mediaFileName+=mediaChecker(url);
  List <String> hi = (await _findLocalPath()).split("/");
  String myFile=hi[0];
  for(int i=1;i<hi.length-4;i++)
  {
    myFile+="/"+hi[i];
  }
  _localPath = myFile + Platform.pathSeparator + 'TIRANGA DOWNLOADS';
  savedDir = Directory(_localPath);
  hasExisted = await savedDir.exists();
  if (!hasExisted)
  {
    savedDir.create();
  }
  _localPath = _localPath + Platform.pathSeparator + mediaFolder;
  savedDir = Directory(_localPath);
  hasExisted = await savedDir.exists();
  if (!hasExisted)
  {
    savedDir.create();
  }
  showToast(context, "YOUR DOWNLOAD STARTED. YOUR DOWNLOADED FILES ARE STORED INSIDE TIRANGA DOWNLOADS FOLDER.");
  await FlutterDownloader.enqueue(url: url, savedDir: _localPath, showNotification: true, openFileFromNotification: true, fileName:mediaFileName);
}

void saveMedia(BuildContext context, String url, String mediaFolder, String defaultFolder) async
{
  Map<dynamic, dynamic> _info = await initPlatformState();
  var androidInformation = _info.values.toList();
  if(androidInformation[1] >= 30.0)
  {
    showToast(context, "DOWNLOADING IS UNFORTUNATELY NOT SUPPORTED IN ANDROID 11 MOBILE PHONE. YOU CAN SHARE THE MEDIA USING THE SHARE BUTTON");
  }
  else
  {
    if(await check())
    {
      PermissionStatus permissionStatus = await Permission.storage.status;
      if(permissionStatus.isGranted)
      {
        downloadMedia(context, url, mediaFolder, defaultFolder);
      }
      else
      {
        await Permission.storage.request();
        PermissionStatus permissionStatus = await Permission.storage.status;
        if(permissionStatus.isGranted)
        {
          downloadMedia(context, url, mediaFolder, defaultFolder);
        }
        else
        {
          Alert(context: context, type: AlertType.error, style: AlertStyle(
              animationType: AnimationType.fromTop,
              isCloseButton: false,
              isOverlayTapDismiss: false,
              animationDuration: Duration(milliseconds: 500),
              alertBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.pink,),),
              titleStyle: TextStyle(color: Colors.red)),
              title: "PERMISSION DENIED", desc: "KINDLY ALLOW THE PERMISSION IN ORDER TO SAVE "+mediaFolder+" TO STORAGE AND SHARE",
              buttons:
              [
                DialogButton(child: Text("RETRY", style: TextStyle(color: Colors.white, fontSize: 20)),
                    onPressed: () async
                    {
                      Navigator.pop(context);
                      await Permission.storage.request();
                      PermissionStatus permissionStatus = await Permission.storage.status;
                      if(permissionStatus.isGranted)
                      {
                        downloadMedia(context, url, mediaFolder, defaultFolder);
                      }
                    }, width: 120),
                DialogButton(child: Text("CANCEL", style: TextStyle(color: Colors.white, fontSize: 20)),
                    onPressed: () async
                    {
                      Navigator.pop(context);
                    }, width: 120)
              ]).show();
        }
      }
    }
    else
    {
      showToast(context, "KINDLY CHECK YOUR INTERNET CONNECTION");
    }
  }
}

String mediaChecker(String url)
{
  String extension="";
  if(url.contains("mp3"))
  {
    extension="mp3";
  }
  if(url.contains("mp4"))
  {
    extension="mp4";
  }
  if(url.contains("jpg"))
  {
    extension="jpg";
  }
  if(url.contains("jpeg"))
  {
    extension="jpeg";
  }
  if(url.contains("png"))
  {
    extension="png";
  }
  if(url.contains("gif"))
  {
    extension="gif";
  }
  return extension;
}

void mediaShare(BuildContext context, String url, String media, String mediaType) async
{
  showToast(context,"PLEASE WAIT !!!!");
  if(await check())
  {
    var response = await http.get(Uri.parse(url));
    await WcFlutterShare.share(
        sharePopupTitle: 'SHARE TIRANGA '+media,
        fileName: 'TIRANGA.'+mediaChecker(url),
        mimeType: mediaType+'/'+mediaChecker(url),
        bytesOfFile: response.bodyBytes.buffer.asUint8List());
  }
  else
  {
    showToast(context, "KINDLY CHECK YOUR INTERNET CONNECTION");
  }
}

void launchLink(String link)
{
  if (canLaunch(link) != null)
  {
    launch(link);
  }
  else
  {
    throw 'UNABLE TO LAUNCH !!!';
  }
}

void setWallpaperScreen(BuildContext context, String url, String screen, int type) async
{
  int location = type;
  showToast(context, "PLEASE WAIT !!!!");
  var file = await DefaultCacheManager().getSingleFile(url);
  await WallpaperManager.setWallpaperFromFile(file.path, location);
  showToast(context, screen+" WALLPAPER CHANGED SUCCESSFULLY !!!!");
}

void setWallpaper(BuildContext context, String url, String screen, int type) async
{
  PermissionStatus permissionStatus = await Permission.storage.status;
  if(permissionStatus.isGranted)
  {
    setWallpaperScreen(context, url, screen, type);
  }
  else
  {
    await Permission.storage.request();
    PermissionStatus permissionStatus = await Permission.storage.status;
    if(permissionStatus.isGranted)
    {
      setWallpaperScreen(context, url, screen, type);
    }
    else
    {
      Alert(context: context, type: AlertType.error, style: AlertStyle(
          animationType: AnimationType.fromTop,
          isCloseButton: false,
          isOverlayTapDismiss: false,
          animationDuration: Duration(milliseconds: 500),
          alertBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.pink,),),
          titleStyle: TextStyle(color: Colors.red)),
          title: "PERMISSION DENIED", desc: "KINDLY ALLOW THE PERMISSION IN ORDER TO SET WALLPAPER AS HOME SCREEN BACKGROUND",
          buttons: [
            DialogButton(child: Text("RETRY", style: TextStyle(color: Colors.white, fontSize: 20)),
                onPressed: () async
                {
                  Navigator.pop(context);
                  await Permission.storage.request();
                  PermissionStatus permissionStatus = await Permission.storage.status;
                  if(permissionStatus.isGranted)
                  {
                    setWallpaperScreen(context, url, screen, type);
                  }
                }, width: 120),
            DialogButton(child: Text("CANCEL", style: TextStyle(color: Colors.white, fontSize: 20)),
                onPressed: () async
                {
                  Navigator.pop(context);
                }, width: 120)
          ]).show();
    }
  }

}

void shareMe()
{
  WcFlutterShare.share(
      sharePopupTitle: 'SHARE TIRANGA APP',
      subject: 'TIRANGA - INDIAN INDEPENDENCE DAY APP',
      text: "SHARE TIRANGA - VIRTUAL INDEPENDENCE DAY APP MADE BY RAAM DEVELOPERS. YOU CAN DOWNLOAD THE APP BY CLICKING ON THE LINK BELOW FROM GOOGLE PLAY STORE. \n\n"+Constants.AppPlayStoreLink,
      mimeType: 'text/plain');
}

Future<bool> check() async
{
  var result = await (Connectivity().checkConnectivity());
  if (result == ConnectivityResult.none)
  {
    return false;
  }
  else
  {
    return true;
  }
}

Future<dynamic> celebrateAlert(BuildContext context)
{
  return showDialog(
      context: context,
      builder: (_) => AssetGiffyDialog(
        title: Text(
          'FOLLOW INSTRUCTIONS',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: Constants.OrangeColor),
        ),
        description: Text(
          'STAND STRAIGHT, SING ALOUD AND WITH A FEELING OF TRUE PATRIOT',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Constants.GreenColor,
              fontWeight: FontWeight.bold),
        ),
        entryAnimation: EntryAnimation.TOP_LEFT,
        onOkButtonPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Celebrate())),
        image: Image.asset("assets/images/indian_flag.gif"),
      )
  );
}

Future<Map<dynamic, dynamic>> initPlatformState() async
{
  Map<dynamic, dynamic> info;
  try
  {
    info = await AndroidInfo.version;
  }
  on PlatformException
  {
    info = {'error': 'Failed to get platform version.'};
  }
  return info;
}
