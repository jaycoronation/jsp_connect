import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/LoginWithOTPResponse.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import 'tabcontrol/bottom_navigation_bar_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String ContactNumber;
  const VerifyOtpScreen(this.ContactNumber, {Key? key}) : super(key: key);

  @override
  _VerifyOtpScreen createState() => _VerifyOtpScreen();
}

class _VerifyOtpScreen extends BaseState<VerifyOtpScreen> {
  bool _isLoading = false;
  FocusNode inputNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();
  late Timer _timer;
  int _start = 60;
  bool visibilityResend = false;
  String strPin = "";

  void startTimer() {
    const oneSec = Duration(milliseconds: 1000);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            visibilityResend = true;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState(){
    startTimer();
    Future.delayed(const Duration(seconds: 1),() {
      openKeyboard();
    },);
    loginWithMobile();
    super.initState();
  }

  loginWithMobile() async {
   /* setState(() {
      _isLoading = true;
    });*/

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + loginWithOTP);
    Map<String, String> jsonBody = {'mobile': (widget as VerifyOtpScreen).ContactNumber.toString().trim(), 'from_app': FROM_APP};
    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = LoginWithOtpResponse.fromJson(apiResponse);

    if (statusCode == 200 && dataResponse.success == 1) {
      showSnackBar(dataResponse.message, context);
    } else {
      showSnackBar(dataResponse.message, context);
    }
   /* setState(() {
      _isLoading = false;
    });*/
  }

  verifyOTPCall() async {
    setState(() {
      _isLoading = true;
    });

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + verifyOTP);
    Map<String, String> jsonBody = {
      'mobile': (widget as VerifyOtpScreen).ContactNumber.toString().trim(),
      'from_app': FROM_APP,
      'otp' : strPin};
    final response = await http.post(
        url,
        body: jsonBody);
    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = LoginWithOtpResponse.fromJson(apiResponse);

