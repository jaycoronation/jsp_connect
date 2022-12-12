/// details : [{"data":[{"date":"22.09.2022","quotes":"Looking beyond possiblities","name":"MR. NAVEEN JINDAL"},{"date":"22.09.2022","quotes":"Truly, for some men, destiny isn't written, unless they write it.","name":"MR. NAVEEN JINDAL"},{"date":"22.09.2022","quotes":"Do. Or do not. There is no try.","name":"MR. NAVEEN JINDAL"},{"date":"22.09.2022","quotes":"“I will prepare and some day my chance will come.”","name":"MR. NAVEEN JINDAL"}],"events":[{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg2mfh46p41qs4fmntgg16f4i.jpg","event_name":"Naveen Jindal with Mr. Bill Gates and Mr. Ratan Tata","date":"22.09.2022"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg2mfh5mklpu52ff1t7t1jo7l.jpg","event_name":"With honourable President of India, 2008","date":"22.09.2022"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg2mfh5be81umis8l1pvl1vovm.jpg","event_name":"Naveen Jindal during his Myanmar visit","date":"22.09.2022"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg2mfh613bc9pau6qu74hnn.jpg","event_name":"World Population Day walkathon","date":"22.09.2022"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg2mfh6qsn1dgq23t143m4qqp.jpg","event_name":"Addressing the public during World Population Day","date":"22.09.2022"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg2mfh6ofmhgq86cuatbpoq.jpg","event_name":"Dignitaries at World Population Day","date":"22.09.2022"}],"live":[{"image":"https://img.youtube.com/vi/ASoXyjpWmgQ/mqdefault.jpg","title":"'We the people' - debate on new age voting rights NDTV","video_url":"https://www.youtube.com/watch?v=ASoXyjpWmgQ","date":"10.24.2011","location":"New Dehil"},{"image":"http://img.youtube.com/vi/wL43GK_u-rA/mqdefault.jpg","title":"'We the people' - debate on 'young politicians, old ideas' on NDTV","video_url":"https://www.youtube.com/watch?v=wL43GK_u-rA","date":"24.05.2010","location":"New Dehil"},{"image":"http://img.youtube.com/vi/mt8OSaPQ0Ec/mqdefault.jpg","title":"Naveen Jindal on Lokpal Bill on News 24","video_url":"https://www.youtube.com/watch?v=mt8OSaPQ0Ec","date":"06.09.2011","location":"kurukshetra"}],"about":[{"about_data":[{"image":"","name":"NAVEEN JINDAL","sub_title":"Member of Parliament","detail":"Committed to building the nation of our dreams."}],"biography":"","inspiration":"","mission":"","member":""}],"gallery":[{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adaik8gh1eite2qis8jip1kl5i.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adaik8gg1dr1ntn4l31scl1kftg.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adfjvfds8skvocq3618e41dmkd.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adfjvfdsktt39r1td6e50nr4f.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adfjvfds13ra58bo1d1gpvptfg.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg0lrbi1osb11cmvlj1priu0fp.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg0lrbj1ig310fiqs924ebhtq.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg22m9e1n9r1clq1as3be598g.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg22m9enr21jnbvs61eht171hh.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg35aq41e4htdu1pmh1hbvdg5j.jpg"}],"video":[{"video_url":"https://www.youtube.com/watch?time_continue=1&v=9jq7igz2Ou8"},{"video_url":"https://www.youtube.com/watch?time_continue=2&v=zBq3_GyY8sI"},{"video_url":"https://www.youtube.com/watch?v=4ZL0s9gKKEk"},{"video_url":"https://www.youtube.com/watch?v=Jcj0fZ6WN-E"},{"video_url":"https://www.youtube.com/watch?v=vox5J1DPtck"},{"video_url":"https://www.youtube.com/watch?v=O8k43nu0eVE"},{"video_url":"https://www.youtube.com/watch?v=X3e7966izKI"}],"media_management":[{"image":"","para":"","date":""},{"image":"","para":"","date":""},{"image":"","para":"","date":""}]}]

