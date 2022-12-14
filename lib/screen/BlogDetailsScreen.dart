import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:jspl_connect/screen/tabcontrol/bottom_navigation_bar_screen.dart';
import 'package:jspl_connect/widget/no_data.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';

import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../constant/global_context.dart';
import '../model/BlogResponseModel.dart';
import '../model/CommanResponse.dart';
import '../model/PostDetailsResponse.dart';
import '../model/PostListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../utils/full_screen_image_new.dart';
import '../widget/loading.dart';

class BlogDetailsScreen extends StatefulWidget {
  final String postId;

  const BlogDetailsScreen(this.postId, {Key? key}) : super(key: key);

  @override
  _BlogDetailsScreen createState() => _BlogDetailsScreen();
}

class _BlogDetailsScreen extends BaseState<BlogDetailsScreen> {
  late final String postId;
  num isLiked = 0;
  num isBookMark = 0;
  bool _isLoading = false;
  bool _isNoData = false;
  num shareCount = 0;
  late final PostDetails postDetailsData;

  @override
  void initState() {
    postId = (widget as BlogDetailsScreen).postId;
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
            titleSpacing: 0,
            leading: GestureDetector(
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
                    String data = "$postId|$shareCount";
                    Navigator.pop(context, data);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(6),
                  child: Image.asset('assets/images/ic_back_button.png', height: 22, width: 22, color: white),
                )),
            title: Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "",
                style: TextStyle(fontWeight: FontWeight.w600, color: white, fontSize: 18),
              ),
            ),
            actions: [
              Visibility(visible: !_isNoData,child: GestureDetector(
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
              Visibility(visible:  !_isNoData,child: GestureDetector(
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
              Visibility(visible:  !_isNoData,child: GestureDetector(
                onTap: () {
                  if(postDetailsData.media!.isNotEmpty)
                  {
                    if(postDetailsData.media![0].media.toString().isNotEmpty)
                    {
                      Share.share(postDetailsData.media![0].media.toString());
                      shareCount = shareCount + 1;
                      _sharePost(postId);
                    }
                    else
                    {
                      showSnackBar("Blog link not found.", context);
                    }
                  }
                  else
                  {
                    showSnackBar("Blog link not found.", context);
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(right: 8),
                  child: Image.asset('assets/images/share.png', height: 22, width: 22, color: white),
                ),
              )),
            ],
          ),
          body: _isLoading
              ? const LoadingWidget() : _isNoData ? const MyNoDataWidget(msg: "No blog details found.")
              : SingleChildScrollView(
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
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FadeInImage.assetNetwork(
                        image: postDetailsData.featuredImage.toString(),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        placeholder: 'assets/images/bg_gray.jpeg',
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(postDetailsData.title.toString(),
                      style: const TextStyle(color: white, fontSize: 22, fontWeight: titleFont, fontFamily: aileron)),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      Text(postDetailsData.location.toString(), style: TextStyle(fontWeight: FontWeight.w400, fontFamily: aileron, fontSize: 12, color: lightGray)),
                      postDetailsData.location.toString().isNotEmpty ? Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(left: 6,right: 6),
                        decoration: const BoxDecoration(
                          color: lightGray,
                          shape: BoxShape.circle,
                        ),
                      ) : Container(),
                      Text(postDetailsData.saveTimestamp.toString(), style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: aileron, fontSize: 12,
                          color: white)),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 22, 16, 8),
                  child: HtmlWidget(postDetailsData.description.toString(),
                      textStyle: const TextStyle(height: 1.5, color: white, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: robotoFinal)),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                  child: const Text(
                    "Related Blogs",
                    style: TextStyle(fontFamily: roboto, fontSize: 17, color: white, fontWeight: FontWeight.w800),
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
                                final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => BlogDetailsScreen(postDetailsData.reatedPosts![index].id.toString())));
                                print("result ===== $result");
                                setState(() {
                                  var data = result.toString().split("|");
                                  for (int i = 0; i < postDetailsData.reatedPosts!.length; i++) {
                                    if(postDetailsData.reatedPosts![i].id == data[0])
                                    {
                                      postDetailsData.reatedPosts![i].setSharesCount = num.parse(data[1]);
                                      break;
                                    }
                                  }
                                });
                              },
                              child: Container(
                                  margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(width: 0.6, color: white.withOpacity(0.4), style: BorderStyle.solid)
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Container(
                                                    alignment: Alignment.centerLeft,
                                                    margin: EdgeInsets.only(left: 14, right: 22, top:postDetailsData.reatedPosts![index].saveTimestamp.toString().isNotEmpty ? 10 : 22),
                                                    child: Text(
                                                      postDetailsData.reatedPosts![index].title.toString().trim(),
                                                      overflow: TextOverflow.clip,
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                          fontWeight: titleFont,
                                                          fontSize: 16,
                                                          fontFamily: aileron,
                                                          overflow: TextOverflow.clip,
                                                          color: white),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Stack(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only( right: 10,top: 12),
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                height: 80,
                                                width: 80,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(20), // Image border
                                                  child: SizedBox.fromSize(
                                                    size: const Size.fromRadius(48), // Image radius
                                                    child: Image.network(
                                                      postDetailsData.reatedPosts![index].featuredImage.toString(),
                                                      fit: BoxFit.cover,
                                                      width: MediaQuery.of(context).size.width,
                                                      alignment: Alignment.topRight,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(18, 38, 18, 12),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text(postDetailsData.reatedPosts![index].location.toString(), style: TextStyle(fontWeight: FontWeight.w400, fontFamily: aileron, fontSize: 12, color: lightGray)),
                                                postDetailsData.reatedPosts![index].location.toString().isNotEmpty ? Container(
                                                  width: 6,
                                                  height: 6,
                                                  margin: const EdgeInsets.only(left: 6,right: 6),
                                                  decoration: const BoxDecoration(
                                                    color: lightGray,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ) : Container(),
                                                Text(postDetailsData.reatedPosts![index].saveTimestamp.toString(), style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: aileron, fontSize: 12,
                                                    color: white)),
                                              ],
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                if(postDetailsData.reatedPosts![index].media!.isNotEmpty)
                                                {
                                                  if(postDetailsData.reatedPosts![index].media![0].media.toString().isNotEmpty)
                                                  {
                                                    Share.share(postDetailsData.reatedPosts![index].media![0].media.toString());
                                                    _sharePost(postDetailsData.reatedPosts![index].id.toString());
                                                    setState(() {
                                                      postDetailsData.reatedPosts![index].setSharesCount = postDetailsData.reatedPosts![index].sharesCount! + 1;
                                                    });
                                                  }
                                                  else
                                                  {
                                                    showSnackBar("Blog link not found.", context);
                                                  }
                                                }
                                                else
                                                {
                                                  showSnackBar("Blog link not found.", context);
                                                }
                                              },
                                              behavior: HitTestBehavior.opaque,
                                              child:  Container(
                                                width: 32,
                                                height: 32,
                                                padding: const EdgeInsets.all(6),
                                                child: Image.asset("assets/images/share.png", height: 22,
                                                    width: 22,color: white),
                                              ),
                                            ),
                                            Text(
                                              postDetailsData.reatedPosts![index].sharesCount.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
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
            String data = "$postId|$shareCount";
            Navigator.pop(context, data);
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
      'type_id': "6"
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

  _sharePost(String id) async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + postMetaSave);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'post_id' : id,
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
  }

  @override
  void castStatefulWidget() {
    widget is BlogDetailsScreen;
  }
}
