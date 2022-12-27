import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jspl_connect/widget/event_block.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/CommanResponse.dart';
import '../model/DashBoardDataResponse.dart';
import '../model/PostListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/news_block.dart';
import '../widget/no_data.dart';
import 'BlogDetailsScreen.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({Key? key}) : super(key: key);

  @override
  _NewsListScreen createState() => _NewsListScreen();
}

class _NewsListScreen extends BaseState<NewsListScreen> {
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 15;
  bool _isLastPage = false;
  bool isScrollingDown = false;
  late ScrollController _scrollViewController;
  List<Posts> postList = List<Posts>.empty(growable: true);

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
      getApiData(false, true);
    } else {
      noInterNet(context);
    }
    isBlogReload = false;
    super.initState();
  }

  Future<bool> _refresh() {
    print("refresh......");
    if (isInternetConnected) {
      getApiData(true, true);
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
          getApiData(false, false);
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
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(6),
                      child: Image.asset('assets/images/ic_back_button.png',
                          height: 22, width: 22,color: black),
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 65,
                  margin: const EdgeInsets.only(left: 5),
                  child: Text(
                    "News List",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: black,
                        fontSize: 18),
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
                    Expanded(
                        child: Stack(
                        children: [
                          Visibility(
                            visible: postList.isEmpty,
                            child: const MyNoDataWidget(msg: 'No News data found!'),
                          ),
                          AnimationLimiter(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              controller: _scrollViewController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: postList.length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: Column(
                                        children: [
                                          NewsBlock(listNews: postList,index: index,setState: setState, isFromNews: false,),
                                          Container(height: index == postList.length - 1 ? 20 : 0,)
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                    )),
                    Visibility(
                        visible: _isLoadingMore,
                        child: Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xff444444),
                                            width: 1,
                                          )),
                                      child:  Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: CircularProgressIndicator(color: white, strokeWidth: 2),
                                      ))),
                               Text(' Loading more...', style: TextStyle(color: white, fontWeight: FontWeight.w400, fontSize: 16))
                            ],
                          ),
                        ))
                  ],
                ),
              ));
  }

  Future<void> _viewDetails(BuildContext context, Posts postsData) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => BlogDetailsScreen(postsData.id.toString())));
    print("result ===== $result");
    setState(() {
      var data = result.toString().split("|");
      for (int i = 0; i < postList.length; i++) {
        if (postList[i].id == data[0]) {
          postList[i].setSharesCount = num.parse(data[1]);
          break;
        }
      }
    });
  }

  _sharePost(String postId) async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + postMetaSave);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'post_id': postId.toString(),
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

  getApiData([bool isPull = false, bool isFirstTime = false]) async {
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
      'type_id': "4"
    };
    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = PostListResponse.fromJson(apiResponse);

    if (isFirstTime) {
      if (postList.isNotEmpty) {
        postList = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1) {
      if (dataResponse.posts != null && dataResponse.posts!.isNotEmpty) {
        List<Posts>? _tempList = [];
        _tempList = dataResponse.posts;
        postList.addAll(_tempList!);

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
    widget is NewsListScreen;
  }
}
