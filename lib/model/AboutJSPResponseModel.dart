class AboutJspResponseModel {
  AboutJspResponseModel({
      String? bio, 
      String? bioImage, 
      String? nj, 
      String? njImage,}){
    _bio = bio;
    _bioImage = bioImage;
    _nj = nj;
    _njImage = njImage;
}

  AboutJspResponseModel.fromJson(dynamic json) {
    _bio = json['bio'];
    _bioImage = json['bio_image'];
    _nj = json['nj'];
    _njImage = json['nj_image'];
  }
  String? _bio;
  String? _bioImage;
  String? _nj;
  String? _njImage;
AboutJspResponseModel copyWith({  String? bio,
  String? bioImage,
  String? nj,
  String? njImage,
}) => AboutJspResponseModel(  bio: bio ?? _bio,
  bioImage: bioImage ?? _bioImage,
  nj: nj ?? _nj,
  njImage: njImage ?? _njImage,
);
  String? get bio => _bio;
  String? get bioImage => _bioImage;
  String? get nj => _nj;
  String? get njImage => _njImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bio'] = _bio;
    map['bio_image'] = _bioImage;
    map['nj'] = _nj;
    map['nj_image'] = _njImage;
    return map;
  }

}