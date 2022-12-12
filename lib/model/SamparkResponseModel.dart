/// connect : [{"img":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1666939855_sampark-hindi.jpg","url":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1666939878_Sampark%20Magazine%20October%202022.pdf"},{"img":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1666342807_connect.jpg","url":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1666344650_Connect%20Magazine%20October%202022%20%281%29.pdf"},{"img":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/page/1661345767_sampark%20cover.jpg","url":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/page/1661345886_%E0%A4%B8%E0%A4%AE%E0%A5%8D%E0%A4%AA%E0%A4%B0%E0%A5%8D%E0%A4%95%20%E0%A4%85%E0%A4%97%E0%A4%B8%E0%A5%8D%E0%A4%A4%202022.pdf"},{"img":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1626691241_samparkjuly21.gif","url":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1626691252_Sampark%20JULY%202021%20.pdf"},{"img":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1626160595_connect_july_21.jpg","url":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1626160619_Connect%20Magazine%20July%202021.pdf"},{"img":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1623667561_connect_june_21.jpg","url":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1623667597_Connect%20Magazine%20June%202021.pdf"},{"img":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1622633531_sampar-may21.jpg","url":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1622633871_Sampark-Magazine-May-2021.pdf"},{"img":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1622633531_sampar-april21.jpg","url":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1622635509_Sampark-April-2021.pdf"},{"img":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1622633530_connect_ebookapril21.jpg","url":"https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1622635122_Connect-Magazine-April-2021.pdf"}]

class SamparkResponseModel {
  SamparkResponseModel({
      List<Connect>? connect,
      List<Connect>? sampark,
  }){
    _connect = connect;
    _sampark = sampark;
}

  SamparkResponseModel.fromJson(dynamic json) {
    if (json['connect'] != null) {
      _connect = [];
      json['connect'].forEach((v) {
        _connect?.add(Connect.fromJson(v));
      });
    }
    if (json['sampark'] != null) {
      _sampark = [];
      json['sampark'].forEach((v) {
        _sampark?.add(Connect.fromJson(v));
      });
    }
  }
  List<Connect>? _connect;
  List<Connect>? _sampark;
SamparkResponseModel copyWith({
  List<Connect>? connect,
  List<Connect>? sampark,
}) => SamparkResponseModel(
  connect: connect ?? _connect,
  sampark: sampark ?? _sampark,
);
  List<Connect>? get connect => _connect;
  List<Connect>? get sampark => _sampark;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_sampark != null) {
      map['sampark'] = _sampark?.map((v) => v.toJson()).toList();
    }
    if (_connect != null) {
      map['connect'] = _connect?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// img : "https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1666939855_sampark-hindi.jpg"
/// url : "https://d2lptvt2jijg6f.cloudfront.net/jindalconnect/custom/1666939878_Sampark%20Magazine%20October%202022.pdf"

class Connect {
  Connect({
      String? img, 
      String? url,}){
    _img = img;
    _url = url;
}

  Connect.fromJson(dynamic json) {
    _img = json['img'];
    _url = json['url'];
  }
  String? _img;
  String? _url;
Connect copyWith({  String? img,
  String? url,
}) => Connect(  img: img ?? _img,
  url: url ?? _url,
);
  String? get img => _img;
  String? get url => _url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['img'] = _img;
    map['url'] = _url;
    return map;
  }

}