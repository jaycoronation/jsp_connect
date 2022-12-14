import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../constant/colors.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerScreen(this.videoUrl, this.title, {Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends BaseState<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    print('<><> URL ' + (widget as VideoPlayerScreen).videoUrl);
    var videoId = YoutubePlayer.convertUrlToId((widget as VideoPlayerScreen).videoUrl);
    print('<><> URL ID  $videoId');
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
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
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
    _controller.pause();
    _controller.dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: YoutubePlayerBuilder(
          onExitFullScreen: () {
            // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
            SystemChrome.setPreferredOrientations(DeviceOrientation.values);
          },
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            onReady: () {
              _isPlayerReady = true;
            },
            onEnded: (data) {
              showSnackBar("Video Finish", context);
              Navigator.pop(context);
            },
          ),
          builder: (context, player) => Scaffold(
            appBar: AppBar(
              leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0, top: 18, bottom: 18, right: 18),
                    child: Image.asset('assets/images/ic_back_button.png', height: 16, width: 16, color: white),
                  )),
              title: Text(
                (widget as VideoPlayerScreen).title,
                style: TextStyle(fontWeight: FontWeight.w600, color: white, fontSize: 18),
              ),
            ),
            body: Container(
              color: black,
              alignment: Alignment.center,
              child: player,
            ),
          ),
        ),
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        });
  }

  @override
  void castStatefulWidget() {
    widget is VideoPlayerScreen;
  }
}
