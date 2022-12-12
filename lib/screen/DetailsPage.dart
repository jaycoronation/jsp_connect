import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:share/share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/VideoResponseModel.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class DetailsScreen extends StatefulWidget {
  final String title;
  final String videoTitle;
  final int Index;
  const DetailsScreen(this.title, this.Index, this.videoTitle, {Key? key}) : super(key: key);

  @override
  _DetailsScreen createState() => _DetailsScreen();
}

class _DetailsScreen extends BaseState<DetailsScreen> {
  var listVideo = List<Videos>.empty(growable: true);
  bool _isLoading = false;
  String title = "";
  String image = "";
  String data = "";
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  @override
  void initState(){
    videoAPI();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    _controller = YoutubePlayerController(
        initialVideoId: "4ZL0s9gKKEk",
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        )
    );

    if ((widget as DetailsScreen).Index == 0)
      {
        image = "https://www.livemint.com/rf/Image-621x414/LiveMint/Period1/2012/09/24/Photos/naveen_jindal--621x414.jpg";
        title = "Shree Amitabh Bachchan and Naveen Jindal on The National Flag  A2Z";
        data = "Patriot and Congress MP Naveen Jindal on the occasion of hoisting a 100 ft monumental flag at Mathura said: 'people should visit to see the monumental Flag just like other monuments.' He further said that people should hoist the National Flag at their home.";
      }
    else if ((widget as DetailsScreen).Index == 1)
      {
        image = "https://media.gettyimages.com/id/72296890/photo/britains-prince-andrew-the-duke-of-york-a-special-representative-for-international-trade-and.jpg?s=612x612&w=0&k=20&c=rqvebr3vyVh0-hDpRTYURNqc2wKmIh-M1cwLZMHvrn8=";
        title = "India First - Naveen Jindal in conversation with Shaina N. C. Zee News";
        data = "A young parliamentarian  and a Congress MP, a dynamic industrialist and an accomplished sportsperson, Mr. Naveen Jindal in conversation with Ms. Shaina NC on the show INDIA FIRST. ";
      }
    else if ((widget as DetailsScreen).Index == 2)
      {
        image = "https://media.gettyimages.com/id/528037462/photo/naveen-jindal-cmd-jindal-steel-power-ltd-with-arunachal-pradesh-chief-minister-kalikho-pul.jpg?s=612x612&w=0&k=20&c=eQK1YA7lbBBrOqXXmJkkfChfeI62SkLmqoWCpJSJkkQ=";
        title = "Straight Talk with Naveen Jindal News X";
        data = "NewsXs national affairs editor Seema Mustafa in Straight Talk with Congress MP from Kurushetra Naveen Jindal. The young MP clears the air on his alleged remarks supporting the Khap Panchayat.";
      }
    else
      {
        title = "Doing it for India': Tricolour crusader & ex-Cong MP Naveen Jindal backs PM Modi's Tiranga campaign";
        image = "https://media.gettyimages.com/id/89240820/photo/new-delhi-india-july-23-naveen-jindal-attends-the-panel-discussion-of-yuva-samagam-vision-of.jpg?s=612x612&w=0&k=20&c=FYnmvBPDcbhAKliSQPkUGYbDgkOUcXuuHrMamxrvc8I=";
        data = "Naveen Jindal, a young parliamentarian, a Member of Parliament from the Kurukshetra (Haryana) talking about how he won his constituency and how he fought & won the battle for every Indian to fly the National Flag with pride and dignity on all days of the year. He talks about his ideas on accountability, need for firm action and better delivery mechanism.";
      }
    super.initState();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller.pause();
    }
    super.deactivate();
  }

  @override
  void dispose(){
    if (_controller != null)
      {
        _controller.dispose();
      }
    super.dispose();
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
            titleSpacing: 0,
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset('assets/images/ic_back_button.png',
                    height: 16, width: 16,color: white),
                )),
            title: Text(
              (widget as DetailsScreen).title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: white,
                  fontSize: 18),
            ),
            actions: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                margin: EdgeInsets.only(right: 8),
                child: Image.asset('assets/images/like.png',
                    height: 22, width: 22,color: white),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                margin: EdgeInsets.only(right: 8),
                child: Image.asset('assets/images/share.png',
                    height: 22, width: 22,color: white),
              )
            ],
          ),
          body: _isLoading
              ? const LoadingWidget()
              : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      GestureDetector(
                        onTap: () async {
                          var url = (widget as DetailsScreen).Index == 0
                              ? "https://www.youtube.com/watch?v=4ZL0s9gKKEk"
                              : (widget as DetailsScreen).Index == 1
                              ? "https://www.youtube.com/watch?v=Jcj0fZ6WN-E"
                              : (widget as DetailsScreen).Index == 2
                              ? "https://www.youtube.com/watch?v=vox5J1DPtck"
                              : "https://www.youtube.com/watch?v=fh9KihdNNYg";
                          showVideo(url);
                         // var value = await Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(url),));
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.network(
                                    image,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              ),
                              Container(height: 200,alignment: Alignment.center,child: Image.asset("assets/images/play.png",width: 36,height: 36,))
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                        child: Text(title,
                        style: const TextStyle(color: Colors.white,fontSize: 19,fontWeight: FontWeight.w600,fontFamily: roboto)),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                        child: const Text("Aug 14, 2022",
                          style: TextStyle(fontFamily: roboto,fontSize: 15,color: white,fontWeight: FontWeight.w600),),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                        child: const Text("Industrialist Naveen Jindal, who describes himself as a Tricolour crusader, has backed PM Narendra Modi's Har Ghar Tiranga campaign to mark the 75th year of India's Independence. A two-time Congress MP, Jindal fought for the private citizen's right to fly the Tiranga and got the Flag Code changed twice. He disagrees with Rahul Gandhi's criticism of RSS for not hoisting the national flag for five decades. Naveen Jindal made these remarks in an interview to the Hindustan Times. Watch.",
                        style: TextStyle(fontFamily: roboto,fontSize: 15,color: white,fontWeight: FontWeight.w400),),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                        child: const Text("More Videos",
                          style: TextStyle(fontFamily: roboto,fontSize: 17,color: white,fontWeight: FontWeight.w600),),
                      ),
                    AnimationLimiter(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: listVideo.length,
                        itemBuilder:(context, index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen("Video Details",index,listVideo[index].title.toString()),));
                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(listVideo?[index].videoUrl.toString() ?? ""),));
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 14,right: 14,top: 14),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(width: 0.2, color: white.withOpacity(0.4))
                                        ),
                                        height: 300,
                                        width: MediaQuery.of(context).size.width,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(30), // Image border
                                          child: SizedBox.fromSize(
                                            size: const Size.fromRadius(48), // Image radius
                                            child: Image.network(listVideo[index].image.toString(),
                                              fit: BoxFit.fill,
                                              width: MediaQuery.of(context).size.width,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 300,
                                        margin: const EdgeInsets.only(left: 14,right: 14,top: 14),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(30),
                                            gradient: LinearGradient(
                                                begin: FractionalOffset.topCenter,
                                                end: FractionalOffset.bottomCenter,
                                                colors: [
                                                  black.withOpacity(0.0),
                                                  black
                                                ],
                                                stops: const [
                                                  0.2,
                                                  1.0
                                                ]
                                            )
                                        ),
                                      ),
                                      Positioned(
                                          top: 22,
                                          left: 32,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(22),
                                                color: white.withOpacity(0.2),
                                              ),
                                              padding: const EdgeInsets.only(left: 8,right: 8,top: 4,bottom: 4),
                                              child: const Text("8:10 mins",style: TextStyle(color: white,fontSize: 12,fontFamily: roboto,fontWeight: FontWeight.w400),)
                                          )
                                      ),

                                      Positioned.fill(
                                        bottom: 50,
                                        child: Container(
                                          width: 46,
                                          height: 46,
                                          alignment: Alignment.center,
                                          child: Image.asset('assets/images/play.png',
                                            height: 46, width: 46,),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 32,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(top: 10, left: 22),
                                              decoration: BoxDecoration(
                                                color: bgOverlay,
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                                                child: Text("National Flag",style: TextStyle(fontFamily: gilroy,fontWeight: FontWeight.w400,fontSize: 12,color: white),),
                                              ),),
                                            Container(
                                                alignment: Alignment.bottomLeft,
                                                margin: const EdgeInsets.only(top: 14, left: 22,right: 10),
                                                child: Text(listVideo![index].title.toString(),overflow: TextOverflow.clip, style: const TextStyle(color: white, fontWeight: FontWeight.w400, fontFamily: gilroy, fontSize: 16,overflow: TextOverflow.clip))),
                                            Container(
                                              width: MediaQuery.of(context).size.width - 28,
                                              margin: const EdgeInsets.only(left: 12, right: 22, top: 14,),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    alignment: Alignment.bottomRight,
                                                    padding: const EdgeInsets.only(top: 6, bottom: 6, left: 10, right: 10),
                                                    child: Text(universalDateConverter("dd.MM.yyyy", "dd MMMM, yyyy", listVideo![index].date.toString()), style: const TextStyle(fontWeight: FontWeight.w500, fontFamily: aileron, fontSize: 12, color: lightGray)),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.bottomRight,
                                                    margin: const EdgeInsets.only(right: 6),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            if(listVideo![index].videoUrl.toString().trim().isNotEmpty)
                                                            {
                                                              Share.share(listVideo![index].videoUrl.toString());
                                                            }
                                                          },
                                                          behavior: HitTestBehavior.opaque,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(6.0),
                                                            child: Image.asset(
                                                              "assets/images/share.png",
                                                              height: 22,
                                                              color: darkGray,
                                                              width: 22,
                                                            ),
                                                          ),
                                                        ),
                                                        const Text("14",textAlign: TextAlign.center,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,fontFamily: roboto,color: white),),
                                                        GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              listVideo![index].isLike = !listVideo![index].isLike;
                                                            });
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(6.0),
                                                            child: Image.asset(
                                                              listVideo![index].isLike
                                                                  ? "assets/images/like_filled.png"
                                                                  : "assets/images/like.png",
                                                              height: 22,
                                                              color: darkGray,
                                                              width: 22,
                                                            ),
                                                          ),
                                                        ),
                                                        const Text("14",textAlign: TextAlign.center,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,fontFamily: roboto,color: white),),
                                                        Padding(
                                                          padding: const EdgeInsets.all(6.0),
                                                          child: Image.asset(
                                                            "assets/images/saved.png",
                                                            height: 22,
                                                            color: darkGray,
                                                            width: 22,
                                                          ),
                                                        ),
                                                        const Text("14",textAlign: TextAlign.center,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,fontFamily: roboto,color: white),)
                                                      ],
                                                    ),
                                                  )
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
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          
        ),
        onWillPop: (){
          Navigator.pop(context);
          return Future.value(true);
        }
    );
  }

  videoAPI() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(MAIN_URL + videoApi);

    final response = await http.get(url);
    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = VideoResponseModel.fromJson(user);

    if (statusCode == 200) {
      listVideo = dataResponse.videos ?? [];


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
    widget is DetailsScreen;
  }

  void showVideo(String url) {
    var videoId = YoutubePlayer.convertUrlToId(url);
    print('this is $videoId');
    _controller = YoutubePlayerController(
      initialVideoId: videoId.toString(),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: SizedBox(
            height: 400,
            width: MediaQuery.of(context).size.width,
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.red,
              topActions: <Widget>[
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    _controller.metadata.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 25.0,
                  ),
                  onPressed: () {
                  },
                ),
              ],
              onReady: () {
                _isPlayerReady = true;
              },
              onEnded: (data) {
                showSnackBar("Video Finish", context);
                Navigator.pop(context);
              },
            ),
          ),

        );
      },
    );
  }
}