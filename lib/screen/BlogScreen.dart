import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/CommanResponse.dart';
import '../model/PostListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/no_data.dart';
import 'BlogDetailsScreen.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  _BlogScreen createState() => _BlogScreen();
}

class _BlogScreen extends BaseState<BlogScreen> {
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 15;
  bool _isLastPage = false;
  bool isScrollingDown = false;
  late ScrollController _scrollViewController;
  List<PostsData> blogList = List<PostsData>.empty(growable: true);

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
      blogAPI(false, true);
    } else {
      noInterNet(context);
    }
    isBlogReload = false;
    super.initState();
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffFFFFFF), Color(0xffaaa9a3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final Shader linearGradientForDate = const LinearGradient(
    colors: <Color>[Color(0xffaaa9a3), Color(0xff72716d)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  Future<bool> _refresh() {
    print("refresh......");
    if (isInternetConnected) {
      blogAPI(true, true);
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
          blogAPI(false, false);
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
          backgroundColor: white,
          elevation: 0,
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*  InkWell(
                    onTap: () {
                      final BottomNavigationBar bar = bottomWidgetKey.currentWidget as BottomNavigationBar;
                      bar.onTap!(0);
                    },
                    child: Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(6),
                      child: Image.asset('assets/images/ic_back_button.png',
                        height: 22, width: 22,color: white),
                    )),*/
                Container(
                  alignment: Alignment.centerLeft,
                  height: 65,
                  margin: const EdgeInsets.only(left: 5),
                  child: const Text(
                    "Blog",
                    style: TextStyle(fontWeight: FontWeight.w600, color: black, fontFamily: roboto),
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
                    Expanded(
                        child: Stack(
                      children: [
                        Visibility(
                          visible: blogList.isEmpty,
                          child: const MyNoDataWidget(msg: 'No blog data found!'),
                        ),
                        AnimationLimiter(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            controller: _scrollViewController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: blogList.length,
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        _viewDetails(context, blogList[index]);
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(width: 0.6, color: black.withOpacity(0.4), style: BorderStyle.solid)),
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
                                                            margin: EdgeInsets.only(
                                                                left: 14,
                                                                right: 22,
                                                                top: blogList[index].saveTimestamp.toString().isNotEmpty ? 10 : 22),
                                                            child: Text(
                                                              blogList[index].title.toString().trim(),
                                                              overflow: TextOverflow.clip,
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                  fontWeight: titleFont,
                                                                  fontSize: 16,
                                                                  fontFamily: aileron,
                                                                  overflow: TextOverflow.clip,
                                                                  foreground: Paint()..shader = linearGradientForDate),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets.only(right: 10, top: 12),
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
                                                              blogList[index].featuredImage.toString(),
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
                                                        Text(blogList[index].location.toString(),
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w400, fontFamily: aileron, fontSize: 12, color: black)),
                                                        blogList[index].location.toString().isNotEmpty
                                                            ? Container(
                                                                width: 6,
                                                                height: 6,
                                                                margin: const EdgeInsets.only(left: 6, right: 6),
                                                                decoration: const BoxDecoration(
                                                                  color: black,
                                                                  shape: BoxShape.circle,
                                                                ),
                                                              )
                                                            : Container(),
                                                        Text(blogList[index].saveTimestamp.toString(),
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w400,
                                                                fontFamily: aileron,
                                                                fontSize: 12,
                                                                foreground: Paint()..shader = linearGradientForDate)),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (blogList[index].media!.isNotEmpty) {
                                                          if (blogList[index].media![0].media.toString().isNotEmpty) {
                                                            Share.share(blogList[index].media![0].media.toString());
                                                            _sharePost(blogList[index].id.toString());
                                                            setState(() {
                                                              blogList[index].setSharesCount = blogList[index].sharesCount! + 1;
                                                            });
                                                          } else {
                                                            showSnackBar("Blog link not found.", context);
                                                          }
                                                        } else {
                                                          showSnackBar("Blog link not found.", context);
                                                        }
                                                      },
                                                      behavior: HitTestBehavior.opaque,
                                                      child: Container(
                                                        width: 32,
                                                        height: 32,
                                                        padding: const EdgeInsets.all(6),
                                                        child: Image.asset("assets/images/share.png", height: 22, width: 22, color: white),
                                                      ),
                                                    ),
                                                    Text(
                                                      blogList[index].sharesCount.toString(),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
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
                                      child: const Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: CircularProgressIndicator(color: white, strokeWidth: 2),
                                      ))),
                              const Text(' Loading more...', style: TextStyle(color: white, fontWeight: FontWeight.w400, fontSize: 16))
                            ],
                          ),
                        ))
                  ],
                ),
              ));
  }

  Future<void> _viewDetails(BuildContext context, PostsData postsData) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => BlogDetailsScreen(postsData.id.toString())));
    print("result ===== $result");
    setState(() {
      var data = result.toString().split("|");
      for (int i = 0; i < blogList.length; i++) {
        if (blogList[i].id == data[0]) {
          blogList[i].setSharesCount = num.parse(data[1]);
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

  blogAPI([bool isPull = false, bool isFirstTime = false]) async {
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
      'type_id': "6"
    };
    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = PostListResponse.fromJson(apiResponse);

    if (isFirstTime) {
      if (blogList.isNotEmpty) {
        blogList = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1) {
      if (dataResponse.posts != null && dataResponse.posts!.isNotEmpty) {
        List<PostsData>? _tempList = [];
        _tempList = dataResponse.posts;
        blogList.addAll(_tempList!);

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
    widget is BlogScreen;
  }
}
