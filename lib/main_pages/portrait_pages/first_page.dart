import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:pokemon/constants.dart';
import 'package:pokemon/first_tab_pages/parent_pages/image_files.dart';
import 'package:pokemon/general_utility_functions.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';
import 'third_page.dart';

class FirstPage extends StatelessWidget
{
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    ToastContext().init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>
      [
        SizedBox(
            height: MediaQuery.of(context).size.height/4.35,
            width: MediaQuery.of(context).size.width - 25,
            child: AnotherCarousel(
              images:
              const [
                CachedNetworkImageProvider(Constants.BannerNetworkImage_01),
                CachedNetworkImageProvider(Constants.BannerNetworkImage_02),
                CachedNetworkImageProvider(Constants.BannerNetworkImage_03),
                CachedNetworkImageProvider(Constants.BannerNetworkImage_04),
                CachedNetworkImageProvider(Constants.BannerNetworkImage_05),
              ],
              dotSize: 7.5,
              dotSpacing: 15.0,
              dotColor: Constants.OrangeColor,
              dotVerticalPadding: 5.0,
              dotIncreasedColor: Constants.GreenColor ,
              dotBgColor: Colors.transparent,
              borderRadius: true,
              indicatorBgPadding: 0.0,
              moveIndicatorFromBottom: 10.0,
              boxFit: BoxFit.fill,
              defaultImage: const AssetImage("assets/images/flag.jpg"),
              noRadiusForIndicator: true,
              overlayShadow: true,
              overlayShadowColors: Colors.transparent,
              overlayShadowSize: 0,
            )
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ThirdPage())),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset(
                              "assets/images/military.gif",
                              height: MediaQuery.of(context).size.height/8.5,
                              width: MediaQuery.of(context).size.width / 2 - 25),
                        ),
                      ),
                      Text("REAL HEROES OF INDIA",
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width*0.048,
                              color: Constants.BlueColor,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    ]
                )
            ),
          ),
        ),
        GestureDetector(
          onTap: () => celebrateAlert(context),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 2,
              child: SizedBox(
                height: MediaQuery.of(context).size.height/4.35,
                width: MediaQuery.of(context).size.width - 25,
                child: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>
                    [
                      Padding(
                        padding: const EdgeInsets.only(left:20.0, top:8, bottom:10),
                        child: Shimmer.fromColors(
                            highlightColor: Constants.GreenColor,
                            baseColor: Constants.OrangeColor,
                            child: Text(
                              'CELEBRATE\nINDEPENDENCE\nDAY',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Constants.BlueColor,
                                //letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width*0.05,
                              ),
                              maxLines: 4,
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right:5.0, top:8, bottom:10),
                        child: Image.asset(
                          'assets/images/map.gif',
                          height: MediaQuery.of(context).size.height/4.5,
                          width: MediaQuery.of(context).size.width*0.4,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>
        [
          FirstPortraitCard(context, "assets/images/heart.gif", "SHAYARI",ImageFiles(Constants.ShayariAPI, Constants.AppBarShayari,"SHAYARI")/*LiveVideo(Constants.liveVideoAPI) NationalSongs(Constants.NationalSongsAPI, Constants.AppBarSongs)*/ ),
          FirstPortraitCard(context, "assets/images/circle.gif", "LETTERS", ImageFiles(Constants.NameLettersAPI, Constants.AppBarNameLetters,"NAME LETTERS")),
        ]),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget FirstPortraitCard(BuildContext context, String image, String title, Widget nextPage)
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0),
      child: GestureDetector(
        onTap: () async => await check() ? Future.delayed(Duration.zero, () {

          Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage));

        }) : showToast("KINDLY CHECK YOUR INTERNET CONNECTION"),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 2,
          child: SizedBox(
            height: MediaQuery.of(context).size.height/5.5,
            width: MediaQuery.of(context).size.width / 2 - 25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height/8.5,
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Shimmer.fromColors(
                    highlightColor: Constants.GreenColor,
                    baseColor: Colors.deepOrange,
                    child: Text(title, style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.05, fontWeight: FontWeight.bold)
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}