import 'dart:convert';
import 'package:flutter/material.dart';
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
  var listGallery = List<PostsData>.empty(growable: true);

  @override
  void initState() {
    if (isOnline) {
      _AlbumApi();
    } else {
      noInterNet(context);
    }
    isGalleryReload= false;
    super.initState();
  }

  Future<bool> _refresh() {
    print("refresh......");
    if (isInternetConnected) {
      _AlbumApi(true);
    } else {
      noInterNet(context);
    }
    return Future.value(true);
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
                child: Stack(
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
                                                toDisplayCase(listGallery[index].title.toString().replaceAll(" ", "\n")),
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                  fontFamily: gilroy,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 16,
                                                  foreground: Paint()..shader = linearGradient,
                                                  overflow: TextOverflow.clip,
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
                ),
              ));
  }

  _AlbumApi([bool isPull = false]) async {
    if (!isPull) {
      setState(() {
        _isLoading = true;
      });
    }

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + posts);
    Map<String, String> jsonBody = {'from_app': FROM_APP, 'page': "0", 'limit': "50", 'type_id': "5"};
    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = PostListResponse.fromJson(apiResponse);

    if (statusCode == 200 && dataResponse.success == 1) {
      if (dataResponse.posts != null && dataResponse.posts!.isNotEmpty) {
        listGallery = List<PostsData>.empty(growable: true);
        listGallery.addAll(dataResponse.posts!);
      }
    } else {
      showSnackBar(dataResponse.message, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffFFFFFF), Color(0xffaaa9a3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  void castStatefulWidget() {
    widget is AlbumScreen;
  }
}
