import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/PostListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/no_data.dart';
import 'GalleryScreen.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({Key? key}) : super(key: key);

  @override
  _AlbumScreen createState() => _AlbumScreen();
}

class _AlbumScreen extends BaseState<AlbumScreen> {
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 15;
  bool _isLastPage = false;
  bool isScrollingDown = false;
  late ScrollController _scrollViewController;
  var listGallery = List<PostsData>.empty(growable: true);

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
      _AlbumApi(false,true);
    } else {
      noInterNet(context);
    }
    isGalleryReload= false;
    super.initState();
  }

  Future<bool> _refresh() {
    print("refresh......");
    if (isInternetConnected) {
      _AlbumApi(true,true);
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
          _AlbumApi(false,false);
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
          backgroundColor: black,
          elevation: 0,
          centerTitle: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    final BottomNavigationBar bar = bottomWidgetKey.currentWidget as BottomNavigationBar;
                    bar.onTap!(0);
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
                  "Photo Gallery",
                  style: TextStyle(fontWeight: FontWeight.w600, color: white, fontSize: 16),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        backgroundColor: black,
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
                        Visibility(visible: listGallery.isEmpty, child: MyNoDataWidget(msg: 'No photo gallery data found!')),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AnimationLimiter(
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, mainAxisExtent: 300, crossAxisSpacing: 2, mainAxisSpacing: 2),
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: listGallery.length,
                              controller: _scrollViewController,
                              itemBuilder: (BuildContext context, int index) {
                                return AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  columnCount: 2,
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (listGallery[index].media!.isNotEmpty)
                                          {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryScreen(listGallery[index])));
                                          }
                                          else
                                          {
                                            showSnackBar("Album data not found.", context);
                                          }
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 12),
                                          child: Stack(children: [
                                            Container(
                                              margin: const EdgeInsets.only(left: 4, right: 4),
                                              decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(20)),
                                              height: 300,
                                              width: MediaQuery.of(context).size.width,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: SizedBox.fromSize(
                                                  size: const Size.fromRadius(20), // Image radius
                                                  child: FadeInImage.assetNetwork(
                                                    image: listGallery[index].featuredImage.toString(),
                                                    fit: BoxFit.cover,
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 300,
                                                    placeholder: 'assets/images/bg_gray.jpeg',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(left: 4, right: 4),
                                              height: 300,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  gradient:
                                                  LinearGradient(begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, colors: [
                                                    black.withOpacity(0.1),
                                                    black.withOpacity(1),
                                                  ], stops: const [
                                                    0.0,
                                                    1.0
                                                  ]),
                                                  borderRadius: BorderRadius.circular(20)),
                                            ),
                                            Positioned(
                                                top: 12,
                                                right: 12,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    color: white.withOpacity(0.2),
                                                  ),
                                                  padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/album.png",
                                                        width: 18,
                                                        height: 18,
                                                      ),
                                                      Container(
                                                        width: 6,
                                                      ),
                                                      Text(
                                                        listGallery[index].media!.length.toString(),
                                                        style: TextStyle(color: white, fontSize: 12, fontFamily: roboto, fontWeight: FontWeight.w400),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                            Positioned(
                                              bottom: 12,
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context).size.width / 2 - 50,
                                                  margin: const EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 20),
                                                  child: Text(
                                                    toDisplayCase(listGallery[index].title.toString()).replaceAll(" ", "\n"),
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                        foreground: Paint()..shader = linearGradient,
                                                        fontWeight: titleFont,
                                                        fontFamily: gilroy,
                                                        fontSize: 16,
                                                        overflow: TextOverflow.clip
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )),
                                            )
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
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
              ));
  }

  _AlbumApi([bool isPull = false,bool isFirstTime = false]) async {
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
    Map<String, String> jsonBody = {'from_app': FROM_APP,
      'limit': _pageResult.toString(),
      'page': _pageIndex.toString(),
      'type_id': "5"};
    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = PostListResponse.fromJson(apiResponse);

    if (isFirstTime) {
      if (listGallery.isNotEmpty) {
        listGallery = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1) {
      if (dataResponse.posts != null && dataResponse.posts!.isNotEmpty) {


        List<PostsData>? _tempList = [];
        _tempList = dataResponse.posts;
        listGallery.addAll(_tempList!);

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

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffFFFFFF), Color(0xffaaa9a3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  void castStatefulWidget() {
    widget is AlbumScreen;
  }
}
