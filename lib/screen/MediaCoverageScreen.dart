import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jspl_connect/widget/loading_more.dart';
import 'package:jspl_connect/widget/news_block.dart';
import 'package:jspl_connect/widget/no_data.dart';
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
import 'CommonDetailsScreen.dart';
import 'MediaCoverageDetailsScreen.dart';

class MediaCoverageScreen extends StatefulWidget {
  const MediaCoverageScreen({Key? key}) : super(key: key);

  @override
  _MediaCoverageScreen createState() => _MediaCoverageScreen();
}

class _MediaCoverageScreen extends BaseState<MediaCoverageScreen> {
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 15;
  bool _isLastPage = false;
  bool isScrollingDown = false;
  late ScrollController _scrollViewController;
  List<Posts> listMedia = [];
  
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

    if (isOnline)
    {
      listData(true);
    }
    else
    {
      noInterNet(context);
    }
    super.initState();
  }

  void pagination() {
    if (!_isLastPage && !_isLoadingMore) {
      if ((_scrollViewController.position.pixels == _scrollViewController.position.maxScrollExtent)) {
        setState(() {
          _isLoadingMore = true;
          listData(false);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 42,
                        height: 42,
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(12),
                        child: Image.asset('assets/images/ic_back_button.png',
                          height: 32, width: 32,color: black),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 65,
                    margin: const EdgeInsets.only(left: 5),
                    child: Text(
                      "Media Coverage",
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
              ? const LoadingWidget() : listMedia.isEmpty ? MyNoDataWidget(msg: 'No media coverage data found!')
              : Column(
                  children: [
                    Expanded(child: SingleChildScrollView(
                      controller: _scrollViewController,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                            child: Column(
                              children: [
                                AnimationLimiter(
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: const NeverScrollableScrollPhysics(),
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: listMedia.length,
                                      itemBuilder: (ctx, index) => AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration: const Duration(milliseconds: 375),
                                        child:  SlideAnimation(
                                          verticalOffset: 50.0,
                                          child: FadeInAnimation(
                                              child: NewsBlock(listNews: listMedia, index: index, isFromNews: false, setState: setState)
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                    Visibility(visible : _isLoadingMore,child: LoadingMoreWidget())
                  ],
                ),
        ),
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        });
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

  listData([bool isFirstTime = false]) async {
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
      'user_id' : sessionManager.getUserId().toString(),
      'limit': _pageResult.toString(),
      'page': _pageIndex.toString(),
      'type_id' : "8"};
    final response = await http.post(
        url,
        body: jsonBody,
        headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = PostListResponse.fromJson(apiResponse);

    if (isFirstTime) {
      if (listMedia.isNotEmpty) {
        listMedia = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1) {
      if(dataResponse.posts !=null && dataResponse.posts!.isNotEmpty)
      {

        List<Posts>? _tempList = [];
        _tempList = dataResponse.posts;
        listMedia.addAll(_tempList!);

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
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
      showSnackBar(dataResponse.message, context);
    }
  }

  @override
  void castStatefulWidget() {
    widget is MediaCoverageScreen;
  }

}