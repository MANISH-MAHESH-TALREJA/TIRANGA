import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';

class AndroidInfo {
  static const MethodChannel _channel =
  const MethodChannel('net.manish.pokemon/version');

  static Future<Map<dynamic, dynamic>?>? get version async
  {
    if (!Platform.isAndroid)
    {
      return null;
    }

    final Map<dynamic, dynamic> _version =
    await _channel.invokeMethod('getAndroidVersion');
    return _version;
  }
}