class DashboardModel {
  DashboardModel({
      List<Details>? details,}){
    _details = details;
}

  DashboardModel.fromJson(dynamic json) {
    if (json['details'] != null) {
      _details = [];
      json['details'].forEach((v) {
        _details?.add(Details.fromJson(v));
      });
    }
  }
  List<Details>? _details;
DashboardModel copyWith({  List<Details>? details,
}) => DashboardModel(  details: details ?? _details,
);
  List<Details>? get details => _details;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_details != null) {
      map['details'] = _details?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// data : [{"date":"22.09.2022","quotes":"Looking beyond possiblities","name":"MR. NAVEEN JINDAL"},{"date":"22.09.2022","quotes":"Truly, for some men, destiny isn't written, unless they write it.","name":"MR. NAVEEN JINDAL"},{"date":"22.09.2022","quotes":"Do. Or do not. There is no try.","name":"MR. NAVEEN JINDAL"},{"date":"22.09.2022","quotes":"“I will prepare and some day my chance will come.”","name":"MR. NAVEEN JINDAL"}]
/// events : [{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg2mfh46p41qs4fmntgg16f4i.jpg","event_name":"Naveen Jindal with Mr. Bill Gates and Mr. Ratan Tata","date":"22.09.2022"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg2mfh5mklpu52ff1t7t1jo7l.jpg","event_name":"With honourable President of India, 2008","date":"22.09.2022"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg2mfh5be81umis8l1pvl1vovm.jpg","event_name":"Naveen Jindal during his Myanmar visit","date":"22.09.2022"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg2mfh613bc9pau6qu74hnn.jpg","event_name":"World Population Day walkathon","date":"22.09.2022"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg2mfh6qsn1dgq23t143m4qqp.jpg","event_name":"Addressing the public during World Population Day","date":"22.09.2022"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg2mfh6ofmhgq86cuatbpoq.jpg","event_name":"Dignitaries at World Population Day","date":"22.09.2022"}]
/// live : [{"image":"https://img.youtube.com/vi/ASoXyjpWmgQ/mqdefault.jpg","title":"'We the people' - debate on new age voting rights NDTV","video_url":"https://www.youtube.com/watch?v=ASoXyjpWmgQ","date":"10.24.2011","location":"New Dehil"},{"image":"http://img.youtube.com/vi/wL43GK_u-rA/mqdefault.jpg","title":"'We the people' - debate on 'young politicians, old ideas' on NDTV","video_url":"https://www.youtube.com/watch?v=wL43GK_u-rA","date":"24.05.2010","location":"New Dehil"},{"image":"http://img.youtube.com/vi/mt8OSaPQ0Ec/mqdefault.jpg","title":"Naveen Jindal on Lokpal Bill on News 24","video_url":"https://www.youtube.com/watch?v=mt8OSaPQ0Ec","date":"06.09.2011","location":"kurukshetra"}]
/// about : [{"about_data":[{"image":"","name":"NAVEEN JINDAL","sub_title":"Member of Parliament","detail":"Committed to building the nation of our dreams."}],"biography":"","inspiration":"","mission":"","member":""}]
/// gallery : [{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adaik8gh1eite2qis8jip1kl5i.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adaik8gg1dr1ntn4l31scl1kftg.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adfjvfds8skvocq3618e41dmkd.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adfjvfdsktt39r1td6e50nr4f.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adfjvfds13ra58bo1d1gpvptfg.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg0lrbi1osb11cmvlj1priu0fp.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg0lrbj1ig310fiqs924ebhtq.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg22m9e1n9r1clq1as3be598g.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg22m9enr21jnbvs61eht171hh.jpg"},{"image":"https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg35aq41e4htdu1pmh1hbvdg5j.jpg"}]
/// video : [{"video_url":"https://www.youtube.com/watch?time_continue=1&v=9jq7igz2Ou8"},{"video_url":"https://www.youtube.com/watch?time_continue=2&v=zBq3_GyY8sI"},{"video_url":"https://www.youtube.com/watch?v=4ZL0s9gKKEk"},{"video_url":"https://www.youtube.com/watch?v=Jcj0fZ6WN-E"},{"video_url":"https://www.youtube.com/watch?v=vox5J1DPtck"},{"video_url":"https://www.youtube.com/watch?v=O8k43nu0eVE"},{"video_url":"https://www.youtube.com/watch?v=X3e7966izKI"}]
/// media_management : [{"image":"","para":"","date":""},{"image":"","para":"","date":""},{"image":"","para":"","date":""}]

class Details {
  Details({
      List<Data>? data, 
      List<Events>? events, 
      List<Live>? live, 
      List<About>? about, 
      List<Gallery>? gallery, 
      List<Video>? video, 
      List<MediaManagement>? mediaManagement,}){
    _data = data;
    _events = events;
    _live = live;
    _about = about;
    _gallery = gallery;
    _video = video;
    _mediaManagement = mediaManagement;
}

  Details.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    if (json['events'] != null) {
      _events = [];
      json['events'].forEach((v) {
        _events?.add(Events.fromJson(v));
      });
    }
    if (json['live'] != null) {
      _live = [];
      json['live'].forEach((v) {
        _live?.add(Live.fromJson(v));
      });
    }
    if (json['about'] != null) {
      _about = [];
      json['about'].forEach((v) {
        _about?.add(About.fromJson(v));
      });
    }
    if (json['gallery'] != null) {
      _gallery = [];
      json['gallery'].forEach((v) {
        _gallery?.add(Gallery.fromJson(v));
      });
    }
    if (json['video'] != null) {
      _video = [];
      json['video'].forEach((v) {
        _video?.add(Video.fromJson(v));
      });
    }
    if (json['media_management'] != null) {
      _mediaManagement = [];
      json['media_management'].forEach((v) {
        _mediaManagement?.add(MediaManagement.fromJson(v));
      });
    }
  }
  List<Data>? _data;
  List<Events>? _events;
  List<Live>? _live;
  List<About>? _about;
  List<Gallery>? _gallery;
  List<Video>? _video;
  List<MediaManagement>? _mediaManagement;
Details copyWith({  List<Data>? data,
  List<Events>? events,
  List<Live>? live,
  List<About>? about,
  List<Gallery>? gallery,
  List<Video>? video,
  List<MediaManagement>? mediaManagement,
}) => Details(  data: data ?? _data,
  events: events ?? _events,
  live: live ?? _live,
  about: about ?? _about,
  gallery: gallery ?? _gallery,
  video: video ?? _video,
  mediaManagement: mediaManagement ?? _mediaManagement,
);
  List<Data>? get data => _data;
  List<Events>? get events => _events;
  List<Live>? get live => _live;
  List<About>? get about => _about;
  List<Gallery>? get gallery => _gallery;
  List<Video>? get video => _video;
  List<MediaManagement>? get mediaManagement => _mediaManagement;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_events != null) {
      map['events'] = _events?.map((v) => v.toJson()).toList();
    }
    if (_live != null) {
      map['live'] = _live?.map((v) => v.toJson()).toList();
    }
    if (_about != null) {
      map['about'] = _about?.map((v) => v.toJson()).toList();
    }
    if (_gallery != null) {
      map['gallery'] = _gallery?.map((v) => v.toJson()).toList();
    }
    if (_video != null) {
      map['video'] = _video?.map((v) => v.toJson()).toList();
    }
    if (_mediaManagement != null) {
      map['media_management'] = _mediaManagement?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// image : ""
/// para : ""
/// date : ""

class MediaManagement {
  MediaManagement({
      String? image, 
      String? para, 
      String? date,}){
    _image = image;
    _para = para;
    _date = date;
}

  MediaManagement.fromJson(dynamic json) {
    _image = json['image'];
    _para = json['para'];
    _date = json['date'];
  }
  String? _image;
  String? _para;
  String? _date;
MediaManagement copyWith({  String? image,
  String? para,
  String? date,
}) => MediaManagement(  image: image ?? _image,
  para: para ?? _para,
  date: date ?? _date,
);
  String? get image => _image;
  String? get para => _para;
  String? get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = _image;
    map['para'] = _para;
    map['date'] = _date;
    return map;
  }

}

