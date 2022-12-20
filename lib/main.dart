import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jspl_connect/constant/colors.dart';
import 'package:jspl_connect/push_notification/PushNotificationService.dart';
import 'package:jspl_connect/screen/BlogDetailsScreen.dart';
import 'package:jspl_connect/screen/CommonDetailsScreen.dart';
import 'package:jspl_connect/screen/EventDetailsScreen.dart';
import 'package:jspl_connect/screen/LeadershipDetailsScreen.dart';
import 'package:jspl_connect/screen/LoginScreen.dart';
import 'package:jspl_connect/screen/MagazineListScreen.dart';
import 'package:jspl_connect/screen/MediaCoverageDetailsScreen.dart';
import 'package:jspl_connect/screen/NewsDetailsScreen.dart';
import 'package:jspl_connect/screen/SocialWallScreen.dart';
import 'package:jspl_connect/screen/VideoDetailsPage.dart';
import 'package:jspl_connect/screen/tabcontrol/bottom_navigation_bar_screen.dart';
import 'package:jspl_connect/utils/app_utils.dart';
import 'package:jspl_connect/utils/session_manager_methods.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'constant/api_end_point.dart';
import 'constant/global_context.dart';
import 'model/DashBoardDataResponse.dart';
import 'utils/session_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionManagerMethods.init();
  await PushNotificationService().setupInteractedMessage();
  runApp(const MyApp());
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print("@@@@@@@@ Main Dart @@@@@@@@ ${initialMessage.data}");
    NavigationService.notif_type = initialMessage.data['content_id'];
    NavigationService.notif_post_id = initialMessage.data['post_id'];
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSP Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: createMaterialColor(black),
      ),
      darkTheme: SessionManager().getDarkMode() ?? false ? ThemeData.dark() : ThemeData.light(),
      home: const MyHomePage(),
        navigatorKey: NavigationService.navigatorKey
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoggedIn = false ;
  SessionManager sessionManager = SessionManager();
  DashBoardDataResponse _dataResponse = DashBoardDataResponse();

  @override
  void initState() {
    super.initState();
    doSomeAsyncStuff();
  }

  Future<void> doSomeAsyncStuff() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      SessionManager sessionManager = SessionManager();
      isLoggedIn = sessionManager.checkIsLoggedIn() ?? false;

        if(isLoggedIn)
        {
          print("<><> NOTIF TYPE :" + NavigationService.notif_type + " <><>");
          if(NavigationService.notif_post_id != null)
          {
            if(NavigationService.notif_post_id.toString().isNotEmpty)
            {
              if(NavigationService.notif_type == "1")
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SocialWallScreen()));
              }
              else if(NavigationService.notif_type == "2" || NavigationService.notif_type == "3" ||NavigationService.notif_type == "4" || NavigationService.notif_type == "6" || NavigationService.notif_type == "8" || NavigationService.notif_type == "10" )
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CommonDetailsScreen(NavigationService.notif_post_id.toString(),(NavigationService.notif_type.toString()))));
              }
              else if(NavigationService.notif_type == "5")
              {
                Timer(
                    const Duration(seconds: 3),
                        () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    const BottomNavigationBarScreen(1)), (Route<dynamic> route) => false));
                NavigationService.notif_type = "";
                NavigationService.notif_post_id = "";
              }
              else if(NavigationService.notif_type == "7")
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MagazineListScreen()));
              }


            }
            else
            {
              Timer(
                  const Duration(seconds: 3),
                      () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  const BottomNavigationBarScreen(0)), (Route<dynamic> route) => false));
            }
          }
          else
          {
            Timer(
                const Duration(seconds: 3),
                    () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                const BottomNavigationBarScreen(0)), (Route<dynamic> route) => false));
          }
        }
      else
        {
          Timer(
              const Duration(seconds: 3), () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false));
        }

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
      statusBarColor: screenBg,
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness: Brightness.dark,
    ));
    return Container(
      color: white,
      height: MediaQuery.of(context).size.height,
      child: Image.asset('assets/images/jspl.jpg',fit: BoxFit.cover),
    );
  }

  getDashboradData() async {
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
      _dataResponse = dataResponse;
    } else {
      showSnackBar(dataResponse.message, context);
    }
    setState(() {
    });
  }
}
