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

class EventBlock extends StatelessWidget {
  final List<Posts> listEvents;
  final int index;
  final StateSetter setState;

  const EventBlock({Key? key, required this.listEvents, required this.index, required this.setState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