/// video_url : "https://www.youtube.com/watch?time_continue=1&v=9jq7igz2Ou8"

class Video {
  Video({
      String? videoUrl,}){
    _videoUrl = videoUrl;
}

  Video.fromJson(dynamic json) {
    _videoUrl = json['video_url'];
  }
  String? _videoUrl;
Video copyWith({  String? videoUrl,
}) => Video(  videoUrl: videoUrl ?? _videoUrl,
);
  String? get videoUrl => _videoUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['video_url'] = _videoUrl;
    return map;
  }

}

/// image : "https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adaik8gh1eite2qis8jip1kl5i.jpg"

class Gallery {
  Gallery({
      String? image,}){
    _image = image;
}

  Gallery.fromJson(dynamic json) {
    _image = json['image'];
  }
  String? _image;
Gallery copyWith({  String? image,
}) => Gallery(  image: image ?? _image,
);
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = _image;
    return map;
  }

}

/// about_data : [{"image":"","name":"NAVEEN JINDAL","sub_title":"Member of Parliament","detail":"Committed to building the nation of our dreams."}]
/// biography : ""
/// inspiration : ""
/// mission : ""
/// member : ""

class About {
  About({
      List<AboutData>? aboutData, 
      String? biography, 
      String? inspiration, 
      String? mission, 
      String? member,}){
    _aboutData = aboutData;
    _biography = biography;
    _inspiration = inspiration;
    _mission = mission;
    _member = member;
}

