import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:http/http.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pokemon/constants.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:toast/toast.dart';

import '../../general_utility_functions.dart';
import '../../main_pages/other/app_bar_drawer.dart';
import '../../models/ringtones_model.dart';
import '../child_pages/ringtones_output.dart';

//ignore: must_be_immutable
class RingtonesList extends StatefulWidget
{
  String url;
  List<String> titles;
  RingtonesList(this.url, this.titles, {super.key});

  @override
  State<RingtonesList> createState() => _RingtonesListState();
}

class _RingtonesListState extends State<RingtonesList>
{
  bool isLoading = true;
  List<RingtonesModel>? ringtonesModel;
  TextEditingController searchController = TextEditingController();

  @override
  void initState()
  {
    super.initState();
    Future.delayed(Duration.zero, ()
    {
      fetchRingtones();
    });
    ToastContext().init(context);
  }

  void fetchRingtones() async
  {
    Response response;
    response = await get(Uri.parse(widget.url));
    if (response.statusCode == 200)
    {
      if(!mounted) return;
      setState(()
      {
        isLoading = false;
        ringtonesModel = ringtonesModelFromJson(response.body);
      });
    }
    else
    {
      debugPrint(response.body.toString());
      debugPrint(response.statusCode.toString());
      if(!mounted) return;
      failureFunction(context, super.widget);
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return OrientationBuilder(builder: (context, orientation)
    {
      return Scaffold(
          appBar: const RepublicDrawer().RepublicAppBar(context,widget.titles),
          body: isLoading ? const RepublicDrawer().TirangaProgressBar(context, orientation) : specialListView(orientation),
      );
    });
  }

  Widget tirangaCard(int index, RingtonesModel value, Orientation orientation)
  {
    return GestureDetector(
      onTap: () async => await check() ? Future.delayed(Duration.zero, () {

        showMaterialModalBottomSheet(context: context, builder: (context) => AudioApp(value.audioLink!, value.audioName!));

      }) : showToast("INTERNET CONNECTION UNAVAILABLE"),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Card(
            elevation: 2,
            color: (index+1) % 2 == 0 ? Colors.lightGreen : Colors.orangeAccent,
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
                          child: Text(value.audioName!, maxLines: 2, //textAlign: TextAlign.center,
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

  Widget specialListView(Orientation orientation)
  {
    int index = 0;
    return Padding(
      padding: const EdgeInsets.only(top:10, left: 10.0, right:10.0),
      child: SearchableList<RingtonesModel>(
        initialList: ringtonesModel!,
        itemBuilder: (RingtonesModel ringtonesModel)
        {
          index++;
          return tirangaCard(index, ringtonesModel, orientation);
        },
        filter: (value) => ringtonesModel!.where((element) => element.audioName!.toLowerCase().contains(value.toLowerCase())).toList(),
        searchTextController: searchController,
        inputDecoration: InputDecoration(
          suffix: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey[300],
                child: IconButton(
                  icon: const Icon(Icons.close, size: 15, color: Color(0xFF333333),),
                  onPressed: ()
                  {
                    searchController.clear();
                    setState(()
                    {
                      ringtonesModel;
                    });
                  },
                ),
              )
          ),
          hintText: "Search Ringtones",
          hintStyle: const TextStyle(fontFamily: 'Poppins', color: Constants.GreenColor, fontSize: 14),
          labelStyle: const TextStyle(fontFamily: 'Poppins', color: Color(0xFF333333), fontSize: 14),
          border: const OutlineInputBorder(borderSide: BorderSide(
              color: Constants.OrangeColor
          )),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(
              color: Constants.OrangeColor
          )),
          labelText: "Search Ringtones",
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: const Icon(Icons.search, size: 25),
                color: const Color(0xFF333333),
                onPressed: () {}),
          ),
          contentPadding: const EdgeInsets.only(right: 0, left: 10),
        ),
      ),
    );
  }
}