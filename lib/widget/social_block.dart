import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jspl_connect/utils/session_manager.dart';
import 'package:like_button/like_button.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/CommanResponse.dart';
import '../model/DashBoardDataResponse.dart';
import '../model/PostListResponse.dart';
import '../screen/VideoDetailsPage.dart';
import '../utils/app_utils.dart';

class SocialBlock extends StatelessWidget {
  final List<Posts> listSocial;
  final int index;
  final StateSetter setState;

  const SocialBlock({Key? key, required this.listSocial, required this.index, required this.setState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (listSocial[index].socialMediaLink!.isNotEmpty) {
          if (await canLaunchUrl(Uri.parse(listSocial[index].socialMediaLink!.toString()))) {
            launchUrl(Uri.parse(listSocial[index].socialMediaLink!.toString()), mode: LaunchMode.externalNonBrowserApplication);
          }
        }
      },
      child: Container(
        height: 450,
        margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),),
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
                  listSocial[index].featuredImage.toString(),
                  fit: BoxFit.cover,
                  height: 450,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: whiteConst.withOpacity(0.7)
                  ),
                  width: 40,
                  height: 30,
                  padding: const EdgeInsets.all(6),
                  alignment: Alignment.center,
                  child: Image.asset(
                    listSocial[index].socialMediaType.toString() == "Facebook"
                        ? "assets/images/facebook.png"
                        : listSocial[index].socialMediaType.toString() == "Twitter"
                        ? "assets/images/ic_twitter.png"
                        : "assets/images/ic_insta.png",
                    height: 24,
                    width: 24,
                    color: whiteConst,
                  )),
            ),
            Container(
              height: 450,
              decoration: BoxDecoration(
                  color: blackConst,
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, colors: [
                    blackConst.withOpacity(0.1),
                    blackConst,
                  ], stops: const [
                    0.6,
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
                      margin: const EdgeInsets.only(bottom: 0, left: 14, right: 14),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        listSocial[index].shortDescription.toString(),
                        maxLines: 3,
                        style: const TextStyle(
                            color: whiteConst,
                            fontWeight: FontWeight.w500,
                            fontFamily: gilroy,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis),
                        overflow: TextOverflow.clip,
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width - 55,
                    margin: const EdgeInsets.only(left: 14, right: 14, top: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(bottom: 8,  right: 10),
                          child: Text(listSocial[index].saveTimestamp.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontFamily: aileron, fontSize: 14, color: darkGray)),
                        ),
                       /* Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (listSocial[index].socialMediaLink!.isNotEmpty) {
                                  Share.share(listSocial[index].socialMediaLink.toString());
                                  _sharePost(listSocial[index].id.toString());
                                  setState(() {
                                    listSocial[index].setSharesCount = listSocial[index].sharesCount! + 1;
                                  });
                                } else {
                                  showSnackBar("Social link not found.", context);
                                }
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Image.asset(
                                "assets/images/share.png",
                                height: 22,
                                color: lightGray,
                                width: 22,
                              ),
                            ),
                            const Gap(6),
                            Text(
                              listSocial[index].sharesCount.toString(),
                              textAlign: TextAlign.center,
                              style:  TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: lightGray),
                            )
                          ],
                        ),*/
                      ],
                    ),
                  )
                ],
              ),
            )
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
