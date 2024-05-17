import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pokemon/GeneralUtilityFunctions.dart';
import '../../Constants.dart';
import '../../audio_player.dart';

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }

class AudioApp extends StatefulWidget
{
  final String url, name;
  AudioApp(this.url,this.name);
  @override
  _AudioAppState createState() => _AudioAppState();
}

class _AudioAppState extends State<AudioApp>
{
  @override
  void initState()
  {
    super.initState();
    initAudioPlayer();
  }

  Duration? duration;
  Duration? position;
  AudioPlayer? audioPlayer;
  String? localFilePath;
  PlayerState playerState = PlayerState.stopped;
  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;
  get durationText => duration != null ? duration.toString().split('.').first.replaceFirst("0:", "") : '';
  get positionText => position != null ? position.toString().split('.').first.replaceFirst("0:", "") : '';
  StreamSubscription? _positionSubscription;
  StreamSubscription? _audioPlayerStateSubscription;

  @override
  void dispose()
  {
    _positionSubscription!.cancel();
    _audioPlayerStateSubscription!.cancel();
    audioPlayer!.stop();
    super.dispose();
  }

  void initAudioPlayer()
  {
    audioPlayer = AudioPlayer();
    _positionSubscription = audioPlayer!.onAudioPositionChanged.listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer!.onPlayerStateChanged.listen((s)
        {
          if (s == AudioPlayerState.PLAYING)
          {
            setState(() => duration = audioPlayer!.duration);
          }
          else if (s == AudioPlayerState.STOPPED)
          {
            onComplete();
            setState(()
            {
              position = duration;
            });
          }
        }, onError: (msg)
        {
          setState(()
          {
            playerState = PlayerState.stopped;
            duration = Duration(seconds: 0);
            position = Duration(seconds: 0);
          });
        });
  }

  Future play(String ringUrl) async
  {
    if(await check())
    {
      await audioPlayer!.play(ringUrl);
      setState(()
      {
        playerState = PlayerState.playing;
      });
    }
    else
    {
      showToast(context, "INTERNET CONNECTION UNAVAILABLE");
    }
  }

  Future stop() async
  {
    await audioPlayer!.stop();
    setState(()
    {
      playerState = PlayerState.stopped;
      position = Duration();
    });
  }

  void onComplete()
  {
    setState(() => playerState = PlayerState.stopped);
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(
      height: 130,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>
          [
            SizedBox(height: 5,),
        Text(widget.name, maxLines: 2, textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20,color: Constants.BlueColor, fontFamily: Constants.AppFont, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
              [
                if (position != null)  Row(mainAxisSize: MainAxisSize.min, children:
                [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      value: position != null && position!.inMilliseconds > 0 ? (position?.inMilliseconds.toDouble() ?? 0.0) / (duration?.inMilliseconds.toDouble() ?? 0.0) : 0.0,
                      valueColor: AlwaysStoppedAnimation(Constants.BlueColor),
                      backgroundColor: Colors.grey[500],
                    ),
                  ),
                  Text(position != null ? "${positionText ?? ''} / ${durationText ?? ''}" : duration != null ? durationText : '', style: TextStyle(fontSize: 18.0),
                  )
                ]),
                IconButton(
                  onPressed: isPlaying ? null : () => play(widget.url),
                  icon: Icon(Icons.play_circle_outline),
                  iconSize: 35,
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: (isPlaying || isPaused) && position!=null ? () => stop() : null,
                  icon: Icon(Icons.stop),
                  iconSize: 35,
                  color: Colors.red,
                ),
                IconButton(
                  onPressed: () async => saveMedia(context, widget.url, "RINGTONES", 'Music'),
                  iconSize: 35,
                  icon: Icon(Icons.file_download),
                  color: Constants.GreenColor,
                ),
              ],
            ),
            ElevatedButton(
                child: Container(
                  width: 160,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.share_rounded, color: Colors.white,),
                        SizedBox(width: 10,),
                        Text(
                            "SHARE RINGTONE".toUpperCase(),
                            style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)
                        ),
                      ]
                  ),
                ),
                style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                    backgroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.00),
                            side: BorderSide(color: Constants.GreenColor)
                        )
                    )
                ),
                onPressed: () => mediaShare(context, widget.url, "RINGTONES", "audio")
            ),
          ],
        ),
      ),
    );
  }
}
