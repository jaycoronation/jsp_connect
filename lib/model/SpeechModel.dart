/// speech : [{"speech_data":[{"video":"http://naveenjindal.com/wp-content/uploads/foundation-india.jpg","date":"22.09.2022","title":"Naveen Jindal on the national flag.","location":"New Delhi, India.","para1":"On 23rd January 2004, the Supreme Court of India ruled in favour of Mr. Naveen Jindal, (Member of Parliament, Lok Sabha) and cited a new fundamental right that would allow every Indian to hoist the national flag on all days of the year. After this landmark ruling, Naveen and his wife Ms. Shallu Jindal, established the Flag Foundation of India. One of the primary objectives of the Foundation is to instill in the citizens of India, a sense of pride in the Tiranga. In order to spread the symbolism of the Tiranga, the Flag Foundation uses all available mediums such as music, art, photography, cultural programmes, festivals, seminars and workshops. This also includes collaborations with other civil societies and advocacy groups, corporate houses, educationists and other like-minded individuals, with a special focus on children and youth. The Foundation launched a travelling art exhibition, Tiranga – Rights & Responsibilities, which exhibited at the India Habitat Centre (New Delhi), Jaipur Virasat Festival (Jaipur) and Jehangir Art Gallery (Mumbai) and other parts of the country. In January 2005, the Foundation produced an international coffee table book, ‘Tiranga-A Celebration of the Indian Flag’. Professionals and amateurs from across the country contributed images that represented the relationship between the Tiranga and its people. The book features the photographic vision of more than seventy of Indias photographers including T. S. Satyan, Raghu Rai, Avinash Pasricha, Ram Rahman, Prashant Panjiar, Dayanita Singh and Swapan Parekh. The real star of this book is however the Indian tricolour itself, explored with a lot of energy and freshness across India and in a variety of situations. An exhibition featuring many of the works of the book was held at National Centre for Performing Arts (NCPA) in 2005.","read_more_txt":"Tiranga Tera Anchal an audio album of melodious songs on the Tiranga was also released. The music was composed by well-known composer Vanraj Bhatia, and it featured renowned singers – Sonu Nigam, Udit Narayan, Sadhna Sargam, Shreya Ghoshal, Vinod Rathore, Sunidhi Chauhan and Shankar Mahadevan. The lyrics were composed by Santosh Anand, Nida Fazili, Mehboob and Bashir Badr. There was also a book entitled ‘The Indian Tricolour‘ by Cdr. K.V. Singh (Retd.). Comprehensively researched, the book is a definitive account of the Indian tricolour, detailing its history and evolution. It serves as an authentic reference for both students and scholars. Each year the Foundation organises a ‘Tiranga Run‘ and participants include people of all ages in different parts of the country. To mark the Independence Day celebrations, Tiranga Fest, a six-day festival was organised at Dilli Haat, New Delhi in 2005."}],"comments":[{"display_picture":"","name":"Pratiksha Panchal","comment":"I am pround of you dear respected sir."},{"display_picture":"","name":"Jay Mistry","comment":"Good inspiration sir ji."},{"display_picture":"","name":"Disha Patel","comment":"very good work my God shri Naveen Jindal ji Jai hind"}]}]

class SpeechModel {
  SpeechModel({
      List<Speech>? speech,}){
    _speech = speech;
}

