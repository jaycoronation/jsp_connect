import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../constant/api_end_point.dart';
import '../constant/global_context.dart';
import '../model/NotificationCountResponse.dart';
import '../screen/CommonDetailsScreen.dart';
import '../screen/LoginScreen.dart';
import '../screen/MagazineListScreen.dart';
import '../screen/SocialWallScreen.dart';
import '../screen/tabcontrol/bottom_navigation_bar_screen.dart';
import '../utils/app_utils.dart';
import '../utils/session_manager.dart';
import 'package:http/http.dart' as http;

import '../utils/session_manager_methods.dart';

// ignore: slash_for_doc_comments
/**
 * Documents added by Alaa, enjoy ^-^:
 * There are 3 major things to consider when dealing with push notification :
 * - Creating the notification
 * - Hanldle notification click
 * - App status (foreground/background and killed(Terminated))
 *
 * Creating the notification:
 *
 * - When the app is killed or in background state, creating the notification is handled through the back-end services.
 *   When the app is in the foreground, we have full control of the notification. so in this case we build the notification from scratch.
 *
 * Handle notification click:
 *
 * - When the app is killed, there is a function called getInitialMessage which
 *   returns the remoteMessage in case we receive a notification otherwise returns null.
 *   It can be called at any point of the application (Preferred to be after defining GetMaterialApp so that we can go to any screen without getting any errors)
 * - When the app is in the background, there is a function called onMessageOpenedApp which is called when user clicks on the notification.
 *   It returns the remoteMessage.
 * - When the app is in the foreground, there is a function flutterLocalNotificationsPlugin, is passes a future function called onSelectNotification which
 *   is called when user clicks on the notification.
 *
 * */
