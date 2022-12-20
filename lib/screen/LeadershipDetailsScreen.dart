import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:jspl_connect/screen/tabcontrol/bottom_navigation_bar_screen.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../constant/global_context.dart';
import '../model/PostDetailsResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../utils/full_screen_image_new.dart';
import '../widget/loading.dart';
import '../widget/no_data.dart';

class LeadershipDetailsScreen extends StatefulWidget {
  final String postId;

  const LeadershipDetailsScreen(this.postId, {Key? key}) : super(key: key);

  @override
  _LeadershipDetailsScreen createState() => _LeadershipDetailsScreen();
}

class _LeadershipDetailsScreen extends BaseState<LeadershipDetailsScreen> {
  late final PostDetails postDetailsData;
  num isLiked = 0;
  num isBookMark = 0;
  num shareCount = 0;
  late final String postId;
  bool _isLoading = false;
  bool _isNoData = false;

  @override
  void initState() {
    postId = (widget as LeadershipDetailsScreen).postId;
    if (isOnline) {
      _getPostDetails();
    } else {
      noInterNet(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: screenBg,
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
                        if (NavigationService.notif_type.isNotEmpty)
                        {
                          NavigationService.notif_type = "";
                          NavigationService.notif_post_id = "";
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const BottomNavigationBarScreen(0)),
                                  (Route<dynamic> route) => false);
                        }
                        else
                        {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(
                          'assets/images/ic_back_button.png',
                          height: 22,
                          width: 22,
                          color: black,
                        ),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 65,
                    margin: const EdgeInsets.only(left: 5),
                    child:  Text(
                      "",
                      style: TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            actions: [
             /* Visibility(
                  visible: !_isNoData,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if(isLiked == 1)
                        {
                          isLiked = 0;
                        }
                        else
                        {
                          isLiked = 1;
                        }
                      });
                      _likePost();
                    },
                    behavior: HitTestBehavior.opaque,
                    child:  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(6),
                      margin: const EdgeInsets.only(right: 8),
                      child: Image.asset(isLiked == 1 ? "assets/images/like_filled.png" : "assets/images/like.png", height: 22, width: 22,color: isLiked == 1 ? Colors.yellow : white,),
                    ),
                  )),
              Visibility(
                  visible: !_isNoData,
                  child:GestureDetector(
                    onTap: () {
                      setState(() {
                        if(isBookMark == 1)
                        {
                          isBookMark = 0;
                        }
                        else
                        {
                          isBookMark = 1;
                        }
                      });
                      _bookmarkPost();
                    },
                    behavior: HitTestBehavior.opaque,
                    child:  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(6),
                      margin: const EdgeInsets.only(right: 8),
                      child: Image.asset(isBookMark == 1 ? "assets/images/saved_fill.png" : "assets/images/saved.png", height: 22, width: 22,color: isBookMark == 1 ? Colors.yellow : white,),
                    ),
                  )),
              Visibility(
                  visible: !_isNoData,
                  child:GestureDetector(
                    onTap: () {
                      if(postDetailsData.media!.isNotEmpty)
                      {
                        if(postDetailsData.media![0].media.toString().isNotEmpty)
                        {
                          Share.share(postDetailsData.media![0].media.toString());
                          _sharePost();
                        }
                        else
                        {
                          showSnackBar("Event link not found.", context);
                        }
                      }
                      else
                      {
                        showSnackBar("Event link not found.", context);
                      }

                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(6),
                      margin: const EdgeInsets.only(right: 8),
                      child: Image.asset('assets/images/share.png', height: 22, width: 22, color: white),
                    ),
                  )),*/
            ],
          ),
          body:_isLoading
              ? const LoadingWidget()
              : _isNoData
              ? const MyNoDataWidget(msg: "No event details found.")
              :  SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    List<String> listImage = [];
                    listImage.add(postDetailsData.featuredImage.toString().trim());
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => FullScreenImageNew("", listImage, 0),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;
                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                        color: white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 0.4, color: white.withOpacity(0.3), style: BorderStyle.solid)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: FadeInImage.assetNetwork(
                        image: postDetailsData.featuredImage.toString().trim(),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        placeholder: 'assets/images/bg_gray.jpeg',
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(postDetailsData.title.toString(), style: TextStyle(color: black, fontSize: 22, fontWeight: FontWeight.w500, fontFamily: roboto)),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(postDetailsData.saveTimestamp.toString(), style: TextStyle(color: black, fontSize: 12, fontWeight: FontWeight.w500, fontFamily: roboto)),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 22, 16, 8),
                  child: HtmlWidget(postDetailsData.description.toString(),textStyle: TextStyle(height: 1.5, color: black, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: roboto)),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () {
          if (NavigationService.notif_type.isNotEmpty)
          {
            NavigationService.notif_type = "";
            NavigationService.notif_post_id = "";
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const BottomNavigationBarScreen(0)),
                    (Route<dynamic> route) => false);
          }
          else
          {
            Navigator.pop(context);
          }
          return Future.value(true);
        });
  }

  _getPostDetails() async {
    setState(() {
      _isLoading = true;
    });

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + postDetails);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'post_id': postId.toString(),
      'user_id': sessionManager.getUserId().toString(),
      'type_id': "10"
    };
    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = PostDetailsResponse.fromJson(apiResponse);

    if (statusCode == 200 && dataResponse.success == 1) {
      if (dataResponse.postDetails != null) {
        postDetailsData = dataResponse.postDetails!;
        isLiked = postDetailsData.isLiked!;
        isBookMark = postDetailsData.isBookmarked!;
        shareCount = postDetailsData.sharesCount!;
      }
    } else {
      setState(() {
        _isNoData = true;
      });
      showSnackBar(dataResponse.message, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  /*_likePost() async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + postMetaSave);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'post_id' : postId.toString(),
      'user_id' : sessionManager.getUserId().toString(),
      'type' : "like",
      'comments': ""};
    final response = await http.post(
        url,
        body: jsonBody,
        headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = CommanResponse.fromJson(apiResponse);

    if (statusCode == 200 && dataResponse.status == 1) {

    } else {
      setState(() {
        if(isLiked == 1)
        {
          isLiked = 0;
        }
        else
        {
          isLiked = 1;
        }
      });
      showSnackBar(dataResponse.message, context);
    }
  }

  _bookmarkPost() async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + postMetaSave);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'post_id' : postId.toString(),
      'user_id' : sessionManager.getUserId().toString(),
      'type' : "bookmark",
      'comments': ""};
    final response = await http.post(
        url,
        body: jsonBody,
        headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = CommanResponse.fromJson(apiResponse);

    if (statusCode == 200 && dataResponse.status == 1) {

    } else {
      setState(() {
        if(isBookMark == 1)
        {
          isBookMark = 0;
        }
        else
        {
          isBookMark = 1;
        }
      });
      showSnackBar(dataResponse.message, context);
    }
  }

  _sharePost() async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + postMetaSave);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'post_id' :  postId.toString(),
      'user_id' : sessionManager.getUserId().toString(),
      'type' : "share",
      'comments': ""};

    final response = await http.post(
        url,
        body: jsonBody,
        headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = CommanResponse.fromJson(apiResponse);

    if (statusCode == 200 && dataResponse.status == 1) {
    } else {
      showSnackBar(dataResponse.message, context);
    }
  }*/

  @override
  void castStatefulWidget() {
    widget is LeadershipDetailsScreen;
  }
}
