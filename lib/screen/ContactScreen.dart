import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constant/colors.dart';
import '../utils/base_class.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreen createState() => _ContactScreen();
}

class _ContactScreen extends BaseState<ContactScreen> {

  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffFFFFFF), Color(0xffaaa9a3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 800.0, 80.0));


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
            title: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(6),
                        child: Image.asset('assets/images/ic_back_button.png',
                          height: 22, width: 22,color: white),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 65,
                    margin: const EdgeInsets.only(left: 5),
                    child: const Text(
                      "Contact Us",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: white,
                          fontSize: 16),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 12,right: 12,top: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Address",style: TextStyle(fontFamily: roboto,fontSize: 20,
                        foreground: Paint()..shader = linearGradient,fontWeight: FontWeight.w900),),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(left: 12,right: 12,top: 22),
                  child: Text("Jindal Centre 12, Bhikaiji Cama Place, New Delhi – 110 066, INDIA.",overflow: TextOverflow.clip,style: TextStyle(fontFamily: roboto,fontSize: 20,
                      foreground: Paint()..shader = linearGradient,fontWeight: FontWeight.w400,overflow: TextOverflow.clip),),
                ),
              ),
            ],
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
    widget is ContactScreen;
  }
}