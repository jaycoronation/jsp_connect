
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../constant/colors.dart';
import '../utils/base_class.dart';
import 'LoginScreen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreen createState() => _IntroScreen();
}

class _IntroScreen extends BaseState<IntroScreen> {

  @override
  Widget build(BuildContext context) {

    final controller = PageController(viewportFraction: 1, keepPage: true);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light, // For Android (dark icons)
      statusBarBrightness: Brightness.light,
    ));

    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: black,
          appBar: AppBar(toolbarHeight: 0,elevation: 0,systemOverlayStyle: SystemUiOverlayStyle.dark,),
          body: Stack(
            children: [
              PageView.builder(
                controller: controller,
                itemCount: 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Image.asset("assets/images/ic_naveen_splash.jpg",height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,fit: BoxFit.fill),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                black.withOpacity(0.0),
                                black.withOpacity(1),
                              ],
                              stops: const [
                                0.6,
                                1.0
                              ]
                          ),
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 180,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Naveen\n   Jindal",textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: nj, color: white, fontSize: 34,fontWeight:FontWeight.w400),
                            ),
                            Container(height: 22,),
                            Container(
                              margin: EdgeInsets.only(left: 32),
                              child: const Text("COMMITTED TO\nBUILDING THE\nNATION OF OUR\nDREAMS.",
                                overflow: TextOverflow.clip,
                                style: TextStyle(fontFamily: aileron,
                                  color: white,
                                  fontSize: 32,
                                  fontWeight:FontWeight.w800,
                                  overflow: TextOverflow.clip,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              Positioned(
                bottom: 120,
                left: 32,
                child: Container(
                  decoration: BoxDecoration(
                      color: lightGray.withOpacity(0.3)),
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: 2,
                    effect: SlideEffect(
                        spacing: 2.0,
                        radius: 0.0,
                        dotWidth: 30.0,
                        dotHeight: 2.5,
                        paintStyle: PaintingStyle.stroke,
                        strokeWidth: 0,
                        dotColor: lightGray.withOpacity(0.3),
                        activeDotColor: lightGray),
                  ),
                ),
              ),
              Positioned(
                bottom: 80,
                right: 32,
                child:  GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Image.asset("assets/images/ic_arrow_white.png",height: 54,width: 54,),
                  ),
                ),
              )
            ],
          ),
      ),
    );
  }

  @override
  void castStatefulWidget() {
    widget is IntroScreen;
  }
}
