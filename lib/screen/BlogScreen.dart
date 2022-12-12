
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
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
  List<PostsData> blogList = List<PostsData>.empty(growable: true);

  @override
  void initState(){
    if (isOnline)
    {
      blogAPI();
    }
    else
      {
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
      blogAPI(true);
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
    return Scaffold (
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
                      final BottomNavigationBar bar = bottomWidgetKey.currentWidget as BottomNavigationBar;
                      bar.onTap!(0);
                    },
                    child: Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(6),
                      child: Image.asset('assets/images/ic_back_button.png',
                        height: 22, width: 22,color: white),
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 65,
                  margin: const EdgeInsets.only(left: 5),
                  child: const Text(
                    "Blog",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: white,
                        fontSize: 18),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        backgroundColor: black,
        resizeToAvoidBottomInset: true,
        body: _isLoading
            ? const LoadingWidget()
            : RefreshIndicator (
          color: orange,
          onRefresh: _refresh,
          child: Stack(
            children: [
              Visibility(
                visible: blogList.isEmpty,
                child: const MyNoDataWidget(msg: 'No blog data found!'),
              ),
              AnimationLimiter(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: blogList.length,
                  itemBuilder:(context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: (){
                              _viewDetails(context,blogList[index]);
                            },
                            child: Container(
                                margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(width: 0.6, color: white.withOpacity(0.4), style: BorderStyle.solid)
                                ),
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
                                                  margin: EdgeInsets.only(left: 14, right: 22, top:blogList[index].saveTimestamp.toString().isNotEmpty ? 10 : 22),
                                                  child: Text(
                                                    blogList[index].title.toString().trim(),
                                                    overflow: TextOverflow.clip,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(fontWeight: FontWeight.w600,
                                                        fontSize: 20,
                                                        fontFamily: aileron,
                                                        overflow: TextOverflow.clip,
                                                        foreground: Paint()..shader = linearGradient),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Stack(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only( right: 10,top: 12),
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
                                              Text(blogList[index].location.toString(), style: TextStyle(fontWeight: FontWeight.w400, fontFamily: aileron, fontSize: 12, color: lightGray)),
                                              blogList[index].location.toString().isNotEmpty ? Container(
                                                width: 6,
                                                height: 6,
                                                margin: const EdgeInsets.only(left: 6,right: 6),
                                                decoration: const BoxDecoration(
                                                  color: lightGray,
                                                  shape: BoxShape.circle,
                                                ),
                                              ) : Container(),
                                              Text(blogList[index].saveTimestamp.toString(), style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: aileron, fontSize: 12,
                                                  foreground:Paint()..shader = linearGradientForDate)),
                                            ],
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              if(blogList[index].media!.isNotEmpty)
                                              {
                                                if(blogList[index].media![0].media.toString().trim().isNotEmpty)
                                                {
                                                  Share.share(blogList[index].media![0].media.toString());
                                                }
                                              }
                                            },
                                            behavior: HitTestBehavior.opaque,
                                            child:  Container(
                                              width: 32,
                                              height: 32,
                                              padding: const EdgeInsets.all(6),
                                              child: Image.asset("assets/images/share.png", height: 22,
                                                  width: 22,color: white),
                                            ),
                                          ),
                                          Text(
                                            blogList[index].sharesCount.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
    );
  }

  Future<void> _viewDetails(BuildContext context,PostsData postsData) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => BlogDetailsScreen(postsData)));
   // print("result ===== $result");
    setState(() {
      for (int i = 0; i < blogList.length; i++) {
        if(blogList[i].id == result.id)
        {
          blogList[i].setIsLikeMain = result.isLiked;
        }
      }
    });
  }

  blogAPI([bool isPull = false]) async {
      if(!isPull)
      {
        setState(() {
          _isLoading = true;
        });
      }

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + posts);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'user_id' : sessionManager.getUserId().toString(),
      'page' : "0",
      'limit' : "50",
      'type_id' : "6"};
    final response = await http.post(
        url,
        body: jsonBody,
        headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = PostListResponse.fromJson(apiResponse);

    if (statusCode == 200 && dataResponse.success == 1) {
      if(dataResponse.posts !=null && dataResponse.posts!.isNotEmpty)
      {
        blogList = List<PostsData>.empty(growable: true);
        blogList.addAll(dataResponse.posts!);
      }
    } else {
      showSnackBar(dataResponse.message, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void castStatefulWidget() {
    widget is BlogScreen;
  }

}