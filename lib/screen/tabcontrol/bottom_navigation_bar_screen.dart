import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jspl_connect/model/CommanResponse.dart';
import 'package:jspl_connect/model/DashBoardDataResponse.dart';
import 'package:jspl_connect/screen/tabcontrol/DashboardNewScreen.dart';
import 'package:jspl_connect/utils/base_class.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:slide_indexed_stack/slide_indexed_stack.dart';
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

  final GlobalKey<_BottomNavigationBarScreenState> myWidgetState = GlobalKey<_BottomNavigationBarScreenState>();

  @override
  void initState() {
    super.initState();
    getDeviceToken();
    _page1 = TrendingScreen(key : myWidgetState);
    //_page1 = DashboardNewScreen();
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
   // HapticFeedback.vibrate();
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if(value == 0 && isHomeReload) {
      setState(() {
        _pages.removeAt(0);
        _pages.insert(0, TrendingScreen(key: myWidgetState));
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
        backgroundColor: screenBg,
        extendBody: true,
        body: SlideIndexedStack(
            axis: Axis.horizontal,
            slideOffset: 0.9,
            index: _currentIndex,
            duration: const Duration(milliseconds: 80),
          children: _pages,
        ),
        bottomNavigationBar: Material(
          elevation: 6,
          child: Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30),),
              ),
              child: BottomNavigationBar(
                elevation: 0,
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
                iconSize: 28,
                selectedItemColor: black,
                selectedLabelStyle: TextStyle(color: black,fontSize: 12,fontFamily: roboto,fontWeight: FontWeight.w500),
                unselectedLabelStyle: TextStyle(color: text_dark,fontSize: 12,fontFamily: roboto,fontWeight: FontWeight.w500),
                backgroundColor: bottombar,
                unselectedItemColor: text_dark,
                selectedIconTheme: const IconThemeData(
                  color: orangeNew,
                ),
                unselectedIconTheme: const IconThemeData(
                  color: text_dark,
                ),
                type: BottomNavigationBarType.fixed,
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