  About.fromJson(dynamic json) {
    if (json['about_data'] != null) {
      _aboutData = [];
      json['about_data'].forEach((v) {
        _aboutData?.add(AboutData.fromJson(v));
      });
    }
    _biography = json['biography'];
    _inspiration = json['inspiration'];
    _mission = json['mission'];
    _member = json['member'];
  }
  List<AboutData>? _aboutData;
  String? _biography;
  String? _inspiration;
  String? _mission;
  String? _member;
About copyWith({  List<AboutData>? aboutData,
  String? biography,
  String? inspiration,
  String? mission,
  String? member,
}) => About(  aboutData: aboutData ?? _aboutData,
  biography: biography ?? _biography,
  inspiration: inspiration ?? _inspiration,
  mission: mission ?? _mission,
  member: member ?? _member,
);
  List<AboutData>? get aboutData => _aboutData;
  String? get biography => _biography;
  String? get inspiration => _inspiration;
  String? get mission => _mission;
  String? get member => _member;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_aboutData != null) {
      map['about_data'] = _aboutData?.map((v) => v.toJson()).toList();
    }
    map['biography'] = _biography;
    map['inspiration'] = _inspiration;
    map['mission'] = _mission;
    map['member'] = _member;
    return map;
  }

}

/// image : ""
/// name : "NAVEEN JINDAL"
/// sub_title : "Member of Parliament"
/// detail : "Committed to building the nation of our dreams."

class AboutData {
  AboutData({
      String? image, 
      String? name, 
      String? subTitle, 
      String? detail,}){
    _image = image;
    _name = name;
    _subTitle = subTitle;
    _detail = detail;
}

