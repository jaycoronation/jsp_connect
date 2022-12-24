import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:jspl_connect/screen/AboutJSPLScreen.dart';
import 'package:jspl_connect/screen/AboutScreen.dart';
import 'package:jspl_connect/screen/LeadershipScreen.dart';
import 'package:jspl_connect/screen/MediaCoverageScreen.dart';
import 'package:jspl_connect/screen/SocialWallScreen.dart';
import 'package:jspl_connect/widget/social_block.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import '../../constant/api_end_point.dart';
import '../../constant/colors.dart';
import '../../model/DashBoardDataResponse.dart';
import '../../model/NotificationCountResponse.dart';
import '../../utils/app_utils.dart';
import '../../utils/base_class.dart';
import '../../widget/loading.dart';
import '../../widget/news_block.dart';
import '../../widget/video_block.dart';
import '../CommonDetailsScreen.dart';
import '../MagazineListScreen.dart';
import '../NavigationDrawerScreen.dart';
import '../NotificationListScreen.dart';

class DashboardNewScreen extends StatefulWidget {
  const DashboardNewScreen({Key? key}) : super(key: key);

  @override
  _DashboardNewScreen createState() => _DashboardNewScreen();
}

class _DashboardNewScreen extends BaseState<DashboardNewScreen> {
  
  bool _isLoading = false;
  List<Posts> listSocial = List<Posts>.empty(growable: true);
  List<Posts> listVideos = List<Posts>.empty(growable: true);
  List<Posts> listEvents = List<Posts>.empty(growable: true);
  List<Posts> listNews = List<Posts>.empty(growable: true);

