import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jspl_connect/model/CommanResponse.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class SuggestionFormScreen extends StatefulWidget {
  const SuggestionFormScreen({Key? key}) : super(key: key);

  @override
  _SuggestionFormScreen createState() => _SuggestionFormScreen();
}

class _SuggestionFormScreen extends BaseState<SuggestionFormScreen> {

  TextEditingController suggestionController = TextEditingController();
  bool _isLoading = false;

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
                      "Suggestions",
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
          body: LayoutBuilder(
            builder: (BuildContext , constraints) {
              return _isLoading
                  ? const LoadingWidget()
                  : SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 12,left: 14,right: 14,bottom: 22),
                                width: MediaQuery.of(context).size.width,
                                child: TextField(
                                  controller: suggestionController,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 5,
                                  maxLines: 8,
                                  decoration: const InputDecoration(
                                      hintText: 'Please share your valuable input and suggestion*',
                                      contentPadding: EdgeInsets.all(15),
                                      hintStyle: TextStyle(
                                        color: text_dark,
                                        fontSize: 15,
                                        fontFamily: gilroy,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid)),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)),borderSide: BorderSide(width: 1,color: text_dark,style: BorderStyle.solid))
                                  ),
                                  style: const TextStyle(fontWeight: FontWeight.w300, color: white,fontSize: 16,fontFamily: gilroy),
                                  onChanged: (value) {
                                  },
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
                                    if (suggestionController.value.text.toString().trim().isEmpty)
                                      {
                                        showSnackBar("Please enter your valuable suggestion", context);
                                      }
                                    else
                                      {
                                        if (isOnline) {
                                          saveData();
                                        }
                                        else
                                        {
                                          noInterNet(context);
                                        }
                                      }
                                  },
                                  child: const Text("Submit",style: TextStyle(fontWeight: FontWeight.w600,fontFamily: gilroy,fontSize: 18,color: black)),),
                              ),
                            ],
                          ),
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

  saveData() async {
    setState(() {
      _isLoading = true;
    });

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(API_URL + suggestion_save);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'user_id' : sessionManager.getUserId().toString(),
      'comments' : suggestionController.text.toString().trim(),
      'company_id' : sessionManager.getCompanyID().toString().trim()};
    final response = await http.post(
        url,
        body: jsonBody,
        headers: {"Access-Token": sessionManager.getAccessToken().toString().trim()});

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = CommanResponse.fromJson(apiResponse);

    if (statusCode == 200 && dataResponse.status == 1) {
      showSnackBar("Thanks you for your suggestion.", context);
      Navigator.pop(context);
    } else {
      showSnackBar(dataResponse.message, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void castStatefulWidget() {
    widget is SuggestionFormScreen;
  }
}