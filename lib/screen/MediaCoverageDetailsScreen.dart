import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/CommanResponse.dart';
import '../model/PostListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../utils/full_screen_image_new.dart';

class MediaCoverageDetailsScreen extends StatefulWidget {
  final PostsData post;

  const MediaCoverageDetailsScreen(this.post, {Key? key}) : super(key: key);

  @override
  _NewsDetailsScreen createState() => _NewsDetailsScreen();
}

class _NewsDetailsScreen extends BaseState<MediaCoverageDetailsScreen> {
  late final PostsData post;
  num isLiked = 0;
  @override
  void initState() {
    post = (widget as MediaCoverageDetailsScreen).post;
    isLiked = post.isLiked!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: black,
          appBar: AppBar(
            toolbarHeight: 55,
            automaticallyImplyLeading: false,
            backgroundColor: black,
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
                        post.setIsLikeMain = isLiked;
                        Navigator.pop(context,post);
                      },
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(
                          'assets/images/ic_back_button.png',
                          height: 22,
                          width: 22,
                        ),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 65,
                    margin: const EdgeInsets.only(left: 5),
                    child: const Text(
                      "",
                      style: TextStyle(fontWeight: FontWeight.w600, color: white, fontSize: 16),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            actions: [
              GestureDetector(
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
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(right: 8),
                child: Image.asset('assets/images/share.png', height: 22, width: 22, color: white),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    List<String> listImage = [];
                    listImage.add(post.featuredImage.toString().trim());
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
                        image: post.featuredImage.toString().trim(),
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
                  child: Text(post.title.toString(), style: TextStyle(color: white, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: roboto)),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text("On " + post.saveTimestamp.toString(), style: TextStyle(color: white, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: roboto)),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: HtmlWidget(post.description.toString(),textStyle: const TextStyle(height: 1.5, color: white, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: roboto)),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () {
          post.setIsLikeMain = isLiked;
          Navigator.pop(context,post);
          return Future.value(true);
        });
  }

  _likePost() async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + postMetaSave);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'post_id' : post.id.toString(),
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

  @override
  void castStatefulWidget() {
    widget is MediaCoverageDetailsScreen;
  }
}
