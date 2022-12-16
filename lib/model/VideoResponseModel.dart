class VideoResponseModel {
  VideoResponseModel({
      List<Videos>? videos,}){
    _videos = videos;
}

  VideoResponseModel.fromJson(dynamic json) {
    if (json['videos'] != null) {
      _videos = [];
      json['videos'].forEach((v) {
        _videos?.add(Videos.fromJson(v));
      });
    }
  }
  List<Videos>? _videos;
VideoResponseModel copyWith({  List<Videos>? videos,
}) => VideoResponseModel(  videos: videos ?? _videos,
);
  List<Videos>? get videos => _videos;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_videos != null) {
      map['videos'] = _videos?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Videos {
  Videos({
      String? image, 
      String? videoUrl, 
      String? time, 
      String? date, 
      String? title, 
      bool isLike = false,
      String? data,}){
    _image = image;
    _videoUrl = videoUrl;
    _time = time;
    _date = date;
    _title = title;
    _data = data;
    _isLike = isLike;
}

  Videos.fromJson(dynamic json) {
    _image = json['image'];
    _videoUrl = json['video_url'];
    _time = json['time'];
    _date = json['date'];
    _title = json['title'];
    _data = json['data'];
  }
  String? _image;
  String? _videoUrl;
  String? _time;
  String? _date;
  String? _title;
  String? _data;
  bool _isLike = false;
Videos copyWith({  String? image,
  String? videoUrl,
  String? time,
  String? date,
  String? title,
  String? data,
  bool isLike = false,
}) => Videos(  image: image ?? _image,
  videoUrl: videoUrl ?? _videoUrl,
  time: time ?? _time,
  date: date ?? _date,
  title: title ?? _title,
  data: data ?? _data,
  isLike: isLike,
);
  String? get image => _image;
  String? get videoUrl => _videoUrl;
  String? get time => _time;
  String? get date => _date;
  String? get title => _title;
  String? get data => _data;
  bool get isLike => _isLike;

  set isLike(bool value) {
    _isLike = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = _image;
    map['video_url'] = _videoUrl;
    map['time'] = _time;
    map['date'] = _date;
    map['title'] = _title;
    map['data'] = _data;
    return map;
  }

}