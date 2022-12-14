import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

import '../constant/colors.dart';

/*show message to user*/
showSnackBar(String? message,BuildContext? context) {
  try {
    return ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          content: Text(message!),
          duration: const Duration(seconds: 1),
        ),
      );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

String getPrice(String text) {
    if(text.isNotEmpty)
    {
      try {
        var formatter = NumberFormat('#,##,###');
        return "₹ " + formatter.format(double.parse(text));
      } catch (e) {
        return "₹ " + text;
      }
    }
    else
    {
      return "₹ " + text;
    }
}

noInterNet(BuildContext? context) {
  try {
    return ScaffoldMessenger.of(context!).showSnackBar(
      const SnackBar(
        content: Text("Please check your internet connection!"),
        duration: Duration(seconds: 1),
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

/*check email validation*/
bool isValidEmail(String ? input) {
  try {
    return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(input!);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return false;
  }
}

tabNavigationReload() {
  try {
    isHomeReload = true;
    isGalleryReload = true;
    isVideoReload = true;
    isBlogReload = true;
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

/*convert string to CamelCase*/
toDisplayCase (String str) {
  try {
    return str.toLowerCase().split(' ').map((word) {
        String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
        return word[0].toUpperCase() + leftText;
      }).join(' ');
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

getRandomCartSession () {
  try {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(8, (index) => _chars[r.nextInt(_chars.length)]).join();
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

doubleUpto2Digit (double value) {
  try {
    return double.parse(value.toStringAsFixed(2));
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

convertCommaSeparatedAmount (String value) {
  try {
    var formatter = NumberFormat('#,##,000');
    return formatter.format(value);
  } catch (e) {
    return value;
  }
}

/*generate hex color into material color*/
MaterialColor createMaterialColor(Color color) {
  try {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
        strengths.add(0.1 * i);
      }
    for (var strength in strengths) {
        final double ds = 0.5 - strength;
        swatch[(strength * 1000).round()] = Color.fromRGBO(
          r + ((ds < 0 ? r : (255 - r)) * ds).round(),
          g + ((ds < 0 ? g : (255 - g)) * ds).round(),
          b + ((ds < 0 ? b : (255 - b)) * ds).round(),
          1,
        );
      }
    return MaterialColor(color.value, swatch);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return const MaterialColor(0xFFFFFFFF, <int, Color>{});
  }
}

Future<void> shareFileWithText(String text,String filePath) async {
  try {
    Share.shareFiles([filePath], text: text);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

Future<void> setOrientation(List<DeviceOrientation> orientations) async {
  SystemChrome.setPreferredOrientations(orientations);
}

/*share text content to social apps*/
/*Future<void> shareTextContent(String title,String text,String link,String chooserTitle) async {
  try {
    await FlutterShare.share(
          title: title,
          text: text,
          linkUrl: link,
          chooserTitle: chooserTitle
      );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}*/

/*share text content along with media*/
/*Future<void> shareFileWithText(String title,String text,String filePath) async {
  try {
    await FlutterShare.shareFile(
        title: title,
        text: text,
        filePath: filePath,
      );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}*/


/*generate custom map marker*//*
Future<Uint8List> getBytesFromCanvas(int customNum, int width, int height) async  {
  final PictureRecorder pictureRecorder = PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = white;
  final Radius radius = Radius.circular(width/2);
  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, width.toDouble(),  height.toDouble()),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      paint);

  TextPainter painter = TextPainter(textDirection: TextDirection.LTR);
  painter.text = TextSpan(
    text: '₹' + customNum.toString(), // your custom number here
    style: GoogleFonts.nunito(
        fontSize: 42,
        color: black,
        fontWeight: FontWeight.w700),
  );

  painter.layout();
  painter.paint(
      canvas,
      Offset((width * 0.5) - painter.width * 0.5,
          (height * .5) - painter.height * 0.5));
  final img = await pictureRecorder.endRecording().toImage(width, height);
  final data = await img.toByteData(format: ImageByteFormat.png);
  return data!.buffer.asUint8List();
}*/

String universalDateConverter(String inputDateFormat,String outputDateFormat, String date) {
  var inputFormat = DateFormat(inputDateFormat);
  var inputDate = inputFormat.parse(date); // <-- dd/MM 24H format

  var outputFormat = DateFormat(outputDateFormat);
  var outputDate = outputFormat.format(inputDate);
  print(outputDate); // 12/31/2000 11:59 PM <-- MM/dd 12H format
  return outputDate;
}


class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}