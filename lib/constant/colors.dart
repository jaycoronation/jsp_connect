import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jspl_connect/utils/session_manager.dart';

const String slik = "Gilroy";
const String aileron = "Gilroy";
const String gilroy = "Gilroy";
const String roboto = "Gilroy";
const String robotoFinal = "Roboto";
const String nj = "Boelan Sabit Demo";

const titleFont = FontWeight.w500;

var bottomWidgetKey = GlobalKey<State<BottomNavigationBar>>();
bool isHomeReload = false;
bool isGalleryReload = false;
bool isVideoReload = false;
bool isBlogReload = false;

bool isDarkMode = SessionManager().getDarkMode() ?? false;

final Shader linearGradient = const LinearGradient(
  colors: <Color>[Color(0xffffffff), Color(0xffaaa9a3)],
).createShader(const Rect.fromLTWH(0.0, 0.0, 800.0, 80.0));

final Shader linearGradientSocial = const LinearGradient(
  colors: <Color>[Color(0xffFFFFFF), Color(0xff9b9b98)],
).createShader(const Rect.fromLTWH(0.0, 0.0, 800.0, 80.0));

final Shader linearGradientForDate = const LinearGradient(
  colors: <Color>[Color(0xffaaa9a3), Color(0xff72716d)],
).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

final Shader linearGradientNews = const LinearGradient(
  colors: <Color>[Color(0xff000000), Color(0xff9b9b98)],
).createShader(const Rect.fromLTWH(0.0, 0.0, 800.0, 80.0));

Color grayNew= isDarkMode ? const Color(0xff333333) : const Color(0xffE7EBEE);
Color newsBlock = isDarkMode ? const Color(0xff333333) : const Color(0xffE7EBEE);
Color newsText = isDarkMode ? const Color(0xffE7EBEE) : const Color(0xff72716d);
Color white= isDarkMode ? const Color(0xff000000) : const Color(0xffffffff);
Color screenBg= isDarkMode ? const Color(0Xffff181C1F) : const Color(0xfffffffff);
Color bottombar= isDarkMode ? Color(0Xff181C1F) : Color(0xffE6E9EE);
const Color blackConst= Color(0xff000000);
const Color whiteConst= Color(0xffffffff);
const Color text_light= Color(0xffaaa9a3);
const Color text_dark= Color(0xff72716d);
Color black = isDarkMode ?  const Color(0xffffffff) : const Color(0xff000000);
const Color lightblack= Color(0xff333333);
const Color darkblack= Color(0xff131313);
const Color lightGray = Color(0xff9BA6B3);
const Color facebookBlue = Color(0xff3264b5);
const Color yellow= Color(0xfff8eb21);
const Color Gray= Color(0xffe0e0e0);
const Color lightGrayNew= Color(0xfff3f3f3);
const Color darkGray= Color(0xff999999);
const Color btnBlack= Color(0xff423e3d);
const Color bgOverlay= Color(0xff757575);
const Color bgMain= Color(0xff666666);
const Color red= Color(0xffff0000);
const Color grayTitle1= Color(0xff808080);
const Color grayTitle2= Color(0xff999999);
const Color grayTitle3= Color(0xffb3b3b3);
const Color orange= Color(0xffeb2f00);
const Color blueNew= Color(0xff114ce4);
const Color yellowNew= Color(0xffffe505);
const Color orangeNew= Color(0xffff551d);
const Color navigation= Color(0xffDDE2E6);
const Color navigationGradient1= Color(0xffBAC2DE);
const Color navigationGradient2= Color(0xffEECA9E);
const Color navigationGradient3= Color(0xffEED386);

const Color newScreenBg= Color(0xffefefef);
const Color border= Color(0xff015cfd);

// FOR DARK

/*final Shader linearGradient = const LinearGradient(
  colors: <Color>[Color(0xff000000), Color(0xffaaa9a3)],
).createShader(const Rect.fromLTWH(0.0, 0.0, 800.0, 80.0));

final Shader linearGradientSocial = const LinearGradient(
  colors: <Color>[Color(0xffFFFFFF), Color(0xff9b9b98)],
).createShader(const Rect.fromLTWH(0.0, 0.0, 800.0, 80.0));

final Shader linearGradientForDate = const LinearGradient(
  colors: <Color>[Color(0xffaaa9a3), Color(0xff72716d)],
).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

final Shader linearGradientNews = const LinearGradient(
  colors: <Color>[Color(0xffFFFFFF), Color(0xff9b9b98)],
).createShader(const Rect.fromLTWH(0.0, 0.0, 800.0, 80.0));

const Color grayNew= Color(0xffE7EBEE);
const Color white= Color(0xff000000);
const Color screenBg= Color(0xff181C1F);
const Color whiteConst= Color(0xffffffff);
const Color blackConst= Color(0xff000000);
const Color text_light= Color(0xffaaa9a3);
const Color text_dark= Color(0xff72716d);
const Color black= Color(0xffffffff);
const Color lightblack= Color(0xff333333);
const Color darkblack= Color(0xff131313);
const Color lightGray = Color(0xff9BA6B3);
const Color facebookBlue = Color(0xff3264b5);
const Color yellow= Color(0xfff8eb21);
const Color Gray= Color(0xffe0e0e0);
const Color darkGray= Color(0xff999999);
const Color btnBlack= Color(0xff423e3d);
const Color bgOverlay= Color(0xff757575);
const Color bgMain= Color(0xff666666);
const Color red= Color(0xffff0000);
const Color grayTitle1= Color(0xff808080);
const Color grayTitle2= Color(0xff999999);
const Color grayTitle3= Color(0xffb3b3b3);
const Color orange= Color(0xffeb2f00);
const Color blueNew= Color(0xff114ce4);
const Color yellowNew= Color(0xffffe505);
const Color bottombar= Color(0xffE6E9EE);
const Color orangeNew= Color(0xffff551d);*/
