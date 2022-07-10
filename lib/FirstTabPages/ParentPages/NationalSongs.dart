import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:pokemon/FirstTabPages/ChildPages/NationalSongsOutput.dart';
import 'package:pokemon/MainPages/Other/AppBarDrawer.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:pokemon/Models/NationalSongsModel.dart';
import '../../Constants.dart';
import '../../GeneralUtilityFunctions.dart';

// ignore: must_be_immutable
class NationalSongs extends StatefulWidget
{
  String url;
  List<String> titles;
  NationalSongs(this.url, this.titles);
  @override
  State<StatefulWidget> createState() => _NationalSongsState();
}

class _NationalSongsState extends State<NationalSongs>
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
                        return createListView(context, snapshot, orientation);
                  }
                },
              )
          );
        }
    );
  }

  List<NationalSongsModel> categories;
  Future<List<NationalSongsModel>> getProductList(String page) async
  {
    Response response;
    response = await get(Uri.parse(page));
    int statusCode = response.statusCode;
    final body = json.decode(response.body);
    print(body);
    if (statusCode == 200)
    {
      categories = (body as List).map((i) => NationalSongsModel.fromJson(i)).toList();
      return categories;
    }
    else
    {
      return categories = [];
    }
  }

  // ignore: non_constant_identifier_names
  Widget TirangaCard(int index, NationalSongsModel value, Orientation orientation)
  {
    return GestureDetector(
      onTap: () async => await check() ? Navigator.push(context, MaterialPageRoute(builder: (context) => NationalSongsOutput(value.name, value.link, value.english, value.hindi))) : showToast(context, "INTERNET CONNECTION UNAVAILABLE"),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
            elevation: 2,
            color: (index+1)%2==0 ?Colors.lightGreen:Colors.orangeAccent,
            borderOnForeground: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
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
                      child: Container(width: orientation==Orientation.portrait?MediaQuery.of(context).size.width*0.7:MediaQuery.of(context).size.width*0.8,child: Marquee(
                          textDirection : TextDirection.ltr,
                          animationDuration: Duration(seconds: 3),
                          directionMarguee: DirectionMarguee.oneDirection,
                          child: Text(value.name.toUpperCase(), maxLines: 2, //textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20,color: (index+1)%2==0?Constants.BlueColor:Colors.white, fontFamily: Constants.AppFont, fontWeight: FontWeight.bold)
                          )
                      )
                      ),
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
    List<NationalSongsModel> data = snapshot.data;
    return ListView.builder(
      key: UniqueKey(),
      itemCount: data.length,
      itemBuilder: (context, index)
      {
        final value = data[index];
        return TirangaCard(index, value, orientation);
      },
    );
  }
}
