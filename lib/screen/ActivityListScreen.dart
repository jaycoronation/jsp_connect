import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:jspl_connect/widget/loading_more.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/CommanResponse.dart';
import '../model/DashBoardDataResponse.dart';
import '../model/PostListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/no_data.dart';
import '../widget/social_block.dart';
import '../widget/whats_new_block.dart';

class ActivityListScreen extends StatefulWidget {
  final String typeId;
  const ActivityListScreen(this.typeId, {Key? key}) : super(key: key);

  @override
  _ActivityListScreen createState() => _ActivityListScreen();
}

class _ActivityListScreen extends BaseState<ActivityListScreen> {
  String typeId = "";
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 15;
  bool _isLastPage = false;
  bool isScrollingDown = false;
  late ScrollController _scrollViewController;
  List<Posts> listActivityList = List<Posts>.empty(growable: true);

  @override
  void initState() {
     typeId = (widget as ActivityListScreen).typeId.toString();
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

  final Shader linearGradientSocial = const LinearGradient(
    colors: <Color>[Color(0xffFFFFFF), Color(0xff9b9b98)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 800.0, 120.0));

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
            titleSpacing: 0,
            leading: GestureDetector(
              behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(6),
                  child: Image.asset('assets/images/ic_back_button.png', height: 22, width: 22, color: black),
                )),
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
                      typeId,
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
              ? const LoadingWidget() : listActivityList.isEmpty ? const MyNoDataWidget(msg: 'No post found!')
              : Column(
                  children: [
                    Expanded(
                        child: AnimationLimiter(
                           child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              controller: _scrollViewController,
                              itemCount: listActivityList.length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: WhatsNewBlock(listData: listActivityList, index: index,setState: setState),
                                    ),
                                  ),
                                );
                              },
                            ),
                      )
                    ),
                    Visibility(
                        visible: _isLoadingMore,
                        child: const LoadingMoreWidget())
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
    Map<String, String> jsonBody = {};

      if(typeId == "What's New")
      {
        jsonBody = {
          'from_app': FROM_APP,
          'user_id': sessionManager.getUserId().toString(),
          'limit': _pageResult.toString(),
          'page': _pageIndex.toString(),
          'is_new': "1"
        };
      }
      else if(typeId == "Favourite Post")
        {
          jsonBody = {
            'from_app': FROM_APP,
            'user_id': sessionManager.getUserId().toString(),
            'limit': _pageResult.toString(),
            'page': _pageIndex.toString(),
            'is_like': "1"
          };
        }
      else
        {
          jsonBody = {
            'from_app': FROM_APP,
            'user_id': sessionManager.getUserId().toString(),
            'limit': _pageResult.toString(),
            'page': _pageIndex.toString(),
            'is_bookmark': "1"
          };
        }

    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = PostListResponse.fromJson(apiResponse);

    if (isFirstTime) {
      if (listActivityList.isNotEmpty) {
        listActivityList = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1) {
      if (dataResponse.posts != null && dataResponse.posts!.isNotEmpty) {
        List<Posts>? _tempList = [];
        _tempList = dataResponse.posts;
        listActivityList.addAll(_tempList!);

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
    widget is ActivityListScreen;
  }
}
