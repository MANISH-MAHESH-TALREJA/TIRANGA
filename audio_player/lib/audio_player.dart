import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AudioPlayerState
{
  stopped,
  playing,
  paused,
  completed,
}

const MethodChannel _channel = MethodChannel('net.manish.flutter/audio');


class AudioPlayer
{
  final StreamController<AudioPlayerState> _playerStateController =
  StreamController.broadcast();

  final StreamController<Duration> _positionController =
  StreamController.broadcast();

  AudioPlayerState _state = AudioPlayerState.stopped;
  Duration _duration = const Duration();

  AudioPlayer()
  {
    _channel.setMethodCallHandler(_audioPlayerStateChange);
  }

  Future<void> play(String url, {bool isLocal = false}) async => await _channel.invokeMethod('play', {'url': url, 'isLocal': isLocal});

  Future<void> pause() async => await _channel.invokeMethod('pause');

  Future<void> stop() async => await _channel.invokeMethod('stop');

  Future<void> mute(bool muted) async => await _channel.invokeMethod('mute', muted);

  Future<void> seek(double seconds) async => await _channel.invokeMethod('seek', seconds);

  Stream<AudioPlayerState> get onPlayerStateChanged => _playerStateController.stream;

  AudioPlayerState get state => _state;

  Duration get duration => _duration;

  Stream<Duration> get onAudioPositionChanged => _positionController.stream;

  Future<void> _audioPlayerStateChange(MethodCall call) async
  {
    switch (call.method)
    {
      case "audio.onCurrentPosition":
        assert(_state == AudioPlayerState.playing);
        _positionController.add(Duration(milliseconds: call.arguments));
        break;
      case "audio.onStart":
        _state = AudioPlayerState.playing;
        _playerStateController.add(AudioPlayerState.playing);
        debugPrint('PLAYING ${call.arguments}');
        _duration = Duration(milliseconds: call.arguments);
        break;
      case "audio.onPause":
        _state = AudioPlayerState.paused;
        _playerStateController.add(AudioPlayerState.paused);
        break;
      case "audio.onStop":
        _state = AudioPlayerState.stopped;
        _playerStateController.add(AudioPlayerState.stopped);
        break;
      case "audio.onComplete":
        _state = AudioPlayerState.completed;
        _playerStateController.add(AudioPlayerState.completed);
        break;
      case "audio.onError":
        _state = AudioPlayerState.stopped;
        _playerStateController.addError(call.arguments);
        break;
      default:
        throw ArgumentError('Unknown method ${call.method} ');
    }
  }
}
