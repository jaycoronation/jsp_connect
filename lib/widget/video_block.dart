import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jspl_connect/screen/CommonDetailsScreen.dart';
import 'package:jspl_connect/utils/session_manager.dart';
import 'package:like_button/like_button.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/CommanResponse.dart';
import '../model/DashBoardDataResponse.dart';
import '../screen/VideoDetailsPage.dart';
import '../utils/app_utils.dart';

class VideoBlock extends StatelessWidget {
  final List<Posts> listVideos;
  final int index;
  final StateSetter setState;

  const VideoBlock({Key? key, required this.listVideos, required this.index, required this.setState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CommonDetailsScreen(listVideos[index].id.toString(),"3")));
        print("result ===== $result");
        setState(() {
          var data = result.toString().split("|");
          for (int i = 0; i < listVideos.length; i++) {
            if(listVideos[i].id == data[0])
            {
              listVideos[i].setSharesCount = num.parse(data[1]);
              break;
            }
          }
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 450,
        margin: const EdgeInsets.only(left: 12, right: 12,bottom: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 0.6, color: black.withOpacity(0.4), style: BorderStyle.solid)
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(listVideos[index].featuredImage.toString(),
                  width: MediaQuery.of(context).size.width, height: 450, fit: BoxFit.cover),
            ),
            Container(
              height: 450,
              decoration: BoxDecoration(
                  color: Colors.black,
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        blackConst.withOpacity(0.2),
                        blackConst.withOpacity(1),
                      ],
                      stops: const [
                        0.8,
                        1.0
                      ]
                  ),
                  borderRadius: BorderRadius.circular(20)
              ),
            ),
            Positioned.fill(
              child: Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/play.png',
                  height: 46,
                  width: 46,
                ),
              ),
            ),
            /*Positioned(
                                        top: 16,
                                        left: 16,
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(22),
                                            color: whiteConst.withOpacity(0.9)
                                          ),
                                          alignment: Alignment.center,
                                          child: const Text("8:10 mins",style: TextStyle(color: blackConst,fontSize: 12,fontWeight: FontWeight.w500,fontFamily: roboto)),
                                        )
                                    ),*/
            Positioned(
                bottom: 22,
                left: 16,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: white.withOpacity(0.2)
                      ),
                      alignment: Alignment.center,
                      child: Text(listVideos[index].location.toString(),style: const TextStyle(color: blackConst,fontSize: 12,fontWeight: FontWeight.w500,fontFamily: roboto)),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width - 50,
                        margin: const EdgeInsets.only(top: 12, right: 18,bottom: 22),
                        child: Text(
                          listVideos[index].title.toString(),
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          style: const TextStyle(
                              color: whiteConst,
                              fontWeight: FontWeight.w500,
                              fontFamily: gilroy,
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis),
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            listVideos[index].saveTimestamp.toString(),
                            style: const TextStyle(fontSize: 14, fontFamily: roboto, fontWeight: FontWeight.w400, color: text_light),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  if(listVideos[index].media!.isNotEmpty)
                                  {
                                    if(listVideos[index].media![0].media.toString().isNotEmpty)
                                    {
                                      Share.share(listVideos[index].media![0].media.toString());
                                      _sharePost(listVideos[index].id.toString());
                                      setState(() {
                                        listVideos[index].setSharesCount = listVideos[index].sharesCount! + 1;
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
                                },
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  alignment: Alignment.center,
                                  child: Image.asset('assets/images/share.png', height: 22, width: 22, color: lightGray),
                                ),
                              ),
                              Text(
                                listVideos[index].sharesCount.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: whiteConst),
                              ),
                              Container(width: 16,),
                              /*LikeButton(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                size: 24,
                                isLiked: listVideos[index].likesCount == 1,
                                circleColor: const CircleColor(
                                    start: yellow, end: yellowNew),
                                bubblesColor: const BubblesColor(
                                  dotPrimaryColor: yellow,
                                  dotSecondaryColor: yellowNew,
                                ),
                                likeBuilder: (bool isLiked) {
                                  return Image.asset(
                                    isLiked
                                        ? "assets/images/like_filled.png"
                                        : "assets/images/like.png",
                                    color: isLiked ? orange : lightGray,
                                  );
                                },
                                onTap: (isLike) async {

                                  return true;
                                },
                              ),
                              Container(width: 8,),
                              Text(
                                listVideos[index].likesCount.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: whiteConst),
                              ),
                              Container(width: 16,),
                              LikeButton(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                size: 24,
                                isLiked: listVideos[index].likesCount == 1,
                                circleColor: const CircleColor(
                                    start: yellow, end: yellowNew),
                                bubblesColor: const BubblesColor(
                                  dotPrimaryColor: yellow,
                                  dotSecondaryColor: yellowNew,
                                ),
                                likeBuilder: (bool isLiked) {
                                  return Image.asset(
                                    isLiked
                                        ? "assets/images/saved_fill.png"
                                        : "assets/images/saved.png",
                                    color: isLiked ? orange : lightGray,
                                  );
                                },
                                onTap: (isLike) async {

                                  return true;
                                },
                              ),
                              Container(width: 8,),
                              Text(
                                listVideos[index].sharesCount.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: whiteConst),
                              ),*/
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }

  _sharePost(String postId) async {
    SessionManager sessionManager = SessionManager();
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
      //showSnackBar(dataResponse.message, context);
    }
  }
}
