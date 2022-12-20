import 'package:auto_orientation/auto_orientation.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import '../constant/colors.dart';

class VideoPlayerPage extends StatefulWidget {
  final bool play;
  final String url;
  final String title;

  const VideoPlayerPage(this.play,this.url,this.title, {Key? key}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoPlayerPage>
{
  late VideoPlayerController videoPlayerController ;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    if(widget.url.startsWith("https"))
    {
      videoPlayerController = VideoPlayerController.network(widget.url);
    }
    else
    {
      videoPlayerController = VideoPlayerController.file(File(widget.url));
    }

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      setState(() {});
    });

  } // This closing tag was missing

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: blackConst,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            toolbarHeight: 55,
            automaticallyImplyLeading: false,
            backgroundColor: blackConst,
            elevation: 0,
            centerTitle: false,
            titleSpacing: 0,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(6),
                  child: Image.asset('assets/images/ic_back_button.png', height: 22, width: 22, color: white),
                )),
            title: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title,
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.w600, color: white, fontSize: 18),
              ),
            )
          ),
          body: Container(
            child: Center(
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: videoPlayerController.value.aspectRatio,
                      key: PageStorageKey(widget.url),
                      child: Chewie(
                        key: PageStorageKey(widget.url),
                        controller: ChewieController(
                            videoPlayerController: videoPlayerController,
                            autoInitialize: true,
                            showControls: true,
                            allowFullScreen: true,
                            looping: false,
                            autoPlay: true,
                            errorBuilder: (context, errorMessage) {
                              return Center(
                                child: Text(
                                  errorMessage,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }
                        ),
                      ),
                    );
                  }
                  else {
                    return const Center(
                      child: CircularProgressIndicator(),);
                  }
                },
              ) ,
            ),
          ),
        ),
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        });
  }
}
