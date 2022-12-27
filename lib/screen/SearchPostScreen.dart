import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:jspl_connect/widget/loading_more.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/DashBoardDataResponse.dart';
import '../model/PostListResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/news_block.dart';
import '../widget/no_data.dart';
import 'CommonDetailsScreen.dart';
import 'MagazineListScreen.dart';

class SearchPostScreen extends StatefulWidget {
  const SearchPostScreen({Key? key}) : super(key: key);

  @override
  _SearchPostScreen createState() => _SearchPostScreen();
}

class _SearchPostScreen extends BaseState<SearchPostScreen> {
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 20;
  bool _isLastPage = false;
  bool isScrollingDown = false;
  late ScrollController _scrollViewController;
  List<Posts> listSearch = List<Posts>.empty(growable: true);
  TextEditingController searchController = TextEditingController();
  var searchText = "";

  @override
  void initState() {
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

    super.initState();
  }

  void pagination() {
    if (!_isLastPage && !_isLoadingMore) {
      if ((_scrollViewController.position.pixels == _scrollViewController.position.maxScrollExtent)) {
        setState(() {
          _isLoadingMore = true;
          getApiData(false);
        });
      }
    }
  }

  final Shader linearGradientSocial = const LinearGradient(
    colors: <Color>[Color(0xffFFFFFF), Color(0xff9b9b98)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 800.0, 120.0));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            automaticallyImplyLeading: false,
            backgroundColor: newScreenBg,
            elevation: 0,
            centerTitle: false,
            titleSpacing: 0,
            leading: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(6),
                  child: Image.asset('assets/images/ic_back_button.png', height: 22, width: 22, color: black),
                )),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(),
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.only(right: 15, top: 6, bottom: 6),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22), // if you need this
                        side: const BorderSide(
                          color: lightGrayNew,
                          width: 0,
                        ),
                      ),
                      elevation: 0,
                      child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 12),
                        width: double.infinity,
                        child: TextField(
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          textAlign: TextAlign.start,
                          controller: searchController,
                          cursorColor: blackConst,
                          style: TextStyle(
                            color: blackConst,
                            fontFamily: aileron,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              hintText: "Search post..",
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.transparent, width: 0),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.transparent, width: 0),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              hintStyle: TextStyle(
                                color: blackConst,
                                fontSize: 16,
                                fontFamily: gilroy,
                                fontWeight: FontWeight.w400,
                              ),
                              suffixIcon: InkWell(
                                child: Icon(
                                  Icons.close,
                                  size: 24,
                                  color: blackConst,
                                ),
                                onTap: () {
                                  setState(() {
                                    searchController.text = "";
                                    searchText = "";
                                    if (listSearch.isNotEmpty) {
                                      listSearch = [];
                                    }
                                  });
                                },
                              )),
                          onChanged: (text) {
                            searchController.text = text;
                            searchController.selection = TextSelection.fromPosition(TextPosition(offset: searchController.text.length));
                            if (text.length > 3) {
                              searchText = searchController.text.toString().trim();
                              if (listSearch.isNotEmpty) {
                                listSearch = [];
                              }
                              getApiData(true);
                            } else if (text.length == 1 || text.length == 2 || text.length == 3) {
                            } else {
                              searchText = "";
                              if (listSearch.isNotEmpty) {
                                listSearch = [];
                              }
                              getApiData(true);
                            }
                          },
                        ),
                      )),
                )),
                Container()
              ],
            ),
          ),
          backgroundColor: newScreenBg,
          resizeToAvoidBottomInset: true,
          body: _isLoading
              ? const LoadingWidget()
              : (listSearch.isEmpty && searchText.isNotEmpty)
                  ? const MyNoDataWidget(msg: 'No post data found!')
                  : Column(
                      children: [
                        Expanded(
                            child: AnimationLimiter(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              controller: _scrollViewController,
                              itemCount: listSearch.length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: GestureDetector(
                                        onTap: () async {

                                          String typeId = listSearch[index].postTypeId.toString();
                                          String postId = listSearch[index].id.toString();

                                          if (postId != null) {
                                            if (postId.toString().isNotEmpty) {
                                              if (typeId == "1") {
                                                if (listSearch[index].socialMediaLink!.isNotEmpty) {
                                                  if (await canLaunchUrl(Uri.parse(listSearch[index].socialMediaLink!.toString()))) {
                                                    launchUrl(Uri.parse(listSearch[index].socialMediaLink!.toString()), mode: LaunchMode.externalNonBrowserApplication);
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
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                                              margin: const EdgeInsets.only(left: 12, right: 12, top: 16),
                                              decoration: BoxDecoration(
                                                color: newsBlock,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      margin: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(listSearch[index].title.toString(),
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 3,
                                                              style: TextStyle(
                                                                  color: black,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontFamily: gilroy,
                                                                  fontSize: 16,
                                                                  overflow: TextOverflow.ellipsis)),
                                                          Gap(6),
                                                          Text(listSearch[index].shortDescription.toString(),
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 3,
                                                              style: TextStyle(
                                                                  color: black,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontFamily: gilroy,
                                                                  fontSize: 16,
                                                                  overflow: TextOverflow.ellipsis)),
                                                          Gap(12),
                                                          Text(
                                                            listSearch[index].saveTimestamp.toString(),
                                                            style:
                                                                TextStyle(fontSize: 13, fontFamily: roboto, fontWeight: FontWeight.w400, color: newsText),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    height: 100,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      child: Image.network(listSearch[index].featuredImage.toString(),
                                                          width: 100, height: 100, fit: BoxFit.cover),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Visibility(visible : index == listSearch.length -1 ,child: Gap(20))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        )),
                        Visibility(visible: _isLoadingMore, child: const LoadingMoreWidget())
                      ],
                    ),
        ),
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        });
  }

  getApiData([bool isFirstTime = false]) async {
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

    final url = Uri.parse(API_URL + posts);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'user_id': sessionManager.getUserId().toString(),
      'limit': _pageResult.toString(),
      'page': _pageIndex.toString(),
      'search': searchText
    };
    final response = await http.post(url, body: jsonBody, headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = PostListResponse.fromJson(apiResponse);

    if (isFirstTime) {
      if (listSearch.isNotEmpty) {
        listSearch = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1) {
      if (dataResponse.posts != null && dataResponse.posts!.isNotEmpty) {
        List<Posts>? _tempList = [];
        _tempList = dataResponse.posts;
        listSearch.addAll(_tempList!);

        if (_tempList.isNotEmpty) {
          _pageIndex += 1;
          if (_tempList.isEmpty || _tempList.length % _pageResult != 0) {
            _isLastPage = true;
          }
        }
      }
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    } else {
      showSnackBar(dataResponse.message, context);
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  @override
  void castStatefulWidget() {
    widget is SearchPostScreen;
  }
}