  AboutData.fromJson(dynamic json) {
    _image = json['image'];
    _name = json['name'];
    _subTitle = json['sub_title'];
    _detail = json['detail'];
  }
  String? _image;
  String? _name;
  String? _subTitle;
  String? _detail;
AboutData copyWith({  String? image,
  String? name,
  String? subTitle,
  String? detail,
}) => AboutData(  image: image ?? _image,
  name: name ?? _name,
  subTitle: subTitle ?? _subTitle,
  detail: detail ?? _detail,
);
  String? get image => _image;
  String? get name => _name;
  String? get subTitle => _subTitle;
  String? get detail => _detail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = _image;
    map['name'] = _name;
    map['sub_title'] = _subTitle;
    map['detail'] = _detail;
    return map;
  }

}

/// image : "https://img.youtube.com/vi/ASoXyjpWmgQ/mqdefault.jpg"
/// title : "'We the people' - debate on new age voting rights NDTV"
/// video_url : "https://www.youtube.com/watch?v=ASoXyjpWmgQ"
/// date : "10.24.2011"
/// location : "New Dehil"

class Live {
  Live({
      String? image, 
      String? title, 
      String? videoUrl, 
      String? date, 
      String? location,}){
    _image = image;
    _title = title;
    _videoUrl = videoUrl;
    _date = date;
    _location = location;
}

  Live.fromJson(dynamic json) {
    _image = json['image'];
    _title = json['title'];
    _videoUrl = json['video_url'];
    _date = json['date'];
    _location = json['location'];
  }
  String? _image;
  String? _title;
  String? _videoUrl;
  String? _date;
  String? _location;
Live copyWith({  String? image,
  String? title,
  String? videoUrl,
  String? date,
  String? location,
}) => Live(  image: image ?? _image,
  title: title ?? _title,
  videoUrl: videoUrl ?? _videoUrl,
  date: date ?? _date,
  location: location ?? _location,
);
  String? get image => _image;
  String? get title => _title;
  String? get videoUrl => _videoUrl;
  String? get date => _date;
  String? get location => _location;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = _image;
    map['title'] = _title;
    map['video_url'] = _videoUrl;
    map['date'] = _date;
    map['location'] = _location;
    return map;
  }

}

/// image : "https://naveenjindal.com/wp-content/gallery-bank/gallery-uploads/o_1adg2mfh46p41qs4fmntgg16f4i.jpg"
/// event_name : "Naveen Jindal with Mr. Bill Gates and Mr. Ratan Tata"
/// date : "22.09.2022"

class Events {
  Events({
      String? image, 
      String? eventName, 
      String? date,}){
    _image = image;
    _eventName = eventName;
    _date = date;
}

  Events.fromJson(dynamic json) {
    _image = json['image'];
    _eventName = json['event_name'];
    _date = json['date'];
  }
  String? _image;
  String? _eventName;
  String? _date;
Events copyWith({  String? image,
  String? eventName,
  String? date,
}) => Events(  image: image ?? _image,
  eventName: eventName ?? _eventName,
  date: date ?? _date,
);
  String? get image => _image;
  String? get eventName => _eventName;
  String? get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = _image;
    map['event_name'] = _eventName;
    map['date'] = _date;
    return map;
  }

}

/// date : "22.09.2022"
/// quotes : "Looking beyond possiblities"
/// name : "MR. NAVEEN JINDAL"

class Data {
  Data({
      String? date, 
      String? quotes, 
      String? name,}){
    _date = date;
    _quotes = quotes;
    _name = name;
}

  Data.fromJson(dynamic json) {
    _date = json['date'];
    _quotes = json['quotes'];
    _name = json['name'];
  }
  String? _date;
  String? _quotes;
  String? _name;
Data copyWith({  String? date,
  String? quotes,
  String? name,
}) => Data(  date: date ?? _date,
  quotes: quotes ?? _quotes,
  name: name ?? _name,
);
  String? get date => _date;
  String? get quotes => _quotes;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = _date;
    map['quotes'] = _quotes;
    map['name'] = _name;
    return map;
  }

}