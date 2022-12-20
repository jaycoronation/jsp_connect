import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:jspl_connect/constant/colors.dart';
import 'package:jspl_connect/model/LeadershipResponseModel.dart';
import 'package:jspl_connect/screen/LeadershipDetailsScreen.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant/api_end_point.dart';
import '../model/LeadershipListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/no_data.dart';
import 'CommonDetailsScreen.dart';

class LeadershipScreen extends StatefulWidget {
  const LeadershipScreen({Key? key}) : super(key: key);

  @override
  _LeadershipScreen createState() => _LeadershipScreen();
}

class _LeadershipScreen extends BaseState<LeadershipScreen> {
  bool _isLoading = false;
  var listLeadership = List<PostData>.empty(growable: true);
  int pos = 0;

  @override
  void initState() {
    if (isOnline) {
      getListData();
    } else {
      noInterNet(context);
    }
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
            title: Row(
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
                      child: Image.asset('assets/images/ic_back_button.png', height: 22, width: 22, color: black),
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 65,
                  margin: const EdgeInsets.only(left: 5),
                  child:  Text(
                    "Our Leadership",
                    style: TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          body: _isLoading
              ? const LoadingWidget()
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 42,
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: false,
                            itemCount: listLeadership.length,
                            itemBuilder: (ctx, index) => (Container(
                                  margin: EdgeInsets.only(left: index == 0 ? 0 : 5, right: 5),
                                  height: 42,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: grayNew,
                                      onPrimary: grayNew,
                                      elevation: 0.0,
                                      padding: const EdgeInsets.only(left: 20, right: 20),
                                      side: BorderSide(color: pos == index ? orangeNew.withOpacity(0.6) : black.withOpacity(0.6), width: 0.6, style: BorderStyle.solid),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      tapTargetSize: MaterialTapTargetSize.padded,
                                      animationDuration: const Duration(milliseconds: 100),
                                      enableFeedback: true,
                                      alignment: Alignment.center,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        pos = index;
                                      });
                                    },
                                    child: Text(
                                      listLeadership[index].name.toString(),
                                      style: TextStyle(fontSize: 14, fontWeight: pos == index ? FontWeight.w600 : FontWeight.w500, color: pos == index ? orangeNew.withOpacity(0.8) : black.withOpacity(0.8), fontFamily: gilroy),
                                    ),
                                  ),
                                ))),
                      ),
                      Expanded(
                          child: listLeadership[pos].posts!.isNotEmpty
                              ? Padding(padding: EdgeInsets.all(12),
                                child: AnimationLimiter(
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: listLeadership[pos].posts!.length,
                                    itemBuilder: (context, indexNew) {
                                      return AnimationConfiguration.staggeredList(
                                        position: pos,
                                        duration: const Duration(milliseconds: 375),
                                        child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          child: FadeInAnimation(
                                            child: GestureDetector(
                                              onTap: () async {
                                                   final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CommonDetailsScreen(listLeadership[pos].posts![indexNew].id.toString(),"10")));
                                                   print(result);
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 12),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        border: Border.all(width: 0.6, color: white.withOpacity(0.4), style: BorderStyle.solid)),
                                                    child: Stack(children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(20), // Image border
                                                        child: CachedNetworkImage(
                                                          imageUrl: listLeadership[pos].posts![indexNew].featuredImagePath.toString(),
                                                          fit: BoxFit.cover,
                                                          width: MediaQuery.of(context).size.width,
                                                          height: 350,
                                                          errorWidget: (context, url, error) => Image.asset(
                                                            'assets/images/bg_gray.jpeg',
                                                            width: MediaQuery.of(context).size.width,
                                                            height: 350,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          placeholder: (context, url) => Image.asset(
                                                            'assets/images/bg_gray.jpeg',
                                                            width: MediaQuery.of(context).size.width,
                                                            height: 350,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 350,
                                                        decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            gradient:
                                                            LinearGradient(begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, colors: [
                                                              blackConst.withOpacity(0.2),
                                                              blackConst.withOpacity(1),
                                                            ], stops: const [
                                                              0.7,
                                                              1.0
                                                            ]),
                                                            borderRadius: BorderRadius.circular(20)),
                                                      ),
                                                      Container(
                                                          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 22),
                                                          height: 350,
                                                          color: Colors.transparent,
                                                          width: MediaQuery.of(context).size.width,
                                                          alignment: Alignment.bottomCenter,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Text(
                                                                toDisplayCase(listLeadership[pos].posts![indexNew].title.toString()),
                                                                overflow: TextOverflow.clip,
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: gilroy,
                                                                    color: whiteConst,
                                                                    fontSize: 18,
                                                                    overflow: TextOverflow.clip),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                              checkValidString(listLeadership[pos].posts![indexNew].designation).toString().isNotEmpty
                                                                  ? Text(
                                                                checkValidString(listLeadership[pos].posts![indexNew].designation),
                                                                overflow: TextOverflow.clip,
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: gilroy,
                                                                    color: whiteConst,
                                                                    fontSize: 18,
                                                                    overflow: TextOverflow.clip),
                                                                textAlign: TextAlign.center,
                                                              )
                                                                  : Container()
                                                            ],
                                                          ))
                                                    ]),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )))
                              : MyNoDataWidget(msg: "No " + listLeadership[pos].name.toString().toLowerCase() + " data found!")),
                    ],
                  ),
                ),
        ),
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        });
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffFFFFFF), Color(0xffaaa9a3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  void castStatefulWidget() {
    widget is LeadershipScreen;
  }

  getListData() async {
    setState(() {
      _isLoading = true;
    });

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + leadershipList);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'user_id': sessionManager.getUserId().toString(),
    };
    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = LeadershipListResponse.fromJson(apiResponse);

    if (statusCode == 200 && dataResponse.success == 1) {
      if (dataResponse.postData != null && dataResponse.postData!.isNotEmpty) {
        if (listLeadership.isNotEmpty) {
          listLeadership = [];
        }
        /*if (dataResponse.postData != null && dataResponse.postData!.isNotEmpty) {
          for (int i = 0; i < dataResponse.postData!.length; i++) {
            if (dataResponse.postData![i].posts != null && dataResponse.postData![i].posts!.isNotEmpty) {
              listLeadership.add(dataResponse.postData![i]);
            }
          }
        }*/
        listLeadership.addAll(dataResponse.postData!);
      }
    } else {
      showSnackBar(dataResponse.message, context);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
