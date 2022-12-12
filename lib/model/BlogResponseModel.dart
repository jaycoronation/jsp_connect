/// news : [{"location":"New Delhi","news_title":"JSPL recorded superb growth..","date":"05.05.2020","pdf":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/page/1599739569_Export%20Sales%20PR%20.pdf"},{"location":"New Delhi","news_title":"Flying high against all Odds...","date":"15.04.2020","pdf":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/page/1599739650_France%20Rail%20Press%20Release.pdf"},{"location":"Mumbai | Kolkata","news_title":"Manufacturing companies...","date":"15.04.2020","pdf":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/page/1599739714_Manufacturing%20companies.pdf"},{"location":"New Delhi","news_title":"Will be very conservative in...","date":"15.04.2020","pdf":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/page/1599739814_Will%20be%20very%20conservative.pdf"},{"location":"Kolkata","news_title":"JSPL gets over 2,000 tonne...","date":"12.04.2020","pdf":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/page/1599739893_JSPL%20gets%20over%202%2C000%20tonne%20rails.pdf"},{"location":"New Delhi","news_title":"JSPL shines with promising...","date":"03.04.2020","pdf":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/page/1599739948_FY20-%20Production%20%26%20Sales%20PR.pdf"},{"location":"New Delhi","news_title":"JSPL started transportation...","date":"02.05.2020","pdf":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/page/1599740001_IRON%20ORE%20-PR%201.pdf"}]

class BlogResponseModel {
  BlogResponseModel({
      List<News>? news,}){
    _news = news;
}

  BlogResponseModel.fromJson(dynamic json) {
    if (json['news'] != null) {
      _news = [];
      json['news'].forEach((v) {
        _news?.add(News.fromJson(v));
      });
    }
  }
  List<News>? _news;
BlogResponseModel copyWith({  List<News>? news,
}) => BlogResponseModel(  news: news ?? _news,
);
  List<News>? get news => _news;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_news != null) {
      map['news'] = _news?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// location : "New Delhi"
/// news_title : "JSPL recorded superb growth.."
/// date : "05.05.2020"
/// pdf : "https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/page/1599739569_Export%20Sales%20PR%20.pdf"

class News {
  News({
      String? location, 
      String? newsTitle, 
      String? date, 
      String? image,
      String? data,
      String? pdf,}){
    _location = location;
    _newsTitle = newsTitle;
    _date = date;
    _pdf = pdf;
    _image = image;
    _data = data;
}

  News.fromJson(dynamic json) {
    _location = json['location'];
    _newsTitle = json['news_title'];
    _date = json['date'];
    _pdf = json['pdf'];
    _image = json['image'];
    _data = json['data'];
  }
  String? _location;
  String? _newsTitle;
  String? _date;
  String? _image;
  String? _pdf;
  String? _data;
News copyWith({  String? location,
  String? newsTitle,
  String? date,
  String? image,
  String? pdf,
  String? data,
}) => News(  location: location ?? _location,
  newsTitle: newsTitle ?? _newsTitle,
  date: date ?? _date,
  image: image ?? _image,
  pdf: pdf ?? _pdf,
  data: data ?? _data,
);
  String? get location => _location;
  String? get newsTitle => _newsTitle;
  String? get data => _data;
  String? get date => _date;
  String? get image => _image;
  String? get pdf => _pdf;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['location'] = _location;
    map['news_title'] = _newsTitle;
    map['data'] = _data;
    map['date'] = _date;
    map['image'] = _image;
    map['pdf'] = _pdf;
    return map;
  }

}