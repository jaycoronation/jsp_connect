import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constant/api_end_point.dart';
import '../../constant/colors.dart';
import '../../model/DashBoardDataResponse.dart';
import '../../model/SocialResponseModel.dart';
import '../../utils/app_utils.dart';
import '../../utils/base_class.dart';
import '../../widget/loading.dart';
import '../NavigationDrawerScreen.dart';
import '../NewsDetailsScreen.dart';
import '../NewsDetailsScreenNew.dart';
import '../VideoDetailsPage.dart';
import 'LiveScreen.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({Key? key}) : super(key: key);

  @override
  _TrendingScreen createState() => _TrendingScreen();
}

class _TrendingScreen extends BaseState<TrendingScreen> with SingleTickerProviderStateMixin {
  final controller = PageController(viewportFraction: 1, keepPage: true);
  final controllerSocial = PageController(viewportFraction: 1, keepPage: true);
  int isClicked = 1;
  bool _isLoading = false;
  bool isNotification = false;
  bool isJoining = false;
  bool isPromotion = false;
  bool isAnniversary = false;
  bool isAnimationVisible = false;
  late AnimationController _animationController;
  List<SocialMedia> listSocial = [];
  List<Posts> listVideos = List<Posts>.empty(growable: true);
  List<Posts> listEvents = List<Posts>.empty(growable: true);
  List<Posts> listNews = List<Posts>.empty(growable: true);

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animationController.addStatusListener((animationStatus) {
      if (animationStatus == AnimationStatus.completed) {
        print("ANIMATION OVER");
        setState(() {
          isAnimationVisible = false;
        });
      }
    });

