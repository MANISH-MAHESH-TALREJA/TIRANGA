import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Communicates the current state of the audio player.
enum AudioPlayerState {
  /// Player is stopped. No file is loaded to the player. Calling [resume] or
  /// [pause] will result in exception.
  stopped,

  /// Currently playing a file. The user can [pause], [resume] or [stop] the
  /// playback.
  playing,

  /// Paused. The user can [resume] the playback without providing the URL.
  paused,

  /// The playback has been completed. This state is the same as [stopped],
  /// however we differentiate it because some clients might want to know when
  /// the playback is done versus when the user has stopped the playback.
  completed,
}

const MethodChannel _channel = MethodChannel('net.manish.audio/audio');

/// A plugin for controlling the on device audio player.
///
/// Due to the async nature of the native APIs, this plugin delegates all control
/// methods to native without informing the caller of the state changes that happen
/// as a result of these calls. The state changes are communicated via the
/// [onPlayerStateChanged] stream instead so clients are expected to subscribe
/// to this.
class AudioPlayer {
  final StreamController<AudioPlayerState> _playerStateController =
      StreamController.broadcast();

  final StreamController<Duration> _positionController =
      StreamController.broadcast();

  AudioPlayerState _state = AudioPlayerState.stopped;
  Duration _duration = const Duration();

  AudioPlayer() {
    _channel.setMethodCallHandler(_audioPlayerStateChange);
  }

  /// Play a given url.
  Future<void> play(String url, {bool isLocal = false}) async =>
      await _channel.invokeMethod('play', {'url': url, 'isLocal': isLocal});

  /// Pause the currently playing stream.
  Future<void> pause() async => await _channel.invokeMethod('pause');

  /// Stop the currently playing stream.
  Future<void> stop() async => await _channel.invokeMethod('stop');

  /// Mute sound.
  Future<void> mute(bool muted) async =>
      await _channel.invokeMethod('mute', muted);

  /// Seek to a specific position in the audio stream.
  Future<void> seek(double seconds) async =>
      await _channel.invokeMethod('seek', seconds);

  /// Stream for subscribing to player state change events.
  Stream<AudioPlayerState> get onPlayerStateChanged =>
      _playerStateController.stream;

  /// Reports what the player is currently doing.
  AudioPlayerState get state => _state;

  /// Reports the duration of the current media being played. It might return
  /// 0 if we have not determined the length of the media yet. It is best to
  /// call this from a state listener when the state has become
  /// [AudioPlayerState.playing].
  Duration get duration => _duration;

  /// Stream for subscribing to audio position change events. Roughly fires
  /// every 200 milliseconds. Will continously update the position of the
  /// playback if the status is [AudioPlayerState.playing].
  Stream<Duration> get onAudioPositionChanged => _positionController.stream;

  Future<void> _audioPlayerStateChange(MethodCall call) async {
    switch (call.method) {
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
        // If there's an error, we assume the player has stopped.
        _state = AudioPlayerState.stopped;
        _playerStateController.addError(call.arguments);
        // TODO: Handle error arguments here. It is not useful to pass this
        // to the client since each platform creates different error string
        // formats so we can't expect client to parse these.
        break;
      default:
        throw ArgumentError('Unknown method ${call.method} ');
    }
  }
}
