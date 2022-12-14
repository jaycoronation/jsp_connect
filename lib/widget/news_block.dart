import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jspl_connect/screen/CommonDetailsScreen.dart';
import 'package:jspl_connect/utils/session_manager.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/CommanResponse.dart';
import '../model/DashBoardDataResponse.dart';
import '../utils/app_utils.dart';

class NewsBlock extends StatelessWidget {
  final List<Posts> listNews;
  final int index;
  final bool isFromNews;
  final StateSetter setState;

  const NewsBlock({Key? key, required this.listNews, required this.index, required this.isFromNews, required this.setState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CommonDetailsScreen(listNews[index].id.toString(),listNews[index].postTypeId.toString())));
        print("result ===== $result");
        setState(() {
          var data = result.toString().split("|");
          for (int i = 0; i < listNews.length; i++) {
            if(listNews[i].id == data[0])
            {
              listNews[i].setSharesCount = num.parse(data[1]);
              break;
            }
          }
        });

      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
        margin: const EdgeInsets.only(left: 12, right: 12, top: 16),
        decoration: BoxDecoration(
          color: newsBlock,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(listNews[index].title.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.w500,
                                fontFamily: gilroy,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis)
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(listNews[index].featuredImage.toString(), width: 100, height: 100, fit: BoxFit.cover),
                  ),
                )
              ],
            ),
            Container(
              height: 18,
            ),
            Row(
              children: [
                Text(
                  listNews[index].location.toString(),
                  style: TextStyle(fontSize: 13, fontFamily: roboto, fontWeight: FontWeight.w400, color: newsText),
                ),
                listNews[index].location.toString().isNotEmpty ? Container(
                  width: 6,
                ) : Container(),
                listNews[index].location.toString().isNotEmpty
                    ? Image.asset("assets/images/ic_placeholder.png", width: 4, height: 4, color: text_light,)
                    : Container(),
                listNews[index].location.toString().isNotEmpty
                    ? Container(width: 6,)
                    : Container(),
                Text(
                  listNews[index].saveTimestamp.toString(),
                  style:  TextStyle(fontSize: 13, fontFamily: roboto, fontWeight: FontWeight.w400, color: newsText),
                ),
                const Spacer(),

                Container(
                  width: 8,
                )
                /* Container(
                                        width: 12,
                                      ),
                                      Image.asset(
                                        "assets/images/ic_arrow_right_new.png",
                                        width: 22,
                                        height: 22,
                                      )*/
              ],
            ),
            Container(
              height: 8,
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
