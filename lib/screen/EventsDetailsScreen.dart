import 'package:flutter/material.dart';

import '../constant/colors.dart';
import '../model/BlogModel.dart';
import '../utils/base_class.dart';

class EventsDetailsScreen extends StatefulWidget {
  final BlogModel dataGetSet;
  const EventsDetailsScreen(this.dataGetSet, {Key? key}) : super(key: key);

  @override
  _EventsDetailsScreen createState() => _EventsDetailsScreen();
}

class _EventsDetailsScreen extends BaseState<EventsDetailsScreen> {
  late BlogModel getSet;

  @override
  void initState(){
    getSet = (widget as EventsDetailsScreen).dataGetSet;
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
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(6),
                  child: Image.asset('assets/images/ic_back_button.png',
                      height: 22, width: 22,color: white),
                )),
            title: const Text(
              "Events Details",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: white,
                  fontSize: 16),
            ),
            actions: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                margin: EdgeInsets.only(right: 8),
                child: Image.asset('assets/images/like.png',
                    height: 22, width: 22,color: white),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(6),
                margin: EdgeInsets.only(right: 8),
                child: Image.asset('assets/images/share.png',
                    height: 22, width: 22,color: white),
              )
            ],
            titleSpacing: 0,
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
                  child: Text(getSet.time, style: TextStyle(height:1.5,color: white,fontSize: 16,fontWeight: FontWeight.w500,fontFamily: roboto)),
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
    widget is EventsDetailsScreen;
  }
}