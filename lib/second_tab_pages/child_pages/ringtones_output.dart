import 'dart:async';
import 'package:audio_player/audioplayer.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:pokemon/general_utility_functions.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import 'package:toast/toast.dart';
import '../../constants.dart';

typedef OnError = void Function(Exception exception);

enum PlayerState { stopped, playing, paused }

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
    ToastContext().init(context);
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
            duration = const Duration(seconds: 0);
            position = const Duration(seconds: 0);
          });
        });
  }

  List<QudsPopupMenuBase> getMenuItems()
  {
    return [

      QudsPopupMenuItem(
          leading: const Icon(Icons.alarm),
          title: const Text('ALARM'),
          subTitle: const Text('Set This Song As Alarm Tone'),
          onPressed: ()
          {
            setRingtone(context, widget.url, 0);
          }),

      QudsPopupMenuDivider(),
      QudsPopupMenuItem(
          leading: const Icon(Icons.call_outlined),
          title: const Text('RINGTONE'),
          subTitle: const Text('Set This Song As Ringtone'),
          onPressed: ()
          {
            setRingtone(context, widget.url, 1);
          }),

      QudsPopupMenuDivider(),
      QudsPopupMenuItem(
          leading: const Icon(Icons.notifications_active_outlined),
          title: const Text('NOTIFICATION'),
          subTitle: const Text('Set This Song As Notification'),
          onPressed: ()
          {
            setRingtone(context, widget.url, 2);
          }),
    ];
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
      showToast("INTERNET CONNECTION UNAVAILABLE");
    }
  }

  Future pause() async
  {
    await audioPlayer!.pause();
    setState(()
    {
      playerState = PlayerState.paused;
    });
  }

  Future stop() async
  {
    await audioPlayer!.stop();
    setState(()
    {
      playerState = PlayerState.stopped;
      position = null;
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
      height: 135,
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
                  onPressed: () async => saveMedia(context, widget.url, "RINGTONE", 'Music'),
                  iconSize: 35,
                  icon: const Icon(Icons.file_download),
                  color: Constants.GreenColor,
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                          backgroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.00),
                                  side: const BorderSide(color: Constants.GreenColor)
                              )
                          )
                      ),
                      onPressed: () {},
                      child: QudsPopupButton(
                        tooltip: 'SET RINGTONE',
                        items: getMenuItems(),
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.library_music_outlined, color: Colors.white, size: 20,),
                              SizedBox(width: 10,),
                              Text(
                                  "SET RINGTONE",
                                  style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)
                              ),
                            ]
                        ),
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                          backgroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.00),
                                  side: const BorderSide(color: Constants.GreenColor)
                              )
                          )
                      ),
                      onPressed: () => mediaShare(widget.url, "RINGTONES", "audio"),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.share_rounded, color: Colors.white, size: 20,),
                            SizedBox(width: 10,),
                            Text(
                                "SHARE RINGTONE",
                                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)
                            ),
                          ]
                      )
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
