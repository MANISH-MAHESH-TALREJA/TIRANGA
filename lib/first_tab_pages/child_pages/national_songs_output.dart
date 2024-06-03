import 'dart:async';
import 'package:audio_player/audioplayer.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;

import 'package:pokemon/general_utility_functions.dart';
import 'package:pokemon/main_pages/other/app_bar_drawer.dart';
import 'package:toast/toast.dart';
import '../../Constants.dart';
import '../../flutter_html/flutter_html.dart';

typedef OnError = void Function(Exception exception);

enum PlayerState { stopped, playing, paused }

class NationalSongsOutput extends StatefulWidget
{
  final String english, hindi, name, url;
  const NationalSongsOutput(this.name, this.url, this.english, this.hindi, {super.key});
  @override
  NationalSongsOutputState createState() => NationalSongsOutputState();
}

class NationalSongsOutputState extends State<NationalSongsOutput>
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
    return Scaffold(
        appBar: const RepublicDrawer().RepublicAppBar(context, Constants.OutputAppBarTitle),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal:5.0),
          child: Container(
            decoration: BoxDecoration(
                color: Constants.OrangeColor,
                border: Border.all(
                  color: Constants.BlueColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10))
            ),
            child: FlipCard(
              direction: FlipDirection.HORIZONTAL,
              front: Padding(
                padding: const EdgeInsets.symmetric(vertical : 5.0),
                child: Center(child: SingleChildScrollView(child: Html(
                    defaultTextStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                    data: '''  ${"<center>${widget.hindi}</center>"}   '''),
                )),
              ),
              back: Container(
                decoration: const BoxDecoration(
                    color: Constants.GreenColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical : 5.0),
                  child: Center(child: SingleChildScrollView(child: Html(
                      defaultTextStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                      data: '''  ${"<center>${widget.english}</center>"}   '''),
                  )),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Constants.BlueColor,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))
              ),
              height: 75,
              width: MediaQuery.of(context).size.width-10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>
                [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>
                    [
                      Icon(Icons.swipe, color: Constants.BlueColor,),
                      SizedBox(width: 5,),
                      Text("CLICK ON THE CARD TO CHANGE LANGUAGE", maxLines: 2, textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12,color: Constants.BlueColor, fontFamily: Constants.AppFont)),
                    ],
                  ),
                  /*if (duration != null)
                  Slider(
                      value: position?.inMilliseconds?.toDouble() ?? 0.0,
                      onChanged: (double value)
                      {
                        return audioPlayer.seek((value / 1000).roundToDouble());
                      },
                      min: 0.0,
                      max: duration.inMilliseconds.toDouble()),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                    [
                      if (position != null)  Row(mainAxisSize: MainAxisSize.min, children:
                      [
                        Padding(
                          padding: const EdgeInsets.only(right:5.0, left : 5),
                          child: CircularProgressIndicator(
                            value: position != null && position!.inMilliseconds > 0 ? (position?.inMilliseconds.toDouble() ?? 0.0) / (duration?.inMilliseconds.toDouble() ?? 0.0) : 0.0,
                            valueColor: const AlwaysStoppedAnimation(Constants.BlueColor),
                            backgroundColor: Colors.grey[500],
                          ),
                        ),
                        Text(position != null ? "${positionText ?? ''} / ${durationText ?? ''}" : duration != null ? durationText : '', style: const TextStyle(fontSize: 16.0),
                        )
                      ]),
                      IconButton(
                        onPressed: isPlaying ? null : () => play(widget.url),
                        icon: const Icon(Icons.play_circle_outline),
                        iconSize: 30,
                        color: Colors.blue,
                      ),
                      IconButton(
                        onPressed: isPlaying ? () => pause() : null,
                        iconSize: 30.0,
                        icon: const Icon(Icons.pause_circle_outline_outlined),
                        color: Colors.blue,
                      ),
                      IconButton(
                        onPressed: (isPlaying || isPaused) && position!=null ? () => stop() : null,
                        icon: const Icon(Icons.stop_circle_outlined),
                        iconSize: 30,
                        color: Colors.red,
                      ),
                      IconButton(
                        onPressed: () async => saveMedia(context, widget.url, "NATIONAL SONG",'Music'),
                        iconSize: 30,
                        icon: const Icon(Icons.arrow_circle_down_outlined),
                        color: Constants.GreenColor,
                      ),
                    ],
                  ),
                ],
              )
          ),
        )
    );
  }
}