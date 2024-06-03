import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:pokemon/main_pages/other/app_bar_drawer.dart';
import 'package:http/http.dart';
import 'package:pokemon/models/image_model.dart';
import 'package:pokemon/second_tab_pages/child_pages/image_output.dart';
import 'package:toast/toast.dart';
import '../../general_utility_functions.dart';

// ignore: must_be_immutable
class ImageFiles extends StatefulWidget
{
  String url;
  List<String> titles;
  String imageType;
  ImageFiles(this.url, this.titles, this.imageType, {super.key});
  @override
  State<StatefulWidget> createState() => _ImageFilesState();
}

class _ImageFilesState extends State<ImageFiles>
{
  bool orange = true, white = false, green = false;
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

  List<ImageModel>? categories;
  Future<List<ImageModel>> getProductList(String page) async
  {
    Response response;
    response = await get(Uri.parse(page));
    if (response.statusCode == 200)
    {
      categories = imageModelFromJson(response.body);
      return categories!;
    }
    else
    {
      return categories = [];
    }
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot, Orientation orientation)
  {
    var width = MediaQuery.of(context).size.width / 2;
    List<ImageModel> data = snapshot.data;
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: data.length,
      scrollDirection: orientation==Orientation.portrait? Axis.vertical: Axis.horizontal,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index)
      {
        final value = data[index];
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            onTap: () async => await check() ? Navigator.push(context, MaterialPageRoute(builder: (context) => ImageOutput(image: value.wallpaperImages!,imageType: widget.imageType,))) : showToast("INTERNET CONNECTION UNAVAILABLE"),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SizedBox(
                width: width,
                height: orientation==Orientation.portrait? width - 50 : MediaQuery.of(context).size.width / 4 -50,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CustomCacheImage(imageUrl: value.wallpaperImages!,)
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
