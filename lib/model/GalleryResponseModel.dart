/// gallery_images : {"awards_recognition":[{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598079310_naveen_jindal.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/custom/1597641141_award4.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/custom/1597641141_award5.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/custom/1597641141_award1.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/custom/1597641141_award1.jpg"}],"internal_photo":[{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080283_NJ1.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080371_gal5.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080370_gal1.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080373_gal10.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080372_gal7.jpg"}],"plant_photo":[{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080542_jspl-ctb-16.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080579_5.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080662_img3.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080688_2.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080810_jspl-ct19.jpg"}]}

class GalleryResponseModel {
  GalleryResponseModel({
      GalleryImages? galleryImages,}){
    _galleryImages = galleryImages;
}

  GalleryResponseModel.fromJson(dynamic json) {
    _galleryImages = json['gallery_images'] != null ? GalleryImages.fromJson(json['gallery_images']) : null;
  }
  GalleryImages? _galleryImages;
GalleryResponseModel copyWith({  GalleryImages? galleryImages,
}) => GalleryResponseModel(  galleryImages: galleryImages ?? _galleryImages,
);
  GalleryImages? get galleryImages => _galleryImages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_galleryImages != null) {
      map['gallery_images'] = _galleryImages?.toJson();
    }
    return map;
  }

}

/// awards_recognition : [{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598079310_naveen_jindal.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/custom/1597641141_award4.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/custom/1597641141_award5.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/custom/1597641141_award1.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/custom/1597641141_award1.jpg"}]
/// internal_photo : [{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080283_NJ1.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080371_gal5.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080370_gal1.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080373_gal10.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080372_gal7.jpg"}]
/// plant_photo : [{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080542_jspl-ctb-16.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080579_5.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080662_img3.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080688_2.jpg"},{"image":"https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080810_jspl-ct19.jpg"}]

class GalleryImages {
  GalleryImages({
      List<AwardsRecognition>? awardsRecognition, 
      List<AwardsRecognition>? internalPhoto,
      List<AwardsRecognition>? plantPhoto,}){
    _awardsRecognition = awardsRecognition;
    _internalPhoto = internalPhoto;
    _plantPhoto = plantPhoto;
}

  GalleryImages.fromJson(dynamic json) {
    if (json['awards_recognition'] != null) {
      _awardsRecognition = [];
      json['awards_recognition'].forEach((v) {
        _awardsRecognition?.add(AwardsRecognition.fromJson(v));
      });
    }
    if (json['internal_photo'] != null) {
      _internalPhoto = [];
      json['internal_photo'].forEach((v) {
        _internalPhoto?.add(AwardsRecognition.fromJson(v));
      });
    }
    if (json['plant_photo'] != null) {
      _plantPhoto = [];
      json['plant_photo'].forEach((v) {
        _plantPhoto?.add(AwardsRecognition.fromJson(v));
      });
    }
  }
  List<AwardsRecognition>? _awardsRecognition;
  List<AwardsRecognition>? _internalPhoto;
  List<AwardsRecognition>? _plantPhoto;
GalleryImages copyWith({  List<AwardsRecognition>? awardsRecognition,
  List<AwardsRecognition>? internalPhoto,
  List<AwardsRecognition>? plantPhoto,
}) => GalleryImages(  awardsRecognition: awardsRecognition ?? _awardsRecognition,
  internalPhoto: internalPhoto ?? _internalPhoto,
  plantPhoto: plantPhoto ?? _plantPhoto,
);
  List<AwardsRecognition>? get awardsRecognition => _awardsRecognition;
  List<AwardsRecognition>? get internalPhoto => _internalPhoto;
  List<AwardsRecognition>? get plantPhoto => _plantPhoto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_awardsRecognition != null) {
      map['awards_recognition'] = _awardsRecognition?.map((v) => v.toJson()).toList();
    }
    if (_internalPhoto != null) {
      map['internal_photo'] = _internalPhoto?.map((v) => v.toJson()).toList();
    }
    if (_plantPhoto != null) {
      map['plant_photo'] = _plantPhoto?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// image : "https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080542_jspl-ctb-16.jpg"

class PlantPhoto {
  PlantPhoto({
      String? image,}){
    _image = image;
}

  PlantPhoto.fromJson(dynamic json) {
    _image = json['image'];
  }
  String? _image;
PlantPhoto copyWith({  String? image,
}) => PlantPhoto(  image: image ?? _image,
);
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = _image;
    return map;
  }

}

/// image : "https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598080283_NJ1.jpg"

class InternalPhoto {
  InternalPhoto({
      String? image,}){
    _image = image;
}

  InternalPhoto.fromJson(dynamic json) {
    _image = json['image'];
  }
  String? _image;
InternalPhoto copyWith({  String? image,
}) => InternalPhoto(  image: image ?? _image,
);
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = _image;
    return map;
  }

}

/// image : "https://d2lptvt2jijg6f.cloudfront.net/Jindal%20Connect/post/1598079310_naveen_jindal.jpg"

class AwardsRecognition {
  AwardsRecognition({
      String? image,}){
    _image = image;
}

  AwardsRecognition.fromJson(dynamic json) {
    _image = json['image'];
  }
  String? _image;
AwardsRecognition copyWith({  String? image,
}) => AwardsRecognition(  image: image ?? _image,
);
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = _image;
    return map;
  }

}