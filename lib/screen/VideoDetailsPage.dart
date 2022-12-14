import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:jspl_connect/screen/tabcontrol/bottom_navigation_bar_screen.dart';
import 'package:jspl_connect/screen/video_player_screen.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../constant/global_context.dart';
import '../model/CommanResponse.dart';
import '../model/PostDetailsResponse.dart';
import '../model/PostListResponse.dart';
import '../model/VideoResponseModel.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/no_data.dart';
import 'VideoPlayerPage.dart';

class VideoDetailsPage extends StatefulWidget {
  final String postId;

  const VideoDetailsPage(this.postId, {Key? key}) : super(key: key);

  @override
  _VideoDetailsPage createState() => _VideoDetailsPage();
}

class _VideoDetailsPage extends BaseState<VideoDetailsPage> {
  var listVideo = List<Videos>.empty(growable: true);
  bool _isLoading = false;
  bool _isNoData = false;
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;
  late final String postId;
  late final PostDetails postDetailsData;
  num isLiked = 0;
  num isBookMark = 0;
  num shareCount = 0;

  @override
  void initState() {
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    _controller = YoutubePlayerController(
        initialVideoId: "4ZL0s9gKKEk",
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ));
    postId = (widget as VideoDetailsPage).postId;
    if (isOnline) {
      _getPostDetails();
    } else {
      noInterNet(context);
    }
    super.initState();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
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
            leading: InkWell(
                onTap: () {
                  if (NavigationService.notif_type.isNotEmpty) {
                    NavigationService.notif_type = "";
                    NavigationService.notif_post_id = "";
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const BottomNavigationBarScreen(0)), (Route<dynamic> route) => false);
                  } else {
                    String data = "$postId|$shareCount";
                    Navigator.pop(context, data);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset('assets/images/ic_back_button.png', height: 16, width: 16, color: white),
                )),
            title: const Text(
              "",
              style: TextStyle(fontWeight: FontWeight.w600, color: white, fontSize: 18),
            ),
            actions: [
              Visibility(
                  visible: !_isNoData,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isLiked == 1) {
                          isLiked = 0;
                        } else {
                          isLiked = 1;
                        }
                      });
                      _likePost();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(6),
                      margin: const EdgeInsets.only(right: 8),
                      child: Image.asset(
                        isLiked == 1 ? "assets/images/like_filled.png" : "assets/images/like.png",
                        height: 22,
                        width: 22,
                        color: isLiked == 1 ? Colors.yellow : white,
                      ),
                    ),
                  )),
              Visibility(
                  visible: !_isNoData,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isBookMark == 1) {
                          isBookMark = 0;
                        } else {
                          isBookMark = 1;
                        }
                      });
                      _bookmarkPost();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(6),
                      margin: const EdgeInsets.only(right: 8),
                      child: Image.asset(
                        isBookMark == 1 ? "assets/images/saved_fill.png" : "assets/images/saved.png",
                        height: 22,
                        width: 22,
                        color: isBookMark == 1 ? Colors.yellow : white,
                      ),
                    ),
                  )),
              Visibility(
                  visible: !_isNoData,
                  child: GestureDetector(
                    onTap: () {
                      if (postDetailsData.media!.isNotEmpty) {
                        if (postDetailsData.media![0].media.toString().isNotEmpty) {
                          Share.share(postDetailsData.media![0].media.toString());
                          shareCount = shareCount + 1;
                          _sharePost(postId);
                        } else {
                          showSnackBar("Video link not found.", context);
                        }
                      } else {
                        showSnackBar("Video link not found.", context);
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
              ? const LoadingWidget()
              : _isNoData
                  ? const MyNoDataWidget(msg: "No video details found.")
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (postDetailsData.media!.isNotEmpty) {
                                if (postDetailsData.media![0].media.toString().isNotEmpty) {
                                 /* if (postDetailsData.media![0].fileType == "youtube") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayerScreen(postDetailsData.media![0].media.toString(), postDetailsData.title.toString())));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayerPage(true, postDetailsData.media![0].media.toString(), postDetailsData.title.toString())));
                                  }*/
                                  setOrientation([
                                    DeviceOrientation.landscapeRight,
                                    DeviceOrientation.landscapeLeft
                                  ]);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VideoPlayerScreen("https://www.youtube.com/watch?v=fzGBRDpf5GU", postDetailsData.title.toString())));
                                } else {
                                  showSnackBar("Video not found.", context);
                                }
                              } else {
                                showSnackBar("Video not found.", context);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                              decoration: BoxDecoration(
                                  color: white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(width: 0.5, color: white.withOpacity(0.3), style: BorderStyle.solid)),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: FadeInImage.assetNetwork(
                                      image: postDetailsData.featuredImage.toString(),
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                      height: 250,
                                      placeholder: 'assets/images/bg_gray.jpeg',
                                    ),
                                  ),
                                  Container(
                                      height: 250,
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        "assets/images/play.png",
                                        width: 36,
                                        height: 36,
                                      ))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                            child: Text(postDetailsData.title.toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500, fontFamily: roboto)),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                            child: Text(
                              postDetailsData.saveTimestamp.toString(),
                              style: TextStyle(fontFamily: roboto, fontSize: 12, color: white, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(12, 22, 12, 6),
                            child: HtmlWidget(postDetailsData.description.toString(),
                                textStyle: const TextStyle(height: 1.5, color: white, fontSize: 15, fontWeight: FontWeight.w500, fontFamily: roboto)),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                            child: const Text(
                              "Related Videos",
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
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => VideoDetailsPage(postDetailsData.reatedPosts![index].id.toString())));
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 300,
                                                  margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      border: Border.all(width: 0.6, color: white.withOpacity(0.4), style: BorderStyle.solid)),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: 300,
                                                        width: MediaQuery.of(context).size.width,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(20), // Image border
                                                          child: SizedBox.fromSize(
                                                            size: const Size.fromRadius(20), // Image radius
                                                            child: Image.network(
                                                              postDetailsData.reatedPosts![index].featuredImage.toString(),
                                                              fit: BoxFit.fill,
                                                              width: MediaQuery.of(context).size.width,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 300,
                                                        decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            gradient: LinearGradient(
                                                                begin: FractionalOffset.topCenter,
                                                                end: FractionalOffset.bottomCenter,
                                                                colors: [
                                                                  black.withOpacity(0.4),
                                                                  black.withOpacity(1),
                                                                ],
                                                                stops: const [
                                                                  0.0,
                                                                  1.0
                                                                ]),
                                                            borderRadius: BorderRadius.circular(20)),
                                                      ),
                                                      Positioned.fill(
                                                        bottom: 50,
                                                        child: Container(
                                                          width: 46,
                                                          height: 46,
                                                          alignment: Alignment.center,
                                                          child: Image.asset(
                                                            'assets/images/play.png',
                                                            height: 46,
                                                            width: 46,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 32,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              margin: const EdgeInsets.only(top: 10, left: 22),
                                                              decoration: BoxDecoration(
                                                                color: bgOverlay,
                                                                borderRadius: BorderRadius.circular(30),
                                                              ),
                                                              child: const Padding(
                                                                padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                                                                child: Text(
                                                                  "National Flag",
                                                                  style: TextStyle(
                                                                      fontFamily: gilroy, fontWeight: FontWeight.w400, fontSize: 12, color: white),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                                alignment: Alignment.bottomLeft,
                                                                margin: const EdgeInsets.only(top: 14, left: 22, right: 10),
                                                                child: Text(postDetailsData.reatedPosts![index].title.toString(),
                                                                    overflow: TextOverflow.clip,
                                                                    style: const TextStyle(
                                                                        color: white,
                                                                        fontWeight: FontWeight.w400,
                                                                        fontFamily: gilroy,
                                                                        fontSize: 16,
                                                                        overflow: TextOverflow.clip))),
                                                            Container(
                                                              width: MediaQuery.of(context).size.width - 50,
                                                              margin: const EdgeInsets.only(
                                                                left: 12,
                                                                right: 22,
                                                                top: 14,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Container(
                                                                    alignment: Alignment.bottomRight,
                                                                    padding: const EdgeInsets.only(top: 6, bottom: 6, left: 10, right: 10),
                                                                    child: Text(postDetailsData.reatedPosts![index].saveTimestamp.toString(),
                                                                        style: const TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            fontFamily: aileron,
                                                                            fontSize: 12,
                                                                            color: white)),
                                                                  ),
                                                                  Container(
                                                                    alignment: Alignment.bottomRight,
                                                                    margin: const EdgeInsets.only(right: 6),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            if (postDetailsData.reatedPosts![index].media!.isNotEmpty) {
                                                                              if (postDetailsData.reatedPosts![index].media![0].media
                                                                                  .toString()
                                                                                  .isNotEmpty) {
                                                                                Share.share(
                                                                                    postDetailsData.reatedPosts![index].media![0].media.toString());
                                                                                _sharePost(postDetailsData.reatedPosts![index].id.toString());
                                                                                setState(() {
                                                                                  postDetailsData.reatedPosts![index].setSharesCount =
                                                                                      postDetailsData.reatedPosts![index].sharesCount! + 1;
                                                                                });
                                                                              } else {
                                                                                showSnackBar("Blog link not found.", context);
                                                                              }
                                                                            } else {
                                                                              showSnackBar("Blog link not found.", context);
                                                                            }
                                                                          },
                                                                          behavior: HitTestBehavior.opaque,
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(6.0),
                                                                            child: Image.asset(
                                                                              "assets/images/share.png",
                                                                              height: 22,
                                                                              color: darkGray,
                                                                              width: 22,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          postDetailsData.reatedPosts![index].sharesCount.toString(),
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w400,
                                                                              fontFamily: roboto,
                                                                              color: white),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )),
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
          if (NavigationService.notif_type.isNotEmpty) {
            NavigationService.notif_type = "";
            NavigationService.notif_post_id = "";
            Navigator.of(context)
                .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const BottomNavigationBarScreen(0)), (Route<dynamic> route) => false);
          } else {
            String data = "$postId|$shareCount";
            Navigator.pop(context, data);
          }
          return Future.value(true);
        });
  }

  @override
  void castStatefulWidget() {
    widget is VideoDetailsPage;
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
      'type_id': "3"
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
      showSnackBar(dataResponse.message, context);
      setState(() {
        _isNoData = true;
      });
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
      'post_id': postId.toString(),
      'user_id': sessionManager.getUserId().toString(),
      'type': "like",
      'comments': ""
    };
    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = CommanResponse.fromJson(apiResponse);

    if (statusCode == 200 && dataResponse.status == 1) {
    } else {
      setState(() {
        if (isLiked == 1) {
          isLiked = 0;
        } else {
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
      'post_id': postId.toString(),
      'user_id': sessionManager.getUserId().toString(),
      'type': "bookmark",
      'comments': ""
    };
    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = CommanResponse.fromJson(apiResponse);

    if (statusCode == 200 && dataResponse.status == 1) {
    } else {
      setState(() {
        if (isBookMark == 1) {
          isBookMark = 0;
        } else {
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
      'post_id': id.toString(),
      'user_id': sessionManager.getUserId().toString(),
      'type': "share",
      'comments': ""
    };

    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = CommanResponse.fromJson(apiResponse);

    if (statusCode == 200 && dataResponse.status == 1) {
    } else {
      showSnackBar(dataResponse.message, context);
    }
  }
}
