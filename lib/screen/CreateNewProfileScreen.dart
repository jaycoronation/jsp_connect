
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/colors.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import 'tabcontrol/DashboardScreen.dart';
import 'tabcontrol/bottom_navigation_bar_screen.dart';

class CreateNewProfileScreen extends StatefulWidget {
  const CreateNewProfileScreen({Key? key}) : super(key: key);

  @override
  _CreateNewProfileScreen createState() => _CreateNewProfileScreen();
}

class _CreateNewProfileScreen extends BaseState<CreateNewProfileScreen> {
  bool _isLoading = false;
  late FocusNode focusNode;

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState(){
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: black,
          resizeToAvoidBottomInset: true,
          body:_isLoading
          ? const LoadingWidget()
          : SafeArea(
           child: LayoutBuilder(
             builder: (BuildContext , constraints) {
               return SingleChildScrollView(
                 child: ConstrainedBox(
                   constraints: BoxConstraints(minHeight: constraints.maxHeight),
                   child: IntrinsicHeight(
                     child: Column(
                       children: [
                         Expanded(
                           child: Container(
                             margin: const EdgeInsets.only(left:14,right: 14,top: 10),
                             decoration: BoxDecoration(
                               color: lightblack,
                               borderRadius: BorderRadius.circular(30),
                             ),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Container(
                                   margin: const EdgeInsets.only(left: 14,right: 14,top: 14),
                                   child: Row(
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: [
                                       InkWell(
                                           onTap: () {
                                             Navigator.pop(context);
                                           },
                                           child: Container(
                                             alignment: Alignment.center,
                                             margin: const EdgeInsets.only(right: 8),
                                             child: Image.asset('assets/images/ic_back_button.png',
                                                 height: 22, width: 22),
                                           )),
                                       Container(
                                         margin: const EdgeInsets.only(top: 10),
                                         child: const Text("Create New Profile",
                                           textAlign: TextAlign.center,
                                           style: TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.w600,fontFamily: slik),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                                 Container(
                                   margin: const EdgeInsets.only(top: 45,left: 10,right: 10),
                                   width: MediaQuery.of(context).size.width,
                                   height: 55,
                                   decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(30),
                                   ),
                                   child: TextField(
                                     keyboardType: TextInputType.text,
                                     decoration: InputDecoration(
                                         hintText: 'Name*',
                                         contentPadding: const EdgeInsets.all(15),
                                         fillColor: focusNode.hasFocus ? text_light : Colors.transparent,
                                         hintStyle: const TextStyle(
                                           color: text_dark,
                                           fontSize: 15,
                                           fontFamily: gilroy,
                                           fontWeight: FontWeight.w400,
                                         ),
                                         filled: true,
                                         enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                         focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                         disabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                         border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid))
                                     ),
                                     style: const TextStyle(fontWeight: FontWeight.w300, color: white,fontSize: 16,fontFamily: gilroy),
                                     onChanged: (value) {},
                                   ),
                                 ),
                                 Container(
                                   margin: const EdgeInsets.only(top: 12,left: 10,right: 10),
                                   width: MediaQuery.of(context).size.width,
                                   height: 55,
                                   child: TextField(
                                     keyboardType: TextInputType.text,
                                     decoration: const InputDecoration(
                                         hintText: 'Enter mobile number*',
                                         contentPadding: EdgeInsets.all(15),
                                         hintStyle: TextStyle(
                                           color: text_dark,
                                           fontSize: 15,
                                           fontFamily: gilroy,
                                           fontWeight: FontWeight.w400,
                                         ),
                                         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                         focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                         disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                         border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid))
                                     ),
                                     style: const TextStyle(fontWeight: FontWeight.w300, color: white,fontSize: 16,fontFamily: gilroy),
                                     onChanged: (value) {
                                     },
                                   ),
                                 ),
                                 Container(
                                   margin: const EdgeInsets.only(top: 12,left: 14,right: 14),
                                   width: MediaQuery.of(context).size.width,
                                   height: 55,
                                   child: TextField(
                                     keyboardType: TextInputType.text,
                                     decoration: const InputDecoration(
                                         hintText: 'Designation*',
                                         contentPadding: EdgeInsets.all(15),
                                         hintStyle: TextStyle(
                                           color: text_dark,
                                           fontSize: 15,
                                           fontFamily: gilroy,
                                           fontWeight: FontWeight.w400,
                                         ),
                                         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                         focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                         disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                         border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid))
                                     ),
                                     style: const TextStyle(fontWeight: FontWeight.w300, color: white,fontSize: 16,fontFamily: gilroy),
                                     onChanged: (value) {
                                     },
                                   ),
                                 ),
                                 Container(
                                   margin: const EdgeInsets.only(top: 12,left: 14,right: 14),
                                   width: MediaQuery.of(context).size.width,
                                   height: 55,
                                   child: TextField(
                                     keyboardType: TextInputType.text,
                                     decoration: const InputDecoration(
                                         hintText: 'Email*',
                                         contentPadding: EdgeInsets.all(15),
                                         hintStyle: TextStyle(
                                           color: text_dark,
                                           fontSize: 15,
                                           fontFamily: gilroy,
                                           fontWeight: FontWeight.w400,
                                         ),
                                         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                         focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                         disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                         border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid))
                                     ),
                                     style: const TextStyle(fontWeight: FontWeight.w300, color: white,fontSize: 16,fontFamily: gilroy),
                                     onChanged: (value) {
                                     },
                                   ),
                                 ),
                                 Container(
                                   margin: const EdgeInsets.only(top: 12,left: 14,right: 14,bottom: 22),
                                   width: MediaQuery.of(context).size.width,
                                   height: 55,
                                   child: TextField(
                                     keyboardType: TextInputType.text,
                                     decoration: const InputDecoration(
                                         hintText: 'Password*',
                                         contentPadding: EdgeInsets.all(15),
                                         hintStyle: TextStyle(
                                           color: text_dark,
                                           fontSize: 15,
                                           fontFamily: gilroy,
                                           fontWeight: FontWeight.w400,
                                         ),
                                         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                         focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                         disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                         border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid))
                                     ),
                                     style: const TextStyle(fontWeight: FontWeight.w300, color: white,fontSize: 16,fontFamily: gilroy),
                                     onChanged: (value) {
                                     },
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ),
                         Container(
                           margin: const EdgeInsets.only(bottom: 22,left: 24,right: 24,top: 22),
                           height: 55,
                           width: MediaQuery.of(context).size.width,
                           child: TextButton(
                             style: ButtonStyle(
                                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                   RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(30.0),
                                   ),
                                 ),
                                 backgroundColor: MaterialStateProperty.all<Color>(yellow)
                             ),
                             onPressed: () {
                               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const BottomNavigationBarScreen(0)), (Route<dynamic> route) => false);
                             },
                             child: const Text("CONTINUE",style: TextStyle(fontWeight: FontWeight.w400,fontFamily: gilroy,fontSize: 18,color: black)),),
                         ),
                         Container(
                           margin: const EdgeInsets.only(top: 14),
                           alignment: Alignment.center,
                           child: const Text("By continuing,you agree to our ",textAlign: TextAlign.center,
                             style: TextStyle(fontFamily: gilroy, color: text_light, fontSize: 16,fontWeight:FontWeight.w200),),
                         ),
                         Container(
                           alignment: Alignment.center,
                           margin: const EdgeInsets.only(bottom: 30,left: 10,top: 4),
                           child: RichText(
                             text: TextSpan(
                               style: Theme.of(context).textTheme.bodyText1,
                               children: const [
                                 TextSpan(text: 'Privacy Policy ',
                                   style: TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.w200,fontFamily: roboto),
                                 ),
                                 TextSpan(text: "&",
                                   style: TextStyle(fontSize: 16, color: text_light, fontWeight: FontWeight.w200,fontFamily: roboto),
                                 ),
                                 TextSpan(text: " Terms of Service.",
                                   style: TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.w200,fontFamily: roboto),
                                 ),
                               ],
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
               );
             },
           )
          ),
        ),
        onWillPop:(){
          Navigator.pop(context);
          return Future.value(true);
        }
        );
  }

  @override
  void castStatefulWidget() {
    widget is CreateNewProfileScreen;
  }

}