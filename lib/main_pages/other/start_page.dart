import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:toast/toast.dart';

import '../../main_pages/home_pages/horizontal_main_page.dart';
import '../../main_pages/home_pages/portrait_main_page.dart';

class HomePage extends StatefulWidget
{
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
{
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context)
  {
    ToastContext().init(context);
    return OrientationBuilder(
      builder: (context, orientation)
      {
        return orientation == Orientation.portrait ? const PortraitMainPage() : const HorizontalMainPage() ;
      },
    );
  }
}
