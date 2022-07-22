import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/general_utility_functions.dart';
import '../../constants.dart';

typedef OnError = void Function(Exception exception);

enum MyPlayerState { stopped, playing, paused }

class AudioApp extends StatefulWidget
{
  final String url, name;
  const AudioApp(this.url,this.name, {super.key});
  @override
  AudioAppState createState() => AudioAppState();
}

class AudioAppState extends State<AudioApp>
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
    _positionSubscription = audioPlayer!.onPositionChanged.listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer!.onPlayerStateChanged.listen((s)
        {
          if (s == PlayerState.playing)
          {
            setState(() async => duration = await audioPlayer!.getDuration());
          }
          else if (s == PlayerState.stopped)
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
            duration = const Duration(seconds: 0);
            position = const Duration(seconds: 0);
          });
        });
  }

  Future play(String ringUrl) async
  {
    if(await check())
    {
      await audioPlayer!.play(UrlSource(ringUrl));
      setState(()
      {
        playerState = PlayerState.playing;
      });
    }
    else
    {
      showToast("INTERNET CONNECTION UNAVAILABLE");
    }
  }

  Future stop() async
  {
    await audioPlayer!.stop();
    setState(()
    {
      playerState = PlayerState.stopped;
      position = const Duration();
    });
  }

  void onComplete()
  {
    setState(() => playerState = PlayerState.stopped);
  }

  @override
  Widget build(BuildContext context)
  {
    return SizedBox(
      height: 130,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>
          [
            const SizedBox(height: 5,),
        Text(widget.name, maxLines: 2, textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20,color: Constants.BlueColor, fontFamily: Constants.AppFont, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
              [
                if (position != null)  Row(mainAxisSize: MainAxisSize.min, children:
                [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      value: position != null && position!.inMilliseconds > 0 ? (position?.inMilliseconds.toDouble() ?? 0.0) / (duration?.inMilliseconds.toDouble() ?? 0.0) : 0.0,
                      valueColor: const AlwaysStoppedAnimation(Constants.BlueColor),
                      backgroundColor: Colors.grey[500],
                    ),
                  ),
                  Text(position != null ? "${positionText ?? ''} / ${durationText ?? ''}" : duration != null ? durationText : '', style: const TextStyle(fontSize: 18.0),
                  )
                ]),
                IconButton(
                  onPressed: isPlaying ? null : () => play(widget.url),
                  icon: const Icon(Icons.play_circle_outline),
                  iconSize: 35,
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: (isPlaying || isPaused) && position!=null ? () => stop() : null,
                  icon: const Icon(Icons.stop),
                  iconSize: 35,
                  color: Colors.red,
                ),
                IconButton(
                  onPressed: () async => saveMedia(context, widget.url, "RINGTONES", 'Music'),
                  iconSize: 35,
                  icon: const Icon(Icons.file_download),
                  color: Constants.GreenColor,
                ),
              ],
            ),
            ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Constants.OrangeColor),
                    backgroundColor: MaterialStateProperty.all<Color>(Constants.OrangeColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.00),
                            side: const BorderSide(color: Constants.GreenColor)
                        )
                    )
                ),
                onPressed: () => mediaShare(context, widget.url, "RINGTONES", "audio"),
                child: SizedBox(
                  width: 160,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.share_rounded, color: Colors.white,),
                        const SizedBox(width: 10,),
                        Text(
                            "SHARE RINGTONE".toUpperCase(),
                            style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)
                        ),
                      ]
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
