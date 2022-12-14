import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../constant/global_context.dart';
import '../utils/app_utils.dart';
import '../utils/session_manager.dart';
import '../screen/BlogDetailsScreen.dart';
import '../screen/EventDetailsScreen.dart';
import '../screen/MagazineListScreen.dart';
import '../screen/MediaCoverageDetailsScreen.dart';
import '../screen/NewsDetailsScreen.dart';
import '../screen/VideoDetailsPage.dart';
import '../screen/tabcontrol/bottom_navigation_bar_screen.dart';

class PushNotificationService {
// It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      var postId = "";
      var contentType = "";
      var contentId = "";
      var notificationId = "";
      print('Data Payload:${message.data.toString()}');
      message.data.forEach((key, value) {
        if (key == "post_id")
        {
          postId = value;
        }

        if (key == "content_type")
        {
          contentType = value;
        }

        if (key == "content_id")
        {
          contentId = value;
        }

        if (key == "notification_id")
        {
          notificationId = value;
        }
      });

      print('<><> onMessageOpenedApp postId--->' + postId);
      print('<><> onMessageOpenedApp contentType--->' + contentType);
      print('<><> onMessageOpenedApp contentId--->' + contentId);
      print('<><> onMessageOpenedApp notificationId--->' + notificationId);

      NavigationService.notif_type = contentId;
      NavigationService.notif_post_id = postId;

      tabNavigationReload();
      if(postId != null)
      {
        if(postId.toString().isNotEmpty)
        {
          if(contentId == "2")
          {
            NavigationService.navigatorKey.currentState!.push(
              MaterialPageRoute(
                  builder: (context) =>  EventDetailsScreen(postId.toString())),
            );
          }
          else if(contentId == "3")
          {
            NavigationService.navigatorKey.currentState!.push(
              MaterialPageRoute(
                  builder: (context) =>  VideoDetailsPage(postId.toString())),
            );
          }
          else if(contentId == "4")
          {
            NavigationService.navigatorKey.currentState!.push(
              MaterialPageRoute(
                  builder: (context) =>  NewsDetailsScreen(postId.toString())),
            );
          }
          else if(contentId == "5")
          {
            // for image
          }
          else if(contentId == "6")
          {
            NavigationService.navigatorKey.currentState!.push(
              MaterialPageRoute(
                  builder: (context) =>  BlogDetailsScreen(postId.toString())),
            );
          }
          else if(contentId == "7")
          {
            NavigationService.navigatorKey.currentState!.push(
              MaterialPageRoute(
                  builder: (context) =>  MagazineListScreen()),
            );
          }
          else if(contentId == "8")
          {
            NavigationService.navigatorKey.currentState!.push(
              MaterialPageRoute(
                  builder: (context) =>  MediaCoverageDetailsScreen(postId.toString())),
            );
          }
          else
          {
            NavigationService.navigatorKey.currentState!.push(
              MaterialPageRoute(
                  builder: (context) =>  BottomNavigationBarScreen(0)),
            );
          }
        }
        else
        {
          NavigationService.navigatorKey.currentState!.push(
            MaterialPageRoute(
                builder: (context) =>  BottomNavigationBarScreen(0)),
          );
        }
      }
      else
      {
        NavigationService.navigatorKey.currentState!.push(
          MaterialPageRoute(
              builder: (context) =>  BottomNavigationBarScreen(0)),
        );
      }
    });

    enableIOSNotifications();
    await registerNotificationListeners();
  }


  Future<void> registerNotificationListeners() async {
    final AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSSettings =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        print('<><> ON TAP onMessage Data Payload:${details.payload.toString()}' + " <><>");
      },
    );
// onMessage is called when the app is in foreground and a notification is received
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      print('onMessage Notification Payload:${message?.notification!.toMap().toString()}');
      print('onMessage Data Payload:${message?.data.toString()}');
      RemoteNotification? notification = message?.notification;
      AndroidNotification? android = message?.notification?.android;
      AppleNotification? appleNotification = message?.notification?.apple;
      SessionManager sessionManager = SessionManager();
      var isLoggedIn = sessionManager.checkIsLoggedIn() ?? false;
      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && isLoggedIn && android != null) {

        var postId = "";
        var contentType = "";
        var contentId = "";
        var notificationId = "";
        message?.data.forEach((key, value)
        {
          if (key == "post_id")
          {
            postId = value;
          }

          if (key == "content_type")
          {
            contentType = value;
          }

          if (key == "content_id")
          {
            contentId = value;
          }

          if (key == "notification_id")
          {
            notificationId = value;
          }
        });


        print('<><> onMessage postId--->' + postId);
        print('<><> onMessage contentType--->' + contentType);
        print('<><> onMessage contentId--->' + contentId);
        print('<><> onMessage notificationId--->' + notificationId);
       // const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(presentSound: true,presentAlert: true);
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                'JSP Connect',
                'JSP Connect',
                channelDescription : channel.description,
                icon: android.smallIcon,
                playSound: true,
                importance: Importance.max,
                priority: Priority.high
            ),
          ),
        );
      }
    });
  }


  Future<void> enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  AndroidNotificationChannel androidNotificationChannel() =>
      const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
        'This channel is used for important notifications.', // description
        importance: Importance.max,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('notification_sound_tone.mp3')
      );

}
