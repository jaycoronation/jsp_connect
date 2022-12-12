/// album : [{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598079310_naveen_jindal.jpg","title":"Awards Recognition"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080283_NJ1.jpg","title":" Internal Photo"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080542_jspl-ctb-16.jpg","title":"Plant Photo"}]

class AlbumResponseModel {
  AlbumResponseModel({
      List<Album>? album,}){
    _album = album;
}

  AlbumResponseModel.fromJson(dynamic json) {
    if (json['album'] != null) {
      _album = [];
      json['album'].forEach((v) {
        _album?.add(Album.fromJson(v));
      });
    }
  }
  List<Album>? _album;
AlbumResponseModel copyWith({  List<Album>? album,
}) => AlbumResponseModel(  album: album ?? _album,
);
  List<Album>? get album => _album;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_album != null) {
      map['album'] = _album?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// image : "https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598079310_naveen_jindal.jpg"
/// title : "Awards Recognition"

class Album {
  Album({
      String? image, 
      String? title,}){
    _image = image;
    _title = title;
}

  Album.fromJson(dynamic json) {
    _image = json['image'];
    _title = json['title'];
  }
  String? _image;
  String? _title;
Album copyWith({  String? image,
  String? title,
}) => Album(  image: image ?? _image,
  title: title ?? _title,
);
  String? get image => _image;
  String? get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = _image;
    map['title'] = _title;
    return map;
  }

}