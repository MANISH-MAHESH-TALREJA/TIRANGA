// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
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
import 'package:awesome_notifications/awesome_notifications.dart';
import '../../notification_utility.dart';

import 'first_tab_pages/parent_pages/celebrate.dart';

void showToast(String message)
{
  Toast.show(message, gravity: 0, backgroundColor: Constants.OrangeColor, webTexColor: Constants.GreenColor, duration: 4);
}

void failureFunction(BuildContext context, Widget refreshWidget)
{
  showDialog(
      context: context,
      builder: (_) => AssetGiffDialog(
        title: const Text(
          'REQUEST FAILED',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: Constants.OrangeColor),
        ),
        description: const Text(
          'SOME ERROR OCCURRED. PLEASE TRY AGAIN',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Constants.GreenColor,
              fontWeight: FontWeight.bold),
        ),
        entryAnimation: EntryAnimation.topLeft,
        onOkButtonPressed: ()
        {
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => refreshWidget));
        },
        onCancelButtonPressed: ()
        {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        image: Image.asset("assets/images/indian_flag.gif"),
      )
  );
}

void newDownloadFunction(String url, String mediaFolder, String defaultFolder)
{
  int min = 00;
  int max = 99;
  var randomizer = Random();
  var rNum = min + randomizer.nextInt(max - min);
  String mediaFileName  = "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().microsecond}.";
  mediaFileName+=mediaChecker(url);
  showToast('DOWNLOAD STARTED');
  AwesomeNotifications().setListeners(
      onActionReceivedMethod:         NotificationUtility.onActionReceivedMethod,
      onNotificationCreatedMethod:    NotificationUtility.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:  NotificationUtility.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:  NotificationUtility.onDismissActionReceivedMethod
  );
  FileDownloader.setLogEnabled(true);
  FileDownloader.downloadFile(
      url: url,
      name: mediaFileName,
      onProgress: (data, progress)
      {
        debugPrint(progress.toString());
        debugPrint(progress.toInt().toString());
      },
      onDownloadCompleted: (String path)
      {
        if(defaultFolder.compareTo("Pictures") == 0)
        {
          AwesomeNotifications().createNotification(
              actionButtons:
              [
                NotificationActionButton(key: "BUTTON - SHARE ${defaultFolder.toUpperCase()}", label: "SHARE $mediaFolder", color: Constants.BlueColor),
                NotificationActionButton(key: "BUTTON - OPEN ${defaultFolder.toUpperCase()}", label: "VIEW $mediaFolder", color: Constants.BlueColor),
              ],
              content: NotificationContent(
                id: rNum,
                channelKey: 'TIRANGA',
                color: Constants.GreenColor,
                backgroundColor: Constants.OrangeColor,
                title: "$mediaFolder DOWNLOADED SUCCESSFULLY",
                body: 'SAVED TO DOWNLOADS FOLDER',
                actionType: ActionType.Default,
                bigPicture: url,
                roundedBigPicture: true,
                notificationLayout: NotificationLayout.BigPicture,
                category: NotificationCategory.Message,
                payload:
                {
                  "LINK" : url,
                  "MEDIA TYPE" : defaultFolder,
                  "MEDIA NAME" : mediaFolder,
                  "PATH" : path
                },
              )
          );
        }
        if(defaultFolder.compareTo("Music") == 0 || defaultFolder.compareTo("Movies") == 0)
        {
          AwesomeNotifications().createNotification(
              actionButtons:
              [
                if(mediaFolder.compareTo("NATIONAL SONG") == 1)
                  NotificationActionButton(key: "BUTTON - SHARE ${defaultFolder.toUpperCase()}", label: "SHARE $mediaFolder", color: Constants.BlueColor),
                NotificationActionButton(key: "BUTTON - OPEN ${defaultFolder.toUpperCase()}", label: "PLAY $mediaFolder", color: Constants.BlueColor),
              ],
              content: NotificationContent(
                id: rNum,
                channelKey: 'TIRANGA',
                color: Constants.GreenColor,
                backgroundColor: Constants.OrangeColor,
                title: "$mediaFolder DOWNLOADED SUCCESSFULLY",
                body: 'SAVED TO DOWNLOADS FOLDER',
                actionType: ActionType.Default,
                notificationLayout: NotificationLayout.Default,
                category: NotificationCategory.Message,
                payload:
                {
                  "LINK" : url,
                  "MEDIA TYPE" : defaultFolder,
                  "MEDIA NAME" : mediaFolder,
                  "PATH" : path
                },
              )
          );
        }
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
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if(await check())
    {
      if (androidInfo.version.sdkInt <= 32)
      {
        PermissionStatus permissionStatus = await Permission.storage.status;
        if(permissionStatus.isGranted)
        {
          newDownloadFunction(url, mediaFolder, defaultFolder);
        }
        else
        {
          await Permission.storage.request();
          PermissionStatus permissionStatus = await Permission.storage.status;
          if(permissionStatus.isGranted)
          {
            newDownloadFunction(url, mediaFolder, defaultFolder);
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
                      newDownloadFunction(url, mediaFolder, defaultFolder);
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
        PermissionStatus audioPermission = await Permission.audio.status;
        PermissionStatus videoPermission = await Permission.videos.status;
        PermissionStatus photoPermission = await Permission.photos.status;
        PermissionStatus notificationPermission = await Permission.notification.status;
        if(audioPermission.isGranted && videoPermission.isGranted && photoPermission.isGranted && notificationPermission.isGranted)
        {
          newDownloadFunction(url, mediaFolder, defaultFolder);
        }
        else
        {
          await [Permission.photos, Permission.videos, Permission.audio, Permission.notification].request();
          PermissionStatus audioPermission = await Permission.audio.status;
          PermissionStatus videoPermission = await Permission.videos.status;
          PermissionStatus notificationPermission = await Permission.notification.status;
          if(audioPermission.isGranted && videoPermission.isGranted && photoPermission.isGranted && notificationPermission.isGranted)
          {
            newDownloadFunction(url, mediaFolder, defaultFolder);
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
                    await [Permission.photos, Permission.videos, Permission.audio, Permission.notification].request();
                    PermissionStatus audioPermission = await Permission.audio.status;
                    PermissionStatus videoPermission = await Permission.videos.status;
                    PermissionStatus notificationPermission = await Permission.notification.status;
                    if(audioPermission.isGranted && videoPermission.isGranted && photoPermission.isGranted && notificationPermission.isGranted)
                    {
                      newDownloadFunction(url, mediaFolder, defaultFolder);
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

void mediaShare(String url, String media, String mediaType) async
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
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  if(await check())
  {
    if (androidInfo.version.sdkInt <= 32)
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
              buttons:
              [
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
    else
    {
      PermissionStatus audioPermission = await Permission.audio.status;
      PermissionStatus videoPermission = await Permission.videos.status;
      PermissionStatus photoPermission = await Permission.photos.status;
      PermissionStatus notificationPermission = await Permission.notification.status;
      if(audioPermission.isGranted && videoPermission.isGranted && photoPermission.isGranted && notificationPermission.isGranted)
      {
        setWallpaperScreen(context, url, screen, type);
      }
      else
      {
        await [Permission.photos, Permission.videos, Permission.audio, Permission.notification].request();
        PermissionStatus audioPermission = await Permission.audio.status;
        PermissionStatus videoPermission = await Permission.videos.status;
        PermissionStatus photoPermission = await Permission.photos.status;
        PermissionStatus notificationPermission = await Permission.notification.status;
        if(audioPermission.isGranted && videoPermission.isGranted && photoPermission.isGranted && notificationPermission.isGranted)
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
              buttons:
              [
                DialogButton(onPressed: () async
                {
                  Navigator.pop(context);
                  await [Permission.photos, Permission.videos, Permission.audio, Permission.notification].request();
                  PermissionStatus audioPermission = await Permission.audio.status;
                  PermissionStatus videoPermission = await Permission.videos.status;
                  PermissionStatus photoPermission = await Permission.photos.status;
                  PermissionStatus notificationPermission = await Permission.notification.status;
                  if(audioPermission.isGranted && videoPermission.isGranted && photoPermission.isGranted && notificationPermission.isGranted)
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
  }
  else
  {
    showToast("KINDLY CHECK YOUR INTERNET CONNECTION");
  }
}


void setRingtone(BuildContext context, String url, int type) async
{
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  if(await check())
  {
    if (androidInfo.version.sdkInt <= 32)
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
              buttons:
              [
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
    else
    {
      PermissionStatus audioPermission = await Permission.audio.status;
      PermissionStatus videoPermission = await Permission.videos.status;
      PermissionStatus photoPermission = await Permission.photos.status;
      PermissionStatus notificationPermission = await Permission.notification.status;
      if(audioPermission.isGranted && videoPermission.isGranted && photoPermission.isGranted && notificationPermission.isGranted)
      {
        setRingtoneScreen(context, url, type);
      }
      else
      {
        await [Permission.photos, Permission.videos, Permission.audio, Permission.notification].request();
        PermissionStatus audioPermission = await Permission.audio.status;
        PermissionStatus videoPermission = await Permission.videos.status;
        PermissionStatus photoPermission = await Permission.photos.status;
        PermissionStatus notificationPermission = await Permission.notification.status;
        if(audioPermission.isGranted && videoPermission.isGranted && photoPermission.isGranted && notificationPermission.isGranted)
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
              buttons:
              [
                DialogButton(onPressed: () async
                {
                  Navigator.pop(context);
                  await [Permission.photos, Permission.videos, Permission.audio, Permission.notification].request();
                  PermissionStatus audioPermission = await Permission.audio.status;
                  PermissionStatus videoPermission = await Permission.videos.status;
                  PermissionStatus photoPermission = await Permission.photos.status;
                  PermissionStatus notificationPermission = await Permission.notification.status;
                  if(audioPermission.isGranted && videoPermission.isGranted && photoPermission.isGranted && notificationPermission.isGranted)
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
  }
  else
  {
    showToast("KINDLY CHECK YOUR INTERNET CONNECTION");
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
