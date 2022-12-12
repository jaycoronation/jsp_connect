import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jspl_connect/constant/colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'app_utils.dart';

class FullScreenImageNew extends StatelessWidget {
  final String imageUrl;
  final List<String>? images;
  int selectedIndex;
  FullScreenImageNew(this.imageUrl, this.images, this.selectedIndex,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
  //  final controllerForMainBanner = PageController(viewportFraction: 1, keepPage: false,initialPage: selectedIndex);
    PageController? controller = PageController(initialPage: selectedIndex);
   /* final pagesMainBanner = List.generate(images!.length, (index) => InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(20.0),
      minScale: 0.1,
      maxScale: 1.6,
      child: FadeInImage.assetNetwork(
        image: images![index],
        placeholder: 'assets/images/bg_gray.jpeg',
      ),
    ));*/

    return Scaffold(
        backgroundColor: black,
        body: Container(
          color: black,
          child: Stack(
            children: [
             /* PageView.builder(
                controller: controllerForMainBanner,
                itemCount: images!.length,
                itemBuilder: (_, index) {
                  return pagesMainBanner[index % pagesMainBanner.length];
                },
                onPageChanged: (int index){
                  selectedIndex = index;
                },
              ),*/
              PhotoViewGallery.builder(
                itemCount: images!.length,
                pageController: controller,
                onPageChanged: (int index){
                  selectedIndex = index;
                },
                loadingBuilder: (context, event) => Image.asset(
                  'assets/images/bg_gray.jpeg',
                  fit: BoxFit.contain,
                ),
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(images![index]),
                    initialScale: PhotoViewComputedScale.contained,
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                scrollPhysics: const BouncingScrollPhysics(),
                backgroundDecoration: const BoxDecoration(
                  color: black,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 42, right: 12),
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close_rounded),
                  color: white,
                  iconSize: 32,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 42, right: 12),
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () async {
                    final uri = Uri.parse(images![selectedIndex].toString());
                    final response = await http.get(uri);
                    final bytes = response.bodyBytes;
                    final temp = await getTemporaryDirectory();
                    final path = '${temp.path}/image.jpg';
                    File(path).writeAsBytes(bytes);
                    shareFileWithText("",path);
                  },
                  icon: Image.asset('assets/images/share.png', height: 24, width: 24, color: white),
                  color: white,
                  iconSize: 32,
                ),
              ),
              images!.length > 1
                  ? Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.all(18),
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: images!.length,
                      effect: const ExpandingDotsEffect(
                        dotHeight: 6,
                        dotWidth: 6,
                        activeDotColor: white,
                        dotColor: Colors.grey,
                        // strokeWidth: 5,
                      ),
                    ),
                  )
                  : Container()
            ],
          ) ,
        ));
  }
}
