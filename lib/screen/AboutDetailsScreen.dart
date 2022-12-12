import 'package:flutter/material.dart';

import '../constant/colors.dart';
import '../model/AboutNJModel.dart';
import '../utils/base_class.dart';

class AboutDetailsScreen extends StatefulWidget {
  final AboutNJModel dataGetSet;
  const AboutDetailsScreen(this.dataGetSet, {Key? key}) : super(key: key);

  @override
  _AboutDetailsScreen createState() => _AboutDetailsScreen();
}

class _AboutDetailsScreen extends BaseState<AboutDetailsScreen> {
  AboutNJModel getSet = AboutNJModel();

  @override
  void initState(){
    getSet = (widget as AboutDetailsScreen).dataGetSet;
    super.initState();
  }

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
                          height: 22, width: 22,),
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 65,
                    margin: const EdgeInsets.only(left: 5),
                    child: Text(
                      getSet.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: white,
                          fontSize: 18),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      getSet.image,
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(getSet.title, style: TextStyle(color: white,fontSize: 20,fontWeight: FontWeight.w600,fontFamily: roboto)),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(getSet.description, style: TextStyle(height:1.5,color: white,fontSize: 16,fontWeight: FontWeight.w500,fontFamily: roboto)),
                ),
              ],
            ),
          ),
        ),
        onWillPop: (){
          Navigator.of(context).pop();
          return Future.value(true);
        }
    );
  }

  @override
  void castStatefulWidget() {
    widget is AboutDetailsScreen;
  }
}