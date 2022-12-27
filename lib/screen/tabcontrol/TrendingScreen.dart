import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:jspl_connect/screen/AboutJSPLScreen.dart';
import 'package:jspl_connect/screen/AboutScreen.dart';
import 'package:jspl_connect/screen/LeadershipScreen.dart';
import 'package:jspl_connect/screen/MediaCoverageScreen.dart';
import 'package:jspl_connect/screen/SocialWallScreen.dart';
import 'package:jspl_connect/widget/event_block.dart';
import 'package:jspl_connect/widget/social_block.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import '../../constant/api_end_point.dart';
import '../../constant/colors.dart';
import '../../model/DashBoardDataResponse.dart';
import '../../model/NotificationCountResponse.dart';
import '../../model/PostListResponse.dart';
import '../../utils/app_utils.dart';
import '../../utils/base_class.dart';
import '../../widget/loading.dart';
import '../../widget/news_block.dart';
import '../../widget/video_block.dart';
import '../CommonDetailsScreen.dart';
import '../EventListScreen.dart';
import '../MagazineListScreen.dart';
import '../NavigationDrawerScreen.dart';
import '../NewsListScreen.dart';
import '../NotificationListScreen.dart';
import '../SearchPostScreen.dart';
import '../SuggestionFormScreen.dart';
import '../VideoScreen.dart';
import '../WhatsNewListScreen.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({Key? key}) : super(key: key);

  @override
  _TrendingScreen createState() => _TrendingScreen();
}

