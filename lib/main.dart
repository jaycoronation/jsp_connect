import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jspl_connect/constant/colors.dart';
import 'package:jspl_connect/push_notification/PushNotificationService.dart';
import 'package:jspl_connect/screen/BlogDetailsScreen.dart';
import 'package:jspl_connect/screen/EventDetailsScreen.dart';
import 'package:jspl_connect/screen/LoginScreen.dart';
import 'package:jspl_connect/screen/MagazineListScreen.dart';
import 'package:jspl_connect/screen/MediaCoverageDetailsScreen.dart';
import 'package:jspl_connect/screen/NewsDetailsScreen.dart';
import 'package:jspl_connect/screen/VideoDetailsPage.dart';
import 'package:jspl_connect/screen/tabcontrol/bottom_navigation_bar_screen.dart';
import 'package:jspl_connect/utils/app_utils.dart';
import 'package:jspl_connect/utils/session_manager_methods.dart';
import 'constant/global_context.dart';
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
              if(NavigationService.notif_type == "2")
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen(NavigationService.notif_post_id.toString())));
              }
              else if(NavigationService.notif_type == "3")
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => VideoDetailsPage(NavigationService.notif_post_id.toString())));
              }
              else if(NavigationService.notif_type == "4")
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailsScreen(NavigationService.notif_post_id.toString())));
              }
              else if(NavigationService.notif_type == "5")
              {
                // for image
              }
              else if(NavigationService.notif_type == "6")
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BlogDetailsScreen(NavigationService.notif_post_id.toString())));
              }
              else if(NavigationService.notif_type == "7")
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MagazineListScreen()));
              }
              else if(NavigationService.notif_type == "8")
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MediaCoverageDetailsScreen(NavigationService.notif_post_id.toString())));
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
              const Duration(seconds: 3),
                  () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false));
        }

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light, // For Android (dark icons)
      statusBarBrightness: Brightness.light,
    ));
    return Container(
      color: white,
      height: MediaQuery.of(context).size.height,
      child: Image.asset('assets/images/jspl.jpg',fit: BoxFit.cover),
    );
  }
}
