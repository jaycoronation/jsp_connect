import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jspl_connect/model/AboutJSPResponseModel.dart';
import 'package:jspl_connect/utils/app_utils.dart';
import 'package:like_button/like_button.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/AboutModel.dart';
import '../model/AboutNJModel.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import 'AboutDetailsScreen.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreen createState() => _AboutScreen();
}

class _AboutScreen extends BaseState<AboutScreen> {
  bool _isLoading = false;
  bool isLiked = false;
  var listAbout = List<About>.empty(growable: true);
  List<AboutNJModel> listNew = [];

  String bio = "A crusader for the Indian national flag, an advocate of women and child rights, a philanthropist, a parliamentarian, a politician, a successful industrialist, and a sportsman par excellence…that’s Naveen Jindal for you\n\nA man of myriad talents, Naveen stands out for his sense of commitment, responsibility, dedication, honesty, integrity and sheer passion in all his undertakings\n\nBorn in Hisar, Haryana, on 9 March 1970, Naveen is the youngest child of the industrialist-philanthropist-politician Om Prakash Jindal and his wife Savitri. He studied at the Delhi Public School (Mathura Road), New Delhi, before graduating in Commerce from Hans Raj College, Delhi University, in 1990. He subsequently completed an MBA degree from the University of Texas at Dallas, in 1992. His penchant for leadership became evident during his student days. He was the President of the Student Government and recipient of the ‘Student Leader of the Year Award’ at the university\n\nOn his return to India, Naveen began managing his father’s political affairs. In 2004 he stood for elections from Kurukshetra on a Congress party ticket and won, beating his nearest rival Abhay Singh Chautala by 1.6 lakh votes. He repeated the feat in 2009\n\nWhile Naveen is a two-time Member of Parliament from the Kurukshetra Lok Sabha constituency in Haryana, he is also the Chairman and Managing Director of Jindal Steel and Power Limited, which is a part of the 15 billion USD diversified O.P. Jindal Group. Naveen’s hard work and business acumen demands applause, for he has transformed the once moderately performing enterprise to the organisation that today operates as the world’s largest coal-based sponge iron manufacturing plant in Raigarh, Chhattisgarh, in addition to plants in Jharkhand and Odisha\n\nHe is also the Chairman of Jindal Power Limited, a subsidiary of JSP, which runs the 1,000 MW O.P. Jindal Thermal Power Plant in Raigarh, Chhattisgarh – India’s first such 1,000 MW plant in the private sector. Going beyond his own constituency, Naveen has championed the causes of education, healthcare and the upliftment of weaker sections across Haryana, and in the vicinity of his factories in other parts of India. He has set up hospitals and schools, adopted villages and is an active campaigner for women’s empowerment, health and education. In 2011 Naveen added another feather in his cap by establishing the ‘Citizens’ Alliance for Reproductive Health and Rights’, an organisation that brings together politicians, media persons and NGOs in a bid to spread awareness about family planning, maternal and child mortality, and related issues. Naveen is a true social entrepreneur. He is a people person. He can effortlessly relate to thousands of other people, and is driven to help those who are in need. His numerous social initiatives have led to an overall improvement in the quality of life in all regions where he has business interests, and beyond\n\nFor those who may not know, Naveen is the man who is single-handedly responsible for making the Tiranga more accessible to the average citizen. His unrelenting legal and political campaign led to a revision of the Flag Code of India which now grants every private citizen the right to fly the Indian National Flag publicly with dignity and honour on all days of the year. The Flag Foundation of India that he founded along with his wife is an effort to foster respect for the Tiranga and the values it embodies among Indian youth.";
  String bioImage = "";

