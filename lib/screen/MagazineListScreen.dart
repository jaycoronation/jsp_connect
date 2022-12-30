import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jspl_connect/constant/colors.dart';
import 'package:jspl_connect/model/MagazineListResponse.dart';
import 'package:jspl_connect/screen/tabcontrol/bottom_navigation_bar_screen.dart';
import 'package:jspl_connect/widget/loading.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant/api_end_point.dart';
import '../constant/global_context.dart';
import '../model/CommanResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading_more.dart';
import '../widget/no_data.dart';

class MagazineListScreen extends StatefulWidget {
  const MagazineListScreen({Key? key}) : super(key: key);

  @override
  _MagazineListScreen createState() => _MagazineListScreen();
}

class _MagazineListScreen extends BaseState<MagazineListScreen> {
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 15;
  bool _isLastPage = false;
  bool isScrollingDown = false;
  late ScrollController _scrollViewController;
  var listMagazine = List<PostData>.empty(growable: true);

  @override
  void initState(){

    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {

      if (_scrollViewController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          setState(() {});
        }
      }
      if (_scrollViewController.position.userScrollDirection == ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          setState(() {});
        }
      }
      pagination();

    });

    if (isOnline) {
      getListData(true);
    } else {
      noInterNet(context);
    }

    super.initState();
  }

  void pagination() {
    if (!_isLastPage && !_isLoadingMore) {
      if ((_scrollViewController.position.pixels == _scrollViewController.position.maxScrollExtent)) {
        setState(() {
          _isLoadingMore = true;
          getListData(false);
        });
      }
    }
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
            title: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        if (NavigationService.notif_type.isNotEmpty)
                        {
                          NavigationService.notif_type = "";
                          NavigationService.notif_post_id = "";
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const BottomNavigationBarScreen(0)),
                                  (Route<dynamic> route) => false);
                        }
                        else
                        {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(6),
                        child: Image.asset('assets/images/ic_back_button.png',
                          height: 22, width: 22,color: black),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 65,
                    margin: const EdgeInsets.only(left: 5),
                    child: Text(
                      "Magazine",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: black,
                          fontSize: 18),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          body:_isLoading
              ? const LoadingWidget() : listMagazine.isEmpty ? const MyNoDataWidget(msg: 'No magazine data found!')
              : Column(
            children: [
              Expanded(child: SingleChildScrollView(
                controller: _scrollViewController,
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
                                  child: listMagazine[index].posts!.isNotEmpty
                                      ? Column(
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
                                                  TextSpan(text: listMagazine[index].name.toString(),style: TextStyle(fontFamily: roboto,fontSize: 20, color: black,fontWeight: FontWeight.w900)),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 12,top: 4,bottom: 8),
                                        height: 265,
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
                                                height: 265,
                                                width: 180,
                                                margin: const EdgeInsets.only(top: 8,),
                                                child: Column(
                                                  children: [
                                                    Stack(
                                                        children:[
                                                          Container(
                                                            margin:const EdgeInsets.only(left: 4,right: 4),
                                                            decoration:  BoxDecoration(
                                                                color: Colors.transparent,
                                                                borderRadius: BorderRadius.circular(4)
                                                            ),
                                                            height: 225,
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
                                                                    height: 225,
                                                                    errorWidget: (context, url, error) => Image.asset('assets/images/bg_gray.jpeg', width: MediaQuery.of(context).size.width,
                                                                      height: 225,fit: BoxFit.cover,),
                                                                    placeholder: (context, url) => Image.asset('assets/images/bg_gray.jpeg', width: MediaQuery.of(context).size.width,
                                                                      height: 225,),
                                                                  )
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            right: 10,
                                                            top: 6,
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  behavior: HitTestBehavior.opaque,
                                                                  onTap: (){
                                                                    if(listMagazine[index].posts![indexNew].media!.isNotEmpty)
                                                                    {
                                                                      if(listMagazine[index].posts![indexNew].media![0].media.toString().isNotEmpty)
                                                                      {
                                                                        Share.share(listMagazine[index].posts![indexNew].media![0].media.toString());
                                                                        setState(() {
                                                                          listMagazine[index].posts![indexNew].setSharesCount = listMagazine[index].posts![indexNew].sharesCount! + 1;
                                                                        });
                                                                      }
                                                                      else
                                                                      {
                                                                        showSnackBar("Magazine link not found.", context);
                                                                      }
                                                                    }
                                                                    else
                                                                    {
                                                                      showSnackBar("Magazine link not found.", context);
                                                                    }
                                                                    _sharePost(listMagazine[index].posts![indexNew].id.toString());
                                                                  },
                                                                  child: Container(
                                                                    width: 36,
                                                                    height: 36,
                                                                    decoration: BoxDecoration(
                                                                        color: whiteConst.withOpacity(0.6),
                                                                        shape: BoxShape.circle
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Image.asset("assets/images/share.png",width: 24,height: 24),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  listMagazine[index].posts![indexNew].sharesCount.toString(),
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontSize: 14, fontWeight: FontWeight.w400, fontFamily: roboto, color: black),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ]
                                                    ),
                                                    Container(height: 12,),
                                                    Text(
                                                      listMagazine[index].posts![indexNew].title.toString(),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(color: black, fontFamily: roboto, fontSize: 14, fontWeight: FontWeight.w500),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  )
                                      : Column(),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                    ],
                  ),
                ),
              )),
              Visibility(visible : _isLoadingMore,child: const LoadingMoreWidget())
            ],
          ),
        ),
        onWillPop: (){
          if (NavigationService.notif_type.isNotEmpty)
          {
            NavigationService.notif_type = "";
            NavigationService.notif_post_id = "";
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const BottomNavigationBarScreen(0)),
                    (Route<dynamic> route) => false);
          }
          else
          {
            Navigator.pop(context);
          }
          return Future.value(true);
        }
    );
  }
  _sharePost(String postId) async {
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
      showSnackBar(dataResponse.message, context);
    }
  }

  @override
  void castStatefulWidget() {
    widget is MagazineListScreen;
  }

  getListData([bool isFirstTime = false]) async {
    if (isFirstTime) {
      setState(() {
        _isLoading = true;
        _isLoadingMore = false;
        _pageIndex = 0;
        _isLastPage = false;
      });
    }

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + magazineList);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'user_id': sessionManager.getUserId().toString(),
      'limit': _pageResult.toString(),
      'page': _pageIndex.toString(),
    };
    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = MagazineListResponse.fromJson(apiResponse);

    if (isFirstTime) {
      if (listMagazine.isNotEmpty) {
        listMagazine = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1) {
      if (dataResponse.postData != null && dataResponse.postData!.isNotEmpty) {
        List<PostData>? _tempList = [];
        for (int i = 0; i < dataResponse.postData!.length; i++) {
          if (dataResponse.postData![i].posts != null && dataResponse.postData![i].posts!.isNotEmpty) {
            _tempList.add(dataResponse.postData![i]);
          }
        }

        listMagazine.addAll(_tempList);

        if (_tempList.isNotEmpty) {
          _pageIndex += 1;
          if (_tempList.isEmpty || _tempList.length % _pageResult != 0) {
            _isLastPage = true;
          }
        }
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } else {
      showSnackBar(dataResponse.message, context);
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }
}