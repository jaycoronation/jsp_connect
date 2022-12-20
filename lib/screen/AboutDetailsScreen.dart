import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import '../constant/colors.dart';
import '../model/AboutNJModel.dart';
import '../utils/base_class.dart';

class AboutDetailsScreen extends StatefulWidget {
  final AboutNJModel dataGetSet;
  const AboutDetailsScreen(this.dataGetSet, {Key? key}) : super(key: key);

  @override
  _AboutDetailsScreen createState() => _AboutDetailsScreen();
}

class _AboutDetailsScreen extends BaseState<AboutDetailsScreen> {
  AboutNJModel getSet = AboutNJModel();
  int isLiked = 0;
  int isBookMark = 0;

  @override
  void initState(){
    getSet = (widget as AboutDetailsScreen).dataGetSet;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: screenBg,
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
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(6),
                        child: Image.asset('assets/images/ic_back_button.png',
                          height: 22, width: 22,color: black),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 65,
                    margin: const EdgeInsets.only(left: 5),
                    child: Text(
                      "",
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
            actions: [
              Visibility(
                visible: true,
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
                          }
                          else
                          {
                            isLiked = 1;
                          }
                        });
                        return true;
                      },
                    ),
                  ],
                ),
              ),
              Container(width: 10,),
              Visibility(
                  visible: true,
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
                            }
                            else
                            {
                              isBookMark = 1;
                            }
                          });
                          return true;
                        },
                      ),
                    ],
                  )
              ),
              Container(width: 6,),
              Visibility(
                  visible: true,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(6),
                          margin: const EdgeInsets.only(right: 8),
                          child: Image.asset('assets/images/share.png', height: 22, width: 22, color: black),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(getSet.title, style: TextStyle(color: black,fontSize: 22,fontWeight: FontWeight.w500,fontFamily: roboto)),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      getSet.image,
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: grayNew
                  ),
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(getSet.description, style: TextStyle(height:1.5,color: black,fontSize: 16,fontWeight: FontWeight.w400,fontFamily: roboto)),
                ),
              ],
            ),
          ),
        ),
        onWillPop: (){
          Navigator.of(context).pop();
          return Future.value(true);
        }
    );
  }

  @override
  void castStatefulWidget() {
    widget is AboutDetailsScreen;
  }
}