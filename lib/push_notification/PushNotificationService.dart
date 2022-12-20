import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import '../constant/global_context.dart';
import '../screen/CommonDetailsScreen.dart';
import '../screen/MagazineListScreen.dart';
import '../screen/SocialWallScreen.dart';
import '../screen/tabcontrol/bottom_navigation_bar_screen.dart';
import '../utils/app_utils.dart';
import '../utils/session_manager.dart';
import 'package:http/http.dart' as http;

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
      print('Data Payload:${message.data.toString()}');
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

      print('<><> onMessageOpenedApp postId--->' + postId);
      print('<><> onMessageOpenedApp contentType--->' + contentType);
      print('<><> onMessageOpenedApp contentId--->' + contentId);
      print('<><> onMessageOpenedApp notificationId--->' + notificationId);

      NavigationService.notif_type = contentId;
      NavigationService.notif_post_id = postId;
      tabNavigationReload();
      if (postId != null) {
        if (postId.toString().isNotEmpty) {
          if (contentId == "1") {
            NavigationService.navigatorKey.currentState!.push(
              MaterialPageRoute(builder: (context) => SocialWallScreen()),
            );
          } else if (NavigationService.notif_type == "2" ||
              NavigationService.notif_type == "3" ||
              NavigationService.notif_type == "4" ||
              NavigationService.notif_type == "6" ||
              NavigationService.notif_type == "8" ||
              NavigationService.notif_type == "10") {
            NavigationService.navigatorKey.currentState!.push(
              MaterialPageRoute(
                  builder: (context) => CommonDetailsScreen(NavigationService.notif_post_id.toString(), (NavigationService.notif_type.toString()))),
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
      } else {
        NavigationService.navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => BottomNavigationBarScreen(0)),
        );
      }
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
    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: (message) async {
      // This function handles the click in the notification when the app is in foreground
      // Get.toNamed(NOTIFICATIOINS_ROUTE);
      print('onMessage Data Payload On TAP :' + message.toString() + "  <><>");
      NavigationService.navigatorKey.currentState!.push(
        MaterialPageRoute(builder: (context) => BottomNavigationBarScreen(0)),
      );
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
      if (notification != null && isLoggedIn && android != null) {
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

        print('<><> onMessage postId--->' + postId);
        print('<><> onMessage contentType--->' + contentType);
        print('<><> onMessage contentId--->' + contentId);
        print('<><> onMessage notificationId--->' + notificationId);
        const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(presentSound: true, presentAlert: true);
        print("<><> onMessage Image URL : " + image.toString() + " <><>");
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
              );
            }
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
            );
        }
      }
    });
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
}
