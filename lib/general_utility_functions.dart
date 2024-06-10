// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:set_ringtone/set_ringtone.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaper/wallpaper.dart';
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
      builder: (_) => GiffyDialog.image(Image.asset("assets/images/indian_flag.gif"),
        title: const Text(
          'REQUEST FAILED',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: Constants.OrangeColor),
        ),
        content: const Text(
          'SOME ERROR OCCURRED. PLEASE TRY AGAIN',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Constants.GreenColor,
              fontWeight: FontWeight.bold),
        ),
        entryAnimation: EntryAnimation.topLeft,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                        backgroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.00),
                                side: const BorderSide(color: Constants.GreenColor)
                            )
                        )
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => refreshWidget));
                    },
                    child: SizedBox(
                      width: 100,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(Icons.refresh, color: Colors.white,),
                            const SizedBox(width: 10,),
                            Text(
                                  "OK".toUpperCase(),
                                style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)
                            ),
                          ]
                      ),
                    )
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                        backgroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.00),
                                side: const BorderSide(color: Constants.GreenColor)
                            )
                        )
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      width: 100,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(Icons.cancel_outlined, color: Colors.white,),
                            const SizedBox(width: 10,),
                            Text(
                                "CANCEL".toUpperCase(),
                                style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)
                            ),
                          ]
                      ),
                    )
                ),
              ],
            ),
          )

        ],
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
    if(await check())
    {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if(androidInfo.version.sdkInt >= 33.0)
      {
        PermissionStatus permissionStatus01 = await Permission.audio.status;
        PermissionStatus permissionStatus02 = await Permission.videos.status;
        PermissionStatus permissionStatus03 = await Permission.photos.status;
        PermissionStatus permissionStatus04 = await Permission.notification.status;
        if(permissionStatus01.isGranted && permissionStatus02.isGranted && permissionStatus03.isGranted && permissionStatus04.isGranted)
        {
          newDownloadFunction(url, mediaFolder, defaultFolder);
        }
        else
        {
          await Permission.audio.request();
          await Permission.videos.request();
          await Permission.photos.request();
          await Permission.notification.request();
          PermissionStatus permissionStatus01 = await Permission.audio.status;
          PermissionStatus permissionStatus02 = await Permission.videos.status;
          PermissionStatus permissionStatus03 = await Permission.photos.status;
          PermissionStatus permissionStatus04 = await Permission.notification.status;
          if(permissionStatus01.isGranted && permissionStatus02.isGranted && permissionStatus03.isGranted && permissionStatus04.isGranted)
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
                    await Permission.audio.request();
                    await Permission.videos.request();
                    await Permission.photos.request();
                    await Permission.notification.request();
                    PermissionStatus permissionStatus01 = await Permission.audio.status;
                    PermissionStatus permissionStatus02 = await Permission.videos.status;
                    PermissionStatus permissionStatus03 = await Permission.photos.status;
                    PermissionStatus permissionStatus04 = await Permission.notification.status;
                    if(permissionStatus01.isGranted && permissionStatus02.isGranted && permissionStatus03.isGranted && permissionStatus04.isGranted)
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
  late Stream<String> progressString = Wallpaper.imageDownloadProgress(url, imageName: "TIRANGA-IMAGE", location: DownloadLocation.TEMPORARY_DIRECTORY);
  progressString.listen((data)
  {
    showToast("PLEASE WAIT WE ARE WORKING !!!!");
  }, onDone: () async
  {
    switch(type)
    {
      case 1:
        await Wallpaper.homeScreen(imageName: "TIRANGA-IMAGE", location: DownloadLocation.TEMPORARY_DIRECTORY, options: RequestSizeOptions.RESIZE_FIT, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height);
        showToast("$screen WALLPAPER CHANGED SUCCESSFULLY !!!!");
        break;
      case 2:
        await Wallpaper.lockScreen(imageName: "TIRANGA-IMAGE", location: DownloadLocation.TEMPORARY_DIRECTORY, options: RequestSizeOptions.RESIZE_FIT, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height);
        showToast("$screen WALLPAPER CHANGED SUCCESSFULLY !!!!");
        break;
      case 3:
        await Wallpaper.bothScreen(imageName: "TIRANGA-IMAGE", location: DownloadLocation.TEMPORARY_DIRECTORY, options: RequestSizeOptions.RESIZE_FIT, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height);
        showToast("$screen WALLPAPER CHANGED SUCCESSFULLY !!!!");
        break;
      default:
        showToast("WRONG SCREEN SPECIFIED");
    }
  }, onError: (error)
  {
    showToast("FAILED TO SET WALLPAPER");
  });
}


void setRingtoneScreen(BuildContext context, String url, int type) async
{
  bool status = false;
  String ringtoneType = "";
  showToast("PLEASE WAIT !!!!");
  if(type == 0)
  {
    status = await Ringtone.setAlarmFromNetwork(url);
    ringtoneType = "ALARM";
  }
  if(type == 1)
  {
    status = await Ringtone.setRingtoneFromNetwork(url);
    ringtoneType = "CALL";
  }
  if(type == 2)
  {
    status = await Ringtone.setNotificationFromNetwork(url);
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
  if(await check())
  {
    setWallpaperScreen(context, url, screen, type);
  }
  else
  {
    showToast("KINDLY CHECK YOUR INTERNET CONNECTION");
  }
}

void setRingtone(BuildContext context, String url, int type) async
{
  if(await check())
  {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if(androidInfo.version.sdkInt >= 33.0)
    {
      showToast("THIS FUNCTIONALITY WILL BE ENABLED IN FUTURE UPDATES ...");
      /*PermissionStatus permissionStatus01 = await Permission.audio.status;
      PermissionStatus permissionStatus02 = await Permission.videos.status;
      PermissionStatus permissionStatus03 = await Permission.photos.status;
      PermissionStatus permissionStatus04 = await Permission.notification.status;
      if(permissionStatus01.isGranted && permissionStatus02.isGranted && permissionStatus03.isGranted && permissionStatus04.isGranted)
      {
        setRingtoneScreen(context, url, type);
      }
      else
      {
        await Permission.audio.request();
        await Permission.videos.request();
        await Permission.photos.request();
        await Permission.notification.request();
        PermissionStatus permissionStatus01 = await Permission.audio.status;
        PermissionStatus permissionStatus02 = await Permission.videos.status;
        PermissionStatus permissionStatus03 = await Permission.photos.status;
        PermissionStatus permissionStatus04 = await Permission.notification.status;
        if(permissionStatus01.isGranted && permissionStatus02.isGranted && permissionStatus03.isGranted && permissionStatus04.isGranted)
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
                  await Permission.audio.request();
                  await Permission.videos.request();
                  await Permission.photos.request();
                  await Permission.notification.request();
                  PermissionStatus permissionStatus01 = await Permission.audio.status;
                  PermissionStatus permissionStatus02 = await Permission.videos.status;
                  PermissionStatus permissionStatus03 = await Permission.photos.status;
                  PermissionStatus permissionStatus04 = await Permission.notification.status;
                  if(permissionStatus01.isGranted && permissionStatus02.isGranted && permissionStatus03.isGranted && permissionStatus04.isGranted)
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
      }*/
    }
    else
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
      builder: (_) => GiffyDialog.image(Image.asset("assets/images/indian_flag.gif"),
        title: const Text(
          'FOLLOW INSTRUCTIONS',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              color: Constants.OrangeColor),
        ),
        content: const Text(
          'STAND STRAIGHT, SING ALOUD AND WITH A FEELING OF TRUE PATRIOT',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Constants.GreenColor,
              fontWeight: FontWeight.bold),
        ),
        entryAnimation: EntryAnimation.topLeft,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                        backgroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.00),
                                side: const BorderSide(color: Constants.GreenColor)
                            )
                        )
                    ),
                    onPressed: ()
                    {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Celebrate()));
                    },
                    child: SizedBox(
                      width: 120,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(Icons.celebration_outlined, color: Colors.white,),
                            const SizedBox(width: 10,),
                            Text(
                                "CELEBRATE".toUpperCase(),
                                style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)
                            ),
                          ]
                      ),
                    )
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                        backgroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.00),
                                side: const BorderSide(color: Constants.GreenColor)
                            )
                        )
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: SizedBox(
                      width: 80,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(Icons.info_outline, color: Colors.white,),
                            const SizedBox(width: 10,),
                            Text(
                                "BACK".toUpperCase(),
                                style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)
                            ),
                          ]
                      ),
                    )
                ),
              ],
            ),
          )
        ],
      )
  );
}

