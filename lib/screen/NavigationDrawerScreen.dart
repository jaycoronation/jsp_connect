import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:jspl_connect/screen/AboutJSPLScreen.dart';
import 'package:jspl_connect/screen/LeadershipScreen.dart';
import 'package:jspl_connect/screen/SamparkScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant/colors.dart';
import '../utils/base_class.dart';
import '../utils/session_manager_methods.dart';
import 'AboutScreen.dart';
import 'ContactScreen.dart';
import 'LoginScreen.dart';
import 'MediaCoverageScreen.dart';
import 'SocialWallScreen.dart';
import 'SuggestionFormScreen.dart';

class NavigationDrawerScreen extends StatefulWidget {
  const NavigationDrawerScreen({Key? key}) : super(key: key);

  @override
  _NavigationDrawerScreen createState() => _NavigationDrawerScreen();
}

class _NavigationDrawerScreen extends BaseState<NavigationDrawerScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            elevation: 0,
          ),
          backgroundColor: black,
          resizeToAvoidBottomInset: true,
          body:SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 20),
                    decoration: BoxDecoration(
                      color: lightblack,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      width: 22,
                                      height: 22,
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Image.asset("assets/images/ic_back_button.png", height: 22, width: 22, color: yellow))),
                              sessionManager.getFullName().toString().trim().isNotEmpty ? Container(
                                margin: const EdgeInsets.only(top: 10, left: 10),
                                child: Text(
                                  "Hi, ${sessionManager.getFullName().toString().trim()}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.w600, fontFamily: aileron),
                                ),
                              ) :
                              Container(
                                margin: const EdgeInsets.only(top: 10, left: 10),
                                child: const Text(
                                  "Hi,Guest User",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.w600, fontFamily: aileron),
                                ),
                              ),
                              Expanded(child: Container())
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 26, right: 10, top: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Dashboard",
                                    style: TextStyle(fontFamily: gilroy, fontSize: 18, color: white, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutJSPLScreen()));
                                  },
                                  child: const Text(
                                    "About JSP",
                                    style: TextStyle(fontFamily: slik, fontSize: 18, color: white, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
                                  },
                                  child: const Text(
                                    "About Naveen Jindal",
                                    style: TextStyle(fontFamily: gilroy, fontSize: 18, color: white, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SocialWallScreen()));
                                  },
                                  child: const Text(
                                    "Social",
                                    style: TextStyle(fontFamily: gilroy, fontSize: 18, color: white, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MediaCoverageScreen()));
                                  },
                                  child: const Text(
                                    "Media Coverage",
                                    style: TextStyle(fontFamily: gilroy, fontSize: 18, color: white, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SamparkScreen()));
                                  },
                                  child: const Text(
                                    "Magazine",
                                    style: TextStyle(fontFamily: gilroy, fontSize: 18, color: white, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SuggestionFormScreen()));
                                  },
                                  child: const Text(
                                    "Suggestions",
                                    style: TextStyle(fontFamily: gilroy, fontSize: 18, color: white, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LeadershipScreen()));
                                  },
                                  child: const Text(
                                    "Our Leadership",
                                    style: TextStyle(fontFamily: gilroy, fontSize: 18, color: white, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(height: 18),
                        const Spacer(),
                        const Divider(
                          height: 1,
                          color: text_light,
                          thickness: 1,
                          endIndent: 20,
                          indent: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 22),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactScreen()));
                                },
                                child: Text(
                                  "Contact",
                                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16, color: white, fontFamily: aileron),
                                ),
                              ),
                              Text(
                                "Need Help?",
                                style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16, color: white, fontFamily: aileron),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: yellow,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (await canLaunchUrl(Uri.parse("https://www.facebook.com/JSPLCorporate/"))) {
                                      launchUrl(Uri.parse("https://www.facebook.com/JSPLCorporate/"),
                                          mode: LaunchMode.externalNonBrowserApplication);
                                    }
                                  },
                                  child: Image.asset(
                                    "assets/images/ic_facebook.png",
                                    height: 22,
                                    width: 22,
                                    color: black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (await canLaunchUrl(Uri.parse("https://instagram.com/jsplcorporate?igshid=YmMyMTA2M2Y="))) {
                                      launchUrl(Uri.parse("https://instagram.com/jsplcorporate?igshid=YmMyMTA2M2Y="),
                                          mode: LaunchMode.externalNonBrowserApplication);
                                    }
                                  },
                                  child: Image.asset(
                                    "assets/images/ic_insta.png",
                                    height: 22,
                                    width: 22,
                                    color: black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (await canLaunchUrl(Uri.parse("https://twitter.com/jsplcorporate?lang=en"))) {
                                      launchUrl(Uri.parse("https://twitter.com/jsplcorporate?lang=en"),
                                          mode: LaunchMode.externalNonBrowserApplication);
                                    }
                                  },
                                  child: Image.asset(
                                    "assets/images/ic_twitter.png",
                                    height: 22,
                                    width: 22,
                                    color: black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (await canLaunchUrl(Uri.parse("https://www.youtube.com/jsplcorporate"))) {
                                      launchUrl(Uri.parse("https://www.youtube.com/jsplcorporate"),
                                          mode: LaunchMode.externalNonBrowserApplication);
                                    }
                                  },
                                  child: Image.asset(
                                    "assets/images/ic_youtube.png",
                                    height: 22,
                                    width: 22,
                                    color: black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: TextButton(
                            onPressed: () {
                              logoutFromApp();
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all<Color>(yellow)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/ic_logout.png",
                                    height: 20,
                                    width: 20,
                                    color: black,
                                  ),
                                  const Spacer(),
                                  const Text(
                                    "LOG OUT",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: roboto, color: black, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ) ,
        ),
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        });
  }

  void logoutFromApp() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: black,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: black),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 2,
                    width: 40,
                    alignment: Alignment.center,
                    color: orange,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: const Text('Logout from JSP Connect', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: white))),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                    child: const Text('Are you sure you want to logout from app?',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: white)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, bottom: 40,top: 20),
                    child: Row(
                      children: [
                        Expanded(child: Container(
                                height: 42,
                                child: TextButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      backgroundColor: MaterialStateProperty.all<Color>(yellow)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child:
                                  const Text("No", style: TextStyle(fontWeight: FontWeight.w600, fontFamily: slik, fontSize: 16, color: black)),
                                ))),
                        Gap(20),
                        Expanded(
                          child: Container(
                            height: 42,
                            child: TextButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(yellow)),
                              onPressed: () {
                                Navigator.pop(context);
                                SessionManagerMethods.clear();
                                Navigator.pushAndRemoveUntil(
                                    context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
                              },
                              child: const Text("Yes", style: TextStyle(fontWeight: FontWeight.w600, fontFamily: slik, fontSize: 16, color: black)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void castStatefulWidget() {
    widget is NavigationDrawerScreen;
  }
}
