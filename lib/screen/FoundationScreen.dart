import 'package:flutter/material.dart';

import '../constant/colors.dart';
import '../model/BlogModel.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import 'FoundationDetailsScreen.dart';

class FoundationScreen extends StatefulWidget {
  const FoundationScreen({Key? key}) : super(key: key);

  @override
  _FoundationScreen createState() => _FoundationScreen();
}

class _FoundationScreen extends BaseState<FoundationScreen> {
  List<BlogModel> foundationList = [];
  List<BlogModel> mainList = [];

  @override
  void initState(){

    String sansthan = "In 2005, Naveen set up the O.P. Jindal Gramin Jan Kalyan Sansthan in memory of his father to work for the development of Kurukshetra, Kaithal, Yamuna Nagar and Hisar, all in the state of Haryana.\n" +  "In a bid to green areas both in his constituency and the rest of Haryana while also promoting community sports and cultural interactions, Naveen has spearheaded the development of O.P. Jindal parks in Kurukshetra, Hisar and Yamuna Nagar.";
    String nationalFlag = "Naveen’s political activism began long before he actively took up politics as a career. He is single-handedly responsible for making the Tiranga more accessible to the average citizen. It was his initiative that led to a revision of the Flag Code of India, which now grants every private citizen the right to fly the Indian National Flag publicly with dignity and honour on all days of the year. In an interview to CNBC-TV18, he explained at length the motivation behind the over-10-year-long battle he fought for every Indian’s right to fly the Tiranga \n Not satisfied with a legal victory, Naveen along with his wife Shallu Jindal founded the Flag Foundation of India, an organisation that works towards fostering respect for the Tiranga and the values it embodies among all Indians, particularly the youth.";
    String social = "Naveen is an active campaigner for women’s empowerment, environmental conservation, health, education and youth empowerment. His recently launched initiative, the ‘Citizens’ Alliance for Reproductive Health and Rights’, is an awareness-building exercise through a pressure group consisting of politicians, activists and journalists. The Alliance will, in the long term, work towards building awareness of over-population, maternal and infant mortality and take concrete action on these fronts. \n Besides spending Rs 10.92 crore from the MPLAD (MP Local Area Development) Fund for Kurukshetra, Naveen has dipped into his personal funds plus drawn a total of Rs 47.55 crore from the O.P. Jindal Gramin Jan Kalyan Sansthan for the overall development of the constituency. In 2010, he donated his entire accumulated salary of the previous five years as an MP to the students of primary government schools in Kurukshetra. The consolidated amount was nearly Rs 40 lakh, to which he added a further Rs 10 lakh from his personal income for the cause.";

    foundationList.add(BlogModel(timeStatic: "", titleStatic: "The Sansthan…", locationStatic: sansthan, dateStatic: "", imageStatic: "http://naveenjindal.com/wp-content/uploads/sewing-1.jpg"));
    foundationList.add(BlogModel(timeStatic: "", titleStatic: "National Flag Initiative", locationStatic: nationalFlag, dateStatic: "", imageStatic: "https://d2lptvt2jijg6f.cloudfront.net/flagfoundation/post/1649236673_8.jpg"));
    foundationList.add(BlogModel(timeStatic: "", titleStatic: "Social Activism and Development Initiatives", locationStatic: social, dateStatic: "", imageStatic: "http://naveenjindal.com/wp-content/uploads/medical.jpg"));
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
                    child: const Text(
                      "Foundation",
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
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    primary: false,
                    shrinkWrap: true,
                    itemCount: foundationList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FoundationDetailsScreen(foundationList[index])));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: lightblack,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          margin: const EdgeInsets.only(top: 12,left: 12,right: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            foundationList[index].image,
                                            width: MediaQuery.of(context).size.width,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          )
                                      ),
                                      Positioned(
                                        right: 6,
                                        top: 6,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: (){

                                          },
                                          child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                                color: white.withOpacity(0.6),
                                                shape: BoxShape.circle
                                            ),
                                            padding: EdgeInsets.all(8),
                                            child: Image.asset("assets/images/share.png"),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(width: 6,),
                                  Container(
                                    margin: const EdgeInsets.all(12),
                                    child: Text(toDisplayCase(foundationList[index].title.toString()),
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: roboto, fontSize: 14, color: white,overflow: TextOverflow.clip)),
                                  ),
                                  /*Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(top: 8),
                                            child: Text(foundationList[index].location.toString(),
                                                overflow: TextOverflow.clip,
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(fontWeight: FontWeight.w400, fontFamily: roboto, fontSize: 14, color: white,overflow: TextOverflow.clip)),
                                          ),
                                        ),

                                      ],
                                    ),*/
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
    widget is FoundationScreen;
  }
}