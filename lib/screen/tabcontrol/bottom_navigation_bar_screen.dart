import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jspl_connect/model/CommanResponse.dart';
import 'package:jspl_connect/utils/base_class.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../../constant/api_end_point.dart';
import '../../constant/colors.dart';
import '../../utils/app_utils.dart';
import '../../widget/FadeIndexedStack.dart';
import '../AlbumScreen.dart';
import '../BlogScreen.dart';
import '../VideoScreen.dart';
import 'TrendingScreen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  final int passIndex;
  const BottomNavigationBarScreen(this.passIndex, {Key? key}) : super(key: key);
  @override
  _BottomNavigationBarScreenState createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends BaseState<BottomNavigationBarScreen> {
  late List<Widget> _pages;
  late Widget _page1;
  late Widget _page2;
  late Widget _page3;
  late Widget _page4;
  late int _currentIndex = 0;
  DateTime preBackPressTime = DateTime.now();
  late int currentPage;
  late TabController tabController;


  @override
  void initState() {
    super.initState();
    getDeviceToken();
    _page1 = const TrendingScreen();
    _page2 = const AlbumScreen();
    _page3 = const VideoScreen();
    _page4 = const BlogScreen();
    _pages = [_page1, _page2, _page3, _page4,_page4];
    _currentIndex = (widget as BottomNavigationBarScreen).passIndex;
  }

  Future<void> getDeviceToken() async {
    var fcmToken = await FirebaseMessaging.instance.getToken();
    sessionManager.setDeviceToken(fcmToken.toString());
    print("*************** $fcmToken");

      if(sessionManager.getDeviceToken().toString().trim().isNotEmpty)
      {
        updateDeviceTokenData();
      }
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  void _onItemTapped(int value) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if(value == 0 && isHomeReload) {
      setState(() {
        _pages.removeAt(0);
        _pages.insert(0, TrendingScreen(key: UniqueKey()));
      });

    }else if(value == 1 && isGalleryReload) {
      setState(() {
        _pages.removeAt(1);
        _pages.insert(1, AlbumScreen(key: UniqueKey()));
      });

    }else if(value == 2 && isVideoReload){
      setState(() {
        _pages.removeAt(2);
        _pages.insert(2, VideoScreen(key: UniqueKey()));
      });
    }
    else if(value == 3 && isBlogReload) {
      setState(() {
        _pages.removeAt(3);
        _pages.insert(3, BlogScreen(key: UniqueKey()));
      });

    }
    setState(() {
       _currentIndex = value;
    });
  }

  updateDeviceTokenData() async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + updateDeviceToken);

    var deviceType = "";
    if (Platform.isIOS)
    {
      deviceType = "ios";
    }
    else
    {
      deviceType = "android";
    }

    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'user_id' : sessionManager.getUserId().toString(),
      'device_type': deviceType,
      'device_id': sessionManager.getDeviceToken().toString().trim(),
      'token_id':  sessionManager.getDeviceToken().toString().trim()};

    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = CommanResponse.fromJson(apiResponse);
    if (statusCode == 200 && dataResponse.status == 1) {
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_currentIndex != 0)
        {
          setState(() {
            _currentIndex = 0;
          });
          return Future.value(false);
        }
        else
        {
          final timeGap = DateTime.now().difference(preBackPressTime);
          final cantExit = timeGap >= const Duration(seconds: 2);
          preBackPressTime = DateTime.now();
          if (cantExit)
          {
            showSnackBar('Press back button again to exit', context);
            return Future.value(false);
          }
          else
          {
            SystemNavigator.pop();
            return Future.value(true);
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: black,
        extendBody: true,
        body: FadeIndexedStack(
          _currentIndex,_pages ,const Duration(
          milliseconds: 400,
        )
        ),
        bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: lightblack,
              borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30),),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: BottomNavigationBar(
                key: bottomWidgetKey,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage("assets/images/trending.png")),
                    label: 'Trending',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage("assets/images/news.png")),
                    label: 'Gallery',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage("assets/images/media.png")),
                    label: 'Video',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage("assets/images/podcast.png")),
                    label: 'Blog',
                  ),
                ],
                selectedLabelStyle: const TextStyle(color: white,fontSize: 12,fontFamily: roboto,fontWeight: FontWeight.w400),
                unselectedLabelStyle: const TextStyle(color: white,fontSize: 12,fontFamily: roboto,fontWeight: FontWeight.w400),
                backgroundColor: darkblack,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: orangeNew,
                unselectedItemColor: white,
                currentIndex: _currentIndex,
                onTap: _onItemTapped,
              ),
            ),
          ),
      ),
    );
  }

  @override
  void castStatefulWidget() {
    widget is BottomNavigationBarScreen;
  }
}
