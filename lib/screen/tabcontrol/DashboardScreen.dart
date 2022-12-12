import 'dart:convert';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../constant/api_end_point.dart';
import '../../constant/colors.dart';
import '../../model/DashboardModel.dart';
import '../../utils/app_utils.dart';
import '../../utils/base_class.dart';
import '../../widget/loading.dart';
import '../NavigationDrawerScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreen createState() => _DashboardScreen();
}

class _DashboardScreen extends BaseState<DashboardScreen> {
  bool _isLoading = false;
  final controller = PageController(viewportFraction: 1, keepPage: true);
  var listDetails = List<Details>.empty(growable: true);

  @override
  void initState() {
    if (isOnline) {
      _DashboardApi();
    }
    else
    {
      noInterNet(context);
    }
    super.initState();
  }

  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'iLnmTe5Q2Qw',
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              elevation: 0,
              centerTitle: false,
            ),
            backgroundColor: bgMain,
            resizeToAvoidBottomInset: false,
            body: _isLoading
                ? const LoadingWidget()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 14, right: 14, top: 10),
                          decoration: BoxDecoration(
                            color: Gray,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 12, right: 12, top: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const NavigationDrawerScreen()));
                                        },
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          margin: const EdgeInsets.only(right: 8),
                                          child: Image.asset('assets/images/ic_back_button.png', height: 45, width: 45),
                                        )),
                                    Expanded(
                                        child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: const Text(
                                        "Hi,Rohan",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(fontSize: 16, color: black, fontWeight: FontWeight.w600, fontFamily: aileron),
                                      ),
                                    )
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.only(right: 8),
                                      child: Image.asset('assets/images/ic_user_placeholder.png', height: 45, width: 45,color: darkGray,),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Image.asset('assets/images/ic_user_placeholder.png', height: 45, width: 45,color: darkGray,),
                                    )
                                  ],
                                ),
                              ),
                              Stack(
                                children: [
                                  Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                    elevation: 2,
                                    color: bgOverlay,
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                                      elevation: 2,
                                      color: bgOverlay,
                                      child: SizedBox(
                                          width: double.infinity,
                                          height: 200,
                                          child: YoutubePlayerBuilder(
                                              player: YoutubePlayer(
                                                controller: _controller,
                                              ),
                                              builder: (context, player){
                                                return Column(
                                                  children: [
                                                    player,
                                                  ],
                                                );
                                              }
                                          ),
                                                ),
                                      )
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(left: 14,right: 14,top: 10),
                                    alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      height: 270,
                                      width: MediaQuery.of(context).size.width,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20), // Image border
                                        child: Image.network(listDetails[0].live![0].image.toString(), width: MediaQuery.of(context).size.width, height: 230, fit: BoxFit.cover),
                                      )),
                                  Center(
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 130),
                                      alignment: Alignment.center,
                                      child: Image.asset("assets/images/ic_user_placeholder.png",height: 30,width: 30,color: darkGray,),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(
                                    top: 30,
                                    bottom: 10,
                                    left: 14,
                                    right: 14,
                                  ),
                                  child: const Text(
                                    "Today's picks for you",
                                    style: TextStyle(fontFamily: aileron, color: black, fontSize: 16, fontWeight: FontWeight.w400),
                                  )),
                              SizedBox(
                                height: 200,
                                child: PageView.builder(
                                  controller: controller,
                                  itemCount: listDetails[0].data!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(left: 10, right: 20),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 120,
                                            decoration: BoxDecoration(
                                              color: yellow,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.only(top: 4, bottom: 4, left: 2, right: 2),
                                            child: Text(listDetails[0].data![index].date.toString(), style: const TextStyle(fontWeight: FontWeight.w400, fontFamily: aileron, fontSize: 14, color: black)),
                                          ),
                                          Container(
                                              alignment: Alignment.topLeft,
                                              margin: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                left: 14,
                                                right: 14,
                                              ),
                                              child: Text(
                                                listDetails[0].data![index].quotes.toString(),
                                                style: const TextStyle(fontFamily: gilroy, color: black, fontSize: 22, fontWeight: FontWeight.w600),
                                              )),
                                          const Spacer(),
                                          Container(
                                              alignment: Alignment.topLeft,
                                              margin: const EdgeInsets.only(
                                                top: 4,
                                                bottom: 10,
                                                left: 14,
                                                right: 14,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    listDetails[0].data![index].name.toString(),
                                                    maxLines: 3,
                                                    style: const TextStyle(fontFamily: aileron, color: black, fontSize: 18, fontWeight: FontWeight.w600),
                                                  ),
                                                  Image.asset(
                                                    "assets/images/ic_user_placeholder.png",
                                                    height: 42,
                                                    width: 42,
                                                    color: darkGray,
                                                    alignment: Alignment.topRight,
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 160,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    bottom: 10,
                                    left: 14,
                                    right: 14,
                                  ),
                                  decoration: const BoxDecoration(color: text_dark),
                                  child: SmoothPageIndicator(
                                    controller: controller,
                                    count: 3,
                                    effect: const SlideEffect(spacing: 2.0, radius: 0.0, dotWidth: 30.0, dotHeight: 2.5, paintStyle: PaintingStyle.stroke, strokeWidth: 0, dotColor: text_dark, activeDotColor: lightGray),
                                  ),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(
                                    top: 30,
                                    bottom: 10,
                                    left: 14,
                                    right: 14,
                                  ),
                                  child: const Text(
                                    "Events",
                                    style: TextStyle(fontFamily: gilroy, color: black, fontSize: 32, fontWeight: FontWeight.w600),
                                  )),
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    height: 250,
                                    width: MediaQuery.of(context).size.width,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20), // Image border
                                      child: SizedBox.fromSize(
                                        size: const Size.fromRadius(48), // Image radius
                                        child: Image.network(
                                          listDetails[0].events![0].image.toString(),
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 250,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, colors: [
                                          black.withOpacity(0.0),
                                          black,
                                        ], stops: const [
                                          0.2,
                                          1.0
                                        ])),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          alignment: Alignment.bottomLeft,
                                          margin: const EdgeInsets.only(top: 120, left: 16),
                                          child: Text(listDetails[0].events![0].eventName.toString(), style: const TextStyle(color: white, fontWeight: FontWeight.w400, fontFamily: gilroy, fontSize: 18))),
                                      Container(
                                        margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: btnBlack,
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              alignment: Alignment.centerLeft,
                                              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                                              child: Text(listDetails[0].events![0].date.toString(), style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: aileron, fontSize: 14, color: white)),
                                            ),
                                            Image.asset(
                                              "assets/images/ic_user_placeholder.png",
                                              height: 45,
                                              color: darkGray,
                                              width: 45,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: const EdgeInsets.only(left: 14, right: 14, top: 10),
                          child: Row(
                            children: [
                              Flexible(
                                child: Stack(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(30), border: Border.all(width: 1, color: Colors.transparent, style: BorderStyle.solid)),
                                        height: 300,
                                        width: MediaQuery.of(context).size.width,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20), // Image border
                                          child: SizedBox.fromSize(
                                            size: const Size.fromRadius(48), // Image radius
                                            child: Image.network(listDetails[0].events![1].image.toString(), fit: BoxFit.cover),
                                          ),
                                        )),
                                    Container(
                                      height: 300,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: LinearGradient(begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, colors: [
                                            black.withOpacity(0.0),
                                            black,
                                          ], stops: const [
                                            0.2,
                                            1.0
                                          ])),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      margin: const EdgeInsets.only(top: 14),
                                      child: Column(
                                        children: [
                                          Container(
                                              alignment: Alignment.bottomLeft,
                                              margin: const EdgeInsets.only(top: 160, left: 16),
                                              child: Text(listDetails[0].events![1].eventName.toString(), style: const TextStyle(color: white, fontWeight: FontWeight.w400, fontFamily: gilroy, fontSize: 16))),
                                          Container(
                                            margin: const EdgeInsets.only(left: 14, right: 14, top: 2),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: btnBlack,
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  alignment: Alignment.topLeft,
                                                  padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                                                  child: Text(listDetails[0].events![1].date.toString(), style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: aileron, fontSize: 12, color: white)),
                                                ),
                                                Image.asset(
                                                  "assets/images/ic_user_placeholder.png",
                                                  height: 40,
                                                  width: 40,
                                                  color: darkGray,
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
                              Container(width: 12,),
                              Flexible(
                                child: Stack(children: [
                                  Container(
                                      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(30), border: Border.all(width: 1, color: Colors.transparent, style: BorderStyle.solid)),
                                      height: 300,
                                      width: MediaQuery.of(context).size.width,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20), // Image border
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(48), // Image radius
                                          child: Image.network(listDetails[0].events![2].image.toString(), fit: BoxFit.cover),
                                        ),
                                      )),
                                  Container(
                                    height: 300,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, colors: [
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
                                      children: [
                                        Container(
                                            alignment: Alignment.bottomLeft, margin: const EdgeInsets.only(left: 16), child: Text(listDetails[0].events![2].eventName.toString(), style: const TextStyle(color: white, fontWeight: FontWeight.w400, fontFamily: gilroy, fontSize: 16))),
                                        Container(
                                          margin: const EdgeInsets.only(top: 6),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: btnBlack,
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                alignment: Alignment.topLeft,
                                                padding: const EdgeInsets.only(top: 4, bottom: 4, left: 2, right: 2),
                                                child: Text(listDetails[0].events![2].date.toString(),
                                                    overflow: TextOverflow.clip,
                                                    style: const TextStyle(fontWeight: FontWeight.w600,overflow: TextOverflow.clip, fontFamily: aileron, fontSize: 12, color: white)),
                                              ),
                                              Image.asset(
                                                "assets/images/ic_user_placeholder.png",
                                                height: 28,
                                                width: 28,
                                                color: darkGray,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 30, left: 24, right: 24, top: 22),
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          child: TextButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all<Color>(yellow)),
                            onPressed: () {

                            },
                            child: const Text("VIEW ALL", style: TextStyle(fontWeight: FontWeight.w400, fontFamily: gilroy, fontSize: 16, color: black)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 14, right: 14),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: bgOverlay,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(22, 26, 12, 16),
                                child: const Text(
                                  "Live",
                                  style: TextStyle(fontWeight: FontWeight.w400, color: white, fontFamily: gilroy, fontSize: 22),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Stack(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      height: 270,
                                      width: MediaQuery.of(context).size.width,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20), // Image border
                                        child: Image.network(listDetails[0].live![0].image.toString(), width: MediaQuery.of(context).size.width, height: 230, fit: BoxFit.cover),
                                      )),
                                  Container(
                                    height: 300,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, colors: [
                                          black.withOpacity(0.0),
                                          black,
                                        ], stops: const [
                                          0.2,
                                          1.0
                                        ])),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 20, top: 20),
                                        height: 30,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: btnBlack,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              height: 5,
                                              width: 5,
                                              decoration: BoxDecoration(
                                                color: red,
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                            Container(alignment: Alignment.center, margin: const EdgeInsets.only(left: 4), child: const Text("LIVE", style: TextStyle(color: white, fontWeight: FontWeight.w400, fontFamily: gilroy, fontSize: 12))),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          alignment: Alignment.bottomLeft, margin: const EdgeInsets.only(top: 110, left: 16), child: Text(listDetails[0].live![0].location.toString(), style: const TextStyle(color: white, fontWeight: FontWeight.w400, fontFamily: gilroy, fontSize: 14))),
                                      Container(alignment: Alignment.bottomLeft, margin: const EdgeInsets.only(top: 10, left: 16), child: Text(listDetails[0].live![0].title.toString(), style: const TextStyle(color: white, fontWeight: FontWeight.w400, fontFamily: gilroy, fontSize: 16))),
                                      Container(
                                        margin: const EdgeInsets.only(left: 14, right: 14),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: bgMain,
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              alignment: Alignment.topLeft,
                                              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                                              child: Text(listDetails[0].live![0].date.toString(), style: const TextStyle(fontWeight: FontWeight.w400, fontFamily: aileron, fontSize: 12, color: white)),
                                            ),
                                            Image.asset(
                                              "assets/images/ic_user_placeholder.png",
                                              height: 45,
                                              width: 45,
                                              color: darkGray,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 14, right: 14, top: 10),
                          child: Stack(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  height: 220,
                                  width: MediaQuery.of(context).size.width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20), // Image border
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(48), // Image radius
                                      child: Image.network(
                                        listDetails[0].live![1].image.toString(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )),
                              Container(
                                height: 300,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, colors: [
                                      black.withOpacity(0.0),
                                      black,
                                    ], stops: const [
                                      0.2,
                                      1.0
                                    ])),
                              ),
                              Column(
                                children: [
                                  Container(
                                      alignment: Alignment.bottomLeft, margin: const EdgeInsets.only(top: 160, left: 16), child: Text(listDetails[0].live![1].location.toString(), style: const TextStyle(color: white, fontWeight: FontWeight.w400, fontFamily: aileron, fontSize: 14))),
                                  Container(alignment: Alignment.bottomLeft, margin: const EdgeInsets.only(top: 10, left: 16), child: Text(listDetails[0].live![1].title.toString(), style: const TextStyle(color: white, fontWeight: FontWeight.w400, fontFamily: gilroy, fontSize: 16))),
                                  Container(
                                    margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: btnBlack,
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                height: 5,
                                                width: 5,
                                                decoration: BoxDecoration(
                                                  color: red,
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                              ),
                                              Container(alignment: Alignment.center, margin: const EdgeInsets.only(left: 4), child: const Text("LIVE", style: TextStyle(color: white, fontWeight: FontWeight.w400, fontFamily: gilroy, fontSize: 12))),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                            color: lightblack,
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(listDetails[0].live![1].date.toString(), style: const TextStyle(fontWeight: FontWeight.w400, fontFamily: aileron, fontSize: 12, color: white)),
                                          ),
                                        ),
                                        const Spacer(),
                                        Image.asset(
                                          "assets/images/ic_user_placeholder.png",
                                          height: 24,
                                          width: 24,
                                          color: darkGray,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(14),
                          alignment: Alignment.center,
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: yellow,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            "VIEW ALL",
                            style: TextStyle(color: black, fontSize: 16, fontFamily: gilroy, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 14, right: 14, top: 30),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: bgOverlay,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text(
                                  "About",
                                  style: TextStyle(fontWeight: FontWeight.w500, color: white, fontFamily: gilroy, fontSize: 24),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Stack(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      height: 350,
                                      width: MediaQuery.of(context).size.width,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20), // Image border
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(48), // Image radius
                                          child: Image.asset('assets/images/ic_naveen_jindal.png', fit: BoxFit.cover),
                                        ),
                                      )),
                                  Container(
                                    height: 300,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, colors: [
                                          black.withOpacity(0.0),
                                          black,
                                        ], stops: const [
                                          0.2,
                                          1.0
                                        ])),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                          alignment: Alignment.bottomLeft,
                                          margin: const EdgeInsets.only(top: 190, left: 16),
                                          child: Text(listDetails[0].about![0].aboutData![0].name.toString(), style: const TextStyle(color: white, fontWeight: FontWeight.w400, fontFamily: gilroy, fontSize: 32))),
                                      Container(
                                          alignment: Alignment.bottomLeft,
                                          margin: const EdgeInsets.only(top: 10, left: 16),
                                          child: Text(listDetails[0].about![0].aboutData![0].subTitle.toString(), style: const TextStyle(color: white, fontWeight: FontWeight.w400, fontFamily: aileron, fontSize: 18))),
                                      Container(
                                          alignment: Alignment.bottomLeft,
                                          margin: const EdgeInsets.only(top: 10, left: 16),
                                          child: Text(listDetails[0].about![0].aboutData![0].detail.toString(), style: const TextStyle(color: white, fontWeight: FontWeight.w400, fontFamily: aileron, fontSize: 14))),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                       /* Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: 120,
                                    height: 40,
                                    margin: const EdgeInsets.only(left: 10, right: 20, top: 14),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: text_light,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text("BIOGRAPHY", style: TextStyle(fontWeight: FontWeight.w500, fontFamily: gilroy, fontSize: 14, color: white)),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 120,
                                    height: 40,
                                    margin: const EdgeInsets.only(left: 10, right: 20, top: 14),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: text_light,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text("INSPIRATION", style: TextStyle(fontWeight: FontWeight.w500, fontFamily: gilroy, fontSize: 14, color: white)),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: 120,
                                    height: 40,
                                    margin: const EdgeInsets.only(left: 10, right: 20, top: 14),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: text_light,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text("MISSION", style: TextStyle(fontWeight: FontWeight.w500, fontFamily: gilroy, fontSize: 14, color: white)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 200,
                              height: 40,
                              margin: const EdgeInsets.only( top: 14,left: 20),
                              decoration: BoxDecoration(
                                color: text_light,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text("MEMBER OF PARLIAMENT", style: TextStyle(fontWeight: FontWeight.w500, fontFamily: gilroy, fontSize: 14, color: white),textAlign: TextAlign.center,),
                              ),
                            ),
                            Spacer()
                          ],
                        ),*/
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 20, left: 14, right: 14),
                          alignment: Alignment.center,
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: yellow,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            "ABOUT NAVEEN JINDAL",
                            style: TextStyle(color: black, fontSize: 16, fontFamily: gilroy, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            color: bgOverlay,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                        child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: darkGray,
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(14.0),
                                        child: Text(
                                          "Gallery",
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )),
                                    Flexible(
                                        child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Videos",
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: text_light),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 14, right: 6),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Stack(
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(35), border: Border.all(width: 1, color: Colors.transparent, style: BorderStyle.solid)),
                                                height: 180,
                                                width: MediaQuery.of(context).size.width,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(20), // Image border
                                                  child: SizedBox.fromSize(
                                                    size: const Size.fromRadius(48), // Image radius
                                                    child: Image.network(listDetails[0].gallery![0].image.toString(), fit: BoxFit.cover),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Container(width: 12),
                                      Flexible(
                                        child: Stack(children: [
                                          Container(
                                              decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(35), border: Border.all(width: 1, color: Colors.transparent, style: BorderStyle.solid)),
                                              height: 180,
                                              width: MediaQuery.of(context).size.width,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(20), // Image border
                                                child: SizedBox.fromSize(
                                                  size: const Size.fromRadius(48), // Image radius
                                                  child: Image.network(listDetails[0].gallery![1].image.toString(), fit: BoxFit.cover),
                                                ),
                                              )),
                                        ]),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 160,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8, left: 14, right: 14, top: 22),
                                    decoration: const BoxDecoration(color: text_dark),
                                    child: SmoothPageIndicator(
                                      controller: controller,
                                      count: 3,
                                      effect: const SlideEffect(spacing: 2.0, radius: 0.0, dotWidth: 30.0, dotHeight: 2.5, paintStyle: PaintingStyle.stroke, strokeWidth: 0, dotColor: text_dark, activeDotColor: lightGray),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 14),
                                  height: 55,
                                  width: MediaQuery.of(context).size.width,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        backgroundColor: MaterialStateProperty.all<Color>(yellow)),
                                    onPressed: () {
                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
                                    },
                                    child: const Text("VIEW ALL", style: TextStyle(fontWeight: FontWeight.w400, fontFamily: gilroy, fontSize: 16, color: black)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 14, right: 14, top: 44),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: bgOverlay,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text(
                                  "Media Management",
                                  style: TextStyle(fontWeight: FontWeight.w500, color: white, fontFamily: gilroy, fontSize: 24),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                      child: Column(
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.only(left: 14, right: 4),
                                          decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(30), border: Border.all(width: 1, color: Gray, style: BorderStyle.solid)),
                                          height: 280,
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                height: 100,
                                                width: MediaQuery.of(context).size.width,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(30), // Image border
                                                  child: SizedBox.fromSize(
                                                    size: const Size.fromRadius(48), // Image radius
                                                    child: Image.asset(
                                                      'assets/images/ic_naveen_jindal.png',
                                                      fit: BoxFit.cover,
                                                      width: MediaQuery.of(context).size.width,
                                                      alignment: Alignment.topRight,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: Text(
                                                  "#SelfiewithDaughter-\nWatching the \n#USOpen 2022 with my daughter Yashasvini.",
                                                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12, fontFamily: aileron, color: white),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                margin: const EdgeInsets.only(top: 70, right: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        margin: const EdgeInsets.only(left: 10, right: 20),
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          color: lightblack.withOpacity(0.3),
                                                          borderRadius: BorderRadius.circular(30),
                                                        ),
                                                        child: const Padding(
                                                          padding: EdgeInsets.all(4.0),
                                                          child: Text("23 hours ago", style: TextStyle(fontWeight: FontWeight.w400, fontFamily: aileron, fontSize: 11, color: white)),
                                                        ),
                                                      ),
                                                    ),
                                                    Image.asset(
                                                      "assets/images/ic_user_placeholder.png",
                                                      height: 30,
                                                      width: 30,
                                                      color: yellow,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  )),
                                  Flexible(
                                      child: Column(
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.only(left: 14, right: 4),
                                          decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(30), border: Border.all(width: 1, color: Gray, style: BorderStyle.solid)),
                                          height: 280,
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                height: 100,
                                                width: MediaQuery.of(context).size.width,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(30), // Image border
                                                  child: SizedBox.fromSize(
                                                    size: const Size.fromRadius(48), // Image radius
                                                    child: Image.asset(
                                                      'assets/images/ic_naveen_jindal.png',
                                                      fit: BoxFit.cover,
                                                      width: MediaQuery.of(context).size.width,
                                                      alignment: Alignment.topRight,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: Text(
                                                  "AAp Sabhi ko #hindi divas ki hardik subhkamnaye! aaj hi ke din 14 sep1949 ko bharat ki savindhan  sabha ne hindi ko rajsabha ke rup me apnaya tha.",
                                                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12, fontFamily: aileron, color: white),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                margin: const EdgeInsets.only(top: 20, right: 10, bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        margin: const EdgeInsets.only(left: 10, right: 20),
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          color: lightblack.withOpacity(0.3),
                                                          borderRadius: BorderRadius.circular(30),
                                                        ),
                                                        child: const Padding(
                                                          padding: EdgeInsets.all(4.0),
                                                          child: Text("14.09.2022", style: TextStyle(fontWeight: FontWeight.w400, fontFamily: aileron, fontSize: 12, color: white)),
                                                        ),
                                                      ),
                                                    ),
                                                    Image.asset(
                                                      "assets/images/ic_user_placeholder.png",
                                                      height: 30,
                                                      width: 30,
                                                      color: yellow,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ))
                                ],
                              ),
                              Container(
                                  margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                                  decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(30), border: Border.all(width: 1, color: Gray, style: BorderStyle.solid)),
                                  height: 160,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                                margin: const EdgeInsets.only(left: 14, right: 4, top: 6),
                                                child: const Text(
                                                  "#queenelizabeth's passing away marks the end of an era.She was na remarkable lady who  presided over the #unitedkingdom for decides with grace & dignity..",
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12, fontFamily: aileron,overflow: TextOverflow.clip, color: white),
                                                )),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 6, right: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            height: 100,
                                            width: 100,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20), // Image border
                                              child: SizedBox.fromSize(
                                                size: const Size.fromRadius(48), // Image radius
                                                child: Image.asset(
                                                  'assets/images/ic_naveen_jindal.png',
                                                  fit: BoxFit.cover,
                                                  width: MediaQuery.of(context).size.width,
                                                  alignment: Alignment.topRight,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(top: 10, right: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(left: 10, right: 140),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: lightblack.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Text("08.09.2022", style: TextStyle(fontWeight: FontWeight.w400, fontFamily: aileron, fontSize: 14, color: white)),
                                                ),
                                              ),
                                            ),
                                            Image.asset(
                                              "assets/images/ic_user_placeholder.png",
                                              height: 30,
                                              width: 30,
                                              color: yellow,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                margin: const EdgeInsets.only(top: 14, bottom: 14, right: 14, left: 14),
                                height: 55,
                                width: MediaQuery.of(context).size.width,
                                child: TextButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      backgroundColor: MaterialStateProperty.all<Color>(yellow)),
                                  onPressed: () {
                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
                                  },
                                  child: const Text("VIEW ALL", style: TextStyle(fontWeight: FontWeight.w400, fontFamily: gilroy, fontSize: 16, color: black)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
        ),
        onWillPop: () {
          SystemNavigator.pop();
          return Future.value(true);
        }
        );
  }

  _DashboardApi() async {
    setState(() {
      _isLoading = true;
    });

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(MAIN_URL + dashboardApi);

    final response = await http.get(url);
    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = DashboardModel.fromJson(user);

    if (statusCode == 200) {
      if (dataResponse.details!.isNotEmpty) {
        listDetails = dataResponse.details!;
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void castStatefulWidget() {
    widget is DashboardScreen;
  }
}

class VideoWidget extends StatefulWidget {
  final bool play;
  final String url;
  const VideoWidget({Key? key, required this.url, required this.play}) : super(key: key);
  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget>
{
  late VideoPlayerController videoPlayerController ;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    if(widget.url.startsWith("http"))
    {
      videoPlayerController = VideoPlayerController.network(widget.url);
    }
    else
    {
      //videoPlayerController = VideoPlayerController.file(File(""));
    }

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          {
            return SizedBox(
              height: 200,
              width: double.infinity,
              key: PageStorageKey(widget.url),
              child: Column(
                children: <Widget>[
                  Expanded(flex: 1, child: Chewie(
                    key: PageStorageKey(widget.url),
                    controller: ChewieController(
                      videoPlayerController: videoPlayerController,
                      aspectRatio: 16 / 9,
                      autoInitialize: true,
                      showControls: false,
                      looping: true,
                      autoPlay: true,
                      errorBuilder: (context, errorMessage) {
                        return Center(
                          child: Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ))
                ],
              ),
            );
          }
        else
          {
            return const Center(
              child: CircularProgressIndicator(),);
          }
      },
    );
  }
}