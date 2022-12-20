import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../constant/colors.dart';
import '../model/DashBoardDataResponse.dart';
import '../model/GalleryResponseModel.dart';
import '../model/PostListResponse.dart';
import '../utils/base_class.dart';
import '../utils/full_screen_image_new.dart';
import '../widget/loading.dart';

class GalleryScreen extends StatefulWidget {
  final Posts post;

  const GalleryScreen(this.post, {Key? key}) : super(key: key);

  @override
  _GalleryScreen createState() => _GalleryScreen();
}

class _GalleryScreen extends BaseState<GalleryScreen> {
  late final Posts post;
  bool _isLoading = false;
  var listGallery = GalleryImages();

  @override
  void initState() {
    post = (widget as GalleryScreen).post;
    super.initState();
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
            titleSpacing: 0,
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    'assets/images/ic_back_button.png',
                    height: 22,
                    width: 22,
                    color: black,
                  ),
                )),
            title: Text(
              post.title.toString().trim(),
              style: TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16),
            ),
          ),
          body: _isLoading ? const LoadingWidget() : gallery(),
        ),
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        });
  }

  AnimationLimiter gallery() {
    return AnimationLimiter(
      child: GridView.builder(
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 200, crossAxisSpacing: 2, mainAxisSpacing: 2),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: post.media!.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: 2,
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: GestureDetector(
                  onTap: () {
                    List<String> listImage = [];

                    for (var i = 0; i < post.media!.length; i++)
                    {
                      if (post.media![i].media != null)
                      {
                          if(post.media![i].media!.isNotEmpty)
                          {
                            listImage.add(post.media![i].media.toString());
                          }
                      }
                    }

                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => FullScreenImageNew("", listImage, index),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: Stack(children: [
                      Container(
                        margin: const EdgeInsets.only(left: 6 ,right: 6),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                        ),
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14), // Image border
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(20), // Image radius
                            child: Image.network(
                              post.media![index].media.toString(),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                      ),

                    ]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void castStatefulWidget() {
    widget is GalleryImages;
  }
}
