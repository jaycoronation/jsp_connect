/// social_media : [{"description":"On this International #ChildrensDay let us believe and practice “Inclusion, for every child”, where every child belonging to any society, community or nationality is entitled to equal rights. Let's bridge the gap between kids and build a global society for them.","social":"facebook","date":"11 November, 2022","url":"https://www.facebook.com/JSPLCorporate/posts/pfbid02adSCg6xvkiyKfo45DKVd8keuHaTnMZWoLjGy5z9GndgRph2pGpWnSc9Zu7Wwb6g4l?__cft__[0]=AZV9Vc5xp4TjDhperroK5z82687JNRaIKm_Hdvlbt01_ZaZ4IYIVTx2haoVSy8Tfz1nfP1YVOOhmEelO1iXkv_gkpfbWlIy0Ob_H9DeNTrtPSuyf5rmvEN487tn0gOzC6mKVIWooWfmy8XKs54Pj8tmzig74TVJ_tiWW1z6YcvUyjFHLbDL-C8mGL-ysJi07UndZ23DoDWWDa5TrsxZFYVfx&__tn__=%2CO%2CP-R","image":"https://www.facebook.com/JSPLCorporate/photos/a.1394065230811079/3276771589207091/"},{"description":"OMay Shri Guru Nanak jis teachings stay with you always and may this Gurpurab bring lots of joy and happiness in your life! Happy Gurpurab!","social":"facebook","date":"11 November, 2022","url":"https://www.facebook.com/JSPLCorporate/photos/a.1394065230811079/3274743909409859/","image":"https://scontent-bom1-2.xx.fbcdn.net/v/t39.30808-6/313422535_3274743902743193_2021274691567878931_n.jpg?stp=dst-jpg_p526x296&_nc_cat=108&ccb=1-7&_nc_sid=730e14&_nc_ohc=ZrZtCQIDXRMAX_2xp5Q&_nc_ht=scontent-bom1-2.xx&oh=00_AfBiTCTbEHDdtUBsHZs6oGxbhuAXBIDlo7Ap_p72zIKt9A&oe=638010A7"},{"description":"Steel's rise to prominence as an engineering & building staple worldwide is revolutionary. In this Steelmaking 101 series, we will cover all the aspects of steelmaking to celebrate its rich evolution. ","social":"twitter","date":"18 October, 2022","url":"https://twitter.com/i/status/1582265267739979777","image":""},{"description":"Indian Steel Association is grateful to the Hon'ble Prime Minister of India for withdrawing the Export Duty on Iron & Steel Products. It will go a long way in correcting the balance of trade.","social":"twitter","date":"19 November, 2022","url":"https://twitter.com/steel_indian/status/1593844676263833600?cxt=HHwWgMDTvbvSvJ4sAAAA","image":"https://pbs.twimg.com/media/Fh55SV1X0AYLc3c?format=jpg&name=small"},{"description":"As we learned in the last video, steel is a ground-breaking material that permeates all around us.","social":"Instagram","date":"15 November","url":"https://www.instagram.com/p/CkxRFbPoJ61/?hl=en","image":"https://pbs.twimg.com/media/Fh55SV1X0AYLc3c?format=jpg&name=medium"}]

class SocialResponseModel {
  SocialResponseModel({
      List<SocialMedia>? socialMedia,}){
    _socialMedia = socialMedia;
}

  SocialResponseModel.fromJson(dynamic json) {
    if (json['social_media'] != null) {
      _socialMedia = [];
      json['social_media'].forEach((v) {
        _socialMedia?.add(SocialMedia.fromJson(v));
      });
    }
  }
  List<SocialMedia>? _socialMedia;
SocialResponseModel copyWith({  List<SocialMedia>? socialMedia,
}) => SocialResponseModel(  socialMedia: socialMedia ?? _socialMedia,
);
  List<SocialMedia>? get socialMedia => _socialMedia;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_socialMedia != null) {
      map['social_media'] = _socialMedia?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// description : "On this International #ChildrensDay let us believe and practice “Inclusion, for every child”, where every child belonging to any society, community or nationality is entitled to equal rights. Let's bridge the gap between kids and build a global society for them."
/// social : "facebook"
/// date : "11 November, 2022"
/// url : "https://www.facebook.com/JSPLCorporate/posts/pfbid02adSCg6xvkiyKfo45DKVd8keuHaTnMZWoLjGy5z9GndgRph2pGpWnSc9Zu7Wwb6g4l?__cft__[0]=AZV9Vc5xp4TjDhperroK5z82687JNRaIKm_Hdvlbt01_ZaZ4IYIVTx2haoVSy8Tfz1nfP1YVOOhmEelO1iXkv_gkpfbWlIy0Ob_H9DeNTrtPSuyf5rmvEN487tn0gOzC6mKVIWooWfmy8XKs54Pj8tmzig74TVJ_tiWW1z6YcvUyjFHLbDL-C8mGL-ysJi07UndZ23DoDWWDa5TrsxZFYVfx&__tn__=%2CO%2CP-R"
/// image : "https://www.facebook.com/JSPLCorporate/photos/a.1394065230811079/3276771589207091/"

class SocialMedia {
  SocialMedia({
      String? description, 
      String? social, 
      String? date, 
      String? url, 
      bool isLiked = false,
      String? image,}){
    _description = description;
    _social = social;
    _date = date;
    _url = url;
    _image = image;
    _isLiked = isLiked;
}

  SocialMedia.fromJson(dynamic json) {
    _description = json['description'];
    _social = json['social'];
    _date = json['date'];
    _url = json['url'];
    _image = json['image'];
  }
  String? _description;
  String? _social;
  String? _date;
  String? _url;
  String? _image;
  bool _isLiked = false;
SocialMedia copyWith({  String? description,
  String? social,
  String? date,
  String? url,
  String? image,
  bool isLiked = false,
}) => SocialMedia(  description: description ?? _description,
  social: social ?? _social,
  date: date ?? _date,
  url: url ?? _url,
  image: image ?? _image,
  isLiked: isLiked,
);
  String? get description => _description;
  String? get social => _social;
  String? get date => _date;
  String? get url => _url;
  bool get isLiked => _isLiked;

  set isLiked(bool value) {
    _isLiked = value;
  }

  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = _description;
    map['social'] = _social;
    map['date'] = _date;
    map['url'] = _url;
    map['image'] = _image;
    return map;
  }

}