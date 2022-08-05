import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/main_pages/other/app_bar_drawer.dart';
import 'package:http/http.dart';
import 'package:pokemon/models/national_detail_model.dart';
import 'package:toast/toast.dart';
import '../../constants.dart';
import '../../general_utility_functions.dart';

// ignore: must_be_immutable
class NationalSymbols extends StatefulWidget
{
  String url;
  List<String> titles;
  NationalSymbols(this.url, this.titles, {super.key});
  @override
  State<StatefulWidget> createState() => _NationalSymbolsState();
}

class _NationalSymbolsState extends State<NationalSymbols>
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
                future: getData(widget.url),
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

  List<NationalDetailModel>? categories;
  Future<List<NationalDetailModel>> getData(String page) async
  {
    Response response;
    response = await get(Uri.parse(page));
    if (response.statusCode == 200)
    {
      categories = nationalDetailModelFromJson(response.body);
      return categories!;
    }
    else
    {
      return categories = [];
    }
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot, Orientation orientation)
  {
    List<NationalDetailModel> data = snapshot.data;
    return  ExpandableTheme(
      data: const ExpandableThemeData(
        iconColor: Constants.BlueColor,
        useInkWell: true,
      ),
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index)
          {
            final value = data[index];
            return ContactWidget(value.image!, value.name!, value.detail!, value.link!);
          }),
    );
  }
}

// ignore: must_be_immutable
class ContactWidget extends StatelessWidget
{
  String? image, title, description, link;

  ContactWidget(String this.image, String this.title, String this.description, String this.link, {super.key});

  @override
  Widget build(BuildContext context)
  {
    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            elevation: 2,
            shadowColor: Constants.BlueColor,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>
              [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width-40,
                    child: ClipRRect(borderRadius: BorderRadius.circular(8.0),child: CustomCacheImage(imageUrl: image!,))//Image.network(image, fit: BoxFit.fill,),
                  ),
                ),
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                    ),
                    header: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          title!,
                          style: const TextStyle(fontSize: 16, color: Constants.OrangeColor, fontFamily: Constants.AppFont, fontWeight: FontWeight.bold),
                        )),
                    collapsed: Text(
                      description!,
                      softWrap: true,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 14,color: Constants.GreenColor, fontFamily: Constants.AppFont),
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>
                      [
                        Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              description!,
                              softWrap: true,
                              style: const TextStyle(fontSize: 15,color: Constants.GreenColor, fontFamily: Constants.AppFont),
                              overflow: TextOverflow.fade,
                            )),
                        Center(
                          child: ElevatedButton(
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
                              onPressed: () => launchLink(link!),
                              child: SizedBox(
                                width: 160,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Icon(Icons.info_outline, color: Colors.white,),
                                      const SizedBox(width: 10,),
                                      Text(
                                          "READ MORE",
                                          style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)
                                      ),
                                    ]
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                    builder: (_, collapsed, expanded)
                    {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