    if (statusCode == 200 && dataResponse.success == 1) {
      await sessionManager.createLoginSession(dataResponse.user!.userId.toString(),
          dataResponse.user!.firstName.toString(),
          dataResponse.user!.lastName.toString(),
          dataResponse.user!.email.toString(),
          dataResponse.user!.mobile.toString(),
          "",
          dataResponse.user!.accessToken.toString(),
          dataResponse.user!.companyId.toString());
      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNavigationBarScreen(0)));
    } else {
      showSnackBar(dataResponse.message, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void openKeyboard(){
    FocusScope.of(context).requestFocus(inputNode);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: screenBg,
          resizeToAvoidBottomInset: false,
          body: _isLoading
              ? const LoadingWidget()
              : SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Card(
                          margin: const EdgeInsets.only(left: 14, right: 14, bottom: 20, top: 20),
                          color: lightblack,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.only(left: 10, top: 14, right: 14),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Image.asset(
                                          "assets/images/ic_back_button.png",
                                          height: 22,
                                          width: 22,
                                        ))),
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(top: 14, left: 14),
                                  child:  Text(
                                    "Confirm OTP",
                                    style: TextStyle(color: white, fontSize: 18, fontWeight: FontWeight.w100, fontFamily: slik),
                                  )),
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(bottom: 10, left: 14, top: 14),
                                child: RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.bodyText1,
                                    children: [
                                      const TextSpan(
                                        text: 'OTP is sent on',
                                        style: TextStyle(fontSize: 16, color: text_light, fontWeight: FontWeight.w100, fontFamily: aileron),
                                      ),
                                      TextSpan(
                                        text: " ${(widget as VerifyOtpScreen).ContactNumber}",
                                        style: TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.w600, fontFamily: aileron),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 4, bottom: 4,left: 34,right: 34),
                                child: PinCodeTextField(
                                  focusNode: inputNode,
                                  autoDisposeControllers: false,
                                  controller: textEditingController,
                                  appContext: context,
                                  pastedTextStyle: TextStyle(
                                    fontFamily: aileron,
                                    color: black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textStyle: TextStyle(fontFamily: aileron, fontWeight: FontWeight.w600, color: white),
                                  length: 4,
                                  autoFocus: true,
                                  obscureText: false,
                                  blinkWhenObscuring: true,
                                  autoDismissKeyboard: true,
                                  animationType: AnimationType.fade,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.circle,
                                    borderWidth: 1,
                                    fieldHeight: 50,
                                    fieldWidth: 50,
                                    activeColor: white,
                                    selectedColor: lightGray,
                                    disabledColor: text_dark,
                                    inactiveColor: text_dark,
                                    activeFillColor: Colors.transparent,
                                    selectedFillColor: Colors.transparent,
                                    inactiveFillColor: Colors.transparent,
                                  ),
                                  cursorColor: white,
                                  animationDuration: const Duration(milliseconds: 300),
                                  enableActiveFill: true,
                                  keyboardType: TextInputType.number,
                                  onCompleted: (v) {
                                    setState((){
                                      strPin = v;
                                    });
                                    if(isInternetConnected) {
                                      verifyOTPCall();
                                      textEditingController.clear();
                                    }else{
                                      noInterNet(context);
                                    }
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      strPin = value;
                                    });
                                  },
                                  beforeTextPaste: (text) {
                                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                    return true;
                                  },
                                ),
                              ),
                              !visibilityResend ? Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(bottom: 10, left: 14, top: 14),
                                child: RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.bodyText1,
                                    children: [
                                      const TextSpan(
                                        text: 'Resend OTP in',
                                        style: TextStyle(fontSize: 14, color: text_light, fontWeight: FontWeight.w200, fontFamily: aileron),
                                      ),
                                      TextSpan(
                                        text: " $_start Seconds",
                                        style: TextStyle(fontSize: 14, color: white, fontWeight: FontWeight.w600, fontFamily: aileron),
                                      ),
                                    ],
                                  ),
                                ),
                              ) : Container(),
                              const Spacer(),
                              visibilityResend ? Container(
                                height: 55,
                                margin: const EdgeInsets.only(bottom: 20, left: 24, right: 24, top: 24),
                                width: MediaQuery.of(context).size.width,
                                child: TextButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      backgroundColor: MaterialStateProperty.all<Color>(yellow)),
                                  onPressed: () {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      _start = 60;
                                      visibilityResend = false;
                                      startTimer();
                                      if(isInternetConnected) {
                                        textEditingController.clear();
                                        loginWithMobile();
                                      }else {
                                        noInterNet(context);
                                      }
                                    });
                                  },
                                  child:  Text("Resend OTP", style: TextStyle(fontWeight: FontWeight.w400, fontFamily: slik, fontSize: 16, color: black)),
                                ),
                              ): Container(
                                height: 55,
                                margin: const EdgeInsets.only(bottom: 20, left: 24, right: 24, top: 24),
                                width: MediaQuery.of(context).size.width,
                                child: TextButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      backgroundColor: MaterialStateProperty.all<Color>(yellow)),
                                  onPressed: () {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    if (strPin.isEmpty) {
                                      showSnackBar("Please enter OTP", context);
                                    }else if (strPin.length !=4) {
                                      showSnackBar("Please enter 4 digit OTP", context);
                                    }else {
                                      if(isInternetConnected) {
                                        verifyOTPCall();
                                        textEditingController.clear();
                                      }else{
                                        noInterNet(context);
                                      }
                                    }
                                  },
                                  child:  Text("CONTINUE", style: TextStyle(fontWeight: FontWeight.w400, fontFamily: slik, fontSize: 16, color: black)),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                  alignment: Alignment.bottomCenter,
                                  margin: const EdgeInsets.only(left: 10, top: 14,bottom: 50),
                                  child:  Text(
                                    "Please enter OTP to continue",
                                    style: TextStyle(color: text_light, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: aileron),
                                  )),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(top: 14),
                        alignment: Alignment.center,
                        child:  Text(
                          "By continuing,you agree to our ",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: aileron, color: text_light, fontSize: 14, fontWeight: FontWeight.w200),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 38, left: 10, top: 4),
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyText1,
                            children:  [
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(fontSize: 14, color: white, fontWeight: FontWeight.w200, fontFamily: aileron),
                              ),
                              TextSpan(
                                text: "&",
                                style: TextStyle(fontSize: 14, color: text_light, fontWeight: FontWeight.w200, fontFamily: aileron),
                              ),
                              TextSpan(
                                text: "Terms of Service.",
                                style: TextStyle(fontSize: 14, color: white, fontWeight: FontWeight.w200, fontFamily: aileron),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        onWillPop: () {
          SystemNavigator.pop();
          return Future.value(true);
        });
  }

  @override
  void castStatefulWidget() {
    widget is VerifyOtpScreen;
  }
}
