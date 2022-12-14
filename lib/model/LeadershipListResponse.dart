import 'dart:convert';
/// success : 1
/// message : "Leadership list loaded successfully"
/// postData : [{"name":"Key Managment","category_id":"4","posts":[{"id":"100","title":"Naveen Jindal","post_type_id":"10","post_category_id":"4","short_description":"A well-known Indian Industrialist and Philanthropist, Mr Naveen Jindal is the Chairman of Jindal steel & Power limited (JSPL), India’s leading infrastructure Conglomerate with interests in steel, mining and power sector.\\n\\nHis vision at JSPL is driven by","description":"A well-known Indian Industrialist and Philanthropist, Mr Naveen Jindal is the Chairman of Jindal steel & Power limited (JSPL), India’s leading infrastructure Conglomerate with interests in steel, mining and power sector.\\n\\nHis vision at JSPL is driven by the core principle of Nation Building. Under his leadership, each of the businesses of JSPL is focused towards building world-class capabilities to make India self-reliant and a global economic powerhouse. His tenacity and drive have transformed JSPL into a conglomerate with presence across Africa, Oman and Australia.\\n\\nMr Jindal was declared the Industry Communicator of the year by the World Steel Association in 2016. He was featured by the Fortune magazine as Asia’s 25 Hottest People in Business for turning a struggling steel company into an Asian blue-chip giant. JSPL, under his leadership, was declared as the highest wealth creator in the world between the Years 2005-2009 by the Boston Consulting Group. In 2011, The Economic Times-Corporate Dossier list featured him as India’s Most Powerful CEOs. Ernst & Young conferred upon him the Entrepreneur of the Year Award in the field of Energy and Infrastructure in 2010.\\n\\nHe is the President of the Flag Foundation of India. He led a campaign to democratise the Tricolour, and his decade-long legal struggle resulted in a historic Supreme Court judgment allowing every Indian to display the Indian Flag with pride on all days of the year. He was elected twice to Indian Parliament where he served as a Parliamentarian for 10 years and made many contributions.\\n\\nMr Naveen Jindal is also the founding Chancellor of O P Jindal Global University, which is ranked the number one private university in India as per the QS World university rankings 2021.\\n\\nMr Jindal completed his MBA from the University of Texas at Dallas (UTD) in 1992. In recognition of his exceptional entrepreneurship skills and public service, the School of Management of the University of Texas, Dallas christened it as the Naveen Jindal School of Management. This recognition has led to the establishment of the Naveen Jindal Institute for Indo-American Business Studies.\\n\\nHe is an avid sportsperson, an active Polo Player and a National record holder in skeet shooting.\\n\\nHe is married to noted Indian classical dancer and a compassionate CSR leader Ms Shallu Jindal. The couple is blessed with two children, Venkatesh and Yashasvini.","user_id":"5","slug":"","location":"Maharashtra","meta_title":"","meta_keywords":"","meta_description":"","schedule_timestamp":"1670713200","time_ago":"1 day ago","save_timestamp":"13 Dec 2022","status":"1","designation":"","featured_image":"","featured_image_path":"http://192.168.50.34/jindal/assets/upload/feature_image/1670566557_carbon-fibre-voltt-card.jpg","likes_count":0,"shares_count":0,"bookmark_count":0,"is_liked":0,"is_bookmarked":0}]}]

LeadershipListResponse leadershipListResponseFromJson(String str) => LeadershipListResponse.fromJson(json.decode(str));
String leadershipListResponseToJson(LeadershipListResponse data) => json.encode(data.toJson());
class LeadershipListResponse {
  LeadershipListResponse({
      num? success, 
      String? message, 
      List<PostData>? postData,}){
    _success = success;
    _message = message;
    _postData = postData;
}

  LeadershipListResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    if (json['postData'] != null) {
      _postData = [];
      json['postData'].forEach((v) {
        _postData?.add(PostData.fromJson(v));
      });
    }
  }
  num? _success;
  String? _message;
  List<PostData>? _postData;
