import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:jspl_connect/screen/video_player_screen.dart';
import 'package:jspl_connect/widget/video_block.dart';
import 'package:like_button/like_button.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';

import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../constant/global_context.dart';
import '../model/CommanResponse.dart';
import '../model/PostDetailsResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../utils/full_screen_image_new.dart';
import '../widget/loading.dart';
import '../widget/no_data.dart';
import 'NewsDetailsScreen.dart';
import 'VideoPlayerPage.dart';
import 'tabcontrol/bottom_navigation_bar_screen.dart';

class CommonDetailsScreen extends StatefulWidget {
  final String postId;
  final String typeId;

  const CommonDetailsScreen(this.postId, this.typeId, {Key? key}) : super(key: key);

  @override
  _CommonDetailsScreen createState() => _CommonDetailsScreen();
}

class _CommonDetailsScreen extends BaseState<CommonDetailsScreen> {
  String postId = "";
  String typeId = "";
  String shareCount = "";
  String relatedTitle = "";
  bool _isNoData = false;
  bool _isLoading = false;
  bool isReadMore = false;
  int isLiked = 0;
  int isBookMark = 0;
  PostDetails postDetailsData = PostDetails();

  @override
  void initState(){
    postId = (widget as CommonDetailsScreen).postId.toString();
    typeId = (widget as CommonDetailsScreen).typeId.toString();

    if(typeId == "2")
    {
      relatedTitle = "Related Events";
    }
    else if(typeId == "3")
    {
      relatedTitle = "Related Videos";
    }
    else if(typeId == "4")
    {
      relatedTitle = "Related News";
    }
    else if(typeId == "5")
    {
      relatedTitle = "Related Album";
    }
    else if(typeId == "6")
    {
      relatedTitle = "Related Blogs";
    }
    else if(typeId == "7")
    {
      relatedTitle = "Related Magazine";
    }
    else if(typeId == "8")
    {
      relatedTitle = "Related Media Coverage";
    }
    else if(typeId == "10")
    {
      relatedTitle = "Related Leaders";
    }
    
    if (isOnline) {
      _getPostDetails();
    } else {
      noInterNet(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: screenBg ,
          appBar: AppBar(
            toolbarHeight: 55,
            automaticallyImplyLeading: false,
            backgroundColor: screenBg,
            elevation: 0,
            centerTitle: false,
            titleSpacing: 0,
            leading: InkWell(
                onTap: () {
                  if (NavigationService.notif_post_id.isNotEmpty) {
                    typeId = "";
                    NavigationService.notif_post_id = "";
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const BottomNavigationBarScreen(0)), (Route<dynamic> route) => false);
                  } else {
                    String data = "$postId|$shareCount";
                    Navigator.pop(context, data);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset('assets/images/ic_back_button.png', height: 16, width: 16, color: black),
                )),
            title:  Text(
              "",
              style: TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 18),
            ),
            actions: [
              Visibility(
                visible: !_isNoData,
                child: Row(
                  children: [
                    LikeButton(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      size: 22,
                      isLiked: isLiked == 1,
                      circleColor: const CircleColor(
                          start: orange, end: orangeNew),
                      bubblesColor: const BubblesColor(
                        dotPrimaryColor: orange,
                        dotSecondaryColor: orangeNew,
                      ),
                      likeBuilder: (bool isLiked) {
                        return Image.asset(
                          isLiked
                              ? "assets/images/like_filled.png"
                              : "assets/images/like.png",
                          color: isLiked ? orangeNew : black,
                        );
                      },
                      onTap: (isLike) async {
                        setState(() {
                          if(isLiked == 1)
                          {
                            isLiked = 0;
                            postDetailsData.likesCount = int.parse(postDetailsData.likesCount.toString()) - 1;
                          }
                          else
                          {
                            isLiked = 1;
                            postDetailsData.likesCount = int.parse(postDetailsData.likesCount.toString()) + 1;
                          }
                        });
                        _likePost();
                        return true;
                      },
                    ),
                    Container(width: 8),
                    Text(
                      _isLoading ? "" :
                      postDetailsData.likesCount.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: black),
                    ),
                  ],
                ),
              ),
              Container(width: 10,),
              Visibility(
                  visible: !_isNoData,
                  child:  Row(
                    children: [
                      LikeButton(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        size: 22,
                        isLiked: isBookMark == 1,
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
                            color: isLiked ? yellow : black,
                          );
                        },
                        onTap: (isLike) async {
                          setState(() {
                            if(isBookMark == 1)
                            {
                              isBookMark = 0;
                              postDetailsData.bookmarkCount = int.parse(postDetailsData.bookmarkCount.toString()) - 1;
                            }
                            else
                            {
                              isBookMark = 1;
                              postDetailsData.bookmarkCount = int.parse(postDetailsData.bookmarkCount.toString()) + 1;
                            }
                          });
                          _likePost();
                          return true;
                        },
                      ),
                      Container(width: 8),
                      Text(
                        _isLoading ? "" : postDetailsData.bookmarkCount.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: black),
                      ),
                    ],
                  )
              ),
              Container(width: 6,),
              Visibility(
                  visible: !_isNoData,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (postDetailsData.media!.isNotEmpty) {
                            if (postDetailsData.media![0].media.toString().isNotEmpty) {
                              Share.share(postDetailsData.media![0].media.toString());
                              postDetailsData.sharesCount = int.parse(postDetailsData.sharesCount.toString()) + 1;
                              _sharePost(postId);
                            } else {
                              showSnackBar("Link not found.", context);
                            }
                          } else {
                            showSnackBar("Link not found.", context);
                          }
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(6),
                          margin: const EdgeInsets.only(right: 8),
                          child: Image.asset('assets/images/share.png', height: 22, width: 22, color: black),
                        ),
                      ),
                      Text(
                        _isLoading ? "" : postDetailsData.sharesCount.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: black),
                      ),
                      Container(width: 8),

                    ],
                  )),
            ],
          ),
          body: _isLoading
              ? const LoadingWidget()
              : _isNoData
              ? const MyNoDataWidget(msg: "No news details found.")
              : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text(postDetailsData.title.toString(), style:  TextStyle(color: black, fontSize: 22, fontWeight: FontWeight.w500, fontFamily: roboto)),
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: grayNew,
                          ),
                          padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                          margin: const EdgeInsets.only(left: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                postDetailsData.location.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12, fontFamily: roboto, fontWeight: FontWeight.w400, color: black,
                                  overflow: TextOverflow.ellipsis,),
                              ),
                              postDetailsData.location.toString().isNotEmpty ? Container(
                                width: 6,
                              ) : Container(),
                              postDetailsData.location.toString().isNotEmpty ? Image.asset(
                                "assets/images/ic_placeholder.png",
                                width: 4,
                                height: 4,
                                color: black,
                              ) : Container(),
                              postDetailsData.location.toString().isNotEmpty ?  Container(
                                width: 6,
                              ) : Container(),
                              Text(
                                postDetailsData.saveTimestamp.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12, fontFamily: roboto, fontWeight: FontWeight.w400, color: black,
                                  overflow: TextOverflow.ellipsis,),
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: Container())
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        if (typeId == "3")
                          {
                            if (postDetailsData.media!.isNotEmpty) {
                              if (postDetailsData.media![0].media.toString().isNotEmpty) {
                                 if (postDetailsData.media![0].fileType == "youtube") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayerScreen(postDetailsData.media![0].media.toString(), postDetailsData.title.toString())));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayerPage(true, postDetailsData.media![0].media.toString(), postDetailsData.title.toString())));
                                  }

                              } else {
                                showSnackBar("Video not found.", context);
                              }
                            } else {
                              showSnackBar("Video not found.", context);
                            }
                          }
                        else
                          {
                            List<String> listImage = [];
                            listImage.add(postDetailsData.featuredImage.toString().trim());
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => FullScreenImageNew("", listImage, 0),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(0.0, 1.0);
                                    const end = Offset.zero;
                                    const curve = Curves.ease;
                                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ));
                          }
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        decoration: BoxDecoration(
                            color: black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 0.4, color: black.withOpacity(0.3), style: BorderStyle.solid)
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              FadeInImage.assetNetwork(
                                image: postDetailsData.featuredImage.toString().trim(),
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: 250,
                                placeholder: 'assets/images/bg_gray.jpeg',
                              ),
                              Visibility(
                                visible: typeId == "3",
                                child: Container(
                                    height: 250,
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/images/play.png",
                                      width: 36,
                                      height: 36,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: grayNew
                      ),
                      margin: const EdgeInsets.fromLTRB(16, 22, 16, 8),
                      padding: const EdgeInsets.all(8),
                      child: HtmlWidget(postDetailsData.description.toString(),textStyle: TextStyle(height: 1.5, color: black, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: roboto),),
                    ),
                    Visibility(
                      visible: postDetailsData.reatedPosts!.isNotEmpty,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(15, 6, 12, 6),
                        child: Text(
                          relatedTitle,
                          style:  TextStyle(fontFamily: roboto, fontSize: 17, color: black, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    postDetailsData.reatedPosts!.isNotEmpty
                        ? relatedPostBlock()
                        : Container(),
                    Container(height: 16,)
                  ],
            ),
          ),
        ),
        onWillPop: () {
          if (NavigationService.notif_type.isNotEmpty) {
            typeId = "";
            NavigationService.notif_post_id = "";
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const BottomNavigationBarScreen(0)), (Route<dynamic> route) => false);
          } else {
            String data = "$postId|$shareCount";
            Navigator.pop(context, data);
          }
          return Future.value(true);
        }
    );
  }

  AnimationLimiter relatedPostBlock() {
    if (typeId == "2")
      {
        return AnimationLimiter(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: postDetailsData.reatedPosts!.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CommonDetailsScreen(postDetailsData.reatedPosts![index].id.toString(),"2")));
                        print(result);
                      },
                      child: Container(
                        height: 400,
                        margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 0.6, color: black.withOpacity(0.4), style: BorderStyle.solid)),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: 450,
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20), // Image border
                                child: Image.network(
                                  postDetailsData.reatedPosts![index].featuredImage.toString(),
                                  fit: BoxFit.cover,
                                  height: 450,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                            ),
                            Container(
                              height: 400,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                      begin: FractionalOffset.topCenter,
                                      end: FractionalOffset.bottomCenter,
                                      colors: [
                                        blackConst.withOpacity(0.2),
                                        blackConst,
                                      ],
                                      stops: const [
                                        0.7,
                                        1.0
                                      ]
                                  )
                              ),
                            ),
                            Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                    decoration: BoxDecoration(color: whiteConst.withOpacity(0.4), borderRadius: BorderRadius.circular(22)),
                                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                                    child: Text(
                                      postDetailsData.reatedPosts![index].location.toString(),
                                      style:  const TextStyle(color: blackConst, fontSize: 14, fontWeight: FontWeight.w400),
                                    )
                                )
                            ),
                            Positioned(
                              bottom: 12,
                              child: Column(
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width - 50,
                                      margin: const EdgeInsets.only(bottom: 0, left: 14, right: 14),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        postDetailsData.reatedPosts![index].title.toString(),
                                        style: TextStyle(
                                            foreground: Paint()..shader = linearGradientSocial,
                                            fontWeight: titleFont,
                                            fontFamily: gilroy,
                                            fontSize: 16,
                                            overflow: TextOverflow.clip),
                                        overflow: TextOverflow.clip,
                                      )),
                                  Row(
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context).size.width - 50,
                                          margin: const EdgeInsets.only(top: 12,bottom: 12, left: 14, right: 14),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            postDetailsData.reatedPosts![index].saveTimestamp.toString(),
                                            style:  const TextStyle(
                                                color: lightGray,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: gilroy,
                                                fontSize: 14,
                                                overflow: TextOverflow.clip),
                                            overflow: TextOverflow.clip,
                                          )),
                                    ],
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
        );
      }
    else if (typeId == "3")
      {
        return AnimationLimiter(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: postDetailsData.reatedPosts!.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child:  GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CommonDetailsScreen(postDetailsData.reatedPosts![index].id.toString(),"3")));
                        print("result ===== $result");
                        setState(() {
                        var data = result.toString().split("|");
                        for (int i = 0; i < postDetailsData.reatedPosts!.length; i++) {
                          if(postDetailsData.reatedPosts![i].id == data[0])
                          {
                            postDetailsData.reatedPosts![i].setSharesCount = num.parse(data[1]);
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
                              child: Image.network(postDetailsData.reatedPosts![index].featuredImage.toString(),
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
                                      child: Text(postDetailsData.reatedPosts![index].location.toString(),style:  const TextStyle(color: blackConst,fontSize: 12,fontWeight: FontWeight.w500,fontFamily: roboto)),
                                    ),
                                    Container(
                                        width: MediaQuery.of(context).size.width - 50,
                                        margin: const EdgeInsets.only(top: 12, right: 18,bottom: 22),
                                        child: Text(
                                          postDetailsData.reatedPosts![index].title.toString(),
                                          overflow: TextOverflow.clip,
                                          maxLines: 2,
                                          style:  const TextStyle(
                                              color: whiteConst,
                                              fontWeight: titleFont,
                                              fontFamily: gilroy,
                                              fontSize: 18,
                                              overflow: TextOverflow.clip),
                                        )),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width - 50,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            postDetailsData.reatedPosts![index].saveTimestamp.toString(),
                                            style:  const TextStyle(fontSize: 14, fontFamily: roboto, fontWeight: FontWeight.w400, color: text_light),
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: (){
                                                  if(postDetailsData.reatedPosts![index].media!.isNotEmpty)
                                                  {
                                                    if(postDetailsData.reatedPosts![index].media![0].media.toString().isNotEmpty)
                                                    {
                                                      Share.share(postDetailsData.reatedPosts![index].media![0].media.toString());
                                                      _sharePost(postDetailsData.reatedPosts![index].id.toString());
                                                      setState(() {
                                                        postDetailsData.reatedPosts![index].setSharesCount = postDetailsData.reatedPosts![index].sharesCount! + 1;
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
                                                postDetailsData.reatedPosts![index].sharesCount.toString(),
                                                textAlign: TextAlign.center,
                                                style:  const TextStyle(
                                                    fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: whiteConst),
                                              ),

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
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    else if (typeId == "4")
      {
        return AnimationLimiter(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: postDetailsData.reatedPosts!.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CommonDetailsScreen(postDetailsData.reatedPosts![index].id.toString(),"4")));
                        print("result ===== $result");
                        setState(() {
                          var data = result.toString().split("|");
                          for (int i = 0; i < postDetailsData.reatedPosts!.length; i++) {
                            if(postDetailsData.reatedPosts![i].id == data[0])
                            {
                              postDetailsData.reatedPosts![i].setSharesCount = num.parse(data[1]);
                              break;
                            }
                          }
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                        margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                        decoration: BoxDecoration(
                          color: newsBlock,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    child: Text(postDetailsData.reatedPosts![index].title.toString(),
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: black,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: gilroy,
                                            fontSize: 18,
                                            overflow: TextOverflow.clip)),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(postDetailsData.reatedPosts![index].featuredImage.toString(), width: 100, height: 100, fit: BoxFit.cover),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              height: 18,
                            ),
                            Row(
                              children: [
                                Text(
                                  postDetailsData.reatedPosts![index].location.toString(),
                                  style: TextStyle(fontSize: 13, fontFamily: roboto, fontWeight: FontWeight.w400, color: newsText),
                                ),
                                postDetailsData.reatedPosts![index].location.toString().isNotEmpty ? Container(
                                  width: 6,
                                ) : Container(),
                                postDetailsData.reatedPosts![index].location.toString().isNotEmpty ? Image.asset(
                                  "assets/images/ic_placeholder.png",
                                  width: 4,
                                  height: 4,
                                  color: newsText,
                                ) : Container(),
                                postDetailsData.reatedPosts![index].location.toString().isNotEmpty ?  Container(
                                  width: 6,
                                ) : Container(),
                                Text(
                                  postDetailsData.reatedPosts![index].saveTimestamp.toString(),
                                  style: TextStyle(fontSize: 13, fontFamily: roboto, fontWeight: FontWeight.w400, color: newsText),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    if(postDetailsData.reatedPosts![index].media!.isNotEmpty)
                                    {
                                      if(postDetailsData.reatedPosts![index].media![0].media.toString().isNotEmpty)
                                      {
                                        Share.share(postDetailsData.reatedPosts![index].media![0].media.toString());
                                        _sharePost(postDetailsData.reatedPosts![index].id.toString());
                                        setState(() {
                                          postDetailsData.reatedPosts![index].setSharesCount = postDetailsData.reatedPosts![index].sharesCount! + 1;
                                        });
                                      }
                                      else
                                      {
                                        showSnackBar("News link not found.", context);
                                      }
                                    }
                                    else
                                    {
                                      showSnackBar("News link not found.", context);
                                    }
                                  },
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    alignment: Alignment.center,
                                    child: Image.asset('assets/images/share.png', height: 22, width: 22, color: newsText),
                                  ),
                                ),
                                Text(
                                  postDetailsData.reatedPosts![index].sharesCount.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w400, fontFamily: roboto, color: newsText),
                                ),
                                Container(
                                  width: 8,
                                )
                                /* Container(
                                        width: 12,
                                      ),
                                      Image.asset(
                                        "assets/images/ic_arrow_right_new.png",
                                        width: 22,
                                        height: 22,
                                      )*/
                              ],
                            ),
                            Container(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    else if (typeId == "6")
      {
        return AnimationLimiter(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: postDetailsData.reatedPosts!.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CommonDetailsScreen(postDetailsData.reatedPosts![index].id.toString(),"4")));
                        print("result ===== $result");
                        setState(() {
                          var data = result.toString().split("|");
                          for (int i = 0; i < postDetailsData.reatedPosts!.length; i++) {
                            if(postDetailsData.reatedPosts![i].id == data[0])
                            {
                              postDetailsData.reatedPosts![i].setSharesCount = num.parse(data[1]);
                              break;
                            }
                          }
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                        margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                        decoration: BoxDecoration(
                          color: newsBlock,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(postDetailsData.reatedPosts![index].title.toString(),
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                color: black,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: gilroy,
                                                fontSize: 18,
                                                overflow: TextOverflow.clip))
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(postDetailsData.reatedPosts![index].featuredImage.toString(), width: 100, height: 100, fit: BoxFit.cover),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              height: 18,
                            ),
                            Row(
                              children: [
                                Text(
                                  postDetailsData.reatedPosts![index].location.toString(),
                                  style: TextStyle(fontSize: 13, fontFamily: roboto, fontWeight: FontWeight.w400, color: newsText),
                                ),
                                postDetailsData.reatedPosts![index].location.toString().isNotEmpty ? Container(
                                  width: 6,
                                ) : Container(),
                                postDetailsData.reatedPosts![index].location.toString().isNotEmpty ? Image.asset(
                                  "assets/images/ic_placeholder.png",
                                  width: 4,
                                  height: 4,
                                  color: newsText,
                                ) : Container(),
                                postDetailsData.reatedPosts![index].location.toString().isNotEmpty ?  Container(
                                  width: 6,
                                ) : Container(),
                                Text(
                                  postDetailsData.reatedPosts![index].saveTimestamp.toString(),
                                  style: TextStyle(fontSize: 13, fontFamily: roboto, fontWeight: FontWeight.w400, color: newsText),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    if(postDetailsData.reatedPosts![index].media!.isNotEmpty)
                                    {
                                      if(postDetailsData.reatedPosts![index].media![0].media.toString().isNotEmpty)
                                      {
                                        Share.share(postDetailsData.reatedPosts![index].media![0].media.toString());
                                        _sharePost(postDetailsData.reatedPosts![index].id.toString());
                                        setState(() {
                                          postDetailsData.reatedPosts![index].setSharesCount = postDetailsData.reatedPosts![index].sharesCount! + 1;
                                        });
                                      }
                                      else
                                      {
                                        showSnackBar("News link not found.", context);
                                      }
                                    }
                                    else
                                    {
                                      showSnackBar("News link not found.", context);
                                    }
                                  },
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    alignment: Alignment.center,
                                    child: Image.asset('assets/images/share.png', height: 22, width: 22, color: newsText),
                                  ),
                                ),
                                Text(
                                  postDetailsData.reatedPosts![index].sharesCount.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w400, fontFamily: roboto, color: newsText),
                                ),
                                Container(
                                  width: 8,
                                )
                                /* Container(
                                          width: 12,
                                        ),
                                        Image.asset(
                                          "assets/images/ic_arrow_right_new.png",
                                          width: 22,
                                          height: 22,
                                        )*/
                              ],
                            ),
                            Container(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    else 
      {
        return AnimationLimiter(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: postDetailsData.reatedPosts!.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CommonDetailsScreen(postDetailsData.reatedPosts![index].id.toString(),"8")));
                        print(result);
                        /*final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => MediaCoverageDetailsScreen(postDetailsData.reatedPosts![index].id.toString())));
                                            print("result ===== $result");*/
                        setState(() {
                          var data = result.toString().split("|");
                          for (int i = 0; i < postDetailsData.reatedPosts!.length; i++) {
                            if(postDetailsData.reatedPosts![i].id == data[0])
                            {
                              postDetailsData.reatedPosts![i].setSharesCount = num.parse(data[1]);
                              break;
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
                        padding: const EdgeInsets.only(left: 15.0,right: 15,top: 12,bottom: 12),
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
                                      Text(postDetailsData.reatedPosts![index].location.toString(),
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.start,
                                          style:  const TextStyle(fontWeight: FontWeight.w400, fontFamily: roboto, fontSize: 12, color: whiteConst,overflow: TextOverflow.clip)),
                                      Container(
                                        margin: const EdgeInsets.only(top: 8),
                                        child: Text(postDetailsData.reatedPosts![index].title.toString(),
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.start,
                                            style:  const TextStyle(fontWeight: FontWeight.w600, fontFamily: roboto, fontSize: 16, color: whiteConst,overflow: TextOverflow.clip)),
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
                                          postDetailsData.reatedPosts![index].featuredImage.toString(),
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
                                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                  child: Text(postDetailsData.reatedPosts![index].saveTimestamp.toString(),
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.start,
                                      style:  const TextStyle(fontWeight: FontWeight.w500, fontFamily: roboto, fontSize: 12, color: whiteConst,overflow: TextOverflow.clip)),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        if(postDetailsData.reatedPosts![index].media!.isNotEmpty)
                                        {
                                          if(postDetailsData.reatedPosts![index].media![0].media.toString().isNotEmpty)
                                          {
                                            Share.share(postDetailsData.reatedPosts![index].media![0].media.toString());
                                            _sharePost(postDetailsData.reatedPosts![index].id.toString());
                                            setState(() {
                                              postDetailsData.reatedPosts![index].setSharesCount = postDetailsData.reatedPosts![index].sharesCount! + 1;
                                            });
                                          }
                                          else
                                          {
                                            showSnackBar("Media Coverage link not found.", context);
                                          }
                                        }
                                        else
                                        {
                                          showSnackBar("Media Coverage link not found.", context);
                                        }
                                      },
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        padding: const EdgeInsets.all(6),
                                        child: Image.asset("assets/images/share.png",color: whiteConst),
                                      ),
                                    ),
                                    Text(
                                      postDetailsData.reatedPosts![index].sharesCount.toString(),
                                      textAlign: TextAlign.center,
                                      style:  const TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: whiteConst),
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
              );
            },
          ),
        );
      }
  }

  _getPostDetails() async {
    setState(() {
      _isLoading = true;
    });

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + postDetails);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'post_id': postId.toString(),
      'user_id': sessionManager.getUserId().toString(),
      'type_id': typeId
    };
    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = PostDetailsResponse.fromJson(apiResponse);

    if (statusCode == 200 && dataResponse.success == 1) {
      if (dataResponse.postDetails != null) {
        postDetailsData = dataResponse.postDetails!;
        isLiked = postDetailsData.isLiked!.toInt();
        isBookMark = postDetailsData.isBookmarked!.toInt();
        shareCount = postDetailsData.sharesCount!.toString();
      }
    } else {
      setState(() {
        _isNoData = true;
      });
      showSnackBar(dataResponse.message, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  _likePost() async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + postMetaSave);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'post_id' : postId.toString(),
      'user_id' : sessionManager.getUserId().toString(),
      'type' : "like",
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
      setState(() {
        if(isLiked == 1)
        {
          isLiked = 0;
        }
        else
        {
          isLiked = 1;
        }
      });
      showSnackBar(dataResponse.message, context);
    }
  }

  _bookmarkPost() async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + postMetaSave);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'post_id' : postId.toString(),
      'user_id' : sessionManager.getUserId().toString(),
      'type' : "bookmark",
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
      setState(() {
        if(isBookMark == 1)
        {
          isBookMark = 0;
        }
        else
        {
          isBookMark = 1;
        }
      });
      showSnackBar(dataResponse.message, context);
    }
  }

  _sharePost(String id) async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + postMetaSave);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'post_id' : id,
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

  @override
  void castStatefulWidget() {
    widget is CommonDetailsScreen;
  }

}