import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

import '../../constant/api_end_point.dart';
import '../../constant/colors.dart';
import '../../model/LiveModel.dart';
import '../../model/SpeechModel.dart';
import '../../utils/base_class.dart';
import '../../widget/loading.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({Key? key}) : super(key: key);

  @override
  _LiveScreen createState() => _LiveScreen();
}

class _LiveScreen extends BaseState<LiveScreen> {
  bool _isLoading = false;
  var listLive = List<Live>.empty(growable: true);
  var listSpeech = List<Speech>.empty(growable: true);
  late Timer _timer;
  int _start = 180;

  @override
  void initState() {
    if (isOnline) {
      _LiveApi();
    }
    startTimer();
    super.initState();
  }

  void startTimer() {
    const oneSec = Duration(milliseconds: 1000);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffFFFFFF), Color(0xffaaa9a3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  formatedTime(int timeInSecond) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return minute == "00" ?"$minute : $second sec" : "$minute : $second min";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            automaticallyImplyLeading: false,
            backgroundColor: black,
            elevation: 0,
            centerTitle: false,
          ),
          resizeToAvoidBottomInset: false,
          body: _isLoading
              ? const LoadingWidget()
              : Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/live.jpg"),
                          fit: BoxFit.fill
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
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
                                  padding: const EdgeInsets.all(8),
                                  child: Image.asset('assets/images/ic_back_button.png',
                                    height: 22, width: 22,),
                                )),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 5),
                              child: const Text(
                                "Live",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: roboto,
                                    color: white,
                                    fontSize: 16),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 130,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: yellow,
                            borderRadius: BorderRadius.circular(12)
                          ),
                          padding: const EdgeInsets.only(top: 6,bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/ic_placeholder.png",height: 8,width: 8,color: black,),
                              Container(width: 8),
                              Text("Live in ${formatedTime(_start)}",
                                style: const TextStyle(color: black,fontWeight: FontWeight.w400,fontSize: 12),)
                            ],
                          ),
                        ),
                      ),
                      Container(height: 52),
                      Container(margin: const EdgeInsets.only(left: 12,right: 12),child:  Text("Naveen Jindal group weighs\naluminium foray, plans depends\non mine.",style: TextStyle(foreground:  Paint()..shader = linearGradient,fontWeight: FontWeight.w600,fontFamily: roboto,fontSize: 20),)),
                      Container(height: 12),
                      Container(margin: const EdgeInsets.only(left: 12,right: 12),child: const Text("12 October 2022.",style: TextStyle(color: text_dark,fontWeight: FontWeight.w400,fontFamily: roboto,fontSize: 14),)),
                      Container(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.2, color: white.withOpacity(0.4), style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        margin: const EdgeInsets.fromLTRB(12, 12, 12, 22),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 12,bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(margin: const EdgeInsets.only(left: 12),child: const Text("Comments",style: TextStyle(fontSize: 16,color: white,fontWeight: FontWeight.w500,fontFamily: roboto),)),
                                  const Spacer(),
                                  Container(
                                      decoration: BoxDecoration(
                                        color: bgMain,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                                      margin: const EdgeInsets.only(right: 12),
                                      child: Row(
                                        children: [
                                          Image.asset("assets/images/ic_people.png",width: 22,height: 22,color: yellow),
                                          Container(width: 8),
                                          const Text("600 joined",style: TextStyle(fontSize: 12,color: yellow,fontWeight: FontWeight.w500,fontFamily: roboto),),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            Container(height: 8),
                            Divider(color: white.withOpacity(0.4),thickness: 0.2,height: 1,indent: 8,endIndent: 8),
                            Container(height: 8),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset("assets/images/ic_comment_1.png",height: 50,width: 50,),
                                  Container(width: 8),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Vrushik Patel",
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.w800, fontFamily: gilroy, fontSize: 14, color: white,overflow: TextOverflow.clip)),
                                        Container(height: 8,),
                                        const Text("I am proud of you dear respected sir.",
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(fontWeight: FontWeight.w400, fontFamily: roboto, fontSize: 12, color: lightGray,overflow: TextOverflow.clip)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset("assets/images/ic_comment_2.png",height: 50,width: 50,),
                                  Container(width: 8),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Jignesh Mehta",
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.w800, fontFamily: gilroy, fontSize: 14, color: white,overflow: TextOverflow.clip)),
                                        Container(height: 8,),
                                        const Text("Good inspiration sir.",
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(fontWeight: FontWeight.w400, fontFamily: roboto, fontSize: 12, color: lightGray,overflow: TextOverflow.clip)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset("assets/images/ic_comment_3.png",height: 50,width: 50,),
                                  Container(width: 8),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Mayur Shah",
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.w800, fontFamily: gilroy, fontSize: 14, color: white,overflow: TextOverflow.clip)),
                                        Container(height: 8,),
                                        const Text("Very good work Naveen Jindal ji, Jai Hind",
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(fontWeight: FontWeight.w400, fontFamily: roboto, fontSize: 12, color: lightGray,overflow: TextOverflow.clip)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 12,left: 6,right: 6),
                              decoration: BoxDecoration(
                                color: lightblack,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        hintText: 'Start typing...',
                                        contentPadding: EdgeInsets.all(15),
                                        hintStyle: TextStyle(
                                          color: white,
                                          fontSize: 15,
                                          fontFamily: gilroy,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        border: InputBorder.none,
                                        fillColor: lightblack,
                                      ),
                                      style: const TextStyle(fontWeight: FontWeight.w400, color: white,fontSize: 16,fontFamily: gilroy),
                                      onChanged: (value) {
                                      },
                                    ),
                                  ),
                                  Container(
                                      width: 38,
                                      height: 38,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: yellow
                                      ),
                                      margin: const EdgeInsets.only(right: 4),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset("assets/images/ic_send.png",color: black),
                                      ))
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
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        });
  }

  _LiveApi() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(MAIN_URL + liveApi);

    final response = await http.get(url);
    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = LiveModel.fromJson(user);

    if (statusCode == 200) {
      if (dataResponse.live!.isNotEmpty) {
        listLive = dataResponse.live!;
      }
      _SpeechApi();
      setState(() {
      });
    } else {
      _SpeechApi();
      setState(() {
        _isLoading = false;
      });
    }
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
    widget is LiveScreen;
  }

}