LeadershipListResponse copyWith({  num? success,
  String? message,
  List<PostData>? postData,
}) => LeadershipListResponse(  success: success ?? _success,
  message: message ?? _message,
  postData: postData ?? _postData,
);
  num? get success => _success;
  String? get message => _message;
  List<PostData>? get postData => _postData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_postData != null) {
      map['postData'] = _postData?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// name : "Key Managment"
/// category_id : "4"
/// posts : [{"id":"100","title":"Naveen Jindal","post_type_id":"10","post_category_id":"4","short_description":"A well-known Indian Industrialist and Philanthropist, Mr Naveen Jindal is the Chairman of Jindal steel & Power limited (JSPL), India’s leading infrastructure Conglomerate with interests in steel, mining and power sector.\\n\\nHis vision at JSPL is driven by","description":"A well-known Indian Industrialist and Philanthropist, Mr Naveen Jindal is the Chairman of Jindal steel & Power limited (JSPL), India’s leading infrastructure Conglomerate with interests in steel, mining and power sector.\\n\\nHis vision at JSPL is driven by the core principle of Nation Building. Under his leadership, each of the businesses of JSPL is focused towards building world-class capabilities to make India self-reliant and a global economic powerhouse. His tenacity and drive have transformed JSPL into a conglomerate with presence across Africa, Oman and Australia.\\n\\nMr Jindal was declared the Industry Communicator of the year by the World Steel Association in 2016. He was featured by the Fortune magazine as Asia’s 25 Hottest People in Business for turning a struggling steel company into an Asian blue-chip giant. JSPL, under his leadership, was declared as the highest wealth creator in the world between the Years 2005-2009 by the Boston Consulting Group. In 2011, The Economic Times-Corporate Dossier list featured him as India’s Most Powerful CEOs. Ernst & Young conferred upon him the Entrepreneur of the Year Award in the field of Energy and Infrastructure in 2010.\\n\\nHe is the President of the Flag Foundation of India. He led a campaign to democratise the Tricolour, and his decade-long legal struggle resulted in a historic Supreme Court judgment allowing every Indian to display the Indian Flag with pride on all days of the year. He was elected twice to Indian Parliament where he served as a Parliamentarian for 10 years and made many contributions.\\n\\nMr Naveen Jindal is also the founding Chancellor of O P Jindal Global University, which is ranked the number one private university in India as per the QS World university rankings 2021.\\n\\nMr Jindal completed his MBA from the University of Texas at Dallas (UTD) in 1992. In recognition of his exceptional entrepreneurship skills and public service, the School of Management of the University of Texas, Dallas christened it as the Naveen Jindal School of Management. This recognition has led to the establishment of the Naveen Jindal Institute for Indo-American Business Studies.\\n\\nHe is an avid sportsperson, an active Polo Player and a National record holder in skeet shooting.\\n\\nHe is married to noted Indian classical dancer and a compassionate CSR leader Ms Shallu Jindal. The couple is blessed with two children, Venkatesh and Yashasvini.","user_id":"5","slug":"","location":"Maharashtra","meta_title":"","meta_keywords":"","meta_description":"","schedule_timestamp":"1670713200","time_ago":"1 day ago","save_timestamp":"13 Dec 2022","status":"1","designation":"","featured_image":"","featured_image_path":"http://192.168.50.34/jindal/assets/upload/feature_image/1670566557_carbon-fibre-voltt-card.jpg","likes_count":0,"shares_count":0,"bookmark_count":0,"is_liked":0,"is_bookmarked":0}]

PostData postDataFromJson(String str) => PostData.fromJson(json.decode(str));
String postDataToJson(PostData data) => json.encode(data.toJson());
class PostData {
  PostData({
      String? name, 
      String? categoryId, 
      List<Posts>? posts,}){
    _name = name;
    _categoryId = categoryId;
    _posts = posts;
}

  PostData.fromJson(dynamic json) {
    _name = json['name'];
    _categoryId = json['category_id'];
    if (json['posts'] != null) {
      _posts = [];
      json['posts'].forEach((v) {
        _posts?.add(Posts.fromJson(v));
      });
    }
  }
  String? _name;
  String? _categoryId;
  List<Posts>? _posts;
PostData copyWith({  String? name,
  String? categoryId,
  List<Posts>? posts,
}) => PostData(  name: name ?? _name,
  categoryId: categoryId ?? _categoryId,
  posts: posts ?? _posts,
);
  String? get name => _name;
  String? get categoryId => _categoryId;
  List<Posts>? get posts => _posts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['category_id'] = _categoryId;
    if (_posts != null) {
      map['posts'] = _posts?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "100"
/// title : "Naveen Jindal"
/// post_type_id : "10"
/// post_category_id : "4"
/// short_description : "A well-known Indian Industrialist and Philanthropist, Mr Naveen Jindal is the Chairman of Jindal steel & Power limited (JSPL), India’s leading infrastructure Conglomerate with interests in steel, mining and power sector.\\n\\nHis vision at JSPL is driven by"
/// description : "A well-known Indian Industrialist and Philanthropist, Mr Naveen Jindal is the Chairman of Jindal steel & Power limited (JSPL), India’s leading infrastructure Conglomerate with interests in steel, mining and power sector.\\n\\nHis vision at JSPL is driven by the core principle of Nation Building. Under his leadership, each of the businesses of JSPL is focused towards building world-class capabilities to make India self-reliant and a global economic powerhouse. His tenacity and drive have transformed JSPL into a conglomerate with presence across Africa, Oman and Australia.\\n\\nMr Jindal was declared the Industry Communicator of the year by the World Steel Association in 2016. He was featured by the Fortune magazine as Asia’s 25 Hottest People in Business for turning a struggling steel company into an Asian blue-chip giant. JSPL, under his leadership, was declared as the highest wealth creator in the world between the Years 2005-2009 by the Boston Consulting Group. In 2011, The Economic Times-Corporate Dossier list featured him as India’s Most Powerful CEOs. Ernst & Young conferred upon him the Entrepreneur of the Year Award in the field of Energy and Infrastructure in 2010.\\n\\nHe is the President of the Flag Foundation of India. He led a campaign to democratise the Tricolour, and his decade-long legal struggle resulted in a historic Supreme Court judgment allowing every Indian to display the Indian Flag with pride on all days of the year. He was elected twice to Indian Parliament where he served as a Parliamentarian for 10 years and made many contributions.\\n\\nMr Naveen Jindal is also the founding Chancellor of O P Jindal Global University, which is ranked the number one private university in India as per the QS World university rankings 2021.\\n\\nMr Jindal completed his MBA from the University of Texas at Dallas (UTD) in 1992. In recognition of his exceptional entrepreneurship skills and public service, the School of Management of the University of Texas, Dallas christened it as the Naveen Jindal School of Management. This recognition has led to the establishment of the Naveen Jindal Institute for Indo-American Business Studies.\\n\\nHe is an avid sportsperson, an active Polo Player and a National record holder in skeet shooting.\\n\\nHe is married to noted Indian classical dancer and a compassionate CSR leader Ms Shallu Jindal. The couple is blessed with two children, Venkatesh and Yashasvini."
/// user_id : "5"
/// slug : ""
/// location : "Maharashtra"
/// meta_title : ""
/// meta_keywords : ""
/// meta_description : ""
/// schedule_timestamp : "1670713200"
/// time_ago : "1 day ago"
/// save_timestamp : "13 Dec 2022"
/// status : "1"
/// designation : ""
/// featured_image : ""
/// featured_image_path : "http://192.168.50.34/jindal/assets/upload/feature_image/1670566557_carbon-fibre-voltt-card.jpg"
/// likes_count : 0
/// shares_count : 0
/// bookmark_count : 0
/// is_liked : 0
/// is_bookmarked : 0

Posts postsFromJson(String str) => Posts.fromJson(json.decode(str));
String postsToJson(Posts data) => json.encode(data.toJson());
class Posts {
  Posts({
      String? id, 
      String? title, 
      String? postTypeId, 
      String? postCategoryId, 
      String? shortDescription, 
      String? description, 
      String? userId, 
      String? slug, 
      String? location, 
      String? metaTitle, 
      String? metaKeywords, 
      String? metaDescription, 
      String? scheduleTimestamp, 
      String? timeAgo, 
      String? saveTimestamp, 
      String? status, 
      String? designation, 
      String? featuredImage, 
      String? featuredImagePath, 
      num? likesCount, 
      num? sharesCount, 
      num? bookmarkCount, 
      num? isLiked, 
      num? isBookmarked,}){
    _id = id;
    _title = title;
    _postTypeId = postTypeId;
    _postCategoryId = postCategoryId;
    _shortDescription = shortDescription;
    _description = description;
    _userId = userId;
    _slug = slug;
    _location = location;
    _metaTitle = metaTitle;
    _metaKeywords = metaKeywords;
    _metaDescription = metaDescription;
    _scheduleTimestamp = scheduleTimestamp;
    _timeAgo = timeAgo;
    _saveTimestamp = saveTimestamp;
    _status = status;
    _designation = designation;
    _featuredImage = featuredImage;
    _featuredImagePath = featuredImagePath;
    _likesCount = likesCount;
    _sharesCount = sharesCount;
    _bookmarkCount = bookmarkCount;
    _isLiked = isLiked;
    _isBookmarked = isBookmarked;
}

  Posts.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _postTypeId = json['post_type_id'];
    _postCategoryId = json['post_category_id'];
    _shortDescription = json['short_description'];
    _description = json['description'];
    _userId = json['user_id'];
    _slug = json['slug'];
    _location = json['location'];
    _metaTitle = json['meta_title'];
    _metaKeywords = json['meta_keywords'];
    _metaDescription = json['meta_description'];
    _scheduleTimestamp = json['schedule_timestamp'];
    _timeAgo = json['time_ago'];
    _saveTimestamp = json['save_timestamp'];
    _status = json['status'];
    _designation = json['designation'];
    _featuredImage = json['featured_image'];
    _featuredImagePath = json['featured_image_path'];
    _likesCount = json['likes_count'];
    _sharesCount = json['shares_count'];
    _bookmarkCount = json['bookmark_count'];
    _isLiked = json['is_liked'];
    _isBookmarked = json['is_bookmarked'];
  }
  String? _id;
  String? _title;
  String? _postTypeId;
  String? _postCategoryId;
  String? _shortDescription;
  String? _description;
  String? _userId;
  String? _slug;
  String? _location;
  String? _metaTitle;
  String? _metaKeywords;
  String? _metaDescription;
  String? _scheduleTimestamp;
  String? _timeAgo;
  String? _saveTimestamp;
  String? _status;
  String? _designation;
  String? _featuredImage;
  String? _featuredImagePath;
  num? _likesCount;
  num? _sharesCount;
  num? _bookmarkCount;
  num? _isLiked;
  num? _isBookmarked;
Posts copyWith({  String? id,
  String? title,
  String? postTypeId,
  String? postCategoryId,
  String? shortDescription,
  String? description,
  String? userId,
  String? slug,
  String? location,
  String? metaTitle,
  String? metaKeywords,
  String? metaDescription,
  String? scheduleTimestamp,
  String? timeAgo,
  String? saveTimestamp,
  String? status,
  String? designation,
  String? featuredImage,
  String? featuredImagePath,
  num? likesCount,
  num? sharesCount,
  num? bookmarkCount,
  num? isLiked,
  num? isBookmarked,
}) => Posts(  id: id ?? _id,
  title: title ?? _title,
  postTypeId: postTypeId ?? _postTypeId,
  postCategoryId: postCategoryId ?? _postCategoryId,
  shortDescription: shortDescription ?? _shortDescription,
  description: description ?? _description,
  userId: userId ?? _userId,
  slug: slug ?? _slug,
  location: location ?? _location,
  metaTitle: metaTitle ?? _metaTitle,
  metaKeywords: metaKeywords ?? _metaKeywords,
  metaDescription: metaDescription ?? _metaDescription,
  scheduleTimestamp: scheduleTimestamp ?? _scheduleTimestamp,
  timeAgo: timeAgo ?? _timeAgo,
  saveTimestamp: saveTimestamp ?? _saveTimestamp,
  status: status ?? _status,
  designation: designation ?? _designation,
  featuredImage: featuredImage ?? _featuredImage,
  featuredImagePath: featuredImagePath ?? _featuredImagePath,
  likesCount: likesCount ?? _likesCount,
  sharesCount: sharesCount ?? _sharesCount,
  bookmarkCount: bookmarkCount ?? _bookmarkCount,
  isLiked: isLiked ?? _isLiked,
  isBookmarked: isBookmarked ?? _isBookmarked,
);
  String? get id => _id;
  String? get title => _title;
  String? get postTypeId => _postTypeId;
  String? get postCategoryId => _postCategoryId;
  String? get shortDescription => _shortDescription;
  String? get description => _description;
  String? get userId => _userId;
  String? get slug => _slug;
  String? get location => _location;
  String? get metaTitle => _metaTitle;
  String? get metaKeywords => _metaKeywords;
  String? get metaDescription => _metaDescription;
  String? get scheduleTimestamp => _scheduleTimestamp;
  String? get timeAgo => _timeAgo;
  String? get saveTimestamp => _saveTimestamp;
  String? get status => _status;
  String? get designation => _designation;
  String? get featuredImage => _featuredImage;
  String? get featuredImagePath => _featuredImagePath;
  num? get likesCount => _likesCount;
  num? get sharesCount => _sharesCount;
  num? get bookmarkCount => _bookmarkCount;
  num? get isLiked => _isLiked;
  num? get isBookmarked => _isBookmarked;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['post_type_id'] = _postTypeId;
    map['post_category_id'] = _postCategoryId;
    map['short_description'] = _shortDescription;
    map['description'] = _description;
    map['user_id'] = _userId;
    map['slug'] = _slug;
    map['location'] = _location;
    map['meta_title'] = _metaTitle;
    map['meta_keywords'] = _metaKeywords;
    map['meta_description'] = _metaDescription;
    map['schedule_timestamp'] = _scheduleTimestamp;
    map['time_ago'] = _timeAgo;
    map['save_timestamp'] = _saveTimestamp;
    map['status'] = _status;
    map['designation'] = _designation;
    map['featured_image'] = _featuredImage;
    map['featured_image_path'] = _featuredImagePath;
    map['likes_count'] = _likesCount;
    map['shares_count'] = _sharesCount;
    map['bookmark_count'] = _bookmarkCount;
    map['is_liked'] = _isLiked;
    map['is_bookmarked'] = _isBookmarked;
    return map;
  }

}