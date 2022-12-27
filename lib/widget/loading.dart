import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constant/colors.dart';
import 'PlaceholderTile.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: screenBg,
      child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Shimmer.fromColors(
                    baseColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300 ,
                    highlightColor: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade500 ,
                    enabled: true,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: const [
                          BannerPlaceholder(),
                          TitlePlaceholder(width: double.infinity),
                          SizedBox(height: 16.0),
                          ContentPlaceholder(
                            lineType: ContentLineType.threeLines,
                          ),
                          SizedBox(height: 16.0),
                          TitlePlaceholder(width: 200.0),
                          SizedBox(height: 16.0),
                          ContentPlaceholder(
                            lineType: ContentLineType.twoLines,
                          ),
                          SizedBox(height: 16.0),
                          TitlePlaceholder(width: 200.0),
                          SizedBox(height: 16.0),
                          ContentPlaceholder(
                            lineType: ContentLineType.twoLines,
                          ),
                          SizedBox(height: 16.0),
                          TitlePlaceholder(width: 200.0),
                          SizedBox(height: 16.0),
                          ContentPlaceholder(
                            lineType: ContentLineType.twoLines,
                          ),
                          SizedBox(height: 16.0),
                          TitlePlaceholder(width: 200.0),
                          SizedBox(height: 16.0),
                          ContentPlaceholder(
                            lineType: ContentLineType.twoLines,
                          ),
                          SizedBox(height: 16.0),
                          TitlePlaceholder(width: 200.0),
                          SizedBox(height: 16.0),
                          ContentPlaceholder(
                            lineType: ContentLineType.twoLines,
                          ),
                          SizedBox(height: 16.0),
                          TitlePlaceholder(width: 200.0),
                          SizedBox(height: 16.0),
                          ContentPlaceholder(
                            lineType: ContentLineType.twoLines,
                          ),

                        ],
                      ),
                    )),


               /* SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xff444444),
                            width: 2,
                          )),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(color: const Color(0xff444444)),
                        )
                    ),
                    ),
                  ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Loading...', style: TextStyle(color: black,fontWeight: FontWeight.w600,fontSize: 14),
                )*/
              ],
            ),
          )),
    );
  }
}
