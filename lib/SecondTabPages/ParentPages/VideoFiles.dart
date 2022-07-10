import 'package:auto_animated/auto_animated.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/Constants.dart';
import 'package:pokemon/GeneralUtilityFunctions.dart';
import 'package:pokemon/MainPages/Other/AppBarDrawer.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:pokemon/Models/VideoStatusModel.dart';

// ignore: must_be_immutable
class VideoFiles extends StatefulWidget
{
  String url;
  List<String> titles;
  VideoFiles(this.url, this.titles);
  @override
  State<StatefulWidget> createState() => _VideoFilesState();
}

class _VideoFilesState extends State<VideoFiles>
{
  var data;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context)
  {
    return OrientationBuilder(
        builder: (context, orientation)
        {
          return Scaffold(
              key: _scaffoldKey,
              appBar: RepublicDrawer().RepublicAppBar(context,widget.titles),
              body: FutureBuilder(
                future: getProductList(widget.url),
                builder: (context, AsyncSnapshot snapshot)
                {
                  switch (snapshot.connectionState)
                  {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return new RepublicDrawer().TirangaProgressBar(context, orientation);
                    default:
                      if (snapshot.hasError)
                        return Center(child: Image.asset("assets/images/independence.gif"));
                      else
                        return createListView(context, snapshot);
                  }
                },
              )
          );
        }
    );
  }

  List<VideoStatusModel> categories;
  Future<List<VideoStatusModel>> getProductList(String page) async
  {
    Response response;
    response = await get(Uri.parse(page));
    int statusCode = response.statusCode;
    final body = json.decode(response.body);
    print(body);
    if (statusCode == 200)
    {
      categories = (body as List).map((i) => VideoStatusModel.fromJson(i)).toList();
      return categories;
    }
    else
    {
      return categories = [];
    }
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot)
  {
    List<VideoStatusModel> data = snapshot.data;
    return OrientationBuilder(
      builder: (context, orientation)
      {
        return LiveList.options(
          scrollDirection: orientation==Orientation.portrait ? Axis.vertical : Axis.horizontal,
          options: LiveOptions(
            delay: Duration(seconds: 1),
            showItemInterval: Duration(milliseconds: 0),
            showItemDuration: Duration(seconds: 0),
            visibleFraction: 0.05,
            reAnimateOnVisibility: false,

          ),
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index, animation)
          {
            final value = data[index];
            return FadeTransition(
                opacity: Tween<double>(
                  begin: 0,
                  end: 1,
                ).animate(animation),
                child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, -0.1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: BetterPlayerListVideoPlayer(
                          BetterPlayerDataSource(
                              BetterPlayerDataSourceType.network, value.videoUrl),
                          configuration: BetterPlayerConfiguration(
                              controlsConfiguration: BetterPlayerControlsConfiguration(
                                  controlBarHeight: 35,
                                  iconsColor: Constants.BlueColor,
                                  enableFullscreen: false,
                                  enableSubtitles: false,
                                  enableQualities: false,
                                  enableAudioTracks: false,
                                  overflowMenuIcon: Icons.file_download,
                                  enablePlaybackSpeed: false,
                                  overflowModalColor: Constants.OrangeColor,
                                  overflowMenuCustomItems:
                                  [
                                    BetterPlayerOverflowMenuItem(
                                      Icons.download_sharp,
                                      "DOWNLOAD VIDEO STATUS",
                                          () => saveMedia(context, value.videoUrl, "VIDEO STATUS", 'Movies'),
                                    ),
                                    BetterPlayerOverflowMenuItem(
                                      Icons.share_outlined,
                                      "SHARE VIDEO STATUS",
                                          () => mediaShare(context, value.videoUrl, "VIDEO STATUS", "video"),
                                    )
                                  ],
                                  enableSkips: false
                              )
                          ),
                          autoPlay: false,
                        ),
                      ),
                    )
                )
            );
          }, itemCount: data.length,
        );
      },
    );
  }
}