    if (isOnline) {
      socialAPI();
      getDashboradData();
    } else {
      noInterNet(context);
    }
    isHomeReload= false;
    super.initState();
  }

  Future<bool> _refresh() {
    print("refresh......");
    if (isInternetConnected) {
      getDashboradData(true);
    } else {
      noInterNet(context);
    }
    return Future.value(true);
  }

  socialAPI() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(MAIN_URL + socialApi);

    final response = await http.get(url);
    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = SocialResponseModel.fromJson(user);

    if (statusCode == 200) {
      listSocial = dataResponse.socialMedia?.reversed.toList() ?? [];

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> sendFcmMessage(String title, String message) async {
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAA75A5-5g:APA91bFuRXEkPQfiUs7eXb752-z_HSl5GEyPwt7-E0TRl4vm91g7Nzuyt7wViAJ2E7ol9OkdGwvyi3y99NcKXb2B0P1vrxYT6QBSERPFowi78mybkYi3geS3_D8nj_-OzNiScqGY4t-m",
      };
      var request = {
        "notification": {
          "title": title,
          "body": message,
          "sound": "default",
          "color": "#990000",
          "android": {
            "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/a/aa/Naveen_Jindal_at_the_India_Economic_Summit_2010_cropped.jpg",
          }
        },
        "priority": "high",
        "to": sessionManager.getDeviceToken(),
      };

      var client = Client();
      var response = await client.post(Uri.parse(url), headers: header, body: json.encode(request));
      print(response.body);
      return true;
    } catch (e, s) {
      print(e);
      return false;
    }
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffFFFFFF), Color(0xffaaa9a3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 800.0, 80.0));

  final Shader linearGradientSocial = const LinearGradient(
    colors: <Color>[Color(0xffFFFFFF), Color(0xff9b9b98)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 800.0, 80.0));

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NavigationDrawerScreen()));
          },
          child: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: Image.asset('assets/images/menu.png', height: 22, width: 22),
          ),
        ),
        title: const Text(
          "Discover",
          style: TextStyle(fontWeight: FontWeight.w600, color: white, fontFamily: roboto),
        ),
        actions: [
          GestureDetector(
            onTap: () async {},
            child: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              child: Image.asset('assets/images/search.png', height: 22, width: 22, color: white),
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (isClicked == 1) {
                sendFcmMessage("Hi Jay", "Naveen Jindal is wishing you many many happy returns of the day!");
                setState(() {
                  if (isNotification) {
                    isNotification = false;
                    return;
                  }
                  isNotification = true;
                  isJoining = false;
                  isPromotion = false;
                  isAnniversary = false;
                  isAnimationVisible = true;
                  _animationController.reset();
                  _animationController.duration = const Duration(seconds: 3);
                  _animationController.forward();
                });
              } else if (isClicked == 2) {
                setState(() {
                  if (isJoining) {
                    isJoining = false;
                    return;
                  }
                  isNotification = false;
                  isJoining = true;
                  isPromotion = false;
                  isAnniversary = false;
                  isAnimationVisible = true;
                  _animationController.reset();
                  _animationController.duration = const Duration(seconds: 3);
                  _animationController.forward();
                });
              } else if (isClicked == 3) {
                setState(() {
                  if (isPromotion) {
                    isPromotion = false;
                    return;
                  }
                  isNotification = false;
                  isJoining = false;
                  isPromotion = true;
                  isAnniversary = false;
                  isAnimationVisible = true;
                  _animationController.reset();
                  _animationController.duration = const Duration(seconds: 3);
                  _animationController.forward();
                });
              } else if (isClicked == 4) {
                setState(() {
                  if (isAnniversary) {
                    isAnniversary = false;
                    return;
                  }
                  isNotification = false;
                  isJoining = false;
                  isPromotion = false;
                  isAnniversary = true;

                  isAnimationVisible = true;
                  _animationController.reset();
                  _animationController.duration = const Duration(seconds: 3);
                  _animationController.forward();
                });
              } else {
                setState(() {
                  isAnniversary = false;
                });
              }

              if (isClicked == 5) {
                isClicked = 0;
              } else {
                isClicked = isClicked + 1;
              }
            },
            child: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              child: Image.asset('assets/images/notification_white.png', height: 22, width: 22, color: white),
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
        backgroundColor: black,
      ),
      body: GestureDetector(
        onDoubleTap: () {
          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            transitionDuration: const Duration(milliseconds: 500),
            barrierLabel: MaterialLocalizations.of(context).dialogLabel,
            barrierColor: Colors.black.withOpacity(0.5),
            pageBuilder: (context, _, __) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LiveScreen()));
                      },
                      child: Card(
                        margin: const EdgeInsets.fromLTRB(12, 50, 12, 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 160,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(22),
                                      child: Image.network(
                                        "https://www.oneindia.com/img/2022/07/naveen-jindal1-1658720087.jpg",
                                        width: MediaQuery.of(context).size.width,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                        right: 12,
                                        top: 12,
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Image.asset(
                                              "assets/images/ic_cancel.png",
                                              width: 32,
                                              height: 32,
                                            ))),
                                    Positioned(
                                        bottom: 12,
                                        left: 12,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: black.withOpacity(0.4),
                                          ),
                                          padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "assets/images/ic_placeholder.png",
                                                width: 8,
                                                height: 8,
                                                color: Colors.red,
                                              ),
                                              Container(width: 4),
                                              const Text("LIVE",
                                                  style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 12, fontFamily: roboto)),
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                child: const Text("Chairman Naveen Jindal :",
                                    style: TextStyle(color: black, fontWeight: FontWeight.w900, fontFamily: roboto, fontSize: 16)),
                              ),
                              const Text("Going live at The Elite Heaven of Class and Luxury",
                                  style: TextStyle(color: text_dark, fontWeight: FontWeight.w600, fontFamily: roboto, fontSize: 12)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(yellow),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0), side: const BorderSide(color: yellow)))),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LiveScreen()));
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                                      padding: const EdgeInsets.all(4),
                                      constraints: const BoxConstraints(minWidth: 88.0),
                                      child: Row(
                                        children: const [
                                          Text('Join', style: TextStyle(color: black, fontSize: 12, fontWeight: FontWeight.w400, fontFamily: roboto)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ).drive(Tween<Offset>(
                  begin: const Offset(0.0, -1.0),
                  end: Offset.zero,
                )),
                child: child,
              );
            },
          );
        },
        child: _isLoading ? const LoadingWidget():
        RefreshIndicator(
          color: orange,
          onRefresh: _refresh,
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Stack(
                children: [
                  Column(
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(seconds: 1),
                        opacity: isNotification ? 1 : 0,
                        child: Container(
                          height: isNotification ? 220 : 0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(width: 0.7),
                            color: lightGray.withOpacity(0.2),
                          ),
                          margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Dear Jay, ",
                                      style: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                    ),
                                    Container(
                                      height: 12,
                                    ),
                                    const Text(
                                      "Wishing you a very happy birthday & splendid year ahead.",
                                      style: TextStyle(color: white, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                    ),
                                    Container(
                                      height: 22,
                                    ),
                                    const Text(
                                      "Naveen Jindal",
                                      style: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                    ),
                                    const Text(
                                      "Chairman",
                                      style: TextStyle(color: white, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                  Image.asset(
                                    "assets/images/ic_naveen_wish.png",
                                    width: 120,
                                    height: 150,
                                    fit: BoxFit.fill,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(seconds: 1),
                        opacity: isJoining ? 1 : 0,
                        child: Container(
                          height: isJoining ? 250 : 0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(width: 0.7), color: blueNew),
                          margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Dear Jay, ",
                                      style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                    ),
                                    Container(
                                      height: 12,
                                    ),
                                    const Text(
                                      "Welcome to the JSP Family I am sure you will add great value to the organization with your hardwork and commitment",
                                      style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                    ),
                                    Container(
                                      height: 22,
                                    ),
                                    const Text(
                                      "Naveen Jindal",
                                      style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                    ),
                                    const Text(
                                      "Chairman",
                                      style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                  Image.asset(
                                    "assets/images/ic_naveen_wish.png",
                                    width: 120,
                                    height: 150,
                                    fit: BoxFit.fill,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(seconds: 1),
                        opacity: isPromotion ? 1 : 0,
                        child: Container(
                          height: isPromotion ? 280 : 0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(width: 0.7),
                            color: yellowNew,
                            /*gradient: LinearGradient(
                              // Where the linear gradient begins and ends
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              // Add one stop for each color. Stops should increase from 0 to 1
                              stops: const [0.1,  0.9],
                              colors: [
                                Colors.orange.shade600,
                                Colors.orange.shade100,
                              ],
                            ),*/
                          ),
                          margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Dear Jay, ",
                                      style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                    ),
                                    Container(
                                      height: 12,
                                    ),
                                    const Text(
                                      "Congratulations on your promotion which is the result of your hardwork and commitment, I hope you scale new heights in the future.",
                                      style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                    ),
                                    Container(
                                      height: 22,
                                    ),
                                    const Text(
                                      "Naveen Jindal",
                                      style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                    ),
                                    const Text(
                                      "Chairman",
                                      style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                  Image.asset(
                                    "assets/images/ic_naveen_wish.png",
                                    width: 120,
                                    height: 150,
                                    fit: BoxFit.fill,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(seconds: 1),
                        opacity: isAnniversary ? 1 : 0,
                        child: Container(
                          height: isAnniversary ? 270 : 0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(width: 0.7), color: orangeNew
                              /*gradient: LinearGradient(
                              // Where the linear gradient begins and ends
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              // Add one stop for each color. Stops should increase from 0 to 1
                              stops: const [0.1,  0.9],
                              colors: [
                                Colors.lightGreen.shade600,
                                Colors.lightGreen.shade100,
                              ],
                            ),*/
                              ),
                          margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Dear Jay, ",
                                      style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                    ),
                                    Container(
                                      height: 12,
                                    ),
                                    const Text(
                                      "Congratulations on completion of 2 successful year with JSP, I hope you will achieve new heights with same hardwork and commitment.",
                                      style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                    ),
                                    Container(
                                      height: 22,
                                    ),
                                    const Text(
                                      "Naveen Jindal",
                                      style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                    ),
                                    const Text(
                                      "Chairman",
                                      style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                  Image.asset(
                                    "assets/images/ic_naveen_wish.png",
                                    width: 120,
                                    height: 150,
                                    fit: BoxFit.fill,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'S',
                                    style: TextStyle(fontFamily: roboto, fontSize: 20, color: yellow, fontWeight: FontWeight.w900),
                                  ),
                                  TextSpan(text: 'ocial', style: TextStyle(fontFamily: roboto, fontSize: 20, color: white, fontWeight: FontWeight.w900)),
                                  TextSpan(
                                    text: ' M',
                                    style: TextStyle(fontFamily: roboto, fontSize: 20, color: yellow, fontWeight: FontWeight.w900),
                                  ),
                                  TextSpan(text: 'edia', style: TextStyle(fontFamily: roboto, fontSize: 20, color: white, fontWeight: FontWeight.w900)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                          height: 300,
                          child: PageView.builder(
                            controller: controllerSocial,
                            itemCount: listSocial.length,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  if (listSocial[index].url!.isNotEmpty) {
                                    if (await canLaunchUrl(Uri.parse(listSocial[index].url!.toString()))) {
                                      launchUrl(Uri.parse(listSocial[index].url!.toString()), mode: LaunchMode.externalNonBrowserApplication);
                                    }
                                  }
                                },
                                child: Container(
                                  height: 350,
                                  margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(width: 0.6, color: white.withOpacity(0.4), style: BorderStyle.solid)),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        height: 350,
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20), // Image border
                                          child: Image.network(
                                            listSocial[index].image.toString(),
                                            fit: BoxFit.cover,
                                            height: 350,
                                            width: MediaQuery.of(context).size.width,
                                          ),
                                        ),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(right: 14, top: 14),
                                          alignment: Alignment.topRight,
                                          child: Image.asset(
                                            listSocial[index].social.toString() == "facebook"
                                                ? "assets/images/facebook.png"
                                                : listSocial[index].social.toString() == "twitter"
                                                    ? "assets/images/ic_twitter.png"
                                                    : "assets/images/ic_insta.png",
                                            height: 24,
                                            width: 24,
                                            color: black,
                                          )),
                                      Container(
                                        height: 350,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(20),
                                            gradient: LinearGradient(begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, colors: [
                                              black.withOpacity(0.4),
                                              black,
                                            ], stops: const [
                                              0.0,
                                              1.0
                                            ])),
                                      ),
                                      Positioned(
                                        bottom: 12,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context).size.width - 50,
                                                margin: const EdgeInsets.only(bottom: 0, left: 14, right: 14),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  listSocial[index].description.toString(),
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      foreground: Paint()..shader = linearGradientSocial,
                                                      fontWeight: titleFont,
                                                      fontFamily: gilroy,
                                                      fontSize: 16,
                                                      overflow: TextOverflow.clip),
                                                  overflow: TextOverflow.clip,
                                                )),
                                            Container(
                                              width: MediaQuery.of(context).size.width - 55,
                                              margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: const EdgeInsets.only(top: 8, bottom: 8,  right: 10),
                                                    child: Text(listSocial[index].date.toString(),
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.w400, fontFamily: aileron, fontSize: 14, color: lightGray)),
                                                  ),
                                                  Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          if(listSocial[index].url.toString().isNotEmpty)
                                                          {
                                                            Share.share(listSocial[index].url.toString());
                                                          }
                                                        },
                                                        behavior: HitTestBehavior.opaque,
                                                        child: Image.asset(
                                                          "assets/images/share.png",
                                                          height: 22,
                                                          color: white,
                                                          width: 22,
                                                        ),
                                                      ),
                                                      const Text(
                                                        "  14  ",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                                      ),
                                                   /*   Container(width: 8),
                                                      GestureDetector(
                                                        behavior: HitTestBehavior.opaque,
                                                        onTap: () {
                                                          setState(() {
                                                            listSocial[index].isLiked = !listSocial[index].isLiked;
                                                          });
                                                        },
                                                        child: Image.asset(
                                                          listSocial[index].isLiked ? "assets/images/like_filled.png" : "assets/images/like.png",
                                                          height: 24,
                                                          color: listSocial[index].isLiked ? Colors.red : darkGray,
                                                          width: 24,
                                                        ),
                                                      ),
                                                      const Text(
                                                        "  14  ",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                                      ),*/
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
                      Wrap(
                        children: [
                          Container(
                            width: 220,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 10, left: 14, right: 14, top: 12),
                            decoration: const BoxDecoration(color: text_dark),
                            child: SmoothPageIndicator(
                              controller: controllerSocial,
                              count: listSocial.length,
                              effect: const SlideEffect(
                                  spacing: 2.0,
                                  radius: 0.0,
                                  dotWidth: 22.0,
                                  dotHeight: 2.5,
                                  paintStyle: PaintingStyle.stroke,
                                  strokeWidth: 0,
                                  dotColor: Colors.transparent,
                                  activeDotColor: yellow),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'W',
                                    style: TextStyle(fontFamily: roboto, fontSize: 20, color: yellow, fontWeight: FontWeight.w900),
                                  ),
                                  TextSpan(text: "hat's", style: TextStyle(fontFamily: roboto, fontSize: 20, color: white, fontWeight: FontWeight.w900)),
                                  TextSpan(
                                    text: ' N',
                                    style: TextStyle(fontFamily: roboto, fontSize: 20, color: yellow, fontWeight: FontWeight.w900),
                                  ),
                                  TextSpan(text: 'ew', style: TextStyle(fontFamily: roboto, fontSize: 20, color: white, fontWeight: FontWeight.w900)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 270,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: lightblack.withOpacity(0.8),
                            border: Border.all(width: 0.6, color: white.withOpacity(0.4), style: BorderStyle.solid)),
                        margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          "JSP is an industrial powerhouse with a dominant presence in steel, power, mining and infrastructure sectors. Led by Mr Naveen Jindal, the company’s enviable success story has been scripted essentially by its resolve to innovate, set new standards, enhance capabilities, enrich lives and to ensure that it stays true to its cherished value system., ",
                          style: TextStyle(height: 1.5,
                              foreground: Paint()..shader = linearGradientSocial,
                              fontWeight: titleFont,
                              fontFamily: gilroy,
                              fontSize: 16,
                              overflow: TextOverflow.clip),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12, right: 12, top: 22),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*Text("Events & Engagements",style: TextStyle(fontFamily: roboto,fontSize: 20,
                                foreground: Paint()..shader = linearGradient,fontWeight: FontWeight.w900),),*/
                            RichText(
                              text: const TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'E',
                                    style: TextStyle(fontFamily: roboto, fontSize: 20, color: yellow, fontWeight: FontWeight.w900),
                                  ),
                                  TextSpan(text: 'vents', style: TextStyle(fontFamily: roboto, fontSize: 20, color: white, fontWeight: FontWeight.w900)),
                                  TextSpan(
                                    text: ' & ',
                                    style: TextStyle(fontFamily: roboto, fontSize: 20, color: white, fontWeight: FontWeight.w900),
                                  ),
                                  TextSpan(
                                    text: 'E',
                                    style: TextStyle(fontFamily: roboto, fontSize: 20, color: yellow, fontWeight: FontWeight.w900),
                                  ),
                                  TextSpan(
                                      text: 'ngagements', style: TextStyle(fontFamily: roboto, fontSize: 20, color: white, fontWeight: FontWeight.w900)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                          height: 300,
                          child: PageView.builder(
                            itemCount: listEvents.length,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailsScreenNew(listEvents[index])));
                                  // print("result ===== $result");
                                  setState(() {
                                    for (int i = 0; i < listEvents.length; i++) {
                                      if(listEvents[i].id == result.id)
                                      {
                                        listEvents[i].setIsLikeMain = result.isLiked;
                                      }
                                    }
                                  });
                                },
                                child: Container(
                                  height: 300,
                                  margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(width: 0.6, color: white.withOpacity(0.4), style: BorderStyle.solid)),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        height: 300,
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20), // Image border
                                          child: Image.network(
                                            listEvents[index].featuredImage.toString(),
                                            fit: BoxFit.cover,
                                            height: 350,
                                            width: MediaQuery.of(context).size.width,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 300,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(20),
                                            gradient: LinearGradient(begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, colors: [
                                              black.withOpacity(0.2),
                                              black,
                                            ], stops: const [
                                              0.0,
                                              1.0
                                            ])),
                                      ),
                                      Positioned(
                                          top: 12,
                                          left: 12,
                                          child: Container(
                                              decoration: BoxDecoration(color: black.withOpacity(0.4), borderRadius: BorderRadius.circular(22)),
                                              padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                                              child: Text(
                                                listEvents[index].location.toString(),
                                                style: const TextStyle(color: white, fontSize: 12, fontWeight: FontWeight.w400),
                                              ))),
                                      Positioned(
                                        bottom: 12,
                                        child: Column(
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context).size.width - 50,
                                                margin: const EdgeInsets.only(bottom: 0, left: 14, right: 14),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  listEvents[index].title.toString(),
                                                  style: TextStyle(
                                                      foreground: Paint()..shader = linearGradientSocial,
                                                      fontWeight: titleFont,
                                                      fontFamily: gilroy,
                                                      fontSize: 16,
                                                      overflow: TextOverflow.clip),
                                                  overflow: TextOverflow.clip,
                                                )),
                                            Row(
                                              children: [
                                                Container(
                                                    width: MediaQuery.of(context).size.width - 50,
                                                    margin: const EdgeInsets.only(top: 4, left: 14, right: 14),
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      listEvents[index].saveTimestamp.toString(),
                                                      style: const TextStyle(
                                                          color: lightGray,
                                                          fontWeight: FontWeight.w400,
                                                          fontFamily: gilroy,
                                                          fontSize: 14,
                                                          overflow: TextOverflow.clip),
                                                      overflow: TextOverflow.clip,
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
                      Container(
                        margin: const EdgeInsets.only(left: 12, right: 12, top: 22),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /* Text("Videos",style: TextStyle(fontFamily: roboto,fontSize: 20,
                                foreground: Paint()..shader = linearGradient,fontWeight: FontWeight.w900),),*/
                            RichText(
                              text: const TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'V',
                                    style: TextStyle(fontFamily: roboto, fontSize: 20, color: yellow, fontWeight: FontWeight.w900),
                                  ),
                                  TextSpan(text: 'ideos', style: TextStyle(fontFamily: roboto, fontSize: 20, color: white, fontWeight: FontWeight.w900)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 22),
                        height: 300,
                        child: PageView.builder(
                          controller: controller,
                          itemCount: listVideos.length,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => VideoDetailsPage(listVideos[index].id.toString())));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                margin: const EdgeInsets.only(left: 12, right: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                    border: Border.all(width: 0.6, color: white.withOpacity(0.4), style: BorderStyle.solid)
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.network(listVideos[index].featuredImage.toString(),
                                          width: MediaQuery.of(context).size.width, height: 300, fit: BoxFit.cover),
                                    ),
                                    Container(
                                      height: 300,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          gradient: LinearGradient(begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, colors: [
                                            black.withOpacity(0.4),
                                            black.withOpacity(1),
                                          ], stops: const [
                                            0.0,
                                            1.0
                                          ]),
                                          borderRadius: BorderRadius.circular(20)),
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        width: 46,
                                        height: 46,
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          'assets/images/play.png',
                                          height: 46,
                                          width: 46,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 120,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width - 60,
                                        margin: const EdgeInsets.only(left: 18, right: 22),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    if(listVideos[index].media!.isNotEmpty)
                                                    {
                                                      if(listVideos[index].media![0].media.toString().isNotEmpty)
                                                      {
                                                        Share.share(listVideos[index].media![0].media.toString());
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 42,
                                                    height: 42,
                                                    alignment: Alignment.center,
                                                    child: Image.asset('assets/images/share.png', height: 22, width: 22, color: white),
                                                  ),
                                                ),
                                                Text(
                                                  listVideos[index].sharesCount.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                                ),
                                               /* Container(
                                                  width: 42,
                                                  height: 42,
                                                  alignment: Alignment.center,
                                                  child:  Image.asset(
                                                    "assets/images/ic_arrow_right_new.png",
                                                    height: 22, width: 22,
                                                  ),
                                                )*/

                                               /* GestureDetector(
                                                  onTap: () async {
                                                      setState(() {
                                                      listVideos[index].isLiked = !listVideos[index].isLiked;
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 42,
                                                    height: 42,
                                                    alignment: Alignment.center,
                                                    child: Image.asset(
                                                        listVideos[index].isLiked == 1
                                                            ? "assets/images/like_filled.png"
                                                            : 'assets/images/like.png',
                                                        height: 22, width: 22,color: listVideos[index].isLiked == 1 ? Colors.red : white),
                                                  )
                                                ),*/
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 110,
                                        child: SizedBox(
                                            width: MediaQuery.of(context).size.width - 22,
                                            child: const Divider(
                                              color: lightGray,
                                              thickness: 0.5,
                                              height: 0.5,
                                              indent: 12,
                                              endIndent: 12,
                                            ))),
                                    Positioned(
                                        bottom: 60,
                                        child: Container(
                                            width: MediaQuery.of(context).size.width - 40,
                                            margin: const EdgeInsets.only(left: 18, right: 18),
                                            child: Text(
                                              listVideos[index].title.toString(),
                                              overflow: TextOverflow.clip,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  foreground: Paint()..shader = linearGradientSocial,
                                                  fontWeight: titleFont,
                                                  fontFamily: gilroy,
                                                  fontSize: 16,
                                                  overflow: TextOverflow.clip),
                                            ))),
                                    Positioned(
                                      bottom: 34,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 18, right: 18, top: 12),
                                        child: Row(
                                          children: [
                                            Text(
                                              listVideos[index].location.toString(),
                                              style: const TextStyle(fontSize: 12, fontFamily: roboto, fontWeight: FontWeight.w400, color: white),
                                            ),
                                            Container(
                                              width: listVideos[index].location.toString().isNotEmpty ? 6 : 0,
                                            ),
                                            listVideos[index].location.toString().isNotEmpty ? Image.asset(
                                              "assets/images/ic_placeholder.png",
                                              width: 4,
                                              height: 4,
                                              color: white,
                                            ) : Container(),
                                            Container(
                                              width: listVideos[index].location.toString().isNotEmpty ? 6 : 0,
                                            ),
                                            Text(
                                              listVideos[index].saveTimestamp.toString(),
                                              style: const TextStyle(fontSize: 12, fontFamily: roboto, fontWeight: FontWeight.w400, color: white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Wrap(
                        children: [
                          Container(
                            width: 240,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 10, left: 14, right: 14, top: 12),
                            decoration: const BoxDecoration(color: text_dark),
                            child: SmoothPageIndicator(
                              controller: controller,
                              count: 3,
                              effect: const SlideEffect(
                                  spacing: 2.0,
                                  radius: 0.0,
                                  dotWidth: 80.0,
                                  dotHeight: 2.5,
                                  paintStyle: PaintingStyle.stroke,
                                  strokeWidth: 0,
                                  dotColor: Colors.transparent,
                                  activeDotColor: yellow),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12, right: 12, top: 22),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'N',
                                    style: TextStyle(fontFamily: roboto, fontSize: 20, color: yellow, fontWeight: FontWeight.w900),
                                  ),
                                  TextSpan(text: 'ews', style: TextStyle(fontFamily: roboto, fontSize: 20, color: white, fontWeight: FontWeight.w900)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: listNews.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailsScreen(listNews[index].id.toString())));
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                              margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(width: 0.6, color: white.withOpacity(0.4), style: BorderStyle.solid)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(right: 12),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(listNews[index].title.toString(),
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      foreground: Paint()..shader = linearGradientSocial,
                                                      fontWeight: titleFont,
                                                      fontFamily: gilroy,
                                                      fontSize: 16,
                                                      overflow: TextOverflow.clip))
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        height: 100,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20.0),
                                          child: Image.network(listNews[index].featuredImage.toString(), width: 100, height: 100, fit: BoxFit.cover),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 18,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        listNews[index].location.toString(),
                                        style: TextStyle(fontSize: 12, fontFamily: roboto, fontWeight: FontWeight.w400, color: lightGray),
                                      ),
                                      listNews[index].location.toString().isNotEmpty ? Container(
                                        width: 6,
                                      ) : Container(),
                                      listNews[index].location.toString().isNotEmpty ? Image.asset(
                                        "assets/images/ic_placeholder.png",
                                        width: 4,
                                        height: 4,
                                        color: lightGray,
                                      ) : Container(),
                                      listNews[index].location.toString().isNotEmpty ?  Container(
                                        width: 6,
                                      ) : Container(),
                                      Text(
                                        listNews[index].saveTimestamp.toString(),
                                        style: TextStyle(fontSize: 12, fontFamily: roboto, fontWeight: FontWeight.w400, color: lightGray),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          if(listNews[index].media!.isNotEmpty)
                                          {
                                            if(listNews[index].media![0].media.toString().isNotEmpty)
                                            {
                                              Share.share(listNews[index].media![0].media.toString());
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 42,
                                          height: 42,
                                          alignment: Alignment.center,
                                          child: Image.asset('assets/images/share.png', height: 22, width: 22, color: white),
                                        ),
                                      ),
                                      Text(
                                        listNews[index].sharesCount.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                      ),
                                      Container(
                                        width: 8,
                                      )
                                     /* Container(
                                        width: 12,
                                      ),
                                      Image.asset(
                                        "assets/images/ic_arrow_right_new.png",
                                        width: 22,
                                        height: 22,
                                      )*/
                                    ],
                                  ),
                                  Container(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Gap(20)
                    ],
                  ),
                  Visibility(
                    visible: isAnimationVisible,
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Lottie.asset(
                        'assets/images/confetti.json',
                        repeat: true,
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void castStatefulWidget() {
    widget as TrendingScreen;
  }

  getDashboradData([bool isPull = false]) async {
    if(!isPull)
    {
      setState(() {
        _isLoading = true;
      });
    }

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + dashboardData);

    print("<><> TOKEN : " + sessionManager.getAccessToken().toString().trim() + " <><>");

    Map<String, String> jsonBody = {'from_app': FROM_APP,'user_id' : sessionManager.getUserId().toString()};

    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = DashBoardDataResponse.fromJson(apiResponse);
    if (statusCode == 200 && dataResponse.success == 1) {
      listVideos = List<Posts>.empty(growable: true);
      listEvents = List<Posts>.empty(growable: true);
      listNews = List<Posts>.empty(growable: true);
      if (dataResponse.postsList != null && dataResponse.postsList!.isNotEmpty) {
        for (int i = 0; i < dataResponse.postsList!.length; i++) {
          if (dataResponse.postsList![i].id == "2") // "Events & Enagagements"
          {
            if (dataResponse.postsList![i].posts != null) {
              if (dataResponse.postsList![i].posts!.isNotEmpty) {
                listEvents.addAll(dataResponse.postsList![i].posts!);
              }
            }
          } else if (dataResponse.postsList![i].id == "3") // "Videos"
          {
            if (dataResponse.postsList![i].posts != null) {
              if (dataResponse.postsList![i].posts!.isNotEmpty) {
                listVideos.addAll(dataResponse.postsList![i].posts!);
              }
            }
          } else if (dataResponse.postsList![i].id == "4") // "News"
          {
            if (dataResponse.postsList![i].posts != null) {
              if (dataResponse.postsList![i].posts!.isNotEmpty) {
                listNews.addAll(dataResponse.postsList![i].posts!);
              }
            }
          }
        }
      }
    } else {
      showSnackBar(dataResponse.message, context);
    }
    setState(() {
      _isLoading = false;
    });
  }
}

@immutable
class ShakeWidget extends StatelessWidget {
  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;

  const ShakeWidget({
    required Key key,
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 20,
    this.curve = Curves.bounceOut,
    required this.child,
  }) : super(key: key);

  /// convert 0-1 to 0-1-0
  double shake(double animation) => 2 * (0.5 - (0.5 - curve.transform(animation)).abs());

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, animation, child) => Transform.translate(
        offset: Offset(deltaX * shake(animation), 0),
        child: child,
      ),
      child: child,
    );
  }
}
