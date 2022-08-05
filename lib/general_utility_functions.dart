// ignore_for_file: use_build_context_synchronously

import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:giff_dialog/giff_dialog.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:ringtone_set/ringtone_set.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;

import 'first_tab_pages/parent_pages/celebrate.dart';

void showToast(String message)
{
  Toast.show(message, gravity: 0, backgroundColor: Constants.OrangeColor, webTexColor: Constants.GreenColor, duration: 4);
}

void newDownloadFunction(String url)
{
  String mediaFileName  = "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().microsecond}.";
  mediaFileName+=mediaChecker(url);
  showToast('DOWNLOAD STARTED');
  FileDownloader.setLogEnabled(true);
  FileDownloader.downloadFile(
      url: url,
      name: mediaFileName,
      onDownloadCompleted: (String path)
      {
        showToast('FILE DOWNLOADED TO PATH: $path');
        debugPrint('FILE DOWNLOADED TO PATH: $path');
      },
      onDownloadError: (String error)
      {
        showToast('DOWNLOAD ERROR: $error');
        debugPrint('DOWNLOAD ERROR: $error');
      });
}

void saveMedia(BuildContext context, String url, String mediaFolder, String defaultFolder) async
{

    if(await check())
    {
      PermissionStatus permissionStatus = await Permission.storage.status;
      if(permissionStatus.isGranted)
      {
        newDownloadFunction(url);
      }
      else
      {
        await Permission.storage.request();
        PermissionStatus permissionStatus = await Permission.storage.status;
        if(permissionStatus.isGranted)
        {
          newDownloadFunction(url);
        }
        else
        {
          Alert(context: context, type: AlertType.error, style: AlertStyle(
              animationType: AnimationType.fromTop,
              isCloseButton: false,
              isOverlayTapDismiss: false,
              animationDuration: const Duration(milliseconds: 500),
              alertBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.pink,),),
              titleStyle: const TextStyle(color: Colors.red)),
              title: "PERMISSION DENIED", desc: "KINDLY ALLOW THE PERMISSION IN ORDER TO SAVE $mediaFolder TO STORAGE AND SHARE",
              buttons:
              [
                DialogButton(onPressed: () async
                    {
                      Navigator.pop(context);
                      await Permission.storage.request();
                      PermissionStatus permissionStatus = await Permission.storage.status;
                      if(permissionStatus.isGranted)
                      {
                        newDownloadFunction(url);
                      }
                    }, width: 120, child: const Text("RETRY", style: TextStyle(color: Colors.white, fontSize: 20))),
                DialogButton(onPressed: () async
                    {
                      Navigator.pop(context);
                    }, width: 120, child: const Text("CANCEL", style: TextStyle(color: Colors.white, fontSize: 20)))
              ]).show();
        }
      }
    }
    else
    {
      showToast("KINDLY CHECK YOUR INTERNET CONNECTION");
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
  showToast("PLEASE WAIT !!!!");
  if(await check())
  {
    var response = await http.get(Uri.parse(url));
    await Share.file('TIRANGA $media', 'TIRANGA.${mediaChecker(url)}', response.bodyBytes.buffer.asUint8List(), '$mediaType/${mediaChecker(url)}', text: 'SHARE TIRANGA $media');
  }
  else
  {
    showToast("KINDLY CHECK YOUR INTERNET CONNECTION");
  }
}

void launchLink(String link)
{
  // ignore: unnecessary_null_comparison
  if (canLaunchUrl(Uri.parse(link)) != null)
  {
    launchUrl(Uri.parse(link));
  }
  else
  {
    throw 'UNABLE TO LAUNCH !!!';
  }
}

void setWallpaperScreen(BuildContext context, String url, String screen, int type) async
{
  int location = type;
  showToast("PLEASE WAIT !!!!");
  File file = await DefaultCacheManager().getSingleFile(url);
  debugPrint("MY FILE : $file");
  await WallpaperManagerFlutter().setwallpaperfromFile(file, location);
  showToast("$screen WALLPAPER CHANGED SUCCESSFULLY !!!!");
}