class _TrendingScreen extends BaseState<TrendingScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final controller = PageController(viewportFraction: 1, keepPage: true);
  final controllerNew = PageController(viewportFraction: 0.95, keepPage: false);
  final controllerSocial = PageController(viewportFraction: 1, keepPage: true);
  final controllerEvents = PageController(viewportFraction: 1, keepPage: true);
  int isClicked = 1;
  bool _isLoading = false;
  bool isNotification = false;
  bool isJoining = false;
  bool isPromotion = false;
  bool isAnniversary = false;
  bool isAnimationVisible = false;
  bool isDashboard1 = false;
  late AnimationController _animationController;
  List<Posts> listSocial = List<Posts>.empty(growable: true);
  List<Posts> listVideos = List<Posts>.empty(growable: true);
  List<Posts> listEvents = List<Posts>.empty(growable: true);
  List<Posts> listNews = List<Posts>.empty(growable: true);
  List<Posts> listLeadership = List<Posts>.empty(growable: true);
  List<Posts> listImages = List<Posts>.empty(growable: true);
  List<Posts> listWhatsNew = List<Posts>.empty(growable: true);

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
      unReadNotificationCount();
      getDashBoardData();
      getWhatsNew();
    } else {
      noInterNet(context);
    }

    isHomeReload = false;
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      unReadNotificationCount();
    }
  }

  Future<bool> _refresh() {
    print("refresh......");
    if (isInternetConnected) {
      unReadNotificationCount();
      getDashBoardData(true);
    } else {
      noInterNet(context);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: screenBg,
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () {
            HapticFeedback.vibrate();
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NavigationDrawerScreen()));
          },
          child: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: Image.asset('assets/images/menu.png', height: 22, width: 22, color: black),
          ),
        ),
        title: Text(
          "Discover",
          style: TextStyle(fontWeight: FontWeight.w600, color: black, fontFamily: roboto),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPostScreen()));
            },
            child: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              child: Image.asset('assets/images/search.png', height: 22, width: 22, color: black),
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
              child: Image.asset('assets/images/ic_birthday_light.png', height: 22, width: 22,),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                sessionManager.setUnreadNotificationCount(0);
              });
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationListScreen()));
            },
            child: Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 6, right: 10),
                  child: Image.asset('assets/images/notification_white.png', color: black,height: 22, width: 22),
                ),
                sessionManager.getUnreadNotificationCount()! > 0 ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: orangeNew,
                  ),
                  height: 22,
                  width: 22,
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.only(left: 22,top: 10),
                  child: Center(
                    child: Text(checkValidString(sessionManager.getUnreadNotificationCount().toString()),
                        maxLines: 1,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: whiteConst,
                            fontSize: 11)),
                  ),
                ) : Container(),
              ],
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
        backgroundColor: screenBg,
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
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => const LiveScreen()));
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
                                              Text("LIVE",
                                                  style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 12, fontFamily: roboto)),
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                child: Text("Chairman Naveen Jindal :",
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
                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => const LiveScreen()));
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                                      padding: const EdgeInsets.all(4),
                                      constraints: const BoxConstraints(minWidth: 88.0),
                                      child: Row(
                                        children: [
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
        child: _isLoading
            ? const LoadingWidget()
            : SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: grayNew,
                            onPrimary: grayNew,
                            elevation: 0.0,
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            side: BorderSide(color: isDashboard1 ? orangeNew.withOpacity(0.6) : black.withOpacity(0.6), width: 0.6, style: BorderStyle.solid),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            tapTargetSize: MaterialTapTargetSize.padded,
                            animationDuration: const Duration(milliseconds: 100),
                            enableFeedback: true,
                            alignment: Alignment.center,
                          ),
                          onPressed: () {
                            setState(() {
                              isDashboard1 = true;
                            });
                          },
                          child: Text(
                            "Dashboard 1",
                            style: TextStyle(fontSize: 14, fontWeight: isDashboard1 ? FontWeight.w600 : FontWeight.w500, color: isDashboard1 ? orangeNew.withOpacity(0.8) : black.withOpacity(0.8), fontFamily: gilroy),
                          ),
                        ),
                      ),
                      Container(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: grayNew,
                            onPrimary: grayNew,
                            elevation: 0.0,
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            side: BorderSide(color: !isDashboard1 ? orangeNew.withOpacity(0.6) : black.withOpacity(0.6), width: 0.6, style: BorderStyle.solid),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            tapTargetSize: MaterialTapTargetSize.padded,
                            animationDuration: const Duration(milliseconds: 100),
                            enableFeedback: true,
                            alignment: Alignment.center,
                          ),
                          onPressed: () {
                            setState(() {
                              isDashboard1 = false;
                            });
                          },
                          child: Text(
                            "Dashboard 2",
                            style: TextStyle(fontSize: 14, fontWeight: !isDashboard1 ? FontWeight.w600 : FontWeight.w500, color: !isDashboard1 ? orangeNew.withOpacity(0.8) : black.withOpacity(0.8), fontFamily: gilroy),
                          ),
                        ),
                      ),
                      Container(width: 12),
                    ],
                  ),
                  isDashboard1
                      ? RefreshIndicator(
                      color: orange,
                      onRefresh: _refresh,
                      child: SafeArea(
                        child: SingleChildScrollView(
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
                                          //color: lightGray.withOpacity(0.2),
                                          gradient: const LinearGradient(
                                            colors: [navigationGradient1, navigationGradient2, navigationGradient3],
                                            stops: [0.0, 0.4, 1.0],
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                          )),
                                      margin: EdgeInsets.fromLTRB(12, isNotification ? 12 : 0, 12, 0),
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
                                                  style: TextStyle(color: blackConst, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                                ),
                                                Container(
                                                  height: 12,
                                                ),
                                                const Text(
                                                  "Wishing you a very happy birthday & splendid year ahead.",
                                                  style: TextStyle(color: blackConst, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                                ),
                                                Container(
                                                  height: 22,
                                                ),
                                                const Text(
                                                  "Naveen Jindal",
                                                  style: TextStyle(color: blackConst, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                                ),
                                                const Text(
                                                  "Chairman",
                                                  style: TextStyle(color: blackConst, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Expanded(
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
                                      height: isJoining ? 255 : 0,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(18),
                                          //color: blueNew,
                                          gradient: const LinearGradient(
                                            colors: [navigationGradient1, navigationGradient2, navigationGradient3],
                                            stops: [0.0, 0.4, 1.0],
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                          )),
                                      margin: EdgeInsets.fromLTRB(12, isJoining ? 12 : 0, 12, 0),
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
                                                  style: TextStyle(color: blackConst, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                                ),
                                                Container(
                                                  height: 12,
                                                ),
                                                const Text(
                                                  "Welcome to the JSP Family I am sure you will add great value to the organization with your hardwork and commitment",
                                                  style: TextStyle(color: blackConst, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                                ),
                                                Container(
                                                  height: 22,
                                                ),
                                                const Text(
                                                  "Naveen Jindal",
                                                  style: TextStyle(color: blackConst, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                                ),
                                                const Text(
                                                  "Chairman",
                                                  style: TextStyle(color: blackConst, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
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
                                          //color: yellowNew,
                                          gradient: const LinearGradient(
                                            colors: [navigationGradient1, navigationGradient2, navigationGradient3],
                                            stops: [0.0, 0.4, 1.0],
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                          )
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
                                      margin: EdgeInsets.fromLTRB(12, isPromotion ? 12 : 0, 12, 0),
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
                                                  style: TextStyle(color: blackConst, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                                ),
                                                Container(
                                                  height: 12,
                                                ),
                                                const Text(
                                                  "Congratulations on your promotion which is the result of your hardwork and commitment, I hope you scale new heights in the future.",
                                                  style: TextStyle(color: blackConst, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                                ),
                                                Container(
                                                  height: 22,
                                                ),
                                                const Text(
                                                  "Naveen Jindal",
                                                  style: TextStyle(color: blackConst, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                                ),
                                                const Text(
                                                  "Chairman",
                                                  style: TextStyle(color: blackConst, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
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
                                      height: isAnniversary ? 280 : 0,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(18),
                                          //color: orangeNew,
                                          gradient: const LinearGradient(
                                            colors: [navigationGradient1, navigationGradient2, navigationGradient3],
                                            stops: [0.0, 0.4, 1.0],
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                          )
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
                                      margin: EdgeInsets.fromLTRB(12, isAnniversary ? 12 : 0, 12, 0),
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
                                                  style: TextStyle(color: blackConst, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                                ),
                                                Container(
                                                  height: 12,
                                                ),
                                                const Text(
                                                  "Congratulations on completion of 2 successful year with JSP, I hope you will achieve new heights with same hardwork and commitment.",
                                                  style: TextStyle(color: blackConst, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                                ),
                                                Container(
                                                  height: 22,
                                                ),
                                                const Text(
                                                  "Naveen Jindal",
                                                  style: TextStyle(color: blackConst, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                                ),
                                                const Text(
                                                  "Chairman",
                                                  style: TextStyle(color: blackConst, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
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
                                    margin: const EdgeInsets.only(top: 12,left: 12),
                                    height: 135,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Column(
                                          children: [
                                            TouchRippleEffect(
                                              borderRadius: BorderRadius.circular(18),
                                              rippleColor: Colors.white60,
                                              rippleDuration: const Duration(milliseconds: 100),
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutJSPLScreen()));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(18),
                                                  child: Image.network(
                                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgyscUUTE5JRATut4NyA_H02hk4_3OiShe6w&usqp=CAU",
                                                      width: 150,
                                                      height: 100,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 10,
                                            ),
                                            Text(
                                              "About JSP",
                                              style: TextStyle(color: black, fontFamily: roboto, fontSize: 14, fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                        Container(
                                          width: 6,
                                        ),
                                        Column(
                                          children: [
                                            TouchRippleEffect(
                                              borderRadius: BorderRadius.circular(18),
                                              rippleColor: Colors.white60,
                                              rippleDuration: const Duration(milliseconds: 100),
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
                                              },
                                              child:  Container(
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(18),
                                                  child: Image.network(
                                                      "https://res.cloudinary.com/dliifke2y/image/upload/v1669291685/Naveen%20Jindal/_SAM9274_jxcxzj.jpg",
                                                      width: 150,
                                                      height: 100,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 10,
                                            ),
                                            Text(
                                              "Shri Naveen Jindal",
                                              style: TextStyle(color: black, fontFamily: roboto, fontSize: 14, fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                        Container(
                                          width: 6,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SocialWallScreen()));
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(18),
                                                  child: Image.network(
                                                      "https://d2lptvt2jijg6f.cloudfront.net/Flag%20Foundation/page/1598931776_lapal-pin.jpg",
                                                      width: 150,
                                                      height: 100,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              Container(
                                                height: 10,
                                              ),
                                              Text(
                                                "Social",
                                                style: TextStyle(color: black, fontFamily: roboto, fontSize: 14, fontWeight: FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 6,
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(18),
                                                child: Material(
                                                  color : Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MediaCoverageScreen()));
                                                    },
                                                    borderRadius: BorderRadius.circular(18),
                                                    splashColor: Colors.brown.withOpacity(0.5),
                                                    child: Image.network(
                                                        "https://res.cloudinary.com/dliifke2y/image/upload/v1669291963/Naveen%20Jindal/0X4A0431-min_ospsox.jpg",
                                                        width: 150,
                                                        height: 100,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 10,
                                            ),
                                            Text(
                                              "Media Coverage",
                                              style: TextStyle(color: black, fontFamily: roboto, fontSize: 14, fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                        Container(
                                          width: 6,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const MagazineListScreen()));
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(18),
                                                  child: Image.network(
                                                      "https://res.cloudinary.com/dliifke2y/image/upload/v1669291685/Naveen%20Jindal/_SAM9274_jxcxzj.jpg",
                                                      width: 150,
                                                      height: 100,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              Container(
                                                height: 10,
                                              ),
                                              Text(
                                                "Magazine",
                                                style: TextStyle(color: black, fontFamily: roboto, fontSize: 14, fontWeight: FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 6,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LeadershipScreen()));
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(18),
                                                  child: Image.network(
                                                      "https://indiacsr.in/wp-content/uploads/2022/11/Jindal-Steel-Power-Limited-board-members-1.jpg",
                                                      width: 150,
                                                      height: 100,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              Container(
                                                height: 10,
                                              ),
                                              Text(
                                                "Our Leadership",
                                                style: TextStyle(color: black, fontFamily: roboto, fontSize: 14, fontWeight: FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                      visible: listSocial.isNotEmpty,
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        margin: const EdgeInsets.only(left: 14, right: 14, top: 12),
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: 'Social Media',
                                                  style: TextStyle(fontFamily: roboto, fontSize: 22, color: black, fontWeight: FontWeight.w900)),
                                            ],
                                          ),
                                        ),
                                      )),
                                  Visibility(
                                      visible: listSocial.isNotEmpty,
                                      child: SizedBox(
                                          height: 450,
                                          child: PageView.builder(
                                            controller: controllerSocial,
                                            itemCount: listSocial.length,
                                            physics: const ScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return SocialBlock(
                                                listSocial: listSocial,
                                                index: index,
                                                setState: setState,
                                              );
                                            },
                                          ))),
                                  Visibility(
                                      visible: listSocial.length > 1,
                                      child: Wrap(
                                        children: [
                                          Container(
                                            width: listSocial.length * 36,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(bottom: 10, left: 14, right: 14, top: 12),
                                            decoration: const BoxDecoration(color: text_dark),
                                            child: SmoothPageIndicator(
                                              controller: controllerSocial,
                                              count: listSocial.length,
                                              effect: const SlideEffect(
                                                  spacing: 2.0,
                                                  radius: 0.0,
                                                  dotWidth: 36.0,
                                                  dotHeight: 2.5,
                                                  paintStyle: PaintingStyle.stroke,
                                                  strokeWidth: 0,
                                                  dotColor: Colors.transparent,
                                                  activeDotColor: orangeNew),
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                    margin: const EdgeInsets.only(left: 12, right: 12, top: 22),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Chairman's Message",
                                                  style: TextStyle(fontFamily: roboto, fontSize: 22, color: black, fontWeight: FontWeight.w900)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: newsBlock,
                                    ),
                                    margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "A well-known Indian Industrialist and Philanthropist, Mr Naveen Jindal is the Chairman of Jindal steel & Power limited (JSPL), India’s leading infrastructure Conglomerate with interests in steel, mining and power sector.",
                                                style: TextStyle(
                                                    height: 1.5,
                                                    color: black,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: gilroy,
                                                    fontSize: 14,
                                                    overflow: TextOverflow.clip),
                                              ),
                                              Container(
                                                height: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 12,
                                        ),
                                        SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20.0),
                                            child: Image.asset("assets/images/ic_naveen_video_2.png", width: 100, height: 100, fit: BoxFit.cover),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 12, right: 12, top: 22),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "What's",
                                                  style: TextStyle(fontFamily: roboto, fontSize: 22, color: black, fontWeight: FontWeight.w900)),
                                              TextSpan(
                                                  text: ' New',
                                                  style: TextStyle(fontFamily: roboto, fontSize: 22, color: black, fontWeight: FontWeight.w900)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 320,
                                    width: double.infinity,
                                    child: PageView.builder(
                                      controller: controllerNew,
                                      itemCount: listWhatsNew.length > 4 ? 4 : listWhatsNew.length,
                                      pageSnapping: true,
                                      physics: const ScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          height: 320,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: newsBlock,
                                          ),
                                          margin: const EdgeInsets.fromLTRB(0, 12, 12, 0),
                                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 12,
                                              ),
                                              Text(listWhatsNew[index].saveTimestamp.toString(),
                                                  style: TextStyle(color: black, fontFamily: roboto, fontWeight: FontWeight.w400, fontSize: 14)),
                                              Container(
                                                height: 12,
                                              ),
                                              Text(
                                                listWhatsNew[index].title.toString(),
                                                style: TextStyle(
                                                    height: 1.5,
                                                    color: black,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: gilroy,
                                                    fontSize: 18,
                                                    overflow: TextOverflow.clip),
                                                maxLines: 1,
                                              ),
                                              Container(
                                                height: 12,
                                              ),
                                              Text(
                                                  listWhatsNew[index].shortDescription.toString(),
                                                style: TextStyle(
                                                    height: 1.5,
                                                    color: black,
                                                    fontWeight: titleFont,
                                                    fontFamily: gilroy,
                                                    fontSize: 14,
                                                    overflow: TextOverflow.clip),
                                                maxLines: 5,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Wrap(
                                    children: [
                                      Container(
                                        width: listWhatsNew.length > 4 ? 4 * 36 : listWhatsNew.length * 36,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(bottom: 10, left: 14, right: 14, top: 12),
                                        decoration: const BoxDecoration(color: text_dark),
                                        child: SmoothPageIndicator(
                                          controller: controllerNew,
                                          count: listWhatsNew.length > 4 ? 4 : listWhatsNew.length,
                                          effect: const SlideEffect(
                                              spacing: 2.0,
                                              radius: 0.0,
                                              dotWidth: 36.0,
                                              dotHeight: 2.5,
                                              paintStyle: PaintingStyle.stroke,
                                              strokeWidth: 0,
                                              dotColor: Colors.transparent,
                                              activeDotColor: orangeNew),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                      visible: listEvents.isNotEmpty,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 12, right: 12, top: 22),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            /*Text("Events & Engagements",style: TextStyle(fontFamily: roboto,fontSize: 20,
                                        foreground: Paint()..shader = linearGradient,fontWeight: FontWeight.w900),),*/
                                            RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: 'Events',
                                                      style: TextStyle(fontFamily: roboto, fontSize: 22, color: black, fontWeight: FontWeight.w900)),
                                                  TextSpan(
                                                    text: ' & ',
                                                    style: TextStyle(fontFamily: roboto, fontSize: 22, color: black, fontWeight: FontWeight.w900),
                                                  ),
                                                  TextSpan(
                                                      text: 'Engagements',
                                                      style: TextStyle(fontFamily: roboto, fontSize: 22, color: black, fontWeight: FontWeight.w900)),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                  Visibility(
                                      visible: listEvents.isNotEmpty,
                                      child: SizedBox(
                                        height: 400,
                                        child: PageView.builder(
                                          controller: controllerEvents,
                                          itemCount: listEvents.length,
                                          physics: const ScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return EventBlock(listEvents: listEvents, index: index, setState: setState);
                                          },
                                        ),
                                      )
                                  ),
                                  Visibility(
                                      visible: listEvents.length > 1,
                                      child: Wrap(
                                        children: [
                                          Container(
                                            width: listEvents.length.toDouble() * 36,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(bottom: 10, left: 14, right: 14, top: 12),
                                            decoration: const BoxDecoration(color: text_light),
                                            child: SmoothPageIndicator(
                                              controller: controllerEvents,
                                              count: listEvents.length,
                                              effect: const SlideEffect(
                                                  spacing: 2.0,
                                                  radius: 0.0,
                                                  dotWidth: 36.0,
                                                  dotHeight: 2.5,
                                                  paintStyle: PaintingStyle.stroke,
                                                  strokeWidth: 0,
                                                  dotColor: Colors.transparent,
                                                  activeDotColor: orangeNew),
                                            ),
                                          ),
                                        ],
                                      )),
                                  Visibility(
                                      visible: listVideos.isNotEmpty,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 12, right: 12, top: 22),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            /* Text("Videos",style: TextStyle(fontFamily: roboto,fontSize: 20,
                                        foreground: Paint()..shader = linearGradient,fontWeight: FontWeight.w900),),*/
                                            RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: 'Videos',
                                                      style: TextStyle(fontFamily: roboto, fontSize: 22, color: black, fontWeight: FontWeight.w900)),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                  Visibility(
                                      visible: listVideos.isNotEmpty,
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 22),
                                        height: 450,
                                        child: PageView.builder(
                                          controller: controller,
                                          itemCount: listVideos.length,
                                          physics: const ScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return VideoBlock(
                                              listVideos: listVideos,
                                              index: index,
                                              setState: setState,
                                            );
                                          },
                                        ),
                                      )),
                                  Visibility(
                                      visible: listVideos.length > 1,
                                      child: Wrap(
                                        children: [
                                          Container(
                                            width: listVideos.length.toDouble() * 36,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(bottom: 10, left: 14, right: 14, top: 24),
                                            decoration: const BoxDecoration(color: text_light),
                                            child: SmoothPageIndicator(
                                              controller: controller,
                                              count: listVideos.length,
                                              effect: const SlideEffect(
                                                  spacing: 2.0,
                                                  radius: 0.0,
                                                  dotWidth: 36.0,
                                                  dotHeight: 2.5,
                                                  paintStyle: PaintingStyle.stroke,
                                                  strokeWidth: 0,
                                                  dotColor: Colors.transparent,
                                                  activeDotColor: orange),
                                            ),
                                          ),
                                        ],
                                      )),
                                  Visibility(
                                      visible: listNews.isNotEmpty,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 12, right: 12, top: 22),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: 'News',
                                                      style: TextStyle(fontFamily: roboto, fontSize: 22, color: black, fontWeight: FontWeight.w900)),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                  Visibility(
                                      visible: listNews.isNotEmpty,
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        physics: const NeverScrollableScrollPhysics(),
                                        primary: false,
                                        shrinkWrap: true,
                                        itemCount: listNews.length,
                                        itemBuilder: (context, index) {
                                          return NewsBlock(
                                            listNews: listNews,
                                            index: index,
                                            isFromNews: true,
                                            setState: setState,
                                          );
                                        },
                                      )),
                                  const Gap(20)
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
                    )
                      : Container(
                        color: newScreenBg,
                        child: RefreshIndicator(
                          color: orange,
                          onRefresh: _refresh,
                          child: SafeArea(
                            child: SingleChildScrollView(
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
                                              //color: lightGray.withOpacity(0.2),
                                              gradient: const LinearGradient(
                                                colors: [navigationGradient1, navigationGradient2, navigationGradient3],
                                                stops: [0.0, 0.4, 1.0],
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                              )),
                                          margin: EdgeInsets.fromLTRB(12, isNotification ? 12 : 0, 12, 0),
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
                                                      style: TextStyle(color: blackConst, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                                    ),
                                                    Container(
                                                      height: 12,
                                                    ),
                                                    const Text(
                                                      "Wishing you a very happy birthday & splendid year ahead.",
                                                      style: TextStyle(color: blackConst, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                                    ),
                                                    Container(
                                                      height: 22,
                                                    ),
                                                    const Text(
                                                      "Naveen Jindal",
                                                      style: TextStyle(color: blackConst, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                                    ),
                                                    const Text(
                                                      "Chairman",
                                                      style: TextStyle(color: blackConst, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Expanded(
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
                                          height: isJoining ? 255 : 0,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(18),
                                              //color: blueNew,
                                              gradient: const LinearGradient(
                                                colors: [navigationGradient1, navigationGradient2, navigationGradient3],
                                                stops: [0.0, 0.4, 1.0],
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                              )),
                                          margin: EdgeInsets.fromLTRB(12, isJoining ? 12 : 0, 12, 0),
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
                                                      style: TextStyle(color: blackConst, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                                    ),
                                                    Container(
                                                      height: 12,
                                                    ),
                                                    const Text(
                                                      "Welcome to the JSP Family I am sure you will add great value to the organization with your hardwork and commitment",
                                                      style: TextStyle(color: blackConst, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                                    ),
                                                    Container(
                                                      height: 22,
                                                    ),
                                                    const Text(
                                                      "Naveen Jindal",
                                                      style: TextStyle(color: blackConst, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                                    ),
                                                    const Text(
                                                      "Chairman",
                                                      style: TextStyle(color: blackConst, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
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
                                              //color: yellowNew,
                                              gradient: const LinearGradient(
                                                colors: [navigationGradient1, navigationGradient2, navigationGradient3],
                                                stops: [0.0, 0.4, 1.0],
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                              )
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
                                          margin: EdgeInsets.fromLTRB(12, isPromotion ? 12 : 0, 12, 0),
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
                                                      style: TextStyle(color: blackConst, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                                    ),
                                                    Container(
                                                      height: 12,
                                                    ),
                                                    const Text(
                                                      "Congratulations on your promotion which is the result of your hardwork and commitment, I hope you scale new heights in the future.",
                                                      style: TextStyle(color: blackConst, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                                    ),
                                                    Container(
                                                      height: 22,
                                                    ),
                                                    const Text(
                                                      "Naveen Jindal",
                                                      style: TextStyle(color: blackConst, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                                    ),
                                                    const Text(
                                                      "Chairman",
                                                      style: TextStyle(color: blackConst, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
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
                                          height: isAnniversary ? 280 : 0,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(18),
                                              //color: orangeNew,
                                              gradient: const LinearGradient(
                                                colors: [navigationGradient1, navigationGradient2, navigationGradient3],
                                                stops: [0.0, 0.4, 1.0],
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                              )
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
                                          margin: EdgeInsets.fromLTRB(12, isAnniversary ? 12 : 0, 12, 0),
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
                                                      style: TextStyle(color: blackConst, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                                    ),
                                                    Container(
                                                      height: 12,
                                                    ),
                                                    const Text(
                                                      "Congratulations on completion of 2 successful year with JSP, I hope you will achieve new heights with same hardwork and commitment.",
                                                      style: TextStyle(color: blackConst, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
                                                    ),
                                                    Container(
                                                      height: 22,
                                                    ),
                                                    const Text(
                                                      "Naveen Jindal",
                                                      style: TextStyle(color: blackConst, fontWeight: FontWeight.w600, fontSize: 20, fontFamily: roboto),
                                                    ),
                                                    const Text(
                                                      "Chairman",
                                                      style: TextStyle(color: blackConst, fontWeight: FontWeight.w400, fontSize: 18, fontFamily: roboto),
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
                                        margin: const EdgeInsets.only(top: 12,left: 12),
                                        height: 135,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            Container(
                                              width: 100,
                                              child: Column(
                                                children: [
                                                  TouchRippleEffect(
                                                    borderRadius: BorderRadius.circular(18),
                                                    rippleColor: Colors.white60,
                                                    rippleDuration: const Duration(milliseconds: 100),
                                                    onTap: () {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutJSPLScreen()));
                                                    },
                                                    child: Container(
                                                      width: 80,
                                                      height: 80,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(color: border,width: 2),
                                                      ),
                                                      child: const Padding(
                                                        padding: EdgeInsets.all(4.0),
                                                        child: CircleAvatar(
                                                          radius: 48,
                                                          backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgyscUUTE5JRATut4NyA_H02hk4_3OiShe6w&usqp=CAU"),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Jindal Steel & Power Ltd.",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: black, fontFamily: roboto, fontSize: 12, fontWeight: FontWeight.w500),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 6,
                                            ),
                                            Container(
                                              width: 100,
                                              child: Column(
                                                children: [
                                                  TouchRippleEffect(
                                                    borderRadius: BorderRadius.circular(18),
                                                    rippleColor: Colors.white60,
                                                    rippleDuration: const Duration(milliseconds: 100),
                                                    onTap: () {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
                                                    },
                                                    child: Container(
                                                      width: 80,
                                                      height: 80,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(color: border,width: 2),
                                                      ),
                                                      child: const Padding(
                                                        padding: EdgeInsets.all(4.0),
                                                        child: CircleAvatar(
                                                          radius: 48,
                                                          backgroundImage: NetworkImage("https://res.cloudinary.com/dliifke2y/image/upload/v1669291685/Naveen%20Jindal/_SAM9274_jxcxzj.jpg"),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Shri Naveen Jindal",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: black, fontFamily: roboto, fontSize: 12, fontWeight: FontWeight.w500),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 6,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const SocialWallScreen()));
                                              },
                                              child: Container(
                                                width: 100,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: 80,
                                                      height: 80,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(color: border,width: 2),
                                                      ),
                                                      child: const Padding(
                                                        padding: EdgeInsets.all(4.0),
                                                        child: CircleAvatar(
                                                          radius: 48,
                                                          backgroundImage: NetworkImage("https://d2lptvt2jijg6f.cloudfront.net/Flag%20Foundation/page/1598931776_lapal-pin.jpg"),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "Social",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(color: black, fontFamily: roboto, fontSize: 12, fontWeight: FontWeight.w500),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 6,
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const MediaCoverageScreen()));
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 80,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: border,width: 2),
                                                    ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(4.0),
                                                      child: CircleAvatar(
                                                        radius: 48,
                                                        backgroundImage: NetworkImage("https://res.cloudinary.com/dliifke2y/image/upload/v1669291963/Naveen%20Jindal/0X4A0431-min_ospsox.jpg"),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Media Coverage",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: black, fontFamily: roboto, fontSize: 12, fontWeight: FontWeight.w500),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 6,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const MagazineListScreen()));
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 80,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: border,width: 2),
                                                    ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(4.0),
                                                      child: CircleAvatar(
                                                        radius: 48,
                                                        backgroundImage: NetworkImage("https://res.cloudinary.com/dliifke2y/image/upload/v1669291685/Naveen%20Jindal/_SAM9274_jxcxzj.jpg"),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Magazine",
                                                    style: TextStyle(color: black, fontFamily: roboto, fontSize: 12, fontWeight: FontWeight.w500),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 6,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const LeadershipScreen()));
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 80,
                                                    height: 80,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: border,width: 2),
                                                    ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(4.0),
                                                      child: CircleAvatar(
                                                        radius: 48,
                                                        backgroundImage: NetworkImage("https://indiacsr.in/wp-content/uploads/2022/11/Jindal-Steel-Power-Limited-board-members-1.jpg"),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "Our Leadership",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: black, fontFamily: roboto, fontSize: 12, fontWeight: FontWeight.w500),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 12, right: 12, top: 32),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("What's New",style: TextStyle(fontFamily: roboto, fontSize: 18, color: black, fontWeight: FontWeight.w600),),
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const WhatsNewListScreen()));
                                              },
                                              child: Row(
                                                children: [
                                                  const Text("See All",style: TextStyle(color: text_dark,fontWeight: FontWeight.w500,fontSize: 14,fontFamily: roboto),),
                                                  Container(width: 4,),
                                                  const Icon(Icons.arrow_forward_ios,color: border,size: 12,)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 22),
                                        height: 470,
                                        width: double.infinity,
                                        child: PageView.builder(
                                          controller: controllerNew,
                                          itemCount:  listWhatsNew.length > 4 ? 4 : listWhatsNew.length,
                                          pageSnapping: true,
                                          physics: const ScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: white,
                                              ),
                                              margin: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                                                        child: Image.network(listWhatsNew[index].featuredImage.toString(),
                                                          width: MediaQuery.of(context).size.width,
                                                          height: 300,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      /*Positioned(
                                                          bottom: 12,
                                                          right: 12,
                                                          child: Container(
                                                            width: 36,
                                                            height: 36,
                                                            decoration: BoxDecoration(
                                                                color: whiteConst.withOpacity(0.6),
                                                                shape: BoxShape.circle
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Image.asset("assets/images/share.png",width: 24,height: 24),
                                                            ),
                                                          )
                                                      )*/
                                                    ],
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                                    child: Text(
                                                      listWhatsNew[index].title.toString(),
                                                      style: TextStyle(
                                                          height: 1.5,
                                                          color: black,
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: gilroy,
                                                          fontSize: 18,
                                                          overflow: TextOverflow.clip),
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                                                    child: Text(listWhatsNew[index].saveTimestamp.toString(),
                                                        style: TextStyle(color: text_dark, fontFamily: roboto, fontWeight: FontWeight.w600, fontSize: 12)),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                                                    child: Text(
                                                      listWhatsNew[index].shortDescription.toString(),
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontWeight: FontWeight.w400,
                                                          fontFamily: gilroy,
                                                          fontSize: 14,
                                                          overflow: TextOverflow.clip),
                                                      maxLines: 3,
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Wrap(
                                        children: [
                                          Container(
                                            width: listWhatsNew.length > 4 ? 4 * 36 : listWhatsNew.length * 36,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only( left: 14, right: 14, top: 12),
                                            decoration: const BoxDecoration(color: text_dark),
                                            child: SmoothPageIndicator(
                                              controller: controllerNew,
                                              count:  listWhatsNew.length > 4 ? 4 : listWhatsNew.length,
                                              effect: const SlideEffect(
                                                  spacing: 2.0,
                                                  radius: 0.0,
                                                  dotWidth: 36.0,
                                                  dotHeight: 2.5,
                                                  paintStyle: PaintingStyle.stroke,
                                                  strokeWidth: 0,
                                                  dotColor: Colors.transparent,
                                                  activeDotColor: orangeNew),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.only(top: 32),
                                        padding: const EdgeInsets.fromLTRB(12, 22, 12, 0),
                                        height: 240,
                                        color: white,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Quick Links",style: TextStyle(fontFamily: roboto, fontSize: 18, color: black, fontWeight: FontWeight.w600),),
                                            Container(height: 12),
                                            Wrap(
                                              spacing: 6.0,
                                              runSpacing: 6.0,
                                              children: <Widget>[
                                                _buildChip('Foundation'),
                                                _buildChip('Magazine'),
                                                _buildChip('Jindal Panther'),
                                                _buildChip('News'),
                                                _buildChip('Education'),
                                                _buildChip('Media'),
                                                _buildChip('Investment'),
                                                _buildChip('Safety'),
                                                _buildChip('Blogs'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                          visible: listSocial.isNotEmpty,
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            margin: const EdgeInsets.only(left: 14, right: 14, top: 32),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: 'Social Media',
                                                          style: TextStyle(fontFamily: roboto, fontSize: 18, color: black, fontWeight: FontWeight.w600)),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SocialWallScreen()));
                                                  },
                                                  child: Row(
                                                    children: [
                                                      const Text("See All",style: TextStyle(color: text_dark,fontWeight: FontWeight.w500,fontSize: 14,fontFamily: roboto),),
                                                      Container(width: 4,),
                                                      const Icon(Icons.arrow_forward_ios,color: border,size: 12,)
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                      Visibility(
                                          visible: listSocial.isNotEmpty,
                                          child: Container(
                                              margin: const EdgeInsets.only(left: 12,top: 22),
                                              height: 455,
                                              child: PageView.builder(
                                                controller: controllerSocial,
                                                itemCount: listSocial.length,
                                                physics: const ScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: (){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => CommonDetailsScreen(listSocial[index].id.toString(),listSocial[index].postTypeId.toString())));
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        color: white,
                                                      ),
                                                      margin: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Stack(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                                                                child: Image.network(listSocial[index].featuredImage.toString(),
                                                                  width: MediaQuery.of(context).size.width,
                                                                  height: 300,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                              /*Positioned(
                                                                  bottom: 22,
                                                                  right: 12,
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        width: 36,
                                                                        height: 36,
                                                                        decoration: BoxDecoration(
                                                                            color: whiteConst.withOpacity(0.6),
                                                                            shape: BoxShape.circle
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Image.asset("assets/images/share.png",width: 24,height: 24),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                              )*/
                                                            ],
                                                          ),
                                                          Container(
                                                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                                            child: Row(
                                                              children: [
                                                                Image.asset("assets/images/ic_instagram_new.png",width: 28,height: 28),
                                                                Container(width: 8,),
                                                                Text(
                                                                  listSocial[index].title.toString(),
                                                                  style: TextStyle(
                                                                      height: 1.5,
                                                                      color: black,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontFamily: gilroy,
                                                                      fontSize: 18,
                                                                      overflow: TextOverflow.clip),
                                                                  maxLines: 3,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                                                            child: Text(listSocial[index].saveTimestamp.toString(),
                                                                style: const TextStyle(color: text_dark, fontFamily: roboto, fontWeight: FontWeight.w600, fontSize: 12)),
                                                          ),
                                                          Container(
                                                            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                                                            child:  Text(
                                                              "On #VijayDiwas we salute the brave hearts of the Indian Armed Forces who led India to victory in the 1971 war. #JaiHind #JindalStee",
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  height: 1.5,
                                                                  color: black,
                                                                  fontWeight: FontWeight.w400,
                                                                  fontFamily: gilroy,
                                                                  fontSize: 14,
                                                                  overflow: TextOverflow.clip),
                                                              maxLines: 3,
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ))),
                                      Visibility(
                                          visible: listSocial.length > 1,
                                          child: Wrap(
                                            children: [
                                              Container(
                                                width: listSocial.length * 36,
                                                alignment: Alignment.center,
                                                margin: const EdgeInsets.only(bottom: 10, left: 14, right: 14, top: 12),
                                                decoration: const BoxDecoration(color: text_dark),
                                                child: SmoothPageIndicator(
                                                  controller: controllerSocial,
                                                  count: listSocial.length,
                                                  effect: const SlideEffect(
                                                      spacing: 2.0,
                                                      radius: 0.0,
                                                      dotWidth: 36.0,
                                                      dotHeight: 2.5,
                                                      paintStyle: PaintingStyle.stroke,
                                                      strokeWidth: 0,
                                                      dotColor: Colors.transparent,
                                                      activeDotColor: orangeNew),
                                                ),
                                              ),
                                            ],
                                          )),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        margin: const EdgeInsets.only(left: 14, right: 14, top: 32),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: 'Leadership',
                                                      style: TextStyle(fontFamily: roboto, fontSize: 18, color: black, fontWeight: FontWeight.w600)),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const LeadershipScreen()));
                                              },
                                              child: Row(
                                                children: [
                                                  const Text("See All",style: TextStyle(color: text_dark,fontWeight: FontWeight.w500,fontSize: 14,fontFamily: roboto),),
                                                  Container(width: 4,),
                                                  const Icon(Icons.arrow_forward_ios,color: border,size: 12,)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 220,
                                        margin: const EdgeInsets.only(left: 12,top: 22),
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          physics: const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: listLeadership.length,
                                          itemBuilder: (context, index) {
                                            return AnimationConfiguration.staggeredList(
                                              position: index,
                                              duration: const Duration(milliseconds: 375),
                                              child: SlideAnimation(
                                                verticalOffset: 50.0,
                                                child: FadeInAnimation(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => CommonDetailsScreen(listLeadership[index].id.toString(),listLeadership[index].postTypeId.toString())));
                                                    },
                                                    child: Container(
                                                        height: 220,
                                                        width: 140,
                                                        margin: const EdgeInsets.only(right: 12),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(6)
                                                        ),
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(6),
                                                              child: Image.network(
                                                                listLeadership[index].featuredImage.toString(),
                                                                width: 140,
                                                                height: 220,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                            Positioned(
                                                                bottom: 0,
                                                                child: Container(
                                                                    width: 140,
                                                                    padding: const EdgeInsets.only(top: 4,bottom: 4),
                                                                    alignment: Alignment.center,
                                                                    color: black.withOpacity(0.7),
                                                                    child: Text(listLeadership[index].title.toString(),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,fontFamily: roboto,color: white),overflow: TextOverflow.ellipsis,))
                                                            )
                                                          ],
                                                        )
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      Container(
                                        alignment: Alignment.centerLeft,
                                        margin: const EdgeInsets.only(left: 14, right: 14, top: 32),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: 'Events & Engagement',
                                                      style: TextStyle(fontFamily: roboto, fontSize: 18, color: black, fontWeight: FontWeight.w600)),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const EventListScreen()));
                                              },
                                              child: Row(
                                                children: [
                                                  const Text("See All",style: TextStyle(color: text_dark,fontWeight: FontWeight.w500,fontSize: 14,fontFamily: roboto),),
                                                  Container(width: 4,),
                                                  const Icon(Icons.arrow_forward_ios,color: border,size: 12,)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(left: 12,top: 22),
                                          height: 290,
                                          child: PageView.builder(
                                            itemCount: listEvents.length,
                                            physics: const ScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CommonDetailsScreen(listEvents[index].id.toString(),listEvents[index].postTypeId.toString())));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: white,
                                                  ),
                                                  margin: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(20),
                                                            child: Image.network(listEvents[index].featuredImage.toString(),
                                                              width: MediaQuery.of(context).size.width,
                                                              height: 180,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          /*Positioned(
                                                              bottom: 22,
                                                              right: 12,
                                                              child: Row(
                                                                children: [

                                                                  Container(
                                                                    width: 36,
                                                                    height: 36,
                                                                    decoration: BoxDecoration(
                                                                        color: whiteConst.withOpacity(0.6),
                                                                        shape: BoxShape.circle
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Image.asset("assets/images/share.png",width: 24,height: 24),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                          )*/
                                                        ],
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                                                        child:  Text(
                                                          listEvents[index].title.toString(),
                                                          style: TextStyle(
                                                              height: 1.5,
                                                              color: black,
                                                              fontWeight: FontWeight.w600,
                                                              fontFamily: gilroy,
                                                              fontSize: 18,
                                                              overflow: TextOverflow.ellipsis),
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              listEvents[index].location.toString(),
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(fontSize: 12, fontFamily: roboto, fontWeight: FontWeight.w400, color: black,
                                                                overflow: TextOverflow.ellipsis,),
                                                            ),
                                                            listEvents[index].location.toString().isNotEmpty ? Container(
                                                              width: 12,
                                                            ) : Container(),
                                                            listEvents[index].location.toString().isNotEmpty ? Image.asset(
                                                              "assets/images/ic_placeholder.png",
                                                              width: 4,
                                                              height: 4,
                                                              color: black,
                                                            ) : Container(),
                                                            listEvents[index].location.toString().isNotEmpty ?  Container(
                                                              width: 12,
                                                            ) : Container(),
                                                            Text(
                                                              listEvents[index].saveTimestamp.toString(),
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(fontSize: 12, fontFamily: roboto, fontWeight: FontWeight.w400, color: black,
                                                                overflow: TextOverflow.ellipsis,),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          )),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        margin: const EdgeInsets.only(left: 14, right: 14, top: 32),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: 'Photos',
                                                      style: TextStyle(fontFamily: roboto, fontSize: 18, color: black, fontWeight: FontWeight.w600)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 250,
                                        width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.only(left: 12,right: 12,top: 22),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: white,
                                        ),
                                        child: Stack(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: ClipRRect(
                                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20) ),
                                                      child: Image.network(
                                                        "https://res.cloudinary.com/dliifke2y/image/upload/v1669291684/Naveen%20Jindal/_SAM9259_ydo7fg.jpg",
                                                        fit: BoxFit.cover,
                                                        height: 250,
                                                      ),
                                                    )
                                                ),
                                                Container(
                                                  width: 100,
                                                  margin: const EdgeInsets.only(left: 2),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: ClipRRect(
                                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(20)),
                                                          child: Image.network("https://res.cloudinary.com/dliifke2y/image/upload/v1669291684/Naveen%20Jindal/_SAM9144_kqf6wa.jpg",
                                                            fit: BoxFit.cover,),
                                                        ),
                                                      ),
                                                      Container(height: 2,),
                                                      Expanded(
                                                        child: ClipRRect(
                                                          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
                                                          child: Image.network("https://res.cloudinary.com/dliifke2y/image/upload/v1669291963/Naveen%20Jindal/0X4A0431-min_ospsox.jpg",
                                                            fit: BoxFit.cover,),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Positioned(
                                                bottom: 12,
                                                right: 12,
                                                child: GestureDetector(
                                                  onTap: (){
                                                    final BottomNavigationBar bar = bottomWidgetKey.currentWidget as BottomNavigationBar;
                                                    bar.onTap!(1);
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                    decoration: BoxDecoration(
                                                        color: border.withOpacity(0.8)
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: const [
                                                        Text("View All",style: TextStyle(color: whiteConst,fontFamily: roboto,fontSize: 14,fontWeight: FontWeight.w500),),
                                                        Icon(Icons.arrow_forward_ios,color: whiteConst,size: 14,)
                                                      ],
                                                    ),
                                                  ),
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        margin: const EdgeInsets.only(left: 14, right: 14, top: 32),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: 'News',
                                                      style: TextStyle(fontFamily: roboto, fontSize: 18, color: black, fontWeight: FontWeight.w600)),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsListScreen()));
                                              },
                                              child: Row(
                                                children: [
                                                  const Text("See All",style: TextStyle(color: text_dark,fontWeight: FontWeight.w500,fontSize: 14,fontFamily: roboto),),
                                                  Container(width: 4,),
                                                  const Icon(Icons.arrow_forward_ios,color: border,size: 12,)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(left: 12,top: 22),
                                          height: 320,
                                          child: PageView.builder(
                                            itemCount: listNews.length,
                                            physics: const ScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CommonDetailsScreen(listNews[index].id.toString(),listNews[index].postTypeId.toString())));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: white,
                                                  ),
                                                  margin: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(20),
                                                            child: Image.network(listNews[index].featuredImage.toString(),
                                                              width: MediaQuery.of(context).size.width,
                                                              height: 180,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          /*Positioned(
                                                              bottom: 22,
                                                              right: 12,
                                                              child: Row(
                                                                children: [

                                                                  Container(
                                                                    width: 36,
                                                                    height: 36,
                                                                    decoration: BoxDecoration(
                                                                        color: whiteConst.withOpacity(0.6),
                                                                        shape: BoxShape.circle
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Image.asset("assets/images/share.png",width: 24,height: 24),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                          )*/
                                                        ],
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets.only(top: 22,left: 12,),
                                                        child: Image.asset("assets/images/ic_et_logo.png",width: 140,color: black),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                                                        child:  Text(
                                                          listNews[index].title.toString(),
                                                          style: TextStyle(
                                                              height: 1.5,
                                                              color: black,
                                                              fontWeight: FontWeight.w600,
                                                              fontFamily: gilroy,
                                                              fontSize: 18,
                                                              overflow: TextOverflow.ellipsis),
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              listNews[index].saveTimestamp.toString(),
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(fontSize: 12, fontFamily: roboto, fontWeight: FontWeight.w400, color: black,
                                                                overflow: TextOverflow.ellipsis,),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                      ),

                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SuggestionFormScreen()));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.fromLTRB(12, 22, 12, 0),
                                          padding: const EdgeInsets.fromLTRB(12, 18, 12, 18),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: border
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: const [
                                              Text("Share your suggestions with us",style: TextStyle(color: whiteConst,fontWeight: FontWeight.w600,fontSize: 16,fontFamily: roboto),),
                                              Icon(Icons.arrow_forward_ios,color: whiteConst,size: 12,)
                                            ],
                                          ),
                                        ),
                                      ),

                                      Container(
                                        alignment: Alignment.centerLeft,
                                        margin: const EdgeInsets.only(left: 14, right: 14, top: 32),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: 'Videos',
                                                      style: TextStyle(fontFamily: roboto, fontSize: 18, color: black, fontWeight: FontWeight.w600)),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                final BottomNavigationBar bar = bottomWidgetKey.currentWidget as BottomNavigationBar;
                                                bar.onTap!(2);
                                              },
                                              child: Row(
                                                children: [
                                                  const Text("See All",style: TextStyle(color: text_dark,fontWeight: FontWeight.w500,fontSize: 14,fontFamily: roboto),),
                                                  Container(width: 4,),
                                                  const Icon(Icons.arrow_forward_ios,color: border,size: 12,)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 350,
                                        margin: const EdgeInsets.only(left: 12,right: 12,top: 22),
                                        child: GridView.builder(
                                          itemCount: 4,
                                          physics: const NeverScrollableScrollPhysics(),
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisExtent: 170,
                                              crossAxisSpacing: 12,
                                              mainAxisSpacing: 12
                                          ),
                                          itemBuilder: (BuildContext context, int index) {
                                            return GestureDetector(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => CommonDetailsScreen(listVideos[index].id.toString(),listVideos[index].postTypeId.toString())));
                                              },
                                              child: Stack(
                                                children: [
                                                  SizedBox(
                                                    height: 170,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: Image.network(listVideos[index].featuredImage.toString(),fit: BoxFit.cover,),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      bottom: 12,
                                                      right: 12,
                                                      child: Image.asset("assets/images/play.png",height: 36,width: 36,))
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      const Gap(20)
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
                ],
              ),
            ),
      ),
    );
  }

  @override
  void castStatefulWidget() {
    widget as TrendingScreen;
  }

  Widget _buildChip(String label) {
    return Chip(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      labelPadding: const EdgeInsets.all(2.0),
      label: Text(
        label,
        style: const TextStyle(
            color: border,
            fontFamily: roboto,
            fontSize: 12,
            fontWeight: FontWeight.w500
        ),
      ),
      backgroundColor: lightGrayNew,
      elevation: 0,
      shadowColor: lightGrayNew,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
    );
  }

  getDashBoardData([bool isPull = false]) async {
    if (!isPull) {
      setState(() {
        _isLoading = true;
      });
    }

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + dashboardData);

    print("<><> TOKEN : " + sessionManager.getAccessToken().toString().trim() + " <><>");

    Map<String, String> jsonBody = {'from_app': FROM_APP, 'user_id': sessionManager.getUserId().toString()};

    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = DashBoardDataResponse.fromJson(apiResponse);
    if (statusCode == 200 && dataResponse.success == 1) {
      listSocial = List<Posts>.empty(growable: true);
      listVideos = List<Posts>.empty(growable: true);
      listEvents = List<Posts>.empty(growable: true);
      listNews = List<Posts>.empty(growable: true);
      listLeadership = List<Posts>.empty(growable: true);
      listImages = List<Posts>.empty(growable: true);
      if (dataResponse.postsList != null && dataResponse.postsList!.isNotEmpty) {
        for (int i = 0; i < dataResponse.postsList!.length; i++) {
          if (dataResponse.postsList![i].id == "1") // "Social Media"
              {
            if (dataResponse.postsList![i].posts != null) {
              if (dataResponse.postsList![i].posts!.isNotEmpty) {
                listSocial.addAll(dataResponse.postsList![i].posts!);
              }
            }
          }
          else if (dataResponse.postsList![i].id == "2") // "Events & Enagagements"
              {
            if (dataResponse.postsList![i].posts != null) {
              if (dataResponse.postsList![i].posts!.isNotEmpty) {
                listEvents.addAll(dataResponse.postsList![i].posts!);
              }
            }
          }
          else if (dataResponse.postsList![i].id == "3") // "Videos"
              {
            if (dataResponse.postsList![i].posts != null) {
              if (dataResponse.postsList![i].posts!.isNotEmpty) {
                listVideos.addAll(dataResponse.postsList![i].posts!);
              }
            }
          }
          else if (dataResponse.postsList![i].id == "4") // "News"
              {
            if (dataResponse.postsList![i].posts != null) {
              if (dataResponse.postsList![i].posts!.isNotEmpty) {
                listNews.addAll(dataResponse.postsList![i].posts!);
              }
            }
          }
          else if (dataResponse.postsList![i].id == "5") // "Images"
              {
            if (dataResponse.postsList![i].posts != null) {
              if (dataResponse.postsList![i].posts!.isNotEmpty) {
                listImages.addAll(dataResponse.postsList![i].posts!);
              }
            }
          }
          else if (dataResponse.postsList![i].id == "10") // "Leadership"
              {
            if (dataResponse.postsList![i].posts != null) {
              if (dataResponse.postsList![i].posts!.isNotEmpty) {
                listLeadership.addAll(dataResponse.postsList![i].posts!);
              }
            }
          }
        }
        listLeadership = listLeadership.reversed.toList();

      }
    } else {
      showSnackBar(dataResponse.message, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  getWhatsNew() async {
    setState(() {
      _isLoading = true;
    });

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + posts);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'user_id': sessionManager.getUserId().toString(),
      'limit': "10",
      'page': "0",
      'is_new': "1"
    };
    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});
    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = PostListResponse.fromJson(apiResponse);
    if (statusCode == 200 && dataResponse.success == 1) {
      if (dataResponse.posts != null && dataResponse.posts!.isNotEmpty) {
        listWhatsNew.addAll(dataResponse.posts!);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      showSnackBar(dataResponse.message, context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  unReadNotificationCount() async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + unreadNotification);
    Map<String, String> jsonBody = {'from_app': FROM_APP, 'user_id': sessionManager.getUserId().toString()};
    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});
    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = NotificationCountResponse.fromJson(apiResponse);
    if (statusCode == 200 && dataResponse.success == 1)
    {
        if(dataResponse.totalUnread !=null)
        {
          if(dataResponse.totalUnread.toString().isNotEmpty)
          {
             sessionManager.setUnreadNotificationCount(int.parse(dataResponse.totalUnread.toString()));
          }
          else
          {
            sessionManager.setUnreadNotificationCount(0);
          }
        }
        else
        {
          sessionManager.setUnreadNotificationCount(0);
        }
    } else {
      showSnackBar(dataResponse.message, context);
      sessionManager.setUnreadNotificationCount(0);
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
    colors: <Color>[Color(0xff000000), Color(0xffaaa9a3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 800.0, 80.0));

  final Shader linearGradientSocial = const LinearGradient(
    colors: <Color>[Color(0xffFFFFFF), Color(0xff9b9b98)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 800.0, 80.0));
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
