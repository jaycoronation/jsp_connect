import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/CommanResponse.dart';
import '../model/PostDetailsResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../utils/full_screen_image_new.dart';
import '../widget/loading.dart';

class NewsDetailsScreen extends StatefulWidget {
  final String postId;

  const NewsDetailsScreen(this.postId, {Key? key}) : super(key: key);

  @override
  _NewsDetailsScreen createState() => _NewsDetailsScreen();
}

class _NewsDetailsScreen extends BaseState<NewsDetailsScreen> {
  late final PostDetails postDetailsData;
  num isLiked = 0;
  late final String postId;
  bool _isLoading = false;

  @override
  void initState() {
    postId = (widget as NewsDetailsScreen).postId;
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
                        Navigator.pop(context);
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
          body:  _isLoading
              ? const LoadingWidget() : SingleChildScrollView(
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
                  child: Text(postDetailsData.title.toString(), style: TextStyle(color: white, fontSize: 20, fontWeight: FontWeight.w600, fontFamily: roboto)),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text("On " + postDetailsData.saveTimestamp.toString(), style: TextStyle(color: white, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: roboto)),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: HtmlWidget(postDetailsData.description.toString(),textStyle: const TextStyle(height: 1.5, color: white, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: roboto)),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                  child: const Text(
                    "Related News",
                    style: TextStyle(fontFamily: roboto, fontSize: 17, color: white, fontWeight: FontWeight.w600),
                  ),
                ),
                postDetailsData.reatedPosts!.isNotEmpty
                    ? AnimationLimiter(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: postDetailsData.reatedPosts!.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: GestureDetector(
                              onTap: () async {
                                await Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailsScreen(postDetailsData.reatedPosts![index].id.toString())));
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                                margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(width: 0.6, color: white.withOpacity(0.4), style: BorderStyle.solid)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(right: 12),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(postDetailsData.reatedPosts![index].title.toString(),
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                        overflow: TextOverflow.clip,
                                                        color: white,
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 16,
                                                        fontFamily: roboto))
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          height: 100,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20.0),
                                            child: Image.network(postDetailsData.reatedPosts![index].featuredImage.toString(), width: 100, height: 100, fit: BoxFit.fill),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: 18,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          postDetailsData.reatedPosts![index].location.toString(),
                                          style: TextStyle(fontSize: 12, fontFamily: roboto, fontWeight: FontWeight.w400, color: lightGray),
                                        ),
                                        Container(
                                          width: 6,
                                        ),
                                        Image.asset(
                                          "assets/images/ic_placeholder.png",
                                          width: 4,
                                          height: 4,
                                          color: lightGray,
                                        ),
                                        Container(
                                          width: 6,
                                        ),
                                        Text(
                                          postDetailsData.reatedPosts![index].saveTimestamp.toString(),
                                          style: TextStyle(fontSize: 12, fontFamily: roboto, fontWeight: FontWeight.w400, color: lightGray),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () async {
                                            if(postDetailsData.reatedPosts![index].media!.isNotEmpty)
                                            {
                                              if(postDetailsData.reatedPosts![index].media![0].media.toString().isNotEmpty)
                                              {
                                                Share.share(postDetailsData.reatedPosts![index].media![0].media.toString());
                                              }
                                            }
                                          },
                                          child: Container(
                                            width: 42,
                                            height: 42,
                                            alignment: Alignment.center,
                                            child: Image.asset('assets/images/share.png', height: 22, width: 22, color: white),
                                          ),
                                        ),
                                        Text(
                                          postDetailsData.reatedPosts![index].sharesCount.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                        ),
                                        Container(
                                          width: 8,
                                        )
                                        /* Container(
                                    width: 12,
                                  ),
                                  Image.asset(
                                    "assets/images/ic_arrow_right_new.png",
                                    width: 22,
                                    height: 22,
                                  )*/
                                      ],
                                    ),
                                    Container(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
                    : Container(),
              ],
            ),
          ),
        ),
        onWillPop: () {
          Navigator.pop(context);
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
      'type_id': "4"
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
      }
    } else {
      showSnackBar(dataResponse.message, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  _likePost() async {
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

  @override
  void castStatefulWidget() {
    widget is NewsDetailsScreen;
  }
}
