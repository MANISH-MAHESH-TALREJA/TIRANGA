import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:pokemon/Models/ringtones_model.dart';
import '../../constants.dart';
import '../../main_pages/other/app_bar_drawer.dart';
import '../child_pages/ringtones_output.dart';

// ignore: must_be_immutable
class RingtoneFiles extends StatefulWidget
{
  String url;
  List<String> titles;
  RingtoneFiles(this.url, this.titles, {super.key});
  @override
  State<StatefulWidget> createState() => _RingtoneFilesState();
}

class _RingtoneFilesState extends State<RingtoneFiles>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
  get durationText => duration != null ? duration.toString().split('.').first : '';
  get positionText => position != null ? position.toString().split('.').first : '';
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
    await audioPlayer!.play(UrlSource(ringUrl));
    setState(()
    {
      playerState = PlayerState.playing;
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
    return OrientationBuilder(
        builder: (context, orientation)
        {
          return Scaffold(
              key: _scaffoldKey,
              appBar: const RepublicDrawer().RepublicAppBar(context,widget.titles),
              body: FutureBuilder(
                future: getProductList(widget.url),
                builder: (context, AsyncSnapshot snapshot)
                {
                  switch (snapshot.connectionState)
                  {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const RepublicDrawer().TirangaProgressBar(context, orientation);
                    default:
                      if (snapshot.hasError)
                      {
                        return Center(child: Image.asset("assets/images/independence.gif"));
                      }
                      else
                      {
                        return createListView(context, snapshot, orientation);
                      }
                  }
                },
              )
          );
        }
    );
  }


  List<RingtonesModel>? categories;
  Future<List<RingtonesModel>> getProductList(String page) async
  {
    Response response;
    response = await get(Uri.parse(page));
    int statusCode = response.statusCode;
    final body = json.decode(response.body);
    debugPrint(body);
    if (statusCode == 200)
    {
      categories = (body as List).map((i) => RingtonesModel.fromJson(i)).toList();
      return categories!;
    }
    else
    {
      return categories = [];
    }
  }

  // ignore: non_constant_identifier_names
  Widget TirangaCard(int index, RingtonesModel value, Orientation orientation)
  {
    return GestureDetector(onTap: () => showMaterialModalBottomSheet(context: context, builder: (context) => AudioApp(value.audioLink!, value.audioName!)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
            elevation: 2,
            color: (index+1)%2==0 ?Colors.lightGreen:Colors.orangeAccent,
            borderOnForeground: true,
            //shadowColor: newColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width-20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children:
                  [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Image.asset("assets/images/app_icon.png", height:75, width:75),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(width: orientation==Orientation.portrait?MediaQuery.of(context).size.width*0.7:MediaQuery.of(context).size.width*0.8,child: Marquee(
                          textDirection : TextDirection.ltr,
                          animationDuration: const Duration(seconds: 3),
                          directionMarguee: DirectionMarguee.oneDirection,
                          child: Text(value.audioName!.toUpperCase(), maxLines: 2, //textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20,color: (index+1)%2==0?Constants.BlueColor:Colors.white, fontFamily: Constants.AppFont, fontWeight: FontWeight.bold)))),
                    ),
                  ])
                ],
              ),
            )
        ),
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot, Orientation orientation)
  {
    List<RingtonesModel> data = snapshot.data;
    return ListView.builder(
      key: UniqueKey(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final value = data[index];
        return TirangaCard(index, value, orientation);
      },
    );
  }

}
