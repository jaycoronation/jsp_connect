import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jspl_connect/constant/colors.dart';
import 'package:jspl_connect/push_notification/PushNotificationService.dart';
import 'package:jspl_connect/screen/CommonDetailsScreen.dart';
import 'package:jspl_connect/screen/LoginScreen.dart';
import 'package:jspl_connect/screen/MagazineListScreen.dart';
import 'package:jspl_connect/screen/SocialWallScreen.dart';
import 'package:jspl_connect/screen/tabcontrol/bottom_navigation_bar_screen.dart';
import 'package:jspl_connect/utils/app_utils.dart';
import 'package:jspl_connect/utils/session_manager_methods.dart';
import 'constant/global_context.dart';
import 'utils/session_manager.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //print("Handling a background message: ${message.data.toString()}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    if(kIsWeb)
    {
      await Firebase.initializeApp(
        // Replace with actual values
        options: const FirebaseOptions(
          apiKey: "AIzaSyA2GIssNLcetXVngOSsM_skQtHeB2SPn1c",
          appId: "1:1074098588756:web:b20e714cfdb5e29444b1c1",
          messagingSenderId: "1074098588756",
          projectId: "jspl-connect",
        ),
      );
    }
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1000 << 40; // for increase the cache memory
  await SessionManagerMethods.init();
  await PushNotificationService().setupInteractedMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
   // print("@@@@@@@@ Main Dart @@@@@@@@ ${initialMessage.data}");
    NavigationService.notif_type = initialMessage.data['content_id'];
    NavigationService.notif_post_id = initialMessage.data['post_id'];
  }
  runApp(const MyApp());
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
          primarySwatch: createMaterialColor(white),
          platform: TargetPlatform.iOS,
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
      //print("<><> NOTIF TYPE :" + NavigationService.notif_type + " <><>");
      //print("<><> NOTIF TYPE POST :" + NavigationService.notif_post_id + " <><>");
      if(isLoggedIn)
      {
        if(NavigationService.notif_type == "400")
        {
          SessionManagerMethods.clear();
          Timer(
              const Duration(seconds: 3), () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false));
        }

        if(NavigationService.notif_post_id != null)
        {
          if(NavigationService.notif_post_id.toString().isNotEmpty)
          {
            if(NavigationService.notif_type == "1")
            {
              Timer(
                  const Duration(seconds: 3),
                      () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  const SocialWallScreen()), (Route<dynamic> route) => false));
            }
            else if(NavigationService.notif_type == "2" ||
                NavigationService.notif_type == "3" ||
                NavigationService.notif_type == "4" ||
                NavigationService.notif_type == "6" ||
                NavigationService.notif_type == "8" ||
                NavigationService.notif_type == "10" )
            {
              Timer(
                  const Duration(seconds: 3),
                      () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => CommonDetailsScreen(NavigationService.notif_post_id.toString(),NavigationService.notif_type.toString())), (Route<dynamic> route) => false));
            }
            else if(NavigationService.notif_type == "5")
            {
              Timer(
                  const Duration(seconds: 3),
                      () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  const BottomNavigationBarScreen(1)), (Route<dynamic> route) => false));
            }
            else if(NavigationService.notif_type == "7")
            {
              Timer(
                  const Duration(seconds: 3),
                      () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  const MagazineListScreen()), (Route<dynamic> route) => false));
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: screenBg,
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.transparent,
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.light,
          // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset('assets/images/jspl.jpg',
            fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width),
      ),
    );
  }
}