  final controller = PageController(viewportFraction: 1, keepPage: true);
  final controllerNew = PageController(viewportFraction: 0.90, keepPage: false);
  final controllerSocial = PageController(viewportFraction: 1, keepPage: true);
  final controllerEvents = PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState() {
    if (isOnline) {
      getDashboradData();
    } else {
      noInterNet(context);
    }
    isHomeReload = false;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: newScreenBg,
          appBar: AppBar(
            toolbarHeight: 60,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            leading: GestureDetector(
              onTap: () {
                HapticFeedback.vibrate();
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NavigationDrawerScreen()));
              },
              child: Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: Image.asset('assets/images/menu.png', height: 22, width: 22, color: black),
              ),
            ),
            title: Text(
              "Discover",
              style: TextStyle(fontWeight: FontWeight.w600, color: black, fontFamily: roboto),
            ),
            actions: [
              GestureDetector(
                onTap: () async {},
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/search.png', height: 22, width: 22, color: black),
                ),
              ),
             
              GestureDetector(
                onTap: () {
                  setState(() {
                    sessionManager.setUnreadNotificationCount(0);
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationListScreen()));
                },
                child: Stack(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 6, right: 10),
                      child: Image.asset('assets/images/notification_white.png', color: black,height: 22, width: 22),
                    ),
                    sessionManager.getUnreadNotificationCount()! > 0 ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: orangeNew,
                      ),
                      height: 22,
                      width: 22,
                      alignment: Alignment.topRight,
                      margin: const EdgeInsets.only(left: 22,top: 10),
                      child: Center(
                        child: Text(checkValidString(sessionManager.getUnreadNotificationCount().toString()),
                            maxLines: 1,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: whiteConst,
                                fontSize: 11)),
                      ),
                    ) : Container(),
                  ],
                ),
              ),
            ],
            centerTitle: false,
            elevation: 0,
            backgroundColor: screenBg,
          ),
          body: _isLoading
              ? const LoadingWidget()
              : RefreshIndicator(
                color: orange,
                onRefresh: _refresh,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 12,left: 12),
                          height: 135,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Column(
                                children: [
                                  TouchRippleEffect(
                                    borderRadius: BorderRadius.circular(18),
                                    rippleColor: Colors.white60,
                                    rippleDuration: const Duration(milliseconds: 100),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutJSPLScreen()));
                                    },
                                    child: Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: border,width: 2),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: CircleAvatar(
                                          radius: 48,
                                          backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgyscUUTE5JRATut4NyA_H02hk4_3OiShe6w&usqp=CAU"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Text(
                                    "About JSP",
                                    style: TextStyle(color: black, fontFamily: roboto, fontSize: 14, fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              Container(
                                width: 6,
                              ),
                              Column(
                                children: [
                                  TouchRippleEffect(
                                    borderRadius: BorderRadius.circular(18),
                                    rippleColor: Colors.white60,
                                    rippleDuration: const Duration(milliseconds: 100),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
                                    },
                                    child: Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: border,width: 2),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: CircleAvatar(
                                          radius: 48,
                                          backgroundImage: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/Naveen_Jindal_at_the_India_Economic_Summit_2010_cropped.jpg/800px-Naveen_Jindal_at_the_India_Economic_Summit_2010_cropped.jpg"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Text(
                                    "Shri Naveen Jindal",
                                    style: TextStyle(color: black, fontFamily: roboto, fontSize: 14, fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              Container(
                                width: 6,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SocialWallScreen()));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: border,width: 2),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: CircleAvatar(
                                          radius: 48,
                                          backgroundImage: NetworkImage("https://d2lptvt2jijg6f.cloudfront.net/Flag%20Foundation/page/1598931776_lapal-pin.jpg"),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 10,
                                    ),
                                    Text(
                                      "Social",
                                      style: TextStyle(color: black, fontFamily: roboto, fontSize: 14, fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 6,
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MediaCoverageScreen()));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: border,width: 2),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: CircleAvatar(
                                          radius: 48,
                                          backgroundImage: NetworkImage("https://res.cloudinary.com/dliifke2y/image/upload/v1669291963/Naveen%20Jindal/0X4A0431-min_ospsox.jpg"),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 10,
                                    ),
                                    Text(
                                      "Media Coverage",
                                      style: TextStyle(color: black, fontFamily: roboto, fontSize: 14, fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 6,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MagazineListScreen()));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: border,width: 2),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: CircleAvatar(
                                          radius: 48,
                                          backgroundImage: NetworkImage("https://res.cloudinary.com/dliifke2y/image/upload/v1669291685/Naveen%20Jindal/_SAM9274_jxcxzj.jpg"),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 10,
                                    ),
                                    Text(
                                      "Magazine",
                                      style: TextStyle(color: black, fontFamily: roboto, fontSize: 14, fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 6,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LeadershipScreen()));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: border,width: 2),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: CircleAvatar(
                                          radius: 48,
                                          backgroundImage: NetworkImage("https://indiacsr.in/wp-content/uploads/2022/11/Jindal-Steel-Power-Limited-board-members-1.jpg"),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 10,
                                    ),
                                    Text(
                                      "Our Leadership",
                                      style: TextStyle(color: black, fontFamily: roboto, fontSize: 14, fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 12, right: 12, top: 22),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("What's New",style: TextStyle(fontFamily: roboto, fontSize: 18, color: black, fontWeight: FontWeight.w600),),
                              Row(
                                children: [
                                  const Text("See All",style: const TextStyle(color: text_dark,fontWeight: FontWeight.w500,fontSize: 14,fontFamily: roboto),),
                                  Container(width: 4,),
                                  const Icon(Icons.arrow_forward_ios,color: border,size: 12,)
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 470,
                          width: double.infinity,
                          child: PageView.builder(
                            controller: controllerNew,
                            itemCount: 3,
                            pageSnapping: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: white,
                                ),
                                margin: const EdgeInsets.fromLTRB(0, 12, 12, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(topLeft: const Radius.circular(20),topRight: const Radius.circular(20)),
                                          child: Image.network("https://pbs.twimg.com/media/FkpkP2KUAAEvVcQ?format=jpg&name=medium",
                                              width: MediaQuery.of(context).size.width,
                                            height: 300,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 12,
                                            right: 56,
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: white.withOpacity(0.6),
                                                shape: BoxShape.circle
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Image.asset("assets/images/like.png",width: 24,height: 24),
                                              ),
                                            )
                                        ),
                                        Positioned(
                                            bottom: 12,
                                            right: 12,
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                  color: white.withOpacity(0.6),
                                                  shape: BoxShape.circle
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Image.asset("assets/images/share.png",width: 24,height: 24),
                                              ),
                                            )
                                        )
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                      child: Text(
                                        "Building A Nation of Our Dreams",
                                        style: TextStyle(
                                            height: 1.5,
                                            color: black,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: gilroy,
                                            fontSize: 18,
                                            overflow: TextOverflow.clip),
                                        maxLines: 3,
                                      ),
                                    ),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                                      child: const Text("1 hour ago",
                                          style: const TextStyle(color: text_dark, fontFamily: roboto, fontWeight: FontWeight.w600, fontSize: 12)),
                                    ),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                                      child: Text(
                                        "Led by Mr Naveen Jindal, the company’s enviable success story has been scripted essentially by its resolve to innovate, set new standards, enhance capabilities, enrich lives and to ensure that it stays true to its cherished value system.",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            height: 1.5,
                                            color: black,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: gilroy,
                                            fontSize: 14,
                                            overflow: TextOverflow.clip),
                                        maxLines: 3,
                                      ),
                                    ),

                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 18),
                          padding: const EdgeInsets.fromLTRB(12, 22, 12, 22),
                          height: 240,
                          color: white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Quick Links",style: TextStyle(fontFamily: roboto, fontSize: 18, color: black, fontWeight: FontWeight.w600),),
                              Container(height: 12),
                              Wrap(
                                spacing: 6.0,
                                runSpacing: 6.0,
                                children: <Widget>[
                                  _buildChip('Foundation'),
                                  _buildChip('Magazine'),
                                  _buildChip('Jindal Panther'),
                                  _buildChip('News'),
                                  _buildChip('Education'),
                                  _buildChip('Media'),
                                  _buildChip('Investment'),
                                  _buildChip('Safety'),
                                  _buildChip('Blogs'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                            visible: listSocial.isNotEmpty,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 14, right: 14, top: 22),
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Social Media',
                                        style: TextStyle(fontFamily: roboto, fontSize: 18, color: black, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            )),
                        Visibility(
                            visible: listSocial.isNotEmpty,
                            child: SizedBox(
                                height: 450,
                                child: PageView.builder(
                                  controller: controllerSocial,
                                  itemCount: listSocial.length,
                                  physics: const ScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return SocialBlock(
                                      listSocial: listSocial,
                                      index: index,
                                      setState: setState,
                                    );
                                  },
                                ))),
                        Visibility(
                            visible: listSocial.length > 1,
                            child: Wrap(
                              children: [
                                Container(
                                  width: listSocial.length * 36,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(bottom: 10, left: 14, right: 14, top: 12),
                                  decoration: const BoxDecoration(color: text_dark),
                                  child: SmoothPageIndicator(
                                    controller: controllerSocial,
                                    count: listSocial.length,
                                    effect: const SlideEffect(
                                        spacing: 2.0,
                                        radius: 0.0,
                                        dotWidth: 36.0,
                                        dotHeight: 2.5,
                                        paintStyle: PaintingStyle.stroke,
                                        strokeWidth: 0,
                                        dotColor: Colors.transparent,
                                        activeDotColor: orangeNew),
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          margin: const EdgeInsets.only(left: 12, right: 12, top: 22),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Chairman's Message",
                                        style: TextStyle(fontFamily: roboto, fontSize: 22, color: black, fontWeight: FontWeight.w900)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: newsBlock,
                          ),
                          margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "A well-known Indian Industrialist and Philanthropist, Mr Naveen Jindal is the Chairman of Jindal steel & Power limited (JSPL), India’s leading infrastructure Conglomerate with interests in steel, mining and power sector.",
                                      style: TextStyle(
                                          height: 1.5,
                                          color: black,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: gilroy,
                                          fontSize: 14,
                                          overflow: TextOverflow.clip),
                                    ),
                                    Container(
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 12,
                              ),
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.asset("assets/images/ic_naveen_video_2.png", width: 100, height: 100, fit: BoxFit.cover),
                                ),
                              )
                            ],
                          ),
                        ),

                        Wrap(
                          children: [
                            Container(
                              width: 3 * 36,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(bottom: 10, left: 14, right: 14, top: 12),
                              decoration: const BoxDecoration(color: text_dark),
                              child: SmoothPageIndicator(
                                controller: controllerNew,
                                count: 3,
                                effect: const SlideEffect(
                                    spacing: 2.0,
                                    radius: 0.0,
                                    dotWidth: 36.0,
                                    dotHeight: 2.5,
                                    paintStyle: PaintingStyle.stroke,
                                    strokeWidth: 0,
                                    dotColor: Colors.transparent,
                                    activeDotColor: orangeNew),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                            visible: listEvents.isNotEmpty,
                            child: Container(
                              margin: const EdgeInsets.only(left: 12, right: 12, top: 22),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /*Text("Events & Engagements",style: TextStyle(fontFamily: roboto,fontSize: 20,
                                  foreground: Paint()..shader = linearGradient,fontWeight: FontWeight.w900),),*/
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Events',
                                            style: TextStyle(fontFamily: roboto, fontSize: 22, color: black, fontWeight: FontWeight.w900)),
                                        TextSpan(
                                          text: ' & ',
                                          style: TextStyle(fontFamily: roboto, fontSize: 22, color: black, fontWeight: FontWeight.w900),
                                        ),
                                        TextSpan(
                                            text: 'Engagements',
                                            style: TextStyle(fontFamily: roboto, fontSize: 22, color: black, fontWeight: FontWeight.w900)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                        Visibility(
                            visible: listEvents.isNotEmpty,
                            child: SizedBox(
                              height: 400,
                              child: PageView.builder(
                                controller: controllerEvents,
                                itemCount: listEvents.length,
                                physics: const ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      final result = await Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => CommonDetailsScreen(listEvents[index].id.toString(), "2")));
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
                                                listEvents[index].featuredImage.toString(),
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
                                                    ])),
                                          ),
                                          Positioned(
                                              top: 12,
                                              left: 12,
                                              child: Container(
                                                  decoration:
                                                  BoxDecoration(color: whiteConst.withOpacity(0.4), borderRadius: BorderRadius.circular(22)),
                                                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                                                  child: Text(
                                                    listEvents[index].location.toString(),
                                                    style: const TextStyle(color: blackConst, fontSize: 14, fontWeight: FontWeight.w400),
                                                  ))),
                                          Positioned(
                                            bottom: 12,
                                            child: Column(
                                              children: [
                                                Container(
                                                    width: MediaQuery.of(context).size.width - 50,
                                                    margin: const EdgeInsets.only(bottom: 0, left: 14, right: 14),
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      listEvents[index].title.toString(),
                                                      overflow: TextOverflow.clip,
                                                      style: const TextStyle(
                                                          color: whiteConst,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: gilroy,
                                                          fontSize: 16,
                                                          overflow: TextOverflow.ellipsis),
                                                    )),
                                                Row(
                                                  children: [
                                                    Container(
                                                        width: MediaQuery.of(context).size.width - 50,
                                                        margin: const EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                          listEvents[index].saveTimestamp.toString(),
                                                          style: const TextStyle(
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
                                  );
                                },
                              ),
                            )),
                        Visibility(
                            visible: listEvents.length > 1,
                            child: Wrap(
                              children: [
                                Container(
                                  width: listEvents.length.toDouble() * 36,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(bottom: 10, left: 14, right: 14, top: 12),
                                  decoration: const BoxDecoration(color: text_light),
                                  child: SmoothPageIndicator(
                                    controller: controllerEvents,
                                    count: listEvents.length,
                                    effect: const SlideEffect(
                                        spacing: 2.0,
                                        radius: 0.0,
                                        dotWidth: 36.0,
                                        dotHeight: 2.5,
                                        paintStyle: PaintingStyle.stroke,
                                        strokeWidth: 0,
                                        dotColor: Colors.transparent,
                                        activeDotColor: orangeNew),
                                  ),
                                ),
                              ],
                            )),
                        Visibility(
                            visible: listVideos.isNotEmpty,
                            child: Container(
                              margin: const EdgeInsets.only(left: 12, right: 12, top: 22),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /* Text("Videos",style: TextStyle(fontFamily: roboto,fontSize: 20,
                                  foreground: Paint()..shader = linearGradient,fontWeight: FontWeight.w900),),*/
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Videos',
                                            style: TextStyle(fontFamily: roboto, fontSize: 22, color: black, fontWeight: FontWeight.w900)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                        Visibility(
                            visible: listVideos.isNotEmpty,
                            child: Container(
                              margin: const EdgeInsets.only(top: 22),
                              height: 450,
                              child: PageView.builder(
                                controller: controller,
                                itemCount: listVideos.length,
                                physics: const ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return VideoBlock(
                                    listVideos: listVideos,
                                    index: index,
                                    setState: setState,
                                  );
                                },
                              ),
                            )),
                        Visibility(
                            visible: listVideos.length > 1,
                            child: Wrap(
                              children: [
                                Container(
                                  width: listVideos.length.toDouble() * 36,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(bottom: 10, left: 14, right: 14, top: 24),
                                  decoration: const BoxDecoration(color: text_light),
                                  child: SmoothPageIndicator(
                                    controller: controller,
                                    count: listVideos.length,
                                    effect: const SlideEffect(
                                        spacing: 2.0,
                                        radius: 0.0,
                                        dotWidth: 36.0,
                                        dotHeight: 2.5,
                                        paintStyle: PaintingStyle.stroke,
                                        strokeWidth: 0,
                                        dotColor: Colors.transparent,
                                        activeDotColor: orange),
                                  ),
                                ),
                              ],
                            )),
                        Visibility(
                            visible: listNews.isNotEmpty,
                            child: Container(
                              margin: const EdgeInsets.only(left: 12, right: 12, top: 22),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'News',
                                            style: TextStyle(fontFamily: roboto, fontSize: 22, color: black, fontWeight: FontWeight.w900)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                        Visibility(
                            visible: listNews.isNotEmpty,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              primary: false,
                              shrinkWrap: true,
                              itemCount: listNews.length,
                              itemBuilder: (context, index) {
                                return NewsBlock(
                                  listNews: listNews,
                                  index: index,
                                  isFromNews: true,
                                  setState: setState,
                                );
                              },
                            )),
                        const Gap(20)
                      ],
                    ),
                  ),
                ),
              ),
        ),
        onWillPop: (){
          Navigator.pop(context);
          return Future.value(true);
        }
    );
  }

  @override
  void castStatefulWidget() {
    widget is DashboardNewScreen;
  }

  getDashboradData([bool isPull = false]) async {
    if (!isPull) {
      setState(() {
        _isLoading = true;
      });
    }

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + dashboardData);

    print("<><> TOKEN : " + sessionManager.getAccessToken().toString().trim() + " <><>");

    Map<String, String> jsonBody = {'from_app': FROM_APP, 'user_id': sessionManager.getUserId().toString()};

    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = DashBoardDataResponse.fromJson(apiResponse);
    if (statusCode == 200 && dataResponse.success == 1) {
      listSocial = List<Posts>.empty(growable: true);
      listVideos = List<Posts>.empty(growable: true);
      listEvents = List<Posts>.empty(growable: true);
      listNews = List<Posts>.empty(growable: true);
      if (dataResponse.postsList != null && dataResponse.postsList!.isNotEmpty) {
        for (int i = 0; i < dataResponse.postsList!.length; i++) {
          if (dataResponse.postsList![i].id == "1") // "Social Media"
              {
            if (dataResponse.postsList![i].posts != null) {
              if (dataResponse.postsList![i].posts!.isNotEmpty) {
                listSocial.addAll(dataResponse.postsList![i].posts!);
              }
            }
          } else if (dataResponse.postsList![i].id == "2") // "Events & Enagagements"
              {
            if (dataResponse.postsList![i].posts != null) {
              if (dataResponse.postsList![i].posts!.isNotEmpty) {
                listEvents.addAll(dataResponse.postsList![i].posts!);
              }
            }
          } else if (dataResponse.postsList![i].id == "3") // "Videos"
              {
            if (dataResponse.postsList![i].posts != null) {
              if (dataResponse.postsList![i].posts!.isNotEmpty) {
                listVideos.addAll(dataResponse.postsList![i].posts!);
              }
            }
          } else if (dataResponse.postsList![i].id == "4") // "News"
              {
            if (dataResponse.postsList![i].posts != null) {
              if (dataResponse.postsList![i].posts!.isNotEmpty) {
                listNews.addAll(dataResponse.postsList![i].posts!);
              }
            }
          }
        }
      }
    } else {
      showSnackBar(dataResponse.message, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> _refresh() {
    print("refresh......");
    if (isInternetConnected) {
      getDashboradData(true);
    } else {
      noInterNet(context);
    }
    return Future.value(true);
  }

    Widget _buildChip(String label) {
      return Chip(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelPadding: const EdgeInsets.all(2.0),
        label: Text(
          label,
          style: const TextStyle(
            color: border,
            fontFamily: roboto,
            fontSize: 12,
            fontWeight: FontWeight.w500
          ),
        ),
        backgroundColor: lightGrayNew,
        elevation: 1.0,
        shadowColor: lightGrayNew,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      );
    }
  }