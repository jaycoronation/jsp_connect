import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jspl_connect/widget/no_data.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/PostListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import 'MediaCoverageDetailsScreen.dart';

class MediaCoverageScreen extends StatefulWidget {
  const MediaCoverageScreen({Key? key}) : super(key: key);

  @override
  _MediaCoverageScreen createState() => _MediaCoverageScreen();
}

class _MediaCoverageScreen extends BaseState<MediaCoverageScreen> {
  bool _isLoading = false;
  List<PostsData> listMedia = [];
  
  @override
  void initState() {
    if (isOnline)
    {
      listData();
    }
    else
    {
      noInterNet(context);
    }
    super.initState();
  }

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
                          height: 32, width: 32,color: white),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 65,
                    margin: const EdgeInsets.only(left: 5),
                    child: const Text(
                      "Media Coverage",
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
              ? const LoadingWidget() : listMedia.isEmpty ? MyNoDataWidget(msg: 'No media coverage data found!')
              : SingleChildScrollView(
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
                                        child: GestureDetector(
                                          onTap: () async {
                                            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => MediaCoverageDetailsScreen(listMedia[index])));
                                            setState(() {
                                              for (int i = 0; i < listMedia.length; i++) {
                                                if(listMedia[i].id == result.id)
                                                {
                                                  listMedia[i].setIsLikeMain = result.isLiked;
                                                }
                                              }
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: lightblack,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            margin: const EdgeInsets.only(top: 12),
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(listMedia[index].location.toString(),
                                                              overflow: TextOverflow.clip,
                                                              textAlign: TextAlign.start,
                                                              style: const TextStyle(fontWeight: FontWeight.w400, fontFamily: roboto, fontSize: 12, color: white,overflow: TextOverflow.clip)),
                                                          Container(
                                                            margin: const EdgeInsets.only(top: 8),
                                                            child: Text(listMedia[index].title.toString(),
                                                                overflow: TextOverflow.clip,
                                                                textAlign: TextAlign.start,
                                                                style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: roboto, fontSize: 16, color: white,overflow: TextOverflow.clip)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(width: 8),
                                                    Stack(
                                                      children: [
                                                        ClipRRect(
                                                            borderRadius: BorderRadius.circular(12),
                                                            child: Image.network(
                                                             listMedia[index].featuredImage.toString(),
                                                              height: 80,
                                                              width: 80,
                                                              fit: BoxFit.cover,
                                                            )
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Container(height: 12,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                          color: white.withOpacity(0.2)
                                                      ),
                                                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                                      child: Text(listMedia[index].saveTimestamp.toString(),
                                                          overflow: TextOverflow.clip,
                                                          textAlign: TextAlign.start,
                                                          style: const TextStyle(fontWeight: FontWeight.w500, fontFamily: roboto, fontSize: 12, color: yellow,overflow: TextOverflow.clip)),
                                                    ),
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: (){
                                                            Share.share("");
                                                          },
                                                          child: Container(
                                                            width: 32,
                                                            height: 32,
                                                            padding: EdgeInsets.all(6),
                                                            child: Image.asset("assets/images/share.png",color: white),
                                                          ),
                                                        ),
                                                        Container(width: 12,),
                                                        Image.asset(
                                                          "assets/images/ic_arrow_right_new.png",
                                                          height: 18,
                                                          width: 18,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
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
              ),
        ),
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        });
  }


  listData() async {
    setState(() {
      _isLoading = true;
    });

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + posts);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'user_id' : sessionManager.getUserId().toString(),
      'page' : "0",
      'limit' : "50",
      'type_id' : "8"};
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
        listMedia.addAll(dataResponse.posts!);
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
    widget is MediaCoverageScreen;
  }

}