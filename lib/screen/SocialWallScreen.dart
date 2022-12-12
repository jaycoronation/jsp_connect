import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/SocialResponseModel.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class SocialWallScreen extends StatefulWidget {
  const SocialWallScreen({Key? key}) : super(key: key);

  @override
  _SocialWallScreen createState() => _SocialWallScreen();
}

class _SocialWallScreen extends BaseState<SocialWallScreen> {
  bool _isLoading = false;
  List<SocialMedia> listSocial = [];

  @override
  void initState(){
    setState(() {
      _isLoading = true;
    });
    socialAPI();
    super.initState();
  }

  final Shader linearGradientSocial = const LinearGradient(
    colors: <Color>[Color(0xffFFFFFF), Color(0xff9b9b98)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 800.0, 120.0));

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
                        child: Image.asset('assets/images/ic_back_button.png',
                          height: 22, width: 22,color: white),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 65,
                    margin: const EdgeInsets.only(left: 5),
                    child: const Text(
                      "Social",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: white,
                          fontSize: 18),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: bgMain,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: Row(
                      children: [
                        Image.asset("assets/images/view.png",height: 12,width: 12,),
                        Container(width: 6),
                        const Text("8k Views",textAlign: TextAlign.center,style: TextStyle(color: white,fontSize: 14,fontWeight: FontWeight.w400,fontFamily: gilroy,),),
                      ],
                    ),
                  )
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
                     AnimationLimiter(
                       child: ListView.builder(
                         scrollDirection: Axis.vertical,
                         physics: const NeverScrollableScrollPhysics(),
                         shrinkWrap: true,
                         itemCount: listSocial.length,
                         itemBuilder:(context, index) {
                           return AnimationConfiguration.staggeredList(
                             position: index,
                             duration: const Duration(milliseconds: 375),
                             child: SlideAnimation(
                               verticalOffset: 50.0,
                               child: FadeInAnimation(
                                 child: GestureDetector(
                                   onTap: () async {
                                     if (listSocial[index].url!.isNotEmpty)
                                       {
                                         if (await canLaunchUrl(Uri.parse(listSocial[index].url!.toString())))
                                             {
                                               launchUrl(
                                                   Uri.parse(listSocial[index].url!.toString()),
                                                   mode: LaunchMode.externalNonBrowserApplication
                                               );
                                             }
                                       }
                                   },
                                   child: Container(
                                     height: 350,
                                     margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                                     decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(30),
                                         border: Border.all(width: 0.2, color: white.withOpacity(0.4), style: BorderStyle.solid)
                                     ),
                                     child: Stack(
                                       children: [
                                         Container(
                                           decoration: BoxDecoration(
                                             borderRadius: BorderRadius.circular(30),
                                           ),
                                           height: 350,
                                           alignment: Alignment.center,
                                           width: MediaQuery.of(context).size.width,
                                           child: ClipRRect(
                                             borderRadius: BorderRadius.circular(30), // Image border
                                             child: Image.network(
                                               listSocial[index].image.toString(),
                                               fit: BoxFit.cover,
                                               height: 350,
                                               width: MediaQuery.of(context).size.width,
                                             ),
                                           ),
                                         ),
                                         Container(
                                             margin: const EdgeInsets.only(right: 14,top: 14),
                                             alignment: Alignment.topRight,
                                             child: Image.asset(
                                               listSocial[index].social.toString() == "facebook"
                                                   ? "assets/images/facebook.png"
                                                   : listSocial[index].social.toString() == "twitter"
                                                   ? "assets/images/ic_twitter.png"
                                                   : "assets/images/ic_insta.png",
                                               height: 24,width: 24,color: white,)),
                                         Container(
                                           height: 350,
                                           decoration: BoxDecoration(
                                               color: Colors.white,
                                               borderRadius: BorderRadius.circular(30),
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
                                             mainAxisAlignment: MainAxisAlignment.start,
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Container(
                                                   width: MediaQuery.of(context).size.width - 50,
                                                   margin: const EdgeInsets.only(bottom: 0,left: 14,right: 14),
                                                   alignment: Alignment.centerLeft,
                                                   child: Text(listSocial[index].description.toString(),style: TextStyle(foreground:  Paint()..shader = linearGradientSocial, fontWeight: FontWeight.w600, fontFamily: gilroy, fontSize: 16,overflow: TextOverflow.clip),overflow: TextOverflow.clip,)),
                                               Container(
                                                 width: MediaQuery.of(context).size.width - 55,
                                                 margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                                                 child: Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   crossAxisAlignment: CrossAxisAlignment.center,
                                                   children: [
                                                     Container(
                                                       alignment: Alignment.centerLeft,
                                                       padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                                                       child: Text(listSocial[index].date.toString(), style: const TextStyle(fontWeight: FontWeight.w400, fontFamily: aileron, fontSize: 14, color: lightGray)),
                                                     ),
                                                     Row(
                                                       children: [
                                                         GestureDetector(
                                                           onTap: (){
                                                             Share.share(listSocial[index].url.toString());
                                                           },
                                                           behavior: HitTestBehavior.opaque,
                                                           child: Image.asset(
                                                             "assets/images/share.png",
                                                             height: 24,
                                                             color: darkGray,
                                                             width: 24,
                                                           ),
                                                         ),
                                                         const Text("  14  ",textAlign: TextAlign.center,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,fontFamily: roboto,color: white),),
                                                         Container(width: 8),
                                                         GestureDetector(
                                                           behavior: HitTestBehavior.opaque,
                                                           onTap: (){
                                                             setState(() {
                                                               listSocial[index].isLiked = !listSocial[index].isLiked;
                                                             });
                                                           },
                                                           child: Image.asset(
                                                             listSocial[index].isLiked
                                                                 ? "assets/images/like_filled.png"
                                                                 : "assets/images/like.png",
                                                             height: 24,
                                                             color: darkGray,
                                                             width: 24,
                                                           ),
                                                         ),
                                                         const Text("  14  ",textAlign: TextAlign.center,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,fontFamily: roboto,color: white),),
                                                       ],
                                                     ),
                                                   ],
                                                 ),
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
                     ),
                     Container(height: 22,)

                   ],
                 )
            ),
        ),
        onWillPop: (){
          Navigator.pop(context);
          return Future.value(true);
        }
        );
  }

  socialAPI() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(MAIN_URL + socialApi);

    final response = await http.get(url);
    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = SocialResponseModel.fromJson(user);

    if (statusCode == 200) {
      listSocial = dataResponse.socialMedia ??[];

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
    widget is SocialWallScreen;
  }

}