class PushNotificationService {
  Future<void> setupInteractedMessage() async {
    await Firebase.initializeApp();
    // Get any messages which caused the application to open from a terminated state.
    // If you want to handle a notification click when the app is terminated, you can use `getInitialMessage`
    // to get the initial message, and depending in the remoteMessage, you can decide to handle the click
    // This function can be called from anywhere in your app, there is an example in main file.
    // RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    // if (initialMessage != null && initialMessage.data['type'] == 'chat') {
    // Navigator.pushNamed(context, '/chat',
    //     arguments: ChatArguments(initialMessage));
    // }
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    // This function is called when the app is in the background and user clicks on the notification

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      var postId = "";
      var contentType = "";
      var contentId = "";
      var notificationId = "";
      var image = "";
     // print('Data Payload:${message.data.toString()}');
      message.data.forEach((key, value) {
        if (key == "post_id") {
          postId = value;
        }

        if (key == "content_type") {
          contentType = value;
        }

        if (key == "content_id") {
          contentId = value;
        }

        if (key == "notification_id") {
          notificationId = value;
        }

        if (key == "image") {
          image = value;
        }
      });

      /*print('<><> onMessageOpenedApp postId--->' + postId);
      print('<><> onMessageOpenedApp contentType--->' + contentType);
      print('<><> onMessageOpenedApp contentId--->' + contentId);
      print('<><> onMessageOpenedApp notificationId--->' + notificationId);*/
      openPage(postId,contentId);
    });

    await enableIOSNotifications();
    await registerNotificationListeners();
  }

  registerNotificationListeners() async {
    AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSSettings = const IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    var initSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: (payload) {
      // This function handles the click in the notification when the app is in foreground
      // Get.toNamed(NOTIFICATIOINS_ROUTE);
      try {
        /*print('<><> TAP onMessage :' + payload.toString() + "  <><>");*/
        var data = payload.toString().split("|");
        var contentId = data[0];
        var postId = data[1];
        openPage(postId,contentId);
      } catch (e) {
        print(e);
      }
    });
    // onMessage is called when the app is in foreground and a notification is received
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      print('onMessage Notification Payload:${message?.notification!.toMap().toString()}');
      print('onMessage Data Payload:${message?.data.toString()}');
      RemoteNotification? notification = message?.notification;
      AndroidNotification? android = message?.notification?.android;
      AppleNotification? appleNotification = message?.notification?.apple;
      SessionManager sessionManager = SessionManager();
      var isLoggedIn = sessionManager.checkIsLoggedIn() ?? false;
      if (notification != null && isLoggedIn && android != null)
      {
        var postId = "";
        var contentType = "";
        var contentId = "";
        var notificationId = "";
        var image = "";
        var title = "";
        message?.data.forEach((key, value) {
          if (key == "post_id") {
            postId = value;
          }

          if (key == "content_type") {
            contentType = value;
          }

          if (key == "content_id") {
            contentId = value;
          }

          if (key == "notification_id") {
            notificationId = value;
          }

          if (key == "image") {
            image = value;
          }

          if (key == "title") {
            title = value;
          }
        });

        /* print('<><> onMessage postId--->' + postId);
        print('<><> onMessage contentType--->' + contentType);
        print('<><> onMessage contentId--->' + contentId);
        print('<><> onMessage notificationId--->' + notificationId);
        print("<><> onMessage Image URL : " + image.toString() + " <><>");*/
        const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(presentSound: true, presentAlert: true);
        if (image != null)
        {
            if(image.toString().isNotEmpty)
            {
              String largeIconPath = await _downloadAndSaveFile(image.toString(), 'largeIcon');
              String bigPicturePath = await _downloadAndSaveFile(image.toString(), 'bigPicture');
              final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
                  largeIcon: FilePathAndroidBitmap(largeIconPath),
                  contentTitle: title, //"<b>$title</b>"
                  htmlFormatContentTitle: true,
                  summaryText:"",
                  htmlFormatSummaryText: true);

              flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                "",
                NotificationDetails(
                    android: AndroidNotificationDetails('JSP Connect', 'JSP Connect',
                        channelDescription: channel.description,
                        icon: android.smallIcon,
                        playSound: true,
                        styleInformation: bigPictureStyleInformation,
                        importance: Importance.max,
                        priority: Priority.high),
                    iOS: iOSPlatformChannelSpecifics),
                    payload: "$contentId|$postId",
              );
            }
            else
            {
              flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                "",
                NotificationDetails(
                    android: AndroidNotificationDetails('JSP Connect', 'JSP Connect',
                        channelDescription: channel.description,
                        icon: android.smallIcon,
                        playSound: true,
                        importance: Importance.max,
                        priority: Priority.high),
                    iOS: iOSPlatformChannelSpecifics),
                     payload: "$contentId|$postId",
              );
            }
        }
        else
        {
            flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              "",
              payload: "$contentId|$postId",
              NotificationDetails(
                  android: AndroidNotificationDetails('JSP Connect', 'JSP Connect',
                      channelDescription: channel.description,
                      icon: android.smallIcon,
                      playSound: true,
                      importance: Importance.max,
                      priority: Priority.high),
                  iOS: iOSPlatformChannelSpecifics),
            );
        }

        if(contentId == "400")
        {
          SessionManagerMethods.clear();
          NavigationService.navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
          return;
        }

        unReadNotificationCount(sessionManager);
      }
      else
        {
          print("<><> CHECK DATA : " + " <><>");
        }
    });
  }

  unReadNotificationCount(SessionManager sessionManager) async {
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
      sessionManager.setUnreadNotificationCount(0);
    }
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  enableIOSNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true);
  }

  androidNotificationChannel() => const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.', // description
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification_sound_tone.mp3'),
      );

  void openPage(String postId,String contentId) {

    if(contentId == "400")
    {
      SessionManagerMethods.clear();
      NavigationService.navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
      return;
    }

    if (postId != null)
    {
      NavigationService.notif_type = contentId;
      NavigationService.notif_post_id = postId;
      if (postId.toString().isNotEmpty) {
        if (contentId == "1") {
          NavigationService.navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (context) => SocialWallScreen()),
          );
        } else if (contentId == "2" ||
            contentId == "3" ||
            contentId == "4" ||
            contentId == "6" ||
            contentId == "8" ||
            contentId == "10") {
          NavigationService.navigatorKey.currentState!.push(
            MaterialPageRoute(
                builder: (context) => CommonDetailsScreen(postId,contentId)),
          );
        } else if (contentId == "5") {
          // for image
          NavigationService.navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (context) => BottomNavigationBarScreen(1)),
          );
        } else if (contentId == "7") {
          NavigationService.navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (context) => MagazineListScreen()),
          );
        } else {
          NavigationService.navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (context) => BottomNavigationBarScreen(0)),
          );
        }
      } else {
        NavigationService.navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => BottomNavigationBarScreen(0)),
        );
      }
    }
    else
    {
      NavigationService.navigatorKey.currentState!.push(
        MaterialPageRoute(builder: (context) => BottomNavigationBarScreen(0)),
      );
    }
  }
}
