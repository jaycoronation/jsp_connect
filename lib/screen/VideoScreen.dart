import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../constant/global_context.dart';
import '../model/CommanResponse.dart';
import '../model/PostListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/no_data.dart';
import 'VideoDetailsPage.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreen createState() => _VideoScreen();
}

class _VideoScreen extends BaseState<VideoScreen> {
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 15;
  bool _isLastPage = false;
  bool isScrollingDown = false;
  late ScrollController _scrollViewController;
  var listVideo = List<PostsData>.empty(growable: true);

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffFFFFFF), Color(0xffaaa9a3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

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
      _VideoApi(false,true);
    } else {
      noInterNet(context);
    }
    isVideoReload = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        automaticallyImplyLeading: false,
        backgroundColor: white,
        elevation: 0,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               /*InkWell(
                  onTap: () {
                    final BottomNavigationBar bar = bottomWidgetKey.currentWidget as BottomNavigationBar;
                    bar.onTap!(0);
                  },
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(
                      'assets/images/ic_back_button.png',
                      height: 22,
                      width: 22,
                      color: white,
                    ),
                  )),*/
                Container(
                alignment: Alignment.centerLeft,
                height: 65,
                margin: const EdgeInsets.only(left: 5),
                child: const Text(
                  "Videos",
                  style:TextStyle(fontWeight: FontWeight.w600, color: black, fontFamily: roboto),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      backgroundColor: white,
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
                        visible: listVideo.isEmpty,
                        child: const MyNoDataWidget(msg: 'No video data found!'),
                      ),
                      AnimationLimiter(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          controller: _scrollViewController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: listVideo.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => VideoDetailsPage(listVideo[index].id.toString())));
                                      print("result ===== $result");
                                      setState(() {
                                        var data = result.toString().split("|");
                                        for (int i = 0; i < listVideo.length; i++) {
                                          if(listVideo[i].id == data[0])
                                          {
                                            listVideo[i].setSharesCount = num.parse(data[1]);
                                            break;
                                          }
                                        }
                                      });
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
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(20), // Image border
                                            child: Image.network(
                                              listVideo[index].featuredImage.toString(),
                                              fit: BoxFit.cover,
                                              height: 300,
                                              width: MediaQuery.of(context).size.width,
                                            ),
                                          ),
                                          Container(
                                            height: 300,
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                gradient:
                                                LinearGradient(begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, colors: [
                                                  black.withOpacity(0.4),
                                                  black.withOpacity(1),
                                                ], stops: const [
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
                                                    width: MediaQuery.of(context).size.width - 50,
                                                    alignment: Alignment.bottomLeft,
                                                    margin: const EdgeInsets.only(top: 14, left: 22, right: 10),
                                                    child: Text(listVideo[index].title.toString(),
                                                        overflow: TextOverflow.clip,
                                                        style: TextStyle(
                                                            foreground: Paint()..shader = linearGradient,
                                                            fontWeight: titleFont,
                                                            fontFamily: gilroy,
                                                            fontSize: 16,
                                                            overflow: TextOverflow.clip))),
                                                Container(
                                                  width: MediaQuery.of(context).size.width - 50,
                                                  margin: const EdgeInsets.only(
                                                    left: 12,
                                                    right: 22,
                                                    top: 10,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 6, bottom: 6, left: 10, right: 10),
                                                        child: Row(
                                                          children: [
                                                            Text(listVideo[index].location.toString(), style: const TextStyle(fontWeight: FontWeight.w500, fontFamily: aileron, fontSize: 12, color: lightGray)),
                                                            listVideo[index].location.toString().isNotEmpty ? Container(
                                                              width: 6,
                                                              height: 6,
                                                              margin: const EdgeInsets.only(left: 6,right: 6),
                                                              decoration: const BoxDecoration(
                                                                color: lightGray,
                                                                shape: BoxShape.circle,
                                                              ),
                                                            ) : Container(),
                                                            Text(listVideo[index].saveTimestamp.toString(), style: const TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                fontFamily: aileron, fontSize: 12,
                                                                color: lightGray)),
                                                          ],
                                                        ),
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
                                                                if(listVideo[index].media!.isNotEmpty)
                                                                {
                                                                  if(listVideo[index].media![0].media.toString().isNotEmpty)
                                                                  {
                                                                    Share.share(listVideo[index].media![0].media.toString());
                                                                    _sharePost(listVideo[index].id.toString());
                                                                    setState(() {
                                                                      listVideo[index].setSharesCount = listVideo[index].sharesCount! + 1;
                                                                    });
                                                                  }
                                                                  else
                                                                  {
                                                                    showSnackBar("Video link not found.", context);
                                                                  }
                                                                }
                                                                else
                                                                {
                                                                  showSnackBar("Video link not found.", context);
                                                                }
                                                              },
                                                              behavior: HitTestBehavior.opaque,
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(6.0),
                                                                child: Image.asset(
                                                                  "assets/images/share.png",
                                                                  height: 22,
                                                                  color: white,
                                                                  width: 22,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              listVideo[index].sharesCount.toString(),
                                                              textAlign: TextAlign.center,
                                                              style: const TextStyle(
                                                                  fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                                            ),
                                                            /* GestureDetector(
                                                                onTap: (){
                                                                 */ /* setState(() {
                                                                    listVideo[index].isLike = !listVideo[index].isLike;
                                                                  });*/ /*
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(6.0),
                                                                  child: Image.asset(
                                                                    listVideo[index].isLiked == 1
                                                                    ? "assets/images/like_filled.png"
                                                                    : "assets/images/like.png",
                                                                    height: 22,
                                                                    color: listVideo[index].isLiked == 1
                                                                        ? Colors.red : darkGray,
                                                                    width: 22,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(listVideo[index].likesCount.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,fontFamily: roboto,color: white),),*/
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
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
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
                                child: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: CircularProgressIndicator(color: white,strokeWidth: 2),
                                )
                            )),
                        const Text(' Loading more...',
                            style: TextStyle(color: white, fontWeight: FontWeight.w400, fontSize: 16)
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ),
    );
  }

  _sharePost(String postId) async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + postMetaSave);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'post_id' : postId.toString(),
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

  Future<bool> _refresh() {
    print("refresh......");
    if (isInternetConnected) {
      _VideoApi(true,true);
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
          _VideoApi(false,false);
        });
      }
    }
  }

  _VideoApi([bool isPull = false,bool isFirstTime = false]) async {
    if (isFirstTime) {
      setState(() {
        _isLoading = true;
        _isLoadingMore = false;
        _pageIndex = 0;
        _isLastPage = false;
      });
    }

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + posts);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'user_id': sessionManager.getUserId().toString(),
      'limit': _pageResult.toString(),
      'page': _pageIndex.toString(),
      'type_id': "3"
    };
    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = PostListResponse.fromJson(apiResponse);

    if (isFirstTime) {
      if (listVideo.isNotEmpty) {
        listVideo = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1) {
      if (dataResponse.posts != null && dataResponse.posts!.isNotEmpty) {

        List<PostsData>? _tempList = [];
        _tempList = dataResponse.posts;
        listVideo.addAll(_tempList!);

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
    widget is VideoScreen;
  }
}
