import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:jspl_connect/screen/BlogDetailsScreen.dart';
import 'package:jspl_connect/screen/CommonDetailsScreen.dart';
import 'package:jspl_connect/screen/MagazineListScreen.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/NotificationListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/no_data.dart';
import 'MediaCoverageDetailsScreen.dart';
import 'NewsDetailsScreen.dart';
import 'EventDetailsScreen.dart';
import 'SocialWallScreen.dart';
import 'VideoDetailsPage.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  _NotificationListScreen createState() => _NotificationListScreen();
}

class _NotificationListScreen extends BaseState<NotificationListScreen> {
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _pageIndex = 1;
  final int _pageResult = 50;
  bool _isLastPage = false;
  bool isScrollingDown = false;
  late ScrollController _scrollViewController;
  List<NotificationList> notificationList = List<NotificationList>.empty(growable: true);

  @override
  void initState() {

    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {

      if (_scrollViewController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          setState(() {});
        }
      }
      if (_scrollViewController.position.userScrollDirection == ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          setState(() {});
        }
      }

      pagination();

    });

    if (isOnline) {
      getList(false,true);
    } else {
      noInterNet(context);
    }
    isBlogReload = false;
    super.initState();
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffFFFFFF), Color(0xffaaa9a3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final Shader linearGradientForDate = const LinearGradient(
    colors: <Color>[Color(0xffaaa9a3), Color(0xff72716d)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  Future<bool> _refresh() {
    print("refresh......");
    if (isInternetConnected) {
      getList(true,true);
    } else {
      noInterNet(context);
    }
    return Future.value(true);
  }

  void pagination() {
    if (!_isLastPage && !_isLoadingMore) {
      if ((_scrollViewController.position.pixels == _scrollViewController.position.maxScrollExtent)) {
        setState(() {
          _isLoadingMore = true;
          getList(false,false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 55,
            automaticallyImplyLeading: false,
            backgroundColor: screenBg,
            elevation: 0,
            centerTitle: false,
            title: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(6),
                        child: Image.asset('assets/images/ic_back_button.png', height: 22, width: 22, color: black),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 65,
                    margin: const EdgeInsets.only(left: 5),
                    child:  Text(
                      "Notifications",
                      style: TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 18),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          backgroundColor: screenBg,
          resizeToAvoidBottomInset: true,
          body: _isLoading
              ? const LoadingWidget()
              : RefreshIndicator(
                  color: orange,
                  onRefresh: _refresh,
                  child: Column(
                    children: [
                      Expanded(child: Stack(
                        children: [
                          Visibility(
                            visible: notificationList.isEmpty,
                            child: const MyNoDataWidget(msg: 'No notification found!'),
                          ),
                          AnimationLimiter(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              controller: _scrollViewController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: notificationList.length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          _viewDetails(context, notificationList[index]);
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(width: 0.6, color: black.withOpacity(0.4), style: BorderStyle.solid)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Expanded(child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(notificationList[index].title.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontFamily: aileron, fontSize: 16, color: black)),
                                                      Text(notificationList[index].contentType.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontFamily: aileron, fontSize: 16, color: black)),
                                                      Gap(4),
                                                      Text(notificationList[index].saveTimestamp.toString(), style: TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          fontFamily: aileron, fontSize: 14,
                                                          foreground:Paint()..shader = linearGradientForDate)),
                                                    ],
                                                  )),
                                                 /* SizedBox(
                                                    width: 100,
                                                    height: 100,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      child: Image.network(notificationList[index].featuredImage.toString(), width: 100, height: 100, fit: BoxFit.cover),
                                                    ),
                                                  )*/
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )),
                      Visibility(visible : _isLoadingMore,child: Container(
                        padding: const EdgeInsets.only(top: 10,bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 30, height: 30,
                                child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xff444444),
                                          width: 1,
                                        )),
                                    child:  Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: CircularProgressIndicator(color: white,strokeWidth: 2),
                                    )
                                )),
                             Text(' Loading more...',
                                style: TextStyle(color: white, fontWeight: FontWeight.w400, fontSize: 16)
                            )
                          ],
                        ),
                      ))
                    ],
                  ),
                )),
        onWillPop: (){
          Navigator.pop(context);
          return Future.value(true);
        }
    );
  }

  Future<void> _viewDetails(BuildContext context, NotificationList notificationList) async {

     String contentId = notificationList.contentId.toString();

       if(notificationList.postId != null)
       {
           if(notificationList.postId.toString().isNotEmpty)
           {
             if(contentId == "1")
             {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const SocialWallScreen()));
             }
             else if(contentId == "2" || contentId == "3" ||contentId == "4" || contentId == "6" || contentId == "8" || contentId == "10" )
             {
               Navigator.push(context, MaterialPageRoute(builder: (context) => CommonDetailsScreen(notificationList.postId.toString(),contentId)));
             }
             else if(contentId == "7")
             {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const MagazineListScreen()));
             }

             /*if(contentId == "2")
             {
               Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen(notificationList.postId.toString())));
             }
             else if(contentId == "3")
             {
               Navigator.push(context, MaterialPageRoute(builder: (context) => VideoDetailsPage(notificationList.postId.toString())));
             }
             else if(contentId == "4")
             {
               Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailsScreen(notificationList.postId.toString())));
             }
             else if(contentId == "5")
             {
               // for image
             }
             else if(contentId == "6")
             {
               Navigator.push(context, MaterialPageRoute(builder: (context) => BlogDetailsScreen(notificationList.postId.toString())));
             }
             else if(contentId == "7")
             {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const MagazineListScreen()));
             }
             else if(contentId == "8")
             {
               Navigator.push(context, MaterialPageRoute(builder: (context) => MediaCoverageDetailsScreen(notificationList.postId.toString())));
             }*/
           }
         else
         {
           showSnackBar("Post id not found.", context);
         }
       }
       else
       {
         showSnackBar("Post id not found.", context);
       }

  }

  getList([bool isPull = false,bool isFirstTime = false]) async {
    if (isFirstTime) {
      setState(() {
        _isLoading = true;
        _isLoadingMore = false;
        _pageIndex = 1;
        _isLastPage = false;
      });
    }

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + notification_list);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'user_id': sessionManager.getUserId().toString(),
      'limit': _pageResult.toString(),
      'page': _pageIndex.toString(),
    };
    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = NotificationListResponse.fromJson(apiResponse);

    if (isFirstTime) {
      if (notificationList.isNotEmpty) {
        notificationList = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1) {

      if (dataResponse.notificationList != null && dataResponse.notificationList!.isNotEmpty)
      {
        List<NotificationList>? _tempList = [];
        _tempList = dataResponse.notificationList;
        notificationList.addAll(_tempList!);

        if (_tempList.isNotEmpty) {
          _pageIndex += 1;
          if (_tempList.isEmpty || _tempList.length % _pageResult != 0) {
            _isLastPage = true;
          }
        }

        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
      else {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } else {
      showSnackBar(dataResponse.message, context);
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  @override
  void castStatefulWidget() {
    widget is NotificationListScreen;
  }
}
