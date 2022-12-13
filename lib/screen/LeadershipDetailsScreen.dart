import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:jspl_connect/model/LeadershipResponseModel.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/CommanResponse.dart';
import '../model/PostDetailsResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../utils/full_screen_image_new.dart';
import '../widget/loading.dart';

class LeadershipDetailsScreen extends StatefulWidget {
  final KeyManagment postDetails;

  const LeadershipDetailsScreen(this.postDetails, {Key? key}) : super(key: key);

  @override
  _LeadershipDetailsScreen createState() => _LeadershipDetailsScreen();
}

class _LeadershipDetailsScreen extends BaseState<LeadershipDetailsScreen> {
  late final KeyManagment postDetailsData;
  num isLiked = 0;
  bool _isLoading = false;

  @override
  void initState() {
    postDetailsData = (widget as LeadershipDetailsScreen).postDetails;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: black,
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
                          height: 22,
                          width: 22,
                        ),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 65,
                    margin: const EdgeInsets.only(left: 5),
                    child: const Text(
                      "",
                      style: TextStyle(fontWeight: FontWeight.w600, color: white, fontSize: 16),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
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
                },
                behavior: HitTestBehavior.opaque,
                child:  Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(right: 8),
                  child: Image.asset(isLiked == 1 ? "assets/images/like_filled.png" : "assets/images/like.png", height: 22, width: 22,color: isLiked == 1 ? Colors.yellow : white,),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(right: 8),
                child: Image.asset('assets/images/share.png', height: 22, width: 22, color: white),
              )
            ],
          ),
          body:  _isLoading
              ? const LoadingWidget() : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    List<String> listImage = [];
                    listImage.add(postDetailsData.img.toString().trim());
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
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                        color: white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 0.4, color: white.withOpacity(0.3), style: BorderStyle.solid)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: FadeInImage.assetNetwork(
                        image: postDetailsData.img.toString().trim(),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        placeholder: 'assets/images/bg_gray.jpeg',
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(postDetailsData.name.toString(), style: const TextStyle(color: white, fontSize: 22, fontWeight: FontWeight.w500, fontFamily: roboto)),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(postDetailsData.desgnation.toString(), style: const TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: roboto)),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 22, 16, 8),
                  child: Text(postDetailsData.messgae.toString(),style: const TextStyle(height: 1.5, color: white, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: roboto)),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        });
  }

  @override
  void castStatefulWidget() {
    widget is LeadershipDetailsScreen;
  }
}
