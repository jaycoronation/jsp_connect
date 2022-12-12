import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jspl_connect/constant/colors.dart';
import 'package:jspl_connect/model/MagazineListResponse.dart';
import 'package:jspl_connect/widget/loading.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';

class SamparkScreen extends StatefulWidget {
  const SamparkScreen({Key? key}) : super(key: key);

  @override
  _SamparkScreen createState() => _SamparkScreen();
}

class _SamparkScreen extends BaseState<SamparkScreen> {
  bool _isLoading = false;
  var listMagazine = List<PostData>.empty(growable: true);
  @override
  void initState(){
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
                        child: Image.asset('assets/images/ic_back_button.png',
                          height: 22, width: 22,color: white),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 65,
                    margin: const EdgeInsets.only(left: 5),
                    child: const Text(
                      "Magazine",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: white,
                          fontSize: 18),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          body: _isLoading
              ? const LoadingWidget()
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                        children: [
                          AnimationLimiter(child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              primary: false,
                              shrinkWrap: true,
                              itemCount: listMagazine.length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: GestureDetector(
                                        onTap: () {
                                        },
                                        child: listMagazine[index].posts!.isNotEmpty ? Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(left: 12,right: 12,top: 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(text: listMagazine[index].name.toString(),style: TextStyle(fontFamily: roboto,fontSize: 20, color: white,fontWeight: FontWeight.w900)),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(left: 12,top: 4,bottom: 8),
                                              height: 250,
                                              width: MediaQuery.of(context).size.width,
                                              child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                shrinkWrap: true,
                                                physics: const BouncingScrollPhysics(),
                                                itemCount: listMagazine[index].posts!.length,
                                                itemBuilder: (context, indexNew) {
                                                  return GestureDetector(
                                                    onTap: () async {
                                                      if (await canLaunchUrl(Uri.parse(listMagazine[index].posts![indexNew].media![0].media.toString())))
                                                      {
                                                        launchUrl(Uri.parse(listMagazine[index].posts![indexNew].media![0].media.toString()),mode: LaunchMode.externalApplication);
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 250,
                                                      width: 180,
                                                      margin: const EdgeInsets.only(top: 8,),
                                                      child: Stack(
                                                          children:[
                                                            Container(
                                                              margin:const EdgeInsets.only(left: 4,right: 4),
                                                              decoration:  BoxDecoration(
                                                                  color: Colors.transparent,
                                                                  borderRadius: BorderRadius.circular(4)
                                                              ),
                                                              height: 300,
                                                              width: MediaQuery.of(context).size.width,
                                                              child: ClipRRect(
                                                                borderRadius:  BorderRadius.circular(4),
                                                                child: SizedBox.fromSize(
                                                                  size: const Size.fromRadius(48), // Image radius
                                                                  child:
                                                                    CachedNetworkImage(
                                                                      imageUrl: listMagazine[index].posts![indexNew].featuredImagePath.toString(),
                                                                      fit: BoxFit.cover,
                                                                      width: MediaQuery.of(context).size.width,
                                                                      height: 300,
                                                                      errorWidget: (context, url, error) => Image.asset('assets/images/bg_gray.jpeg', width: MediaQuery.of(context).size.width,
                                                                        height: 300,fit: BoxFit.cover,),
                                                                      placeholder: (context, url) => Image.asset('assets/images/bg_gray.jpeg', width: MediaQuery.of(context).size.width,
                                                                        height: 300,),
                                                                    )
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              right: 6,
                                                              top: 6,
                                                              child: GestureDetector(
                                                                behavior: HitTestBehavior.opaque,
                                                                onTap: (){
                                                                  Share.share(listMagazine[index].posts![indexNew].media![0].media.toString());
                                                                },
                                                                child: Container(
                                                                  width: 32,
                                                                  height: 32,
                                                                  padding: EdgeInsets.all(4),
                                                                  child: Image.asset("assets/images/share.png",width: 22,height: 22,color: white,),
                                                                ),
                                                              ),
                                                            ),
                                                          ]
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ) : Column(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )),
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
    widget is SamparkScreen;
  }

  getListData() async {
    setState(() {
      _isLoading = true;
    });

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + magazineList);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'user_id': sessionManager.getUserId().toString(),
      'page': "0",
      'limit': "50"
    };
    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = MagazineListResponse.fromJson(apiResponse);

    if (statusCode == 200 && dataResponse.success == 1) {
      if (dataResponse.postData != null && dataResponse.postData!.isNotEmpty) {
        listMagazine.addAll(dataResponse.postData!);
      }
    } else {
      showSnackBar(dataResponse.message, context);
    }
    setState(() {
      _isLoading = false;
    });
  }
}