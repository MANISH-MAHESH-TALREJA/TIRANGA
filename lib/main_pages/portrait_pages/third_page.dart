import 'dart:math' as math;
import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:pokemon/constants.dart';
import 'package:toast/toast.dart';
import '../../infinite_cards/src/anim_transform.dart';
import '../../infinite_cards/src/infinite_card_view.dart';
import '../../infinite_cards/src/infinite_cards_controller.dart';
import '../other/app_bar_drawer.dart';

class ThirdPage extends StatefulWidget
{
  const ThirdPage({super.key});

  @override
  ThirdPageState createState() => ThirdPageState();
}

class ThirdPageState extends State<ThirdPage> with TickerProviderStateMixin
{
  InfiniteCardsController? _controller;
  bool _isTypeSwitch = true;


  @override
  void initState()
  {
    super.initState();
    ToastContext().init(context);
    _controller = InfiniteCardsController(
      itemBuilder: _renderItem,
      itemCount: 5,
      animType: AnimType.toSwitch, animDuration: const Duration(seconds: 1),
    );
  }
  List <String> imageList =
  [
    "assets/images/001.jpg",
    "assets/images/002.jpg",
    "assets/images/003.jpg",
    "assets/images/004.jpg",
    "assets/images/005.jpg"
  ];
  Widget _renderItem(BuildContext context, int index)
  {
    return Image(image: AssetImage(imageList[index]));
  }

  void _changeType(BuildContext context)
  {
    if (_isTypeSwitch)
    {
      _controller!.reset(itemCount: 5, animType: AnimType.toFront, transformToBack: _customToBackTransform,
      );
    }
    else
    {
      _controller!.reset(itemCount: 5, animType: AnimType.toSwitch, transformToBack: defaultToBackTransform,);
    }
    _isTypeSwitch = !_isTypeSwitch;
  }
  var particlePaint = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.0;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: const RepublicDrawer().RepublicAppBar(context, Constants.AppBarLeaders),
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation)
        {
          return orientation==Orientation.portrait ?  AnimatedBackground(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InfiniteCards(
                  background: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 1.3,
                  controller: _controller!,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                            backgroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.00),
                                    side: const BorderSide(color: Constants.GreenColor)
                                )
                            )
                        ),
                        onPressed: ()
                        {
                          _controller!.reset(animType: _isTypeSwitch ? AnimType.toSwitch : AnimType.toFront);
                          _controller!.previous();
                        },
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.arrow_back_outlined, color: Colors.white,),
                              SizedBox(width: 5,),
                              Text(
                                  "PREV",
                                  style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)
                              ),
                            ]
                        )
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                            backgroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.00),
                                    side: const BorderSide(color: Constants.GreenColor)
                                )
                            )
                        ),
                        onPressed: () => _changeType(context),
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.refresh, color: Colors.white,),
                              SizedBox(width: 5,),
                              Text(
                                  "RESET",
                                  style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)
                              ),
                            ]
                        )
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                            backgroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.00),
                                    side: const BorderSide(color: Constants.GreenColor)
                                )
                            )
                        ),
                        onPressed: ()
                        {
                          _controller!.reset(animType: AnimType.toEnd);
                          _controller!.next();
                        },
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.arrow_forward_rounded, color: Colors.white,),
                              SizedBox(width: 5,),
                              Text(
                                  "NEXT",
                                  style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)
                              ),
                            ]
                        )
                    ),
                  ],
                ),
              ],
            ),
          ): AnimatedBackground(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>
                [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top:20.0),
                      child: InfiniteCards(
                        background: Colors.transparent,
                        width: MediaQuery.of(context).size.width*0.6,
                        height: MediaQuery.of(context).size.height*0.7,
                        controller: _controller!
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>
                    [
                      ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                              backgroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.00),
                                      side: const BorderSide(color: Constants.GreenColor)
                                  )
                              )
                          ),
                          onPressed: ()
                          {
                            _controller!.reset(animType: _isTypeSwitch ? AnimType.toSwitch : AnimType.toFront);
                            _controller!.previous();
                          },
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.arrow_back_outlined, color: Colors.white,),
                                SizedBox(width: 5,),
                                Text(
                                    "PREV",
                                    style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)
                                ),
                              ]
                          )
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                              backgroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.00),
                                      side: const BorderSide(color: Constants.GreenColor)
                                  )
                              )
                          ),
                          onPressed: () => _changeType(context),
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.refresh, color: Colors.white,),
                                SizedBox(width: 5,),
                                Text(
                                    "RESET",
                                    style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)
                                ),
                              ]
                          )
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                              backgroundColor: WidgetStateProperty.all<Color>(Constants.OrangeColor),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.00),
                                      side: const BorderSide(color: Constants.GreenColor)
                                  )
                              )
                          ),
                          onPressed: ()
                          {
                            _controller!.reset(animType: AnimType.toEnd);
                            _controller!.next();
                          },
                          child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.arrow_forward_rounded, color: Colors.white,),
                                SizedBox(width: 5,),
                                Text(
                                    "NEXT",
                                    style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)
                                ),
                              ]
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      )
    );
  }
}

Transform _customToBackTransform(Widget item, double fraction, double curveFraction, double cardHeight, double cardWidth, int fromPosition, int toPosition)
{
  int positionCount = fromPosition - toPosition;
  double scale = (0.8 - 0.1 * fromPosition) + (0.1 * fraction * positionCount);
  double rotateY;
  double translationX;
  if (fraction < 0.5)
  {
    translationX = cardWidth * fraction * 1.5;
    rotateY = math.pi / 2 * fraction;
  }
  else
  {
    translationX = cardWidth * 1.5 * (1 - fraction);
    rotateY = math.pi / 2 * (1 - fraction);
  }
  double interpolatorScale = 0.8 - 0.1 * fromPosition + (0.1 * curveFraction * positionCount);
  double translationY = -cardHeight * (0.8 - interpolatorScale) * 0.5 - cardHeight * (0.02 * fromPosition - 0.02 * curveFraction * positionCount);
  return Transform.translate(
    offset: Offset(translationX, translationY),
    child: Transform.scale(
      scale: scale,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateY(rotateY),
        alignment: Alignment.center,
        child: item,
      ),
    ),
  );
}

class RainParticleBehaviour extends RandomParticleBehaviour
{
  static math.Random random = math.Random();
  bool enabled;
  RainParticleBehaviour({
    super.options,
    super.paint,
    // ignore: unnecessary_null_comparison
    this.enabled = true}) : assert(options != null);

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