  @override
  void initState(){
      if (isOnline)
      {
        _aboutApi();
      }
      else
      {
        noInterNet(context);
      }

    String sportsMan = "At the age of 6, Naveen Jindal began his riding lessons when his father gave him a horse as a birthday present. He emerged as a prolific rider and focused his attention on polo. The Jindal Steel & Power polo team became a reality and an integral part of the Indian polo circuit. Being an accomplished player and an irrepressible polo enthusiast, he became the driving force behind the multiple successes of the Jindal team.\n\nHis passion for the sport is evident through his sprawling 30-acre farm, where 40 select ponies and horses are trained under professional eye and kept in peak-condition. And his love for the sport is ever increasing, the challenges motivating him to greater heights. He is the moving spirit behind popularising polo as a sport in the country.\n\nAt the age of 15, Naveen developed another passion, which he not only mastered but has been acknowledged for in numerous occasions. It is shooting as a sport. His first rifle was gifted by his father and soon Naveen became extremely focused in improving his overall performance in skeet shooting. He is a National Record Holder in Skeet Shooting. This sport, which entails quick reflexes and decision making, soon became second nature to him.\n\nUnder careful guidance and training from his coaches, he became a name to be reckoned with in the national and international events in skeet shooting. He also initiated and successfully got the import policy changed for the duty-free import of arms and ammunition for shooting as a sport. Earlier only the top 10 shooters were allowed to import arms and ammunition which, through his untiring efforts was changed to the top 25 shooters. He has received intensive training under the guidance of the world-famous Juan Ghia Yarur of Peru.\n\nNaveen is also the President of Chhattisgarh Pradesh Rifle Association and under his guidance shooting ranges have been constructed at Raigarh to further popularise the sport. Coaching camps at Raigarh are under way for school children and for other members of the shooting club. He has plans to carry basic training needs to everyone interested in the sport including members of police and armed forces personnel.";
    String industrialist = "Naveen Jindal has always believed that growing together with customers, employees, shareholders and communities is the essence of being a good corporate citizen. When he took over the reigns of the Raigarh operations of Jindal Strips Limited (JSL) in 1993, the company was a moderately performing enterprise. It was his vision and farsightedness to pursue innovative approaches and optimise operational efficiencies. All this with a view to providing ‘total solutions’ to all the stakeholders.\n\nSponge iron was the backbone of the Raigarh operations. One of the first decisions he took was to bring global economies of scale in the company’s sponge iron production. Today, we are proud that JSP has the largest coal-based sponge iron manufacturing capacity in the world and produces sponge iron at the lowest possible cost.\n\nNaveen also realised that reduction in costs was the guiding principle for long-term growth and profitability. Hence the commissioning of the new blast furnace not only enhanced the steel-making capacity but also reduced the cost of production. Continuing in the path of forward integration, he took the decision to set up the Rail and Universal Beam mill, which manufactures the world’s longest rails in the country, and also parallel flange beams and columns in large sizes for the first time in India. World-class products from the state-of-the- art manufacturing facility has put JSP among the best in the industry.\n\nRealising the need to reduce inventory costs and market finished products at competitive prices, he took the strategic decision to acquire coal and iron ore mines, thereby making them self-sufficient in key raw materials, essential for the manufacture of steel.\n\nThe economies of scale are increasingly making JSP the preferred choice of the customers. The company continues to seek new horizons that complement the market strengths, offer growth potential and leverage its existing assets for future growth and expansion.\n\nJSP has been recently rated the Second Highest Value Creator in the world by the Boston Consulting Group of USA. Naveen has also featured among the top ten of ‘India Inc’s Most Powerful CEOs 2011’ in a survey conducted by the Indian Market Research Bureau (IMRB) for The Economic Times-Corporate Dossier. He has also featured in the ‘Most Influential People’s List’ for the state of Haryana, by India Today and has been conferred with the ‘Ernst and Young Entrepreneur of the Year Award 2010’ in the field of Energy and Infrastructure.";
    String youthIcon = "21st century puts forth a changing face of India. There is a fresh air of optimism and youthful energy. There is something more than just a single-minded quest for success. There is a young man’s dream for growth and development, not just for the self, but for the entire nation. To help those in need, and to help them grow and develop along with him. He is dashing and dynamic, he is determined and devoted to the cause of the people, for he is one of them. He is Naveen Jindal, the youngest son of steel visionary Shri O.P. Jindal.\n\nAfter completing his MBA from the University of Texas at Dallas, USA, Naveen took over the management of the Raigarh & Raipur divisions of Jindal Steel and Power Limited (JSP). In a short span of time, with his numerous initiatives he transformed JSP from a moderately performing company in the steel sector into a star performer.\n\nHe is not afraid to take challenges head-on. At that time it was difficult to successfully implement a coal-based sponge iron technology using high ash Indian thermal coal in the Raigarh unit. The plant was set up in a backward area of Chhattisgarh, which made operating the plant all the more challenging. The unit, under the leadership of Naveen, not only successfully adapted the coal based sponge iron technology but ventured into new areas by setting up captive power plants, which used waste products of the sponge iron making process to generate power. The addition of captive iron ore and coal mines has enhanced the operational efficiencies of the plant, making JSP a trailblazer in the steel sector. This business model of complete backward and forward integration has now become a benchmark in the steel industry.\n\nJSP is today one of the most efficiently run steel companies in the world in terms of scale of operations. Naveen attributes this success to the invaluable guidance and inspiration that he draws from his father, and the hard work put in by the dedicated team of professionals and workers.\n\nIf he has used his head and heart in his professional life, it is his soul with which he serves the nation. Naveen’s passion for social welfare led him to a career in politics. As he himself states: “I do not want to wait for a time when age and physical frailty hamper my abilities. So I’ve begun during the best years of my life. And one day along with the rest of today’s youth, I hope to look back and say with satisfaction that I did not just dream of a great India, but that I worked hard to build the India of my dreams!”";
    String mp = "Naveen Jindal has been an active Member of Parliament ever since he first entered the Lok Sabha in 2004. A regular attendee at all sessions, his powerful speeches and interventions in the House have raised issues that are of significance at the national and local level. Over the years he has been a voice of the people of Haryana – and in particular Kurukshetra – in the Lower House, raising questions about development activities in his constituency including the Kaithal railway bridge, Shahbad-Thol railway over-bridge, a railway over-bridge at Yamuna Nagar, a four-lane-highway from Yamuna Nagar to Pehowa and trauma centres at Yamuna Nagar and Kurukshetra. Naveen has carried his passion for the National Flag into the Parliament complex. Following his repeated efforts, on February 18, 2010, the Rules Committee of the Lok Sabha accepted his proposal to allow MPs display the Tricolour as a lapel pin while seated in the House. The Rules of Procedure and Conduct of Business in the Lok Sabha, did not permit the MPs to wear badges of any kind while seated in the House. An exception has now been made for the ‘Tiranga’. His sustained 3-year effort led to the Central Government making Indian currency acceptable at Duty Free Shops at all international airports in the country. This was a no mean achievement. On August 21, 2002, Naveen wrote a letter to the then NDA government’s Minister of Tourism and Culture articulating his concerns about the non-acceptance of Indian currency within India at the Duty Free Shops run by the Indian Tourism Development Corporation (ITDC), even though FEMA rules permit an Indian resident to carry up to Rs 5,000 while travelling abroad. Over a period of three years (during which time the Congress party came back to power with the UPA), Naveen had to pursue the matter with the Ministry, ITDC and the Reserve Bank of India. Considering the issues of national pride at stake, he finally took up the matter with then Finance Minister P. Chidambaram. In early 2005, the Centre at last decided to make Indian currency acceptable at Duty Free Shops at international airports in India. For more information on Parliamentary Committee";
    String mission = "Why politics? I could have taken the path expected of me, solely devoted myself to expanding the empire I inherited from my father, basked in the glory of my own achievements in industry and sports, and spent a lifetime blaming the system for hampering India’s growth. I could have… but I did not. Because I realised that there was no point in joining the chorus of complaints from the citizenry about the systemic problems we encounter, unless I was willing to do something about it. And there was no point in feeling pain at the poverty and inequality I saw around me, if I did nothing beyond shrugging these off as inevitabilities inherent in the Indian reality.\n\nGandhi said: Be the change you want to see in the world. In the heat and dust of politics, I have found a means to do just that. India is blessed with a wealth of human talent and natural resources. But too many children out there are working when they should be studying, too few adults know how to even write their names, too many women are denied the right to choose when to marry and when to have babies, and too many men refuse to take responsibility for birth control. These are facts that should make us hang our heads in shame as the world looks towards us as a potential superpower.\n\n\Politics is my way of making a difference… in my constituency – Kurukshetra, in my home state – Haryana, and right across this great nation that I love.\n\nI do not want to wait for a time when age and physical frailty hamper my abilities. So I’ve begun during the best years of my life. And one day along with the rest of today’s youth, I hope to look back and say with satisfaction that I did not just dream of a great India, but that I worked hard to build the India of my dreams! Jai Hind!";
    String inspiration = "Born on August 7, 1930 in Nalwa village, in Haryana’s Hisar district, O.P. Jindal began his career with a small bucket-manufacturing unit in Hisar. In 1964, he commissioned a pipe unit under the name Jindal India Limited, followed by a large factory in 1969 called Jindal Strips Limited, which are now part of the 15 billion USD diversified O.P. Jindal Group.\n\nEducation and healthcare were of prime concern to O.P. Jindal. He founded the N.C. Jindal Institute of Medical Care in Hisar and the girls’ residential school Vidya Devi Jindal School also in Hisar. He had donated large sums of money to the needy individuals, and deserving social and religious institutions.\n\nHis passion for people’s welfare ultimately led him to a career in politics. He was a three-time MLA from Haryana (1991, 2000 and 2005), and also the first Indian industrialist to become a Lok Sabha MP. He was also the state’s serving Power Minister at the time of his death. O.P. Jindal passed away on March 31, 2005, at the age of 75, leaving in his wake a mantra of economic progress with a social purpose.\n\nHe bequeathed to his son Naveen a belief in self-reliance in business, as also a conviction that the betterment of business sans the betterment of the people is pointless and unsustainable.\n\nToday, the journey of his life stands as a shining example for us. It has the power to inspire us in ways more than one.";

    listNew.add(AboutNJModel(descriptionStatic: inspiration,imageStatic: "https://bsmedia.business-standard.com/_media/bs/img/about-page/thumb/464_464/1571381194.jpg",titleStatic: "Inspiration"));
    listNew.add(AboutNJModel(imageStatic: "https://res.cloudinary.com/dliifke2y/image/upload/v1670664467/Naveen%20Jindal/WhatsApp_Image_2022-12-10_at_2.49.23_PM_jsmupv.jpg",titleStatic: "Mission",descriptionStatic: mission));
    listNew.add(AboutNJModel(imageStatic: "https://qph.cf2.quoracdn.net/main-qimg-c0e83fb6f7f13379588f1b09014e820e-lq",titleStatic: "Member of Parliament",descriptionStatic: mp));
    listNew.add(AboutNJModel(imageStatic: "https://res.cloudinary.com/dliifke2y/image/upload/v1669291684/Naveen%20Jindal/_SAM9144_kqf6wa.jpg",titleStatic: "Youth Icon",descriptionStatic: youthIcon));
    listNew.add(AboutNJModel(imageStatic: "https://www.leaderbiography.com/wp-content/uploads/2022/03/Naveen-Jindal-Chairman-of-Jindal-Steel-and-Power-Limited.webp",titleStatic: "Industrialist",descriptionStatic: industrialist));
    listNew.add(AboutNJModel(imageStatic: "https://res.cloudinary.com/dliifke2y/image/upload/v1669291963/Naveen%20Jindal/0X4A0431-min_ospsox.jpg",titleStatic: "Sportsman",descriptionStatic: sportsMan));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/images/ic_about_jspl_1-min_lsvqzo.jpeg"), context);
    return WillPopScope(
          child: Scaffold(
            backgroundColor: blackConst,
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              toolbarHeight: 60,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 8),
                    child: Image.asset('assets/images/ic_back_button.png', height: 22, width: 22,color: white),
                  )),
              title: Text(
                "Shri Naveen Jindal",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.w600, fontFamily: gilroy),
              ),
              titleSpacing: 0,
              systemOverlayStyle: const SystemUiOverlayStyle(
                // Status bar color
                statusBarColor: Colors.transparent,
                // Status bar brightness (optional)
                statusBarIconBrightness: Brightness.light,
                // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
            ),
            body: _isLoading
                ? const LoadingWidget()
                 : SingleChildScrollView(
                   child: Stack(
                     children: [
                       Image.asset("assets/images/ic_about_jspl_1-min_lsvqzo.jpeg",
                         fit: BoxFit.cover,
                         height: MediaQuery.of(context).size.height,
                         width: MediaQuery.of(context).size.width,
                       ),
                      /* FadeInImage.assetNetwork(
                         image: bioImage.toString(),
                         fit: BoxFit.cover,
                         height: MediaQuery.of(context).size.height,
                         width: MediaQuery.of(context).size.width, placeholder: 'assets/images/bg_gray.jpeg',
                       ),*/
                       Container(
                         height: MediaQuery.of(context).size.height,
                         decoration: BoxDecoration(
                           color: Colors.white,
                           gradient: LinearGradient(
                               begin: FractionalOffset.topCenter,
                               end: FractionalOffset.bottomCenter,
                               colors: [
                                 blackConst.withOpacity(0.2),
                                 blackConst.withOpacity(1),
                               ],
                               stops: const [
                                 0.7,
                                 1.0
                               ]
                           ),
                         ),
                       ),
                       Column(
                         children: [
                           SizedBox(
                             height: MediaQuery.of(context).size.height / 2.1,
                             width: MediaQuery.of(context).size.width,
                           ),
                           Container(
                             margin: const EdgeInsets.only(right: 22,left: 22),
                             decoration: BoxDecoration(
                               color: grayNew,
                               borderRadius: BorderRadius.circular(30),
                             ),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.all(20),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     children: [
                                        Text(
                                        "Biography",
                                         style: TextStyle(fontFamily: gilroy, fontSize: 16, color: black, fontWeight: FontWeight.w600),
                                       ),
                                       const Spacer(),
                                       LikeButton(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                         size: 22,
                                         isLiked: isLiked,
                                         circleColor: const CircleColor(
                                             start: orange, end: orangeNew),
                                         bubblesColor: const BubblesColor(
                                           dotPrimaryColor: orange,
                                           dotSecondaryColor: orangeNew,
                                         ),
                                         likeBuilder: (bool isLiked) {
                                           return Image.asset(
                                             isLiked
                                                 ? "assets/images/like_filled.png"
                                                 : "assets/images/like.png",
                                             color: isLiked ? orangeNew : black,
                                           );
                                         },
                                         onTap: (isLike) async {
                                           setState(() {
                                             isLiked = !isLiked;
                                           });
                                           return true;
                                         },
                                       ),
                                       Container(width: 12,),
                                       Image.asset(
                                         "assets/images/share.png",
                                         height: 22,
                                         width: 22,
                                         color: black,
                                       ),
                                     ],
                                   ),
                                 ),
                                 Container(
                                   margin: const EdgeInsets.only(left: 14, right: 14,top: 14,bottom: 18),
                                   child: Text(
                                     "A man of myriad talents, Naveen stands out for his  senes of commitment, responsibility, dedicatation, honesty, integirty and sheer passion in all his undertaking.",
                                     style: TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 20, fontFamily: roboto),
                                   ),
                                 ),
                                 Container(
                                   margin: const EdgeInsets.only(left: 14, right: 14,top: 14,bottom: 18),
                                   child: Text(
                                     listAbout[0].aboutData![0].topTxt.toString(),
                                     maxLines: 2,
                                     overflow: TextOverflow.ellipsis,
                                     style: TextStyle(overflow: TextOverflow.ellipsis,fontWeight: FontWeight.w400, color: black, fontSize: 14, fontFamily: roboto),
                                   ),
                                 ),
                                 GestureDetector(
                                   onTap: (){
                                     showModalBottomSheet<void>(
                                       context: context,
                                       isScrollControlled: true,
                                       shape: const RoundedRectangleBorder(
                                           borderRadius: BorderRadius.only(
                                               topLeft: Radius.circular(20),
                                               topRight: Radius.circular(20)
                                           )
                                       ),
                                       elevation: 5,
                                       isDismissible: true,
                                       builder: (BuildContext context) {
                                         return Container(
                                           height: MediaQuery.of(context).size.height * 0.88,
                                           color: grayNew,
                                           padding: const EdgeInsets.all(12),
                                           child: SingleChildScrollView(
                                             child: Column(
                                               mainAxisAlignment: MainAxisAlignment.start,
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: <Widget>[
                                                 Row(
                                                   mainAxisAlignment: MainAxisAlignment.center,
                                                   crossAxisAlignment: CrossAxisAlignment.center,
                                                   children: const [
                                                     Padding(
                                                       padding: EdgeInsets.only(bottom:12 ,top: 12),
                                                       child: SizedBox(
                                                         width: 50,
                                                         child: Divider(
                                                           color: Colors.grey,
                                                           height: 1.5,
                                                           thickness: 1.5,
                                                         ),
                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                                 Text('Biography',style: TextStyle(color: black,fontWeight: FontWeight.w600,fontSize: 20,fontFamily: roboto)),
                                                 Container(height: 8,),
                                                 Text(bio,style: TextStyle(color: black,fontWeight: FontWeight.w400,fontSize: 18,fontFamily: roboto)),
                                               ],
                                             ),
                                           ),
                                         );
                                       },
                                     );
                                   },
                                   child: Container(
                                     margin: const EdgeInsets.only(bottom: 12,left: 12),
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(18),
                                       color: bgMain.withOpacity(0.8),
                                     ),
                                     padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                                     child:  Text("Read More",style: TextStyle(color: whiteConst,fontWeight: FontWeight.w400,fontSize: 14,fontFamily: roboto)),
                                   ),
                                 )
                               ],
                             ),
                           ),
                           Container(
                             margin: const EdgeInsets.fromLTRB(12, 22, 12, 22),
                             height: 250,
                             width: MediaQuery.of(context).size.width,
                             child: ListView.builder(
                               scrollDirection: Axis.horizontal,
                               physics: const BouncingScrollPhysics(),
                               primary: false,
                               shrinkWrap: true,
                               itemCount: listNew.length,
                               itemBuilder: (BuildContext context, int index) {
                                 return GestureDetector(
                                   onTap: (){
                                     Navigator.push(context, MaterialPageRoute(builder: (context) => AboutDetailsScreen(listNew[index])));
                                   },
                                   child: Container(
                                     width: 100,
                                     height: 220,
                                     margin: const EdgeInsets.only(left: 12),
                                     child: Column(
                                       children: [
                                         SizedBox(
                                           height: 160,
                                           child: ClipRRect(
                                             borderRadius: const BorderRadius.all(Radius.circular(44)),
                                             child: Image.network(listNew[index].image,fit: BoxFit.cover),
                                           ),
                                         ),
                                         Container(
                                           alignment: Alignment.center,
                                           margin: const EdgeInsets.only(top: 12),
                                           decoration: BoxDecoration(
                                             borderRadius: BorderRadius.circular(18),
                                             color: grayNew,
                                           ),
                                           padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                                           child: Text(listNew[index].title,
                                               textAlign: TextAlign.center,
                                               style: TextStyle(color: black,fontWeight: FontWeight.w600,fontSize: 14,fontFamily: roboto)),
                                         )
                                       ],
                                     ),
                                   ),
                                 );
                               },
                             ),
                           ),
                         ],
                       ),
                     ],
                   ),
                 ),
          ),
          onWillPop: () {
            Navigator.pop(context);
            return Future.value(true);
          }
        );
  }

  _aboutApi() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(MAIN_URL + aboutApi);

    final response = await http.get(url);
    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = AboutModel.fromJson(user);

    if (statusCode == 200) {
      if (dataResponse.about!.isNotEmpty) {
        listAbout = dataResponse.about!;
      }
    }

    aboutJSPAPI();
  }

  aboutJSPAPI() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(MAIN_URL + aboutJSPApi);

    final response = await http.get(url);
    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = AboutJspResponseModel.fromJson(user);

    if (statusCode == 200) {
      bio = dataResponse.bio.toString();
      bioImage = dataResponse.bioImage.toString();
      precacheImage(NetworkImage(bioImage.toString()), context);
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void castStatefulWidget() {
    widget as AboutScreen;
  }

}
