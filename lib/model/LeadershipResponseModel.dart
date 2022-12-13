class LeadershipResponseModel {
  LeadershipResponseModel({
      List<KeyManagment>? keyManagment, 
      List<KeyManagment>? boardOfDirectors,}){
    _keyManagment = keyManagment;
    _boardOfDirectors = boardOfDirectors;
}

  LeadershipResponseModel.fromJson(dynamic json) {
    if (json['key_managment'] != null) {
      _keyManagment = [];
      json['key_managment'].forEach((v) {
        _keyManagment?.add(KeyManagment.fromJson(v));
      });
    }
    if (json['board_of_directors'] != null) {
      _boardOfDirectors = [];
      json['board_of_directors'].forEach((v) {
        _boardOfDirectors?.add(KeyManagment.fromJson(v));
      });
    }
  }
  List<KeyManagment>? _keyManagment;
  List<KeyManagment>? _boardOfDirectors;
LeadershipResponseModel copyWith({  List<KeyManagment>? keyManagment,
  List<KeyManagment>? boardOfDirectors,
}) => LeadershipResponseModel(  keyManagment: keyManagment ?? _keyManagment,
  boardOfDirectors: boardOfDirectors ?? _boardOfDirectors,
);
  List<KeyManagment>? get keyManagment => _keyManagment;
  List<KeyManagment>? get boardOfDirectors => _boardOfDirectors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_keyManagment != null) {
      map['key_managment'] = _keyManagment?.map((v) => v.toJson()).toList();
    }
    if (_boardOfDirectors != null) {
      map['board_of_directors'] = _boardOfDirectors?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class BoardOfDirectors {
  BoardOfDirectors({
      String? img, 
      String? name, 
      String? desgnation, 
      String? messgae,}){
    _img = img;
    _name = name;
    _desgnation = desgnation;
    _messgae = messgae;
}

  BoardOfDirectors.fromJson(dynamic json) {
    _img = json['img'];
    _name = json['name'];
    _desgnation = json['desgnation'];
    _messgae = json['messgae'];
  }
  String? _img;
  String? _name;
  String? _desgnation;
  String? _messgae;
BoardOfDirectors copyWith({  String? img,
  String? name,
  String? desgnation,
  String? messgae,
}) => BoardOfDirectors(  img: img ?? _img,
  name: name ?? _name,
  desgnation: desgnation ?? _desgnation,
  messgae: messgae ?? _messgae,
);
  String? get img => _img;
  String? get name => _name;
  String? get desgnation => _desgnation;
  String? get messgae => _messgae;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['img'] = _img;
    map['name'] = _name;
    map['desgnation'] = _desgnation;
    map['messgae'] = _messgae;
    return map;
  }

}

class KeyManagment {
  KeyManagment({
      String? img, 
      String? name, 
      String? desgnation, 
      String? messgae,}){
    _img = img;
    _name = name;
    _desgnation = desgnation;
    _messgae = messgae;
}

  KeyManagment.fromJson(dynamic json) {
    _img = json['img'];
    _name = json['name'];
    _desgnation = json['desgnation'];
    _messgae = json['messgae'];
  }
  String? _img;
  String? _name;
  String? _desgnation;
  String? _messgae;
KeyManagment copyWith({  String? img,
  String? name,
  String? desgnation,
  String? messgae,
}) => KeyManagment(  img: img ?? _img,
  name: name ?? _name,
  desgnation: desgnation ?? _desgnation,
  messgae: messgae ?? _messgae,
);
  String? get img => _img;
  String? get name => _name;
  String? get desgnation => _desgnation;
  String? get messgae => _messgae;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['img'] = _img;
    map['name'] = _name;
    map['desgnation'] = _desgnation;
    map['messgae'] = _messgae;
    return map;
  }

}