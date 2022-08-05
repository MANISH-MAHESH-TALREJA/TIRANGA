import 'package:animated_background/animated_background.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audio_player/audio_player.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/general_utility_functions.dart';
import 'package:pokemon/main_pages/other/start_page.dart';
import 'dart:math' as math;
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

import '../../constants.dart';

class Celebrate extends StatefulWidget
{
  const Celebrate({super.key});

  @override
  CelebrateState createState() => CelebrateState();
}

class CelebrateState extends State<Celebrate> with TickerProviderStateMixin
{
  AudioPlayer audioPlugin = AudioPlayer();
  String? mp3Uri;
  // ignore: non_constant_identifier_names
  List <String> national_anthem =
  [
    "जन गण मन अधिनायक जय हे",
    "भारत भाग्य विधाता।",
    "पंजाब सिन्ध गुजरात मराठा",
    "द्रविड़ उत्कल बंग।",
    "विंध्य हिमाचल यमुना गंगा",
    "उच्छल जलधि तरंग।",
    "तव शुभ नामे जागे",
    "तव शुभ आशीष मागे।",
    "गाहे तव जयगाथा।",
    "जन गण मंगलदायक जय हे",
    "भारत भाग्य विधाता।",
    "जय हे, जय हे, जय हे",
    " ",
    "जय जय जय जय हे॥"
  ];

