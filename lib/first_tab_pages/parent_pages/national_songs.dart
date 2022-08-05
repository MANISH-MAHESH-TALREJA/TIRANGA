import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:pokemon/main_pages/other/app_bar_drawer.dart';
import 'package:http/http.dart';
import 'package:toast/toast.dart';
import '../../constants.dart';
import '../../general_utility_functions.dart';
import '../../models/national_songs_model.dart';
import '../child_pages/national_songs_output.dart';

// ignore: must_be_immutable
class NationalSongs extends StatefulWidget
{
  String url;
  List<String> titles;
  NationalSongs(this.url, this.titles, {super.key});
  @override
  State<StatefulWidget> createState() => _NationalSongsState();
}

class _NationalSongsState extends State<NationalSongs>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context)
  {
    ToastContext().init(context);
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
                    case ConnectionState.active:
                    case ConnectionState.done:
                      return createListView(context, snapshot, orientation);
                    default:
                      if (snapshot.hasError)
                      {
                        debugPrint(snapshot.error.toString());
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

  List<NationalSongsModel>? categories;
  Future<List<NationalSongsModel>> getProductList(String page) async
  {
    Response response;
    response = await get(Uri.parse(page));
    if (response.statusCode == 200)
    {
      categories = nationalSongsModelFromJson(response.body);
      return categories!;
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
      onTap: () async => await check() ? Navigator.push(context, MaterialPageRoute(builder: (context) => NationalSongsOutput(value.name!, value.link!, value.english!, value.hindi!))) : showToast("INTERNET CONNECTION UNAVAILABLE"),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
            elevation: 2,
            color: (index+1)%2==0 ?Colors.lightGreen:Colors.orangeAccent,
            borderOnForeground: true,
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
                          child: Text(value.name!, maxLines: 2, //textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16,color: (index+1)%2==0?Constants.BlueColor:Colors.white, fontFamily: Constants.AppFont, fontWeight: FontWeight.bold)
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
