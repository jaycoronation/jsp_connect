import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jspl_connect/screen/CommonDetailsScreen.dart';
import 'package:jspl_connect/utils/session_manager.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/CommanResponse.dart';
import '../model/DashBoardDataResponse.dart';
import '../screen/MagazineListScreen.dart';
import '../screen/SocialWallScreen.dart';
import '../utils/app_utils.dart';

class WhatsNewBlock extends StatelessWidget {
  final List<Posts> listData;
  final int index;
  final StateSetter setState;

  const WhatsNewBlock({Key? key, required this.listData, required this.index, required this.setState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        /*  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CommonDetailsScreen(listData[index].id.toString(), "2")));
        print(result);*/
        String typeId = listData[index].postTypeId.toString();
        String postId = listData[index].id.toString();

        if (postId != null) {
          if (postId.toString().isNotEmpty) {
            if (typeId == "1") {
              if (listData[index].socialMediaLink!.isNotEmpty) {
                if (await canLaunchUrl(Uri.parse(listData[index].socialMediaLink!.toString()))) {
                  launchUrl(Uri.parse(listData[index].socialMediaLink!.toString()), mode: LaunchMode.externalNonBrowserApplication);
                }
              }
            } else if (typeId == "2" || typeId == "3" || typeId == "4" || typeId == "6" || typeId == "8" || typeId == "10") {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CommonDetailsScreen(postId.toString(), typeId)));
            } else if (typeId == "7") {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MagazineListScreen()));
            }
          } else {
            showSnackBar("Post id not found.", context);
          }
        } else {
          showSnackBar("Post id not found.", context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: newScreenBg,
        ),
        margin: const EdgeInsets.fromLTRB(15, 6, 15, 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(listData[index].featuredImage.toString(),
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Visibility(visible : getPostTypeName(listData[index].postTypeId.toString()).isNotEmpty , child:
                Positioned(
                    top: 15,
                    left: 5,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: white.withOpacity(0.5)
                      ),
                      alignment: Alignment.center,
                      child: Text(getPostTypeName(listData[index].postTypeId.toString()),style:  TextStyle(color: black,fontSize: 12,fontWeight: FontWeight.w500,fontFamily: roboto)),
                    ))
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
              child:  Text(
                listData[index].title.toString(),
                style: TextStyle(
                    height: 1.5,
                    color: black,
                    fontWeight: FontWeight.w600,
                    fontFamily: gilroy,
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis),
                maxLines: 2,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    listData[index].saveTimestamp.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, fontFamily: roboto, fontWeight: FontWeight.w400, color: black,
                      overflow: TextOverflow.ellipsis,),
                  ),
                ],
              ),
            ),
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
      'post_id': postId.toString(),
      'user_id': sessionManager.getUserId().toString(),
      'type': "share",
      'comments': ""
    };

    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

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