  @override
  void initState()
  {
    super.initState();
    ToastContext().init(context);
    _load();
    Timer(const Duration(seconds: 63), ()
    {
      Alert(context: context, type: AlertType.success, style: AlertStyle(
          animationType: AnimationType.fromTop,
          isCloseButton: false,
          isOverlayTapDismiss: false,
          animationDuration: const Duration(milliseconds: 500),
          alertBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Constants.OrangeColor),),
          titleStyle: const TextStyle(color: Constants.GreenColor)),
          title: "HAPPY INDEPENDENCE DAY !!!", desc: "THANK YOU FOR CELEBRATING INDEPENDENCE DAY WITH US !!!",
          buttons: [
            DialogButton(onPressed: () async
                {
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
                }, width: 120, child: const Text("PROCEED", style: TextStyle(color: Colors.white, fontSize: 20)))
          ]).show();
    });

  }

  Future<void> _load() async
  {
    final ByteData data = await rootBundle.load('assets/audio/national_anthem.mp3');
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/national_anthem.mp3');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    mp3Uri = tempFile.uri.toString();
    if (mp3Uri != null)
    {
      audioPlugin.play(mp3Uri!, isLocal: true);
    }
  }


  @override
  void dispose()
  {
    audioPlugin.stop();
    super.dispose();
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPop()
  {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2))
    {
      currentBackPressTime = now;
      showToast("PRESS BACK BUTTON AGAIN TO EXIT");
      return Future.value(false);
    }
    return Future.value(true);
  }

  var particlePaint = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.0;
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body:  WillPopScope(
        onWillPop: onWillPop ,
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Constants.OrangeColor,
                  Constants.GreenColor
                ],
              )
          ),
          child: OrientationBuilder(
            builder: (context, orientation)
                {
                  return AnimatedBackground(
                    behaviour: RainParticleBehaviour(
                      options:  ParticleOptions(
                        image: Image.asset('assets/images/flower.png'),
                        spawnOpacity: 1,
                        opacityChangeRate: 0.25,
                        maxOpacity: 0.8,
                        spawnMinSpeed: 30.0,
                        spawnMaxSpeed: 70.0,
                        spawnMinRadius: 15.0,
                        spawnMaxRadius: 30.0,
                        particleCount: 10,
                      ), paint: particlePaint,
                    ),
                    vsync: this,
                    child: Center(
                      child: orientation==Orientation.portrait? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>
                          [
                            const Padding(
                              padding: EdgeInsets.only(top:25),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: SizedBox(
                                height: 290,
                                width: MediaQuery.of(context).size.width-75,
                                child: Image.asset("assets/images/indian_flag.gif", fit: BoxFit.fitHeight,filterQuality: FilterQuality.high,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal : 10),
                              child: SizedBox(
                                height: 40,
                                child: RotateAnimatedTextKit(
                                  onTap: () {},
                                  text: national_anthem,
                                  duration: const Duration(milliseconds:  4000),
                                  textStyle: const TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold, color: Constants.OrangeColor),
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                              child: Marquee(
                                textDirection : TextDirection.ltr,
                                animationDuration: const Duration(seconds: 25),
                                directionMarguee: DirectionMarguee.oneDirection,
                                child: Row(
                                    children : <Widget>
                                    [
                                      for(int i = 0;i<100;i++) Missile()
                                    ]
                                ),
                              ),
                            ),
                          ]
                      ) :SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>
                            [
                              const Padding(
                                padding: EdgeInsets.only(top:25),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height-25,
                                  width: MediaQuery.of(context).size.width/2-25,
                                  child: Image.asset("assets/images/indian_flag.gif", fit: BoxFit.fitHeight,filterQuality: FilterQuality.high,),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width/2+20,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal : 2, vertical: 5),
                                  child: RotateAnimatedTextKit(
                                    onTap: () {},
                                    text: national_anthem,
                                    duration: const Duration(milliseconds:  4000),
                                    textStyle: const TextStyle(fontSize: 23.0,fontWeight: FontWeight.bold, color: Constants.OrangeColor),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),
                  );
                }
          ),
        )
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Missile()
  {
    return Container(
        color: Colors.transparent,
        height: 150,
        width: 100,
        child: Image.asset("assets/images/soldier.gif", fit: BoxFit.fill));
  }
}

class RainParticleBehaviour extends RandomParticleBehaviour
{
  static math.Random random = math.Random();
  bool enabled;
  RainParticleBehaviour({
    ParticleOptions options = const ParticleOptions(),
    Paint? paint,
    // ignore: unnecessary_null_comparison
    this.enabled = true}) : assert(options != null), super(options: options, paint: paint);

  @override
  void initPosition(Particle p)
  {
    p.cx = random.nextDouble() * size!.width;
    if (p.cy == 0.0)
    {
      p.cy = random.nextDouble() * size!.height;
    }
    else
    {
      p.cy = random.nextDouble() * size!.width * 0.2;
    }
  }

  @override
  void initDirection(Particle p, double speed)
  {
    double dirX = (random.nextDouble() - 0.5);
    double dirY = random.nextDouble() * 0.5 + 0.5;
    double magSq = dirX * dirX + dirY * dirY;
    double mag = magSq <= 0 ? 1 : math.sqrt(magSq);
    p.dx = dirX / mag * speed;
    p.dy = dirY / mag * speed;
  }

  @override
  Widget builder(BuildContext context, BoxConstraints constraints, Widget child)
  {
    return GestureDetector(
      onPanUpdate: enabled ? (details) => _updateParticles(context, details.globalPosition) : null,
      onTapDown: enabled ? (details) => _updateParticles(context, details.globalPosition) : null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: double.infinity, minWidth: double.infinity),
        child: super.builder(context, constraints, child),
      ),
    );
  }

  void _updateParticles(BuildContext context, Offset offsetGlobal)
  {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.globalToLocal(offsetGlobal);
    for (var particle in particles!)
    {
      var delta = (Offset(particle.cx, particle.cy) - offset);
      if (delta.distanceSquared < 70 * 70)
      {
        var speed = particle.speed;
        var mag = delta.distance;
        speed *= (70 - mag) / 70.0 * 2.0 + 0.5;
        speed = math.max(options.spawnMinSpeed, math.min(options.spawnMaxSpeed, speed));
        particle.dx = delta.dx / mag * speed;
        particle.dy = delta.dy / mag * speed;
      }
    }
  }
}
