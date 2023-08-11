// ignore_for_file: use_build_context_synchronously

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:pokemon/constants.dart';
import 'package:pokemon/general_utility_functions.dart';

class NotificationUtility
{
  static String generalNotificationType = "GENERAL";

  static String mediaNotificationType = "MEDIA";

  static Future<void> setUpNotificationService(BuildContext buildContext) async
  {
    NotificationSettings notificationSettings = await FirebaseMessaging.instance.getNotificationSettings();

    if (notificationSettings.authorizationStatus == AuthorizationStatus.notDetermined)
    {
      notificationSettings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: true,
        sound: true,
      );

      //if permission is provisional or authorised
      if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized || notificationSettings.authorizationStatus == AuthorizationStatus.provisional)
      {
        initNotificationListener(buildContext);
      }

      //if permission denied
    }
    else if (notificationSettings.authorizationStatus == AuthorizationStatus.denied)
    {
      return;
    }
    initNotificationListener(buildContext);
  }

  static void initNotificationListener(BuildContext buildContext)
  {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen(foregroundMessageListener);
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage)
    {
      onMessageOpenedAppListener(remoteMessage, buildContext);
    });
  }

  static Future<void> onBackgroundMessage(RemoteMessage remoteMessage) async
  {
    //perform any background task if needed here
  }

  static void foregroundMessageListener(RemoteMessage remoteMessage) async
  {
    await FirebaseMessaging.instance.getToken();
    createLocalNotification(dismiss: true, message: remoteMessage);
  }

  static void onMessageOpenedAppListener(RemoteMessage remoteMessage, BuildContext buildContext)
  {
    _onTapNotificationScreenNavigateCallback(remoteMessage.data['type'] ?? "", remoteMessage.data);
  }

  static void _onTapNotificationScreenNavigateCallback(String notificationType, Map<String, dynamic> data)
  {
    debugPrint("ON NOTIFICATION CLICKED $notificationType");
    if (notificationType == generalNotificationType)
    {
     // navigate to some page
    }
    else if (notificationType == mediaNotificationType)
    {
      // navigate to some page
    }
  }

  static Future<void> initializeAwesomeNotification() async
  {
    await AwesomeNotifications().initialize("resource://drawable/ic_stat_tiranga", [
      NotificationChannel(
        channelKey: Constants.AppName,
        channelName: Constants.AppName,
        channelDescription: 'NOTIFICATION CHANNEL FOR TIRANGA NOTIFICATIONS',
        vibrationPattern: highVibrationPattern,
      ),
    ], debug: true);
  }

  static Future<bool> isLocalNotificationAllowed() async
  {
    const notificationPermission = Permission.notification;
    final status = await notificationPermission.status;
    return status.isGranted;
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async
  {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async
  {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async
  {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async
  {
    debugPrint("ACTION RECEIVED METHOD : ${receivedAction.buttonKeyPressed} ${receivedAction.payload}");
    if(receivedAction.buttonKeyPressed.compareTo("BUTTON - SHARE MUSIC") == 0)
    {
      mediaShare(receivedAction.payload!["LINK"]!, receivedAction.payload!["MEDIA NAME"]!, "audio");
    }
    if(receivedAction.buttonKeyPressed.compareTo("BUTTON - OPEN PICTURES") == 0 || receivedAction.buttonKeyPressed.compareTo("BUTTON - OPEN MUSIC") == 0 || receivedAction.buttonKeyPressed.compareTo("BUTTON - OPEN MOVIES") == 0)
    {
      OpenFile.open(receivedAction.payload!["PATH"]!);
    }
    if(receivedAction.buttonKeyPressed.compareTo("BUTTON - SHARE PICTURES") == 0)
    {
      mediaShare(receivedAction.payload!["LINK"]!, receivedAction.payload!["MEDIA NAME"]!, "image");
    }
    if(receivedAction.buttonKeyPressed.compareTo("BUTTON - SHARE MOVIES") == 0)
    {
      mediaShare(receivedAction.payload!["LINK"]!, receivedAction.payload!["MEDIA NAME"]!, "video");
    }
    debugPrint("ACTION RECEIVED METHOD : ${receivedAction.buttonKeyPressed} ${receivedAction.payload}");
    _onTapNotificationScreenNavigateCallback((receivedAction.payload ?? {})['type'] ?? "", Map.from(receivedAction.payload ?? {}));
  }

  static Future<void> createLocalNotification({required bool dismiss, required RemoteMessage message}) async
  {
    String title = message.data['title'] ?? "";
    String body = message.data['body'] ?? "";

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        autoDismissible: dismiss,
        title: title,
        body: body,
        id: 1,
        showWhen: true,
        locked: !dismiss,
        payload: {"type": message.data['type'] ?? ""},
        channelKey: Constants.AppNotificationKey,
      ),
    );
  }
}
