import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constant/colors.dart';

class MyNoDataWidget extends StatelessWidget {
  final String msg;

  const MyNoDataWidget({Key? key, required this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 100),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: grayNew,
            borderRadius: BorderRadius.circular(22)
        ),
        width: 330,
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/ic_jspl_logo.png',
                width: 120, height: 120),
            Text(
              msg,
              style: TextStyle(
                  color: black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500
              ),
            )
          ],
        ),
      ),
    );
  }
}
