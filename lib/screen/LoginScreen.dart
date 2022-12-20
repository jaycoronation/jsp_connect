import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/colors.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import 'VerifyOtpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends BaseState<LoginScreen> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: LayoutBuilder(
            builder: (context , constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Stack(
                      children: [
                        Container(
                          color: white,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                colors: [
                                  blackConst.withOpacity(0.2),
                                  blackConst.withOpacity(0.9),
                                ],
                                stops: const [
                                  0.2,
                                  1.0
                                ]
                            ),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20)
                            ),
                          ),
                        ),
                        Positioned(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 200),
                            child: Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset("assets/images/ic_jspl_logo.png",width: 250,height: 250,),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const Spacer(),
                            Text("Log In",style: TextStyle(color: white,fontFamily: gilroy,fontSize: 22,fontWeight: FontWeight.w600),),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(left: 14, right: 14,bottom: 100),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 20, left: 12, right: 12),
                                    height: 55,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: whiteConst,border: Border.all(width: 1, color: white, style: BorderStyle.solid)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 55,
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(left: 12),
                                          child: const Text("+91", style: TextStyle(fontFamily: aileron, fontWeight: FontWeight.w400, color: orange, fontSize: 16)),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: controller,
                                            maxLength: 10,
                                            inputFormatters: [ FilteringTextInputFormatter. digitsOnly],
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                                counterText: "",
                                                hintText: 'Enter mobile number',
                                                contentPadding: EdgeInsets.all(15),
                                                hintStyle: TextStyle(
                                                  color: text_dark,
                                                  fontSize: 15,
                                                  fontFamily: gilroy,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                border: InputBorder.none),
                                            style: const TextStyle(color: text_dark, fontFamily: aileron,fontWeight: FontWeight.w600),
                                            onChanged: (value) {},
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(top: 22),
                                      child: Text(
                                        "You will receive an OTP on your register mobile no.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.w200, fontFamily: aileron,),
                                      )
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 50,left: 12,right: 12),
                                    width: MediaQuery.of(context).size.width,
                                    child: TextButton(
                                        onPressed: (){
                                          if (controller.value.text.isEmpty)
                                          {
                                            showSnackBar("Please enter your contact number", context);
                                          }
                                          else if (controller.value.text.length != 10)
                                          {
                                            showSnackBar("Please enter valid contact number", context);
                                          }
                                          else
                                          {
                                            if(isInternetConnected)
                                              {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyOtpScreen(controller.value.text)));
                                              }
                                            else
                                              {
                                                noInterNet(context);
                                              }
                                          }
                                        },
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(black),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30.0),
                                                    side: const BorderSide(color: blackConst)
                                                )
                                            )
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Continue",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,fontFamily: gilroy,color: Colors.white),),
                                        )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
    widget is LoginScreen;
  }
}