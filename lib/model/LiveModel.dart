/// live : [{"location":"New Dehil","news_title":"'We the people' - debate on new age voting rights NDTV","image":"https://img.youtube.com/vi/ASoXyjpWmgQ/mqdefault.jpg","video_url":"https://www.youtube.com/watch?v=ASoXyjpWmgQ","date":"10.24.2011"},{"location":"kurukshetra","news_title":"'Versus' - debate on Gen next, New vision on Times Now","image":"http://img.youtube.com/vi/bZUaOMinoTM/mqdefault.jpg","video_url":"https://www.youtube.com/watch?v=bZUaOMinoTM","date":"12.09.2011"},{"location":"kurukshetra","news_title":"'We the people' - debate on 'young politicians, old ideas' on NDTV","image":"http://img.youtube.com/vi/wL43GK_u-rA/mqdefault.jpg","video_url":"https://www.youtube.com/watch?v=wL43GK_u-rA","date":"24.05.2010"},{"location":"kurukshetra","news_title":" Naveen Jindal on Lokpal Bill on News 24","image":"http://img.youtube.com/vi/mt8OSaPQ0Ec/mqdefault.jpg","video_url":"https://www.youtube.com/watch?v=mt8OSaPQ0Ec","date":"06.09.2011"}]

class LiveModel {
  LiveModel({
      List<Live>? live,}){
    _live = live;
}

  LiveModel.fromJson(dynamic json) {
    if (json['live'] != null) {
      _live = [];
      json['live'].forEach((v) {
        _live?.add(Live.fromJson(v));
      });
    }
  }
  List<Live>? _live;
LiveModel copyWith({  List<Live>? live,
}) => LiveModel(  live: live ?? _live,
);
  List<Live>? get live => _live;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_live != null) {
      map['live'] = _live?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// location : "New Dehil"
/// news_title : "'We the people' - debate on new age voting rights NDTV"
/// image : "https://img.youtube.com/vi/ASoXyjpWmgQ/mqdefault.jpg"
/// video_url : "https://www.youtube.com/watch?v=ASoXyjpWmgQ"
/// date : "10.24.2011"

class Live {
  Live({
      String? location, 
      String? newsTitle, 
      String? image, 
      String? videoUrl, 
      String? date,}){
    _location = location;
    _newsTitle = newsTitle;
    _image = image;
    _videoUrl = videoUrl;
    _date = date;
}

  Live.fromJson(dynamic json) {
    _location = json['location'];
    _newsTitle = json['news_title'];
    _image = json['image'];
    _videoUrl = json['video_url'];
    _date = json['date'];
  }
  String? _location;
  String? _newsTitle;
  String? _image;
  String? _videoUrl;
  String? _date;
Live copyWith({  String? location,
  String? newsTitle,
  String? image,
  String? videoUrl,
  String? date,
}) => Live(  location: location ?? _location,
  newsTitle: newsTitle ?? _newsTitle,
  image: image ?? _image,
  videoUrl: videoUrl ?? _videoUrl,
  date: date ?? _date,
);
  String? get location => _location;
  String? get newsTitle => _newsTitle;
  String? get image => _image;
  String? get videoUrl => _videoUrl;
  String? get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['location'] = _location;
    map['news_title'] = _newsTitle;
    map['image'] = _image;
    map['video_url'] = _videoUrl;
    map['date'] = _date;
    return map;
  }

}