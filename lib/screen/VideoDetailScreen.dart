import 'package:flutter/material.dart';
import 'package:story_page_view/story_page_view.dart';

import '../constant/colors.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class VideoDetailScreen extends StatefulWidget {
  const VideoDetailScreen({Key? key}) : super(key: key);

  @override
  _VideoDetailScreen createState() => _VideoDetailScreen();
}

class _VideoDetailScreen extends BaseState<VideoDetailScreen> {
  bool _isLoading = false;

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
                          child: Image.asset(
                            'assets/images/ic_back_button.png',
                            height: 32,
                            width: 32,
                          ),
                        )),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 65,
                      margin: const EdgeInsets.only(left: 5),
                      child: const Text(
                        "Video details",
                        style: TextStyle(fontWeight: FontWeight.w400, color: white, fontSize: 18),
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
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 700,
                          margin: const EdgeInsets.only(left: 22, right: 12),
                          child: StoryPageView(
                            // Customize indicator looking
                            indicatorStyle: StoryPageIndicatorStyle(
                              height: 2,
                              gap: 6,
                              unvisitedColor: lightGray.withOpacity(0.4),
                              visitedColor: white,
                              timerBarBackgroundColor: lightGray.withOpacity(0.4),
                              timerBarColor: white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            controller: StoryPageController(
                              // Customize paging animation style
                              pagingCurve: Curves.linear,
                              pagingDuration: const Duration(milliseconds: 2000),
                            ),
                            storyDuration: const Duration(seconds: 5),
                            // Customize whole layout
                            indicatorPosition: StoryPageIndicatorPosition.custom(
                              layoutBuilder: (c, pageView, indicator) => SafeArea(
                                child: Stack(
                                  children: [
                                    pageView,
                                    Positioned(
                                      bottom: 12,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 12,
                                        ),
                                        child: indicator,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: white,
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.asset("assets/images/discover_1.jpg", width: double.infinity, height: 700, fit: BoxFit.fill),
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          'assets/images/play.png',
                                          height: 22,
                                          width: 22,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        left: 12,
                                        top: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(18),
                                            color: white.withOpacity(0.8),
                                          ),
                                          padding: const EdgeInsets.all(6),
                                          child: const Text("Trending", style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: roboto)),
                                        )),
                                    Positioned(
                                        bottom: 52,
                                        child: Container(
                                          alignment: Alignment.bottomRight,
                                          margin: const EdgeInsets.only(right: 6, left: 14),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(0.0),
                                                child: Image.asset(
                                                  "assets/images/ic_user_placeholder.png",
                                                  height: 24,
                                                  color: darkGray,
                                                  width: 24,
                                                ),
                                              ),
                                              Container(
                                                width: 24,
                                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  "14",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(0),
                                                child: Image.asset(
                                                  "assets/images/ic_user_placeholder.png",
                                                  height: 24,
                                                  color: darkGray,
                                                  width: 24,
                                                ),
                                              ),
                                              Container(
                                                  width: 24,
                                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "14",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.all(0),
                                                child: Image.asset(
                                                  "assets/images/ic_user_placeholder.png",
                                                  height: 24,
                                                  color: darkGray,
                                                  width: 24,
                                                ),
                                              ),
                                              Container(
                                                  width: 24,
                                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "14",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                                  )),
                                              Text(
                                                "Naveen Jindal applauds the Government's\n Decision on the latest amendment to the flag Code.",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: white,
                                                  fontFamily: gilroy,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: white,
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.asset("assets/images/discover_1.jpg", width: double.infinity, height: 700, fit: BoxFit.fill),
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          'assets/images/play.png',
                                          height: 22,
                                          width: 22,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        left: 12,
                                        top: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(18),
                                            color: white.withOpacity(0.8),
                                          ),
                                          padding: const EdgeInsets.all(6),
                                          child: const Text("Trending", style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: roboto)),
                                        )),
                                    Positioned(
                                        bottom: 52,
                                        child: Container(
                                          alignment: Alignment.bottomRight,
                                          margin: const EdgeInsets.only(right: 6, left: 14),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(0.0),
                                                child: Image.asset(
                                                  "assets/images/ic_user_placeholder.png",
                                                  height: 24,
                                                  color: darkGray,
                                                  width: 24,
                                                ),
                                              ),
                                              Container(
                                                width: 24,
                                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  "14",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(0),
                                                child: Image.asset(
                                                  "assets/images/ic_user_placeholder.png",
                                                  height: 24,
                                                  color: darkGray,
                                                  width: 24,
                                                ),
                                              ),
                                              Container(
                                                  width: 24,
                                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "14",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.all(0),
                                                child: Image.asset(
                                                  "assets/images/ic_user_placeholder.png",
                                                  height: 24,
                                                  color: darkGray,
                                                  width: 24,
                                                ),
                                              ),
                                              Container(
                                                  width: 24,
                                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "14",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                                  )),
                                              Text(
                                                "Naveen Jindal applauds the Government's\n Decision on the latest amendment to the flag Code.",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: white,
                                                  fontFamily: gilroy,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: white,
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.asset("assets/images/discover_1.jpg", width: double.infinity, height: 700, fit: BoxFit.fill),
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          'assets/images/play.png',
                                          height: 22,
                                          width: 22,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        left: 12,
                                        top: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(18),
                                            color: white.withOpacity(0.8),
                                          ),
                                          padding: const EdgeInsets.all(6),
                                          child: const Text("Trending", style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: roboto)),
                                        )),
                                    Positioned(
                                        bottom: 52,
                                        child: Container(
                                          alignment: Alignment.bottomRight,
                                          margin: const EdgeInsets.only(right: 6, left: 14),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(0.0),
                                                child: Image.asset(
                                                  "assets/images/ic_user_placeholder.png",
                                                  height: 24,
                                                  color: darkGray,
                                                  width: 24,
                                                ),
                                              ),
                                              Container(
                                                width: 24,
                                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  "14",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(0),
                                                child: Image.asset(
                                                  "assets/images/ic_user_placeholder.png",
                                                  height: 24,
                                                  color: darkGray,
                                                  width: 24,
                                                ),
                                              ),
                                              Container(
                                                  width: 24,
                                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "14",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.all(0),
                                                child: Image.asset(
                                                  "assets/images/ic_user_placeholder.png",
                                                  height: 24,
                                                  color: darkGray,
                                                  width: 24,
                                                ),
                                              ),
                                              Container(
                                                  width: 24,
                                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "14",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                                  )),
                                              Text(
                                                "Naveen Jindal applauds the Government's\n Decision on the latest amendment to the flag Code.",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: white,
                                                  fontFamily: gilroy,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: white,
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.asset("assets/images/discover_1.jpg", width: double.infinity, height: 700, fit: BoxFit.fill),
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          'assets/images/play.png',
                                          height: 22,
                                          width: 22,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        left: 12,
                                        top: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(18),
                                            color: white.withOpacity(0.8),
                                          ),
                                          padding: const EdgeInsets.all(6),
                                          child: const Text("Trending", style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 14, fontFamily: roboto)),
                                        )),
                                    Positioned(
                                        bottom: 52,
                                        child: Container(
                                          alignment: Alignment.bottomRight,
                                          margin: const EdgeInsets.only(right: 6, left: 14),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(0.0),
                                                child: Image.asset(
                                                  "assets/images/ic_user_placeholder.png",
                                                  height: 24,
                                                  color: darkGray,
                                                  width: 24,
                                                ),
                                              ),
                                              Container(
                                                width: 24,
                                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  "14",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(0),
                                                child: Image.asset(
                                                  "assets/images/ic_user_placeholder.png",
                                                  height: 24,
                                                  color: darkGray,
                                                  width: 24,
                                                ),
                                              ),
                                              Container(
                                                  width: 24,
                                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "14",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.all(0),
                                                child: Image.asset(
                                                  "assets/images/ic_user_placeholder.png",
                                                  height: 24,
                                                  color: darkGray,
                                                  width: 24,
                                                ),
                                              ),
                                              Container(
                                                  width: 24,
                                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "14",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: white),
                                                  )),
                                              Text(
                                                "Naveen Jindal applauds the Government's\n Decision on the latest amendment to the flag Code.",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: white,
                                                  fontFamily: gilroy,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        });
  }

  @override
  void castStatefulWidget() {
    widget is VideoDetailScreen;
  }
}
