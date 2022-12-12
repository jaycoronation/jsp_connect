import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constant/colors.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import 'VerifyOtpScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends BaseState<SignUpScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: black,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(elevation: 0, toolbarHeight: 0),
        body: LayoutBuilder(
          builder:(context,constraints) {
             return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 50,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset("assets/images/ic_naveen_jindal.png", fit: BoxFit.fill),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height- 30,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Welcome Back!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: gilroy, color: white, fontSize: 34, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Log in or SignUp",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: gilroy, color: white, fontSize: 24, fontWeight: FontWeight.w100),
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Card(
                                  margin: const EdgeInsets.only(left: 14, right: 14, bottom: 20),
                                  color: lightblack,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 14, right: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(top: 14),
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(width: 1, color: text_light, style: BorderStyle.solid)),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      alignment: Alignment.center,
                                                      margin: const EdgeInsets.only(left: 10),
                                                      child: const Text("+91", style: TextStyle(fontFamily: gilroy, fontWeight: FontWeight.w600, color: white, fontSize: 16)),
                                                    ),
                                                    Expanded(
                                                      child: TextField(
                                                        controller: controller,
                                                        keyboardType: TextInputType.number,
                                                        decoration: const InputDecoration(
                                                            hintText: 'Enter mobile number',
                                                            contentPadding: EdgeInsets.all(15),
                                                            hintStyle: TextStyle(
                                                              color: text_light,
                                                              fontSize: 15,
                                                              fontFamily: gilroy,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                            border: InputBorder.none),
                                                        style: const TextStyle(color: white, fontFamily: gilroy,fontWeight: FontWeight.w600),
                                                        onChanged: (value) {},
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
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
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyOtpScreen(controller.value.text)));
                                                  }
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                                child: Image.asset(
                                                  "assets/images/ic_right.png",
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                            margin: const EdgeInsets.only(top: 40),
                                            child: const Text(
                                              "We will send you OTP via SMS.",
                                              style: TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.w200, fontFamily: gilroy),
                                            )),
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          margin: const EdgeInsets.only(bottom: 10, top: 80),
                                          child: RichText(
                                            text: TextSpan(
                                              style: Theme.of(context).textTheme.bodyText1,
                                              children: const [
                                                TextSpan(
                                                  text: 'Register an new',
                                                  style: TextStyle(fontSize: 18, color: text_light, fontWeight: FontWeight.w200, fontFamily: gilroy),
                                                ),
                                                TextSpan(
                                                  text: " Account",
                                                  style: TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.w200, fontFamily: gilroy),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 40, left: 14),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                "assets/images/ic_back_button.png",
                                height: 50,
                                width: 50,
                                alignment: Alignment.topLeft,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(true);
      },
    );
  }

  @override
  void castStatefulWidget() {
    widget is SignUpScreen;
  }
}
