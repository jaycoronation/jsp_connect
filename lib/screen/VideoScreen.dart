import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jspl_connect/model/DashBoardDataResponse.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/CommanResponse.dart';
import '../model/PostListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/loading_more.dart';
import '../widget/no_data.dart';
import '../widget/video_block.dart';
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
  var listVideo = List<Posts>.empty(growable: true);

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
        backgroundColor: screenBg,
        elevation: 0,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Container(
                  alignment: Alignment.centerLeft,
                  height: 65,
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(
                    "Videos",
                    style:TextStyle(fontWeight: FontWeight.w600, color: black, fontFamily: roboto),
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
                                  child: VideoBlock(listVideos: listVideo,index: index,setState: setState),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  )),
                  Visibility(visible : _isLoadingMore,child: const LoadingMoreWidget())
                ],
              ),
            ),
    );
  }

  mainClick(int index) async {
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
  }

  shareClick(int index) {
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

        List<Posts>? _tempList = [];
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
