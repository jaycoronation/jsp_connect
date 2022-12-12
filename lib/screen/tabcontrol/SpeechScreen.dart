import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

import '../../constant/api_end_point.dart';
import '../../constant/colors.dart';
import '../../model/SpeechModel.dart';
import '../../utils/base_class.dart';
import '../../widget/loading.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  _SpeechScreen createState() => _SpeechScreen();
}

class _SpeechScreen extends BaseState<SpeechScreen> {
  bool _isLoading = false;
  var listSpeech = List<Speech>.empty(growable: true);

  @override
  void initState() {
    if (isOnline) {
      _SpeechApi();
    }
    super.initState();
  }

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
                          height: 32, width: 32,),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 65,
                    margin: const EdgeInsets.only(left: 5),
                    child: const Text(
                      "Speech",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: white,
                          fontSize: 18),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          backgroundColor: black,
          resizeToAvoidBottomInset: true,
          body: _isLoading
              ? const LoadingWidget()
              : SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(left: 14,right: 14),
                    padding: EdgeInsets.only(left: 14,right: 14,top: 14),
                    decoration: BoxDecoration(
                      color: bgOverlay,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                         Image.network(listSpeech[0].speechData![0].video.toString(),height: 250,width: MediaQuery.of(context).size.width,fit: BoxFit.fill,),
                         Container(
                           margin: EdgeInsets.only(top: 14),
                           child: Text(listSpeech[0].speechData![0].para1.toString(),
                               overflow: TextOverflow.clip,
                               textAlign: TextAlign.center,
                               style: TextStyle(fontWeight: FontWeight.w400, fontFamily: gilroy, fontSize: 16, color: white,overflow: TextOverflow.clip)),
                         ),
                        Container(
                          decoration: BoxDecoration(
                          color: bgMain,
                          borderRadius: BorderRadius.circular(30),
                        ),
                          margin: EdgeInsets.only(top: 20,bottom: 14),
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 20,bottom: 20),
                                  child: Text("Comments",style: TextStyle(fontSize: 20,color: white,fontWeight: FontWeight.w600,fontFamily: gilroy),)),
                              ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: listSpeech[0].comments?.length,
                                  itemBuilder: (ctx, index) => (Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset("assets/images/ic_user_placeholder.png",height: 50,width: 50,color: darkGray,),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(listSpeech[0].comments![index].name.toString(),
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontWeight: FontWeight.w800, fontFamily: gilroy, fontSize: 14, color: white,overflow: TextOverflow.clip)),
                                              Text(listSpeech[0].comments![index].comment.toString(),
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(fontWeight: FontWeight.w400, fontFamily: roboto, fontSize: 14, color: white,overflow: TextOverflow.clip)),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  )))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ),
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        });
  }

  _SpeechApi() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(MAIN_URL + speechApi);

    final response = await http.get(url);
    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = SpeechModel.fromJson(user);

    if (statusCode == 200) {
      if (dataResponse.speech!.isNotEmpty) {
        listSpeech = dataResponse.speech!;
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
    widget is SpeechScreen;
  }
}