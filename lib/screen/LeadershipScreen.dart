import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jspl_connect/constant/colors.dart';
import 'package:jspl_connect/model/LeadershipResponseModel.dart';
import 'package:jspl_connect/screen/LeadershipDetailsScreen.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

import '../constant/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';

class LeadershipScreen extends StatefulWidget {

  const LeadershipScreen({Key? key}) : super(key: key);

  @override
  _LeadershipScreen createState() => _LeadershipScreen();
}

class _LeadershipScreen extends BaseState<LeadershipScreen> {
  bool _isLoading = false;
  List<KeyManagment> listKeyManagement = [];
  List<KeyManagment> listBoardOfDirectors = [];

  @override
  void initState() {
    if (isOnline) {
      leadershipAPI();
    } else {
      noInterNet(context);
    }
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
                      child: Image.asset('assets/images/ic_back_button.png', height: 22, width: 22, color: white),
                    )
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 65,
                  margin: const EdgeInsets.only(left: 5),
                  child: const Text(
                    "Our Leadership",
                    style: TextStyle(fontWeight: FontWeight.w600, color: white, fontSize: 16),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12,bottom: 12),
                    child: RichText(
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'K',
                            style: TextStyle(fontFamily: roboto, fontSize: 20, color: yellow, fontWeight: FontWeight.w900),
                          ),
                          TextSpan(text: 'ey', style: TextStyle(fontFamily: roboto, fontSize: 20, color: white, fontWeight: FontWeight.w900)),
                          TextSpan(
                            text: ' M',
                            style: TextStyle(fontFamily: roboto, fontSize: 20, color: yellow, fontWeight: FontWeight.w900),
                          ),
                          TextSpan(text: 'anagment', style: TextStyle(fontFamily: roboto, fontSize: 20, color: white, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    child: AnimationLimiter(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          primary: false,
                          shrinkWrap: true,
                          itemCount: listKeyManagement.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => LeadershipDetailsScreen(listKeyManagement[index])));
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          margin:const EdgeInsets.only(left: 4,right: 4),
                                          decoration:  BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(4)
                                          ),
                                          height: 150,
                                          width: 150,
                                          child: ClipRRect(
                                            borderRadius:  BorderRadius.circular(4),
                                            child: SizedBox.fromSize(
                                                size: const Size.fromRadius(48), // Image radius
                                                child:
                                                CachedNetworkImage(
                                                  imageUrl: listKeyManagement[index].img.toString(),
                                                  fit: BoxFit.cover,
                                                  width: 150,
                                                  height: 120,
                                                  errorWidget: (context, url, error) => Image.asset('assets/images/bg_gray.jpeg', width: MediaQuery.of(context).size.width,
                                                    height: 100,fit: BoxFit.cover,),
                                                  placeholder: (context, url) => Image.asset('assets/images/bg_gray.jpeg', width: MediaQuery.of(context).size.width,
                                                    height: 100,),
                                                )
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 150,
                                          margin: const EdgeInsets.only(left: 12,right: 12,top: 12),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(listKeyManagement[index].name.toString(),style: TextStyle(fontFamily: roboto,fontSize: 16, color: white,fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis),overflow: TextOverflow.ellipsis),
                                              Text(listKeyManagement[index].desgnation.toString(),style: TextStyle(fontFamily: roboto,fontSize: 12, color: white,fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis),overflow: TextOverflow.ellipsis),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12,bottom: 12),
                    child: RichText(
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'B',
                            style: TextStyle(fontFamily: roboto, fontSize: 20, color: yellow, fontWeight: FontWeight.w900),
                          ),
                          TextSpan(text: 'oard Of ', style: TextStyle(fontFamily: roboto, fontSize: 20, color: white, fontWeight: FontWeight.w900)),
                          TextSpan(
                            text: 'D',
                            style: TextStyle(fontFamily: roboto, fontSize: 20, color: yellow, fontWeight: FontWeight.w900),
                          ),
                          TextSpan(text: 'irectors', style: TextStyle(fontFamily: roboto, fontSize: 20, color: white, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: AnimationLimiter(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          primary: false,
                          shrinkWrap: true,
                          itemCount: listBoardOfDirectors.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => LeadershipDetailsScreen(listBoardOfDirectors[index])));
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          margin:const EdgeInsets.only(left: 4,right: 4),
                                          decoration:  BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(4)
                                          ),
                                          height: 150,
                                          width: 150,
                                          child: ClipRRect(
                                            borderRadius:  BorderRadius.circular(4),
                                            child: SizedBox.fromSize(
                                                size: const Size.fromRadius(48), // Image radius
                                                child:
                                                CachedNetworkImage(
                                                  imageUrl: listBoardOfDirectors[index].img.toString(),
                                                  fit: BoxFit.cover,
                                                  width: 150,
                                                  height: 120,
                                                  errorWidget: (context, url, error) => Image.asset('assets/images/bg_gray.jpeg', width: MediaQuery.of(context).size.width,
                                                    height: 100,fit: BoxFit.cover,),
                                                  placeholder: (context, url) => Image.asset('assets/images/bg_gray.jpeg', width: MediaQuery.of(context).size.width,
                                                    height: 100,),
                                                )
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 150,
                                          margin: const EdgeInsets.only(left: 12,right: 12,top: 12),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(listBoardOfDirectors[index].name.toString(),style: TextStyle(fontFamily: roboto,fontSize: 16, color: white,fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis),overflow: TextOverflow.ellipsis),
                                              Text(listBoardOfDirectors[index].desgnation.toString(),style: TextStyle(fontFamily: roboto,fontSize: 12, color: white,fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis),overflow: TextOverflow.ellipsis),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                    ),
                  ),
                ],
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
    widget is LeadershipScreen;
  }

  Future<void> leadershipAPI() async {
    setState((){
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(MAIN_URL + leadershipApi);

    final response = await http.get(url);
    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = LeadershipResponseModel.fromJson(user);

    if (statusCode == 200) {
      listKeyManagement = dataResponse.keyManagment ?? [];
      listBoardOfDirectors = dataResponse.boardOfDirectors ?? [];
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}