void setRingtoneScreen(BuildContext context, String url, int type) async
{
  bool status = false;
  String ringtoneType = "";
  showToast("PLEASE WAIT !!!!");
  if(type == 0)
  {
    status = await RingtoneSet.setAlarmFromNetwork(url);
    ringtoneType = "ALARM";
  }
  if(type == 1)
  {
    status = await RingtoneSet.setRingtoneFromNetwork(url);
    ringtoneType = "CALL";
  }
  if(type == 2)
  {
    status = await RingtoneSet.setNotificationFromNetwork(url);
    ringtoneType = "NOTIFICATION";
  }
  if(status)
  {
    showToast("$ringtoneType RINGTONE CHANGED SUCCESSFULLY !!!!");
  }
  else
  {
    showToast("$ringtoneType RINGTONE CHANGED FAILED !!!!");
  }

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
          animationDuration: const Duration(milliseconds: 500),
          alertBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.pink,),),
          titleStyle: const TextStyle(color: Colors.red)),
          title: "PERMISSION DENIED", desc: "KINDLY ALLOW THE PERMISSION TO SET WALLPAPER",
          buttons: [
            DialogButton(onPressed: () async
                {
                  Navigator.pop(context);
                  await Permission.storage.request();
                  PermissionStatus permissionStatus = await Permission.storage.status;
                  if(permissionStatus.isGranted)
                  {
                    setWallpaperScreen(context, url, screen, type);
                  }
                }, width: 120, child: const Text("RETRY", style: TextStyle(color: Colors.white, fontSize: 20))),
            DialogButton(onPressed: () async
                {
                  Navigator.pop(context);
                }, width: 120, child: const Text("CANCEL", style: TextStyle(color: Colors.white, fontSize: 20)))
          ]).show();
    }
  }

}

void setRingtone(BuildContext context, String url, int type) async
{
  PermissionStatus permissionStatus = await Permission.storage.status;
  if(permissionStatus.isGranted)
  {
    setRingtoneScreen(context, url, type);
  }
  else
  {
    await Permission.storage.request();
    PermissionStatus permissionStatus = await Permission.storage.status;
    if(permissionStatus.isGranted)
    {
      setRingtoneScreen(context, url, type);
    }
    else
    {
      Alert(context: context, type: AlertType.error, style: AlertStyle(
          animationType: AnimationType.fromTop,
          isCloseButton: false,
          isOverlayTapDismiss: false,
          animationDuration: const Duration(milliseconds: 500),
          alertBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.pink,),),
          titleStyle: const TextStyle(color: Colors.red)),
          title: "PERMISSION DENIED", desc: "KINDLY ALLOW THE PERMISSION TO SET RINGTONE",
          buttons: [
            DialogButton(onPressed: () async
            {
              Navigator.pop(context);
              await Permission.storage.request();
              PermissionStatus permissionStatus = await Permission.storage.status;
              if(permissionStatus.isGranted)
              {
                setRingtoneScreen(context, url, type);
              }
            }, width: 120, child: const Text("RETRY", style: TextStyle(color: Colors.white, fontSize: 20))),
            DialogButton(onPressed: () async
            {
              Navigator.pop(context);
            }, width: 120, child: const Text("CANCEL", style: TextStyle(color: Colors.white, fontSize: 20)))
          ]).show();
    }
  }

}

void shareMe()
{
  Share.text('SHARE TIRANGA APP',
      "SHARE TIRANGA - VIRTUAL INDEPENDENCE DAY APP MADE BY RAAM DEVELOPERS. YOU CAN DOWNLOAD THE APP BY CLICKING ON THE LINK BELOW FROM GOOGLE PLAY STORE. \n\n${Constants.AppPlayStoreLink}", 'text/plain');
}

Future<bool> check() async
{
  var result = await (Connectivity().checkConnectivity());
  if (result == ConnectivityStatus.none)
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
      builder: (_) => AssetGiffDialog(
        title: const Text(
          'FOLLOW INSTRUCTIONS',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: Constants.OrangeColor),
        ),
        description: const Text(
          'STAND STRAIGHT, SING ALOUD AND WITH A FEELING OF TRUE PATRIOT',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Constants.GreenColor,
              fontWeight: FontWeight.bold),
        ),
        entryAnimation: EntryAnimation.topLeft,
        onOkButtonPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Celebrate())),
        image: Image.asset("assets/images/indian_flag.gif"),
      )
  );
}
