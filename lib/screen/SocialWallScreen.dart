import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/CommanResponse.dart';
import '../model/PostListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/no_data.dart';

class SocialWallScreen extends StatefulWidget {
  const SocialWallScreen({Key? key}) : super(key: key);

  @override
  _SocialWallScreen createState() => _SocialWallScreen();
}

class _SocialWallScreen extends BaseState<SocialWallScreen> {
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 15;
  bool _isLastPage = false;
  bool isScrollingDown = false;
  late ScrollController _scrollViewController;
  List<PostsData> listSocial = List<PostsData>.empty(growable: true);

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
      socialAPI(false, true);
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
          socialAPI(false, false);
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
                        child: Image.asset('assets/images/ic_back_button.png', height: 22, width: 22, color: white),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 65,
                    margin: const EdgeInsets.only(left: 5),
                    child: const Text(
                      "Social",
                      style: TextStyle(fontWeight: FontWeight.w600, color: white, fontSize: 18),
                    ),
                  ),
                  const Spacer(),
                  /* Container(
                    decoration: BoxDecoration(
                      color: bgMain,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: Row(
                      children: [
                        Image.asset("assets/images/view.png",height: 12,width: 12,),
                        Container(width: 6),
                        const Text("8k Views",textAlign: TextAlign.center,style: TextStyle(color: white,fontSize: 14,fontWeight: FontWeight.w400,fontFamily: gilroy,),),
                      ],
                    ),
                  )*/
                ],
              ),
            ),
          ),
          backgroundColor: black,
          resizeToAvoidBottomInset: true,
          body: _isLoading
              ? const LoadingWidget() : listSocial.isEmpty ? const MyNoDataWidget(msg: 'No social media data found!')
              : Column(
                  children: [
                    Expanded(
                        child: AnimationLimiter(
                           child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          controller: _scrollViewController,
                          itemCount: listSocial.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (listSocial[index].socialMediaLink!.isNotEmpty) {
                                        if (await canLaunchUrl(Uri.parse(listSocial[index].socialMediaLink!.toString()))) {
                                          launchUrl(Uri.parse(listSocial[index].socialMediaLink!.toString()), mode: LaunchMode.externalNonBrowserApplication);
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 350,
                                      margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(width: 0.2, color: white.withOpacity(0.4), style: BorderStyle.solid)),
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            height: 350,
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context).size.width,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(30), // Image border
                                              child: Image.network(
                                                listSocial[index].featuredImage.toString(),
                                                fit: BoxFit.cover,
                                                height: 350,
                                                width: MediaQuery.of(context).size.width,
                                              ),
                                            ),
                                          ),
                                          Container(
                                              margin: const EdgeInsets.only(right: 14, top: 14),
                                              alignment: Alignment.topRight,
                                              child: Image.asset(
                                                listSocial[index].socialMediaType.toString() == "Facebook"
                                                    ? "assets/images/facebook.png"
                                                    : listSocial[index].socialMediaType.toString() == "Twitter"
                                                        ? "assets/images/ic_twitter.png"
                                                        : "assets/images/ic_insta.png",
                                                height: 24,
                                                width: 24,
                                                color: white,
                                              )),
                                          Container(
                                            height: 350,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(30),
                                                gradient:
                                                    LinearGradient(begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, colors: [
                                                  black.withOpacity(0.0),
                                                  black,
                                                ], stops: const [
                                                  0.2,
                                                  1.0
                                                ])),
                                          ),
                                          Positioned(
                                            bottom: 12,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    width: MediaQuery.of(context).size.width - 50,
                                                    margin: const EdgeInsets.only(bottom: 0, left: 14, right: 14),
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      listSocial[index].shortDescription.toString(),
                                                      style: TextStyle(
                                                          foreground: Paint()..shader = linearGradientSocial,
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: gilroy,
                                                          fontSize: 16,
                                                          overflow: TextOverflow.clip),
                                                      overflow: TextOverflow.clip,
                                                    )),
                                                Container(
                                                  width: MediaQuery.of(context).size.width - 60,
                                                  margin: const EdgeInsets.only(left: 14, right: 14, top: 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        alignment: Alignment.centerLeft,
                                                        padding: const EdgeInsets.only(top: 8, bottom: 8,  right: 10),
                                                        child: Text(listSocial[index].saveTimestamp.toString(),
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight.w400, fontFamily: aileron, fontSize: 14, color: lightGray)),
                                                      ),
                                                      Expanded(child: Container()),
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (listSocial[index].socialMediaLink!.isNotEmpty) {
                                                            Share.share(listSocial[index].socialMediaLink.toString());
                                                            _sharePost(listSocial[index].id.toString());
                                                            setState(() {
                                                              listSocial[index].setSharesCount = listSocial[index].sharesCount! + 1;
                                                            });
                                                          } else {
                                                            showSnackBar("Social link not found.", context);
                                                          }
                                                        },
                                                        behavior: HitTestBehavior.opaque,
                                                        child: Image.asset(
                                                          "assets/images/share.png",
                                                          height: 24,
                                                          color: darkGray,
                                                          width: 24,
                                                        ),
                                                      ),
                                                      Gap(6),
                                                      Text(
                                                        listSocial[index].sharesCount.toString(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
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

  socialAPI([bool isPull = false, bool isFirstTime = false]) async {
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
      'type_id': "1"
    };
    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = PostListResponse.fromJson(apiResponse);

    if (isFirstTime) {
      if (listSocial.isNotEmpty) {
        listSocial = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1) {
      if (dataResponse.posts != null && dataResponse.posts!.isNotEmpty) {
        List<PostsData>? _tempList = [];
        _tempList = dataResponse.posts;
        listSocial.addAll(_tempList!);

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
    widget is SocialWallScreen;
  }
}
