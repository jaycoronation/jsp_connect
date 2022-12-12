import 'package:flutter/material.dart';

import '../constant/colors.dart';
import '../utils/base_class.dart';

class AboutJSPLScreen extends StatefulWidget {
  const AboutJSPLScreen({Key? key}) : super(key: key);

  @override
  _AboutJSPLScreen createState() => _AboutJSPLScreen();
}

class _AboutJSPLScreen extends BaseState<AboutJSPLScreen> {

  bool isLiked = false;

  String readMore = "As the Coronavirus pandemic continues to wage a fierce battle against the human race, imposing tremendous pressure across the world, not just financially but also socially, physically and emotionally. I appreciate the meaningful role you are playing despite the uncertainties and hardships that we all are facing. Shallu and I would like to extend our heartfelt gratitude for your enduring dedication and support for each other and the organization.\n\nIn this unfavourable environment, the businesses, in particular, are confronted with questions on their ability to steer through this black swan event and challenges of business continuity. We at JSP have over the past few weeks stepped up our business continuity preparedness to equip our organization with operational resilience. It has been heartening to know how our teams are working in these complex times managing both, their personal priorities and the work responsibilities.\n\nAs we deal with the looming uncertainty and adjust to the new normal, there are no known rules or ready reckoners available to refer. We know that many of us are going to feel anxious and concerned about our own health and the health of our families and friends. In such times we must leverage on our key strength, that has since long helped us sail through tough times - Collaboration. This epidemic has propelled us to broaden the meaning of collaboration at workplace from partnership between employees to a partnership between the employees’ families - organization and to embrace technology to transcend the boundaries of workplace.\n\nThe severity of the present circumstances has driven us to renounce the traditional mind-set that equates office to a fixed building and adopt a progressive belief that treats office as mobile, placing it where one wants it to be. Working remotely or working from home presents us with an opportunity to explore a new style of working, which I believe is the future of work.\n\nI am deeply concerned about the health and safety of those who are working in our plants in roles that currently cannot be performed from home and would like to assure that all the necessary measures have been undertaken to ensure your safety at all times. I am particularly inspired by the agility with which you all have taken ownership of new priorities that have emerged due to the unprecedented nature of the challenge. However, I would also like to stress that each one of you must ensure that you take good care of yourselves and consider your own wellbeing and that of your families, friends and the community that you live in, as your top priority.\n\nJSP is committed to supporting the Government of India in all of its endeavours to contain the outbreak. I urge you to please stay focused, safe and abide by the National, State and Local government guidelines. This is an evolving situation and JSPLs Crisis Management Group is working relentlessly to keep itself abreast of the developments to ensure your safety and that of your family.\n\nThe upcoming times may be challenging, but together we can face it with resilience and commitment. I would like to thank you once again for all your hard work, support, and diligence. I wish you good health and happiness.\n\nWarmly, Naveen Jindal";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: black,
          appBar: AppBar(toolbarHeight: 0, elevation: 0),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage("assets/images/ic_about_jspl_1.jpg"),fit: BoxFit.cover)
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 14, right: 14, top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(right: 8),
                                  child: Image.asset('assets/images/ic_back_button.png', height: 22, width: 22),
                                )),
                            Container(
                              margin: const EdgeInsets.only( left: 12),
                              alignment: Alignment.center,
                              child: const Text(
                                "About JSP",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.w600, fontFamily: gilroy),
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*Container(
                        height: MediaQuery.of(context).size.height / 2.5,
                        width: MediaQuery.of(context).size.width,
                      ),*/
                      Spacer(),
                      Container(
                        margin: const EdgeInsets.only(right: 22,left: 22,bottom: 50),
                        decoration: BoxDecoration(
                          color: lightblack,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Message from the chairman",
                                    style: TextStyle(fontFamily: gilroy, fontSize: 16, color: white, fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                  Image.asset(
                                    "assets/images/share.png",
                                    height: 22,
                                    width: 22,
                                    color: darkGray,
                                  ),
                                  Container(width: 12,),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        isLiked = !isLiked;
                                      });
                                    },
                                    child: Image.asset(
                                      isLiked
                                          ? "assets/images/like_filled.png"
                                          : "assets/images/like.png",
                                      height: 22,
                                      width: 22,
                                      color: isLiked ? Colors.yellow : darkGray,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 14, right: 14,top: 14,bottom: 18),
                              child:  const Text(
                                "As the Coronavirus pandemic continues to wage a fierce battle against the human race, imposing tremendous pressure across the world, not just financially but also socially, physically and emotionally.",
                                style: TextStyle(fontWeight: FontWeight.w900, color: white, fontSize: 20, fontFamily: roboto),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)
                                      )
                                  ),
                                  elevation: 5,
                                  isDismissible: true,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: MediaQuery.of(context).size.height * 0.88,
                                      color: lightblack,
                                      padding: const EdgeInsets.all(12),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: const [
                                                Padding(
                                                  padding: EdgeInsets.only(bottom:12 ,top: 12),
                                                  child: SizedBox(
                                                    width: 50,
                                                    child: Divider(
                                                      color: Colors.grey,
                                                      height: 1.5,
                                                      thickness: 1.5,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Text('Message From Chairman',style: TextStyle(color: white,fontWeight: FontWeight.w600,fontSize: 16)),
                                            Container(height: 8,),
                                            Text(readMore,style: const TextStyle(color: white,fontWeight: FontWeight.w400,fontSize: 14)),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12,left: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: bgMain.withOpacity(0.8),
                                ),
                                padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                                child: const Text("Read More",style: TextStyle(color: white,fontWeight: FontWeight.w400,fontSize: 14,fontFamily: roboto)),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
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

  @override
  void castStatefulWidget() {
    widget is AboutJSPLScreen;
  }
}