  SpeechModel.fromJson(dynamic json) {
    if (json['speech'] != null) {
      _speech = [];
      json['speech'].forEach((v) {
        _speech?.add(Speech.fromJson(v));
      });
    }
  }
  List<Speech>? _speech;
SpeechModel copyWith({  List<Speech>? speech,
}) => SpeechModel(  speech: speech ?? _speech,
);
  List<Speech>? get speech => _speech;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_speech != null) {
      map['speech'] = _speech?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// speech_data : [{"video":"http://naveenjindal.com/wp-content/uploads/foundation-india.jpg","date":"22.09.2022","title":"Naveen Jindal on the national flag.","location":"New Delhi, India.","para1":"On 23rd January 2004, the Supreme Court of India ruled in favour of Mr. Naveen Jindal, (Member of Parliament, Lok Sabha) and cited a new fundamental right that would allow every Indian to hoist the national flag on all days of the year. After this landmark ruling, Naveen and his wife Ms. Shallu Jindal, established the Flag Foundation of India. One of the primary objectives of the Foundation is to instill in the citizens of India, a sense of pride in the Tiranga. In order to spread the symbolism of the Tiranga, the Flag Foundation uses all available mediums such as music, art, photography, cultural programmes, festivals, seminars and workshops. This also includes collaborations with other civil societies and advocacy groups, corporate houses, educationists and other like-minded individuals, with a special focus on children and youth. The Foundation launched a travelling art exhibition, Tiranga – Rights & Responsibilities, which exhibited at the India Habitat Centre (New Delhi), Jaipur Virasat Festival (Jaipur) and Jehangir Art Gallery (Mumbai) and other parts of the country. In January 2005, the Foundation produced an international coffee table book, ‘Tiranga-A Celebration of the Indian Flag’. Professionals and amateurs from across the country contributed images that represented the relationship between the Tiranga and its people. The book features the photographic vision of more than seventy of Indias photographers including T. S. Satyan, Raghu Rai, Avinash Pasricha, Ram Rahman, Prashant Panjiar, Dayanita Singh and Swapan Parekh. The real star of this book is however the Indian tricolour itself, explored with a lot of energy and freshness across India and in a variety of situations. An exhibition featuring many of the works of the book was held at National Centre for Performing Arts (NCPA) in 2005.","read_more_txt":"Tiranga Tera Anchal an audio album of melodious songs on the Tiranga was also released. The music was composed by well-known composer Vanraj Bhatia, and it featured renowned singers – Sonu Nigam, Udit Narayan, Sadhna Sargam, Shreya Ghoshal, Vinod Rathore, Sunidhi Chauhan and Shankar Mahadevan. The lyrics were composed by Santosh Anand, Nida Fazili, Mehboob and Bashir Badr. There was also a book entitled ‘The Indian Tricolour‘ by Cdr. K.V. Singh (Retd.). Comprehensively researched, the book is a definitive account of the Indian tricolour, detailing its history and evolution. It serves as an authentic reference for both students and scholars. Each year the Foundation organises a ‘Tiranga Run‘ and participants include people of all ages in different parts of the country. To mark the Independence Day celebrations, Tiranga Fest, a six-day festival was organised at Dilli Haat, New Delhi in 2005."}]
/// comments : [{"display_picture":"","name":"Pratiksha Panchal","comment":"I am pround of you dear respected sir."},{"display_picture":"","name":"Jay Mistry","comment":"Good inspiration sir ji."},{"display_picture":"","name":"Disha Patel","comment":"very good work my God shri Naveen Jindal ji Jai hind"}]

class Speech {
  Speech({
      List<SpeechData>? speechData, 
      List<Comments>? comments,}){
    _speechData = speechData;
    _comments = comments;
}

  Speech.fromJson(dynamic json) {
    if (json['speech_data'] != null) {
      _speechData = [];
      json['speech_data'].forEach((v) {
        _speechData?.add(SpeechData.fromJson(v));
      });
    }
    if (json['comments'] != null) {
      _comments = [];
      json['comments'].forEach((v) {
        _comments?.add(Comments.fromJson(v));
      });
    }
  }
  List<SpeechData>? _speechData;
  List<Comments>? _comments;
Speech copyWith({  List<SpeechData>? speechData,
  List<Comments>? comments,
}) => Speech(  speechData: speechData ?? _speechData,
  comments: comments ?? _comments,
);
  List<SpeechData>? get speechData => _speechData;
  List<Comments>? get comments => _comments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_speechData != null) {
      map['speech_data'] = _speechData?.map((v) => v.toJson()).toList();
    }
    if (_comments != null) {
      map['comments'] = _comments?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// display_picture : ""
/// name : "Pratiksha Panchal"
/// comment : "I am pround of you dear respected sir."

class Comments {
  Comments({
      String? displayPicture, 
      String? name, 
      String? comment,}){
    _displayPicture = displayPicture;
    _name = name;
    _comment = comment;
}

  Comments.fromJson(dynamic json) {
    _displayPicture = json['display_picture'];
    _name = json['name'];
    _comment = json['comment'];
  }
  String? _displayPicture;
  String? _name;
  String? _comment;
Comments copyWith({  String? displayPicture,
  String? name,
  String? comment,
}) => Comments(  displayPicture: displayPicture ?? _displayPicture,
  name: name ?? _name,
  comment: comment ?? _comment,
);
  String? get displayPicture => _displayPicture;
  String? get name => _name;
  String? get comment => _comment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['display_picture'] = _displayPicture;
    map['name'] = _name;
    map['comment'] = _comment;
    return map;
  }

}

/// video : "http://naveenjindal.com/wp-content/uploads/foundation-india.jpg"
/// date : "22.09.2022"
/// title : "Naveen Jindal on the national flag."
/// location : "New Delhi, India."
/// para1 : "On 23rd January 2004, the Supreme Court of India ruled in favour of Mr. Naveen Jindal, (Member of Parliament, Lok Sabha) and cited a new fundamental right that would allow every Indian to hoist the national flag on all days of the year. After this landmark ruling, Naveen and his wife Ms. Shallu Jindal, established the Flag Foundation of India. One of the primary objectives of the Foundation is to instill in the citizens of India, a sense of pride in the Tiranga. In order to spread the symbolism of the Tiranga, the Flag Foundation uses all available mediums such as music, art, photography, cultural programmes, festivals, seminars and workshops. This also includes collaborations with other civil societies and advocacy groups, corporate houses, educationists and other like-minded individuals, with a special focus on children and youth. The Foundation launched a travelling art exhibition, Tiranga – Rights & Responsibilities, which exhibited at the India Habitat Centre (New Delhi), Jaipur Virasat Festival (Jaipur) and Jehangir Art Gallery (Mumbai) and other parts of the country. In January 2005, the Foundation produced an international coffee table book, ‘Tiranga-A Celebration of the Indian Flag’. Professionals and amateurs from across the country contributed images that represented the relationship between the Tiranga and its people. The book features the photographic vision of more than seventy of Indias photographers including T. S. Satyan, Raghu Rai, Avinash Pasricha, Ram Rahman, Prashant Panjiar, Dayanita Singh and Swapan Parekh. The real star of this book is however the Indian tricolour itself, explored with a lot of energy and freshness across India and in a variety of situations. An exhibition featuring many of the works of the book was held at National Centre for Performing Arts (NCPA) in 2005."
/// read_more_txt : "Tiranga Tera Anchal an audio album of melodious songs on the Tiranga was also released. The music was composed by well-known composer Vanraj Bhatia, and it featured renowned singers – Sonu Nigam, Udit Narayan, Sadhna Sargam, Shreya Ghoshal, Vinod Rathore, Sunidhi Chauhan and Shankar Mahadevan. The lyrics were composed by Santosh Anand, Nida Fazili, Mehboob and Bashir Badr. There was also a book entitled ‘The Indian Tricolour‘ by Cdr. K.V. Singh (Retd.). Comprehensively researched, the book is a definitive account of the Indian tricolour, detailing its history and evolution. It serves as an authentic reference for both students and scholars. Each year the Foundation organises a ‘Tiranga Run‘ and participants include people of all ages in different parts of the country. To mark the Independence Day celebrations, Tiranga Fest, a six-day festival was organised at Dilli Haat, New Delhi in 2005."

class SpeechData {
  SpeechData({
      String? video, 
      String? date, 
      String? title, 
      String? location, 
      String? para1, 
      String? readMoreTxt,}){
    _video = video;
    _date = date;
    _title = title;
    _location = location;
    _para1 = para1;
    _readMoreTxt = readMoreTxt;
}

  SpeechData.fromJson(dynamic json) {
    _video = json['video'];
    _date = json['date'];
    _title = json['title'];
    _location = json['location'];
    _para1 = json['para1'];
    _readMoreTxt = json['read_more_txt'];
  }
  String? _video;
  String? _date;
  String? _title;
  String? _location;
  String? _para1;
  String? _readMoreTxt;
SpeechData copyWith({  String? video,
  String? date,
  String? title,
  String? location,
  String? para1,
  String? readMoreTxt,
}) => SpeechData(  video: video ?? _video,
  date: date ?? _date,
  title: title ?? _title,
  location: location ?? _location,
  para1: para1 ?? _para1,
  readMoreTxt: readMoreTxt ?? _readMoreTxt,
);
  String? get video => _video;
  String? get date => _date;
  String? get title => _title;
  String? get location => _location;
  String? get para1 => _para1;
  String? get readMoreTxt => _readMoreTxt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['video'] = _video;
    map['date'] = _date;
    map['title'] = _title;
    map['location'] = _location;
    map['para1'] = _para1;
    map['read_more_txt'] = _readMoreTxt;
    return map;
  }

}