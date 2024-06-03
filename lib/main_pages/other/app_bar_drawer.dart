import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import '../../constants.dart';
import '../../general_utility_functions.dart';

class RepublicDrawer extends StatelessWidget
{
  const RepublicDrawer({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>
            [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Constants.OrangeColor),
                accountName:  SizedBox(
                  width: MediaQuery.of(context).size.width-25,
                  child: TyperAnimatedTextKit(
                    onTap: () => showToast("HAPPY INDEPENDENCE DAY"),
                    speed: const Duration(milliseconds: 250),
                    isRepeatingAnimation: true,
                    repeatForever: true,
                    text:
                    const [
                      "TIRANGA"
                    ],
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: "Poppins",
                      color: Constants.GreenColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                accountEmail:  SizedBox(
                  width: MediaQuery.of(context).size.width-25,
                  child: TyperAnimatedTextKit(
                    onTap: () => showToast("HAPPY INDEPENDENCE DAY"),
                    speed: const Duration(milliseconds: 250),
                    isRepeatingAnimation: true,
                    repeatForever: true,
                    text:
                    const [
                      "MANISH MAHESH TALREJA"
                    ],
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: "Poppins",
                      color: Constants.GreenColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                currentAccountPicture: const CircleAvatar(backgroundImage: AssetImage("assets/images/wish_chakra.gif")),
              ),
              const Divider(thickness: 2.00,color: Colors.transparent),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.5),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                      title: const Text("ABOUT US", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                      leading: const Icon(Icons.info, color: Constants.OrangeColor),
                      onTap: ()
                      {
                        Navigator.of(context).pop();
                        showDialog
                          (
                          context: context,
                          builder: (BuildContext context)
                          {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              title: const Center(
                                child:Text("ABOUT DEVELOPERS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.00, color: Constants.GreenColor)),

                              ),
                              actions: [MaterialButton
                                (
                                child: const Text("CLOSE",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.00)),
                                onPressed: (){Navigator.of(context).pop();},
                              )],
                              content: const SingleChildScrollView(
                                child: Text("COMPANY : RAAM DEVELOPERS\n\nDEVELOPERS : \n\n1. RAVIRAJ KUNDEKAR\n2. AAYUSHMAN OJHA\n3. ADITI JAISWAL\n4. MANISH MAHESH TALREJA\n\nPURPOSE : \n   TIRANGA - A VIRTUAL INDEPENDENCE DAY APPLICATION.", style:TextStyle(fontFamily: Constants.AppFont, fontWeight: FontWeight.bold, color: Constants.OrangeColor, letterSpacing: 1)
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 2.5),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                      title: const Text("CONTACT US", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                      leading: const Icon(Icons.email, color: Constants.OrangeColor),
                      onTap: ()
                      {
                        Navigator.of(context).pop();
                        _launchURL('manishtalreja189@gmail.com', 'DEVELOPER CONTACT', 'RESPECTED DEVELOPER,\n\n');
                      }
                  ),
                ),
              ),
              /*Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 2.5),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: const Text("RATE APP", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                    leading: const Icon(Icons.star, color: Constants.OrangeColor),
                    onTap: ()
                    {
                      Navigator.of(context).pop();
                      launchLink(Constants.AppPlayStoreLink);
                    },
                  ),
                ),
              ),*/
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 2.5),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                      title: const Text("SHARE APP",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                      leading: const Icon(Icons.share, color: Constants.OrangeColor),
                      onTap: ()
                      {
                        Navigator.of(context).pop();
                        shareMe();
                      }
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 2.5),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: const Text("PRIVACY POLICY",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                    leading: const Icon(Icons.lock, color: Constants.OrangeColor),
                    onTap: ()
                    {
                      Navigator.of(context).pop();
                      launchLink(Constants.AppPrivacyPolicyPage);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 2.5),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: const Text("MORE APPS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                    leading: const Icon(Icons.sentiment_satisfied, color: Constants.OrangeColor),
                    onTap: ()
                    {
                      Navigator.of(context).pop();
                      launchLink(Constants.AppDeveloperPage);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 2.5),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: const Text("EXIT APP", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Constants.BlueColor)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Constants.GreenColor),
                    leading: const Icon(Icons.cancel, color: Constants.OrangeColor),
                    onTap: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop')
                  ),
                ),
              ),
              const Divider(thickness: 2.00,color: Colors.transparent)
            ],
          ),
        )
    );
  }

  _launchURL(String toMailId, String subject, String body) async
  {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    launchLink(url);
  }

  // ignore: non_constant_identifier_names
  AppBar RepublicAppBar(BuildContext context, List<String> title)
  {
    return AppBar(
      actions: <Widget>
      [
        IconButton
          (
            icon: const Icon(Icons.share, color: Constants.OrangeColor, size: 25,),
            tooltip: 'SHARE APPLICATION',
            onPressed: () => shareMe()
        ),
      ],
      title: Padding(
        padding: const EdgeInsets.only(top:12.0),
        child: ScaleAnimatedTextKit(
            onTap: () {},
            text: title,
            textStyle: const TextStyle(
                fontSize: 19.0,
                fontFamily: "Poppins",
                color: Constants.OrangeColor,
                fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.start,
            repeatForever: true,

        ),
      ),
      centerTitle: true,
      elevation: 0,
      iconTheme: const IconThemeData(
          color: Constants.OrangeColor,
          size: 25
      ),
      backgroundColor: Colors.transparent,
    );
  }

  // ignore: non_constant_identifier_names
  Widget TirangaProgressBar(BuildContext context, Orientation orientation)
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: SizedBox(
          height: orientation==Orientation.portrait ? MediaQuery.of(context).size.height*0.4:MediaQuery.of(context).size.height*0.4 ,
            width: orientation==Orientation.portrait ?MediaQuery.of(context).size.width*0.6: MediaQuery.of(context).size.width*0.4 ,
          child: Center(
              child: Image.asset("assets/images/ashoka_chakra.gif", fit: BoxFit.fill,)
          ),
        ),
      ),
    );
  }
}

class CustomCacheImage extends StatelessWidget
{
  final String imageUrl;
  const CustomCacheImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context)
  {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.fill,
      placeholder: (context, url) => Image.asset("assets/images/wish_chakra.gif"),
      errorWidget: (context, url, error) => Image.asset("assets/images/flag.jpg", fit: BoxFit.fill,),
    );
  }
}

