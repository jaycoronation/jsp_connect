import 'dart:convert';
/// success : 1
/// message : "List loaded successfully"
/// post_details : {"id":"28","title":"JSPL in solidarity with nation's fight against Corona","post_type_id":"3","post_category_id":"1","short_description":"The Covid-19 crisis is arguably the biggest challenge being faced by the country and it's people.","description":"The Covid-19 crisis is arguably the biggest challenge being faced by the country and it's people. With all the efforts that the government is making, all of us are making, we are sure we are going to come out stronger out of this. Let's Stand Together to Fight Corona. We shall overcome.... He talks about Syngas and coal gasification technologies, their economic and technical viability. And plans of JSPL to reduce debt in next 3-4 years.","user_id":"5","slug":"","location":"","meta_title":"The Covid-19 crisis is arguably","meta_keywords":"","meta_description":"","schedule_timestamp":"0","time_ago":"2 days ago","save_timestamp":"05 Dec 2022","status":"1","featured_image":"https://jsp.coronation.in/api/assets/upload/feature_image/1670223008-video2_vimage2.jpg","likes_count":0,"shares_count":0,"is_liked":0,"media":[{"post_id":28,"file_name":"1670224323_9763.mp4","file_size":"10304944","file_type":"video/mp4","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670224323_9763.mp4","alt_tag":"videos","sort_order":0,"company_id":6}],"reated_posts":[{"id":"28","title":"JSPL in solidarity with nation's fight against Corona","post_type_id":"3","post_category_id":"1","short_description":"The Covid-19 crisis is arguably the biggest challenge being faced by the country and it's people.","description":"The Covid-19 crisis is arguably the biggest challenge being faced by the country and it's people. With all the efforts that the government is making, all of us are making, we are sure we are going to come out stronger out of this. Let's Stand Together to Fight Corona. We shall overcome.... He talks about Syngas and coal gasification technologies, their economic and technical viability. And plans of JSPL to reduce debt in next 3-4 years.","user_id":"5","slug":"","location":"","meta_title":"The Covid-19 crisis is arguably","meta_keywords":"","meta_description":"","schedule_timestamp":"0","time_ago":"2 days ago","save_timestamp":"05 Dec 2022","status":"1","featured_image":"https://jsp.coronation.in/api/assets/upload/feature_image/1670223008-video2_vimage2.jpg","likes_count":0,"shares_count":0,"is_liked":0,"media":[{"post_id":28,"file_name":"1670224323_9763.mp4","file_size":"10304944","file_type":"video/mp4","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670224323_9763.mp4","alt_tag":"videos","sort_order":0,"company_id":6}]},{"id":"27","title":"VR Sharma Exclusive Interview with Metalogic PMS","post_type_id":"3","post_category_id":"1","short_description":"VR Sharma, Managing Director at Jindal Steel & Power Limited, Exclusive Interview with Monica Bachchan, Founder Metalogic PMS","description":"VR Sharma, Managing Director at Jindal Steel & Power Limited, Exclusive Interview with Monica Bachchan, Founder Metalogic PMS. He talks about Syngas and coal gasification technologies, their economic and technical viability. And plans of JSPL to reduce debt in next 3-4 years.","user_id":"5","slug":"","location":"","meta_title":"Jindal Steel & Power Limited","meta_keywords":"","meta_description":"","schedule_timestamp":"0","time_ago":"2 days ago","save_timestamp":"05 Dec 2022","status":"1","featured_image":"https://jsp.coronation.in/api/assets/upload/feature_image/1670222866-Video3_image3.jpg","likes_count":0,"shares_count":0,"is_liked":0,"media":[{"post_id":27,"file_name":"1670225924_6601.mp4","file_size":"26002813","file_type":"video/mp4","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670225924_6601.mp4","alt_tag":"videos","sort_order":0,"company_id":6}]},{"id":"26","title":"VR Sharma On Supreme Court Order Allowing JSPL To Sell Some Of Its Iron Ore In Odisha","post_type_id":"3","post_category_id":"1","short_description":"JSPL's MD VR Sharma speaks about the Supreme Court order allowing the company to sell some of its iron ore in Odisha","description":"JSPL's MD VR Sharma speaks about the Supreme Court order allowing the company to sell some of its iron ore in Odisha","user_id":"5","slug":"slug","location":"","meta_title":"JSPL's MD VR Sharma speaks about the Supreme Court","meta_keywords":"","meta_description":"","schedule_timestamp":"0","time_ago":"2 days ago","save_timestamp":"05 Dec 2022","status":"1","featured_image":"https://jsp.coronation.in/api/assets/upload/feature_image/1670222720-Video1_Image1.jpg","likes_count":0,"shares_count":0,"is_liked":0,"media":[{"post_id":26,"file_name":"1670225374_3288.mp4","file_size":"10125366","file_type":"video/mp4","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670225374_3288.mp4","alt_tag":"videos","sort_order":0,"company_id":6}]}]}

PostDetailsResponse postDetailsResponseFromJson(String str) => PostDetailsResponse.fromJson(json.decode(str));
String postDetailsResponseToJson(PostDetailsResponse data) => json.encode(data.toJson());
class PostDetailsResponse {
  PostDetailsResponse({
      num? success, 
      String? message, 
      PostDetails? postDetails,}){
    _success = success;
    _message = message;
    _postDetails = postDetails;
}

  PostDetailsResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _postDetails = json['post_details'] != null ? PostDetails.fromJson(json['post_details']) : null;
  }
  num? _success;
  String? _message;
  PostDetails? _postDetails;
PostDetailsResponse copyWith({  num? success,
  String? message,
  PostDetails? postDetails,
}) => PostDetailsResponse(  success: success ?? _success,
  message: message ?? _message,
  postDetails: postDetails ?? _postDetails,
);
  num? get success => _success;
  String? get message => _message;
  PostDetails? get postDetails => _postDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_postDetails != null) {
      map['post_details'] = _postDetails?.toJson();
    }
    return map;
  }

}

/// id : "28"
/// title : "JSPL in solidarity with nation's fight against Corona"
/// post_type_id : "3"
/// post_category_id : "1"
/// short_description : "The Covid-19 crisis is arguably the biggest challenge being faced by the country and it's people."
/// description : "The Covid-19 crisis is arguably the biggest challenge being faced by the country and it's people. With all the efforts that the government is making, all of us are making, we are sure we are going to come out stronger out of this. Let's Stand Together to Fight Corona. We shall overcome.... He talks about Syngas and coal gasification technologies, their economic and technical viability. And plans of JSPL to reduce debt in next 3-4 years."
/// user_id : "5"
/// slug : ""
/// location : ""
/// meta_title : "The Covid-19 crisis is arguably"
/// meta_keywords : ""
/// meta_description : ""
/// schedule_timestamp : "0"
/// time_ago : "2 days ago"
/// save_timestamp : "05 Dec 2022"
/// status : "1"
/// featured_image : "https://jsp.coronation.in/api/assets/upload/feature_image/1670223008-video2_vimage2.jpg"
/// likes_count : 0
/// shares_count : 0
/// is_liked : 0
/// media : [{"post_id":28,"file_name":"1670224323_9763.mp4","file_size":"10304944","file_type":"video/mp4","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670224323_9763.mp4","alt_tag":"videos","sort_order":0,"company_id":6}]
/// reated_posts : [{"id":"28","title":"JSPL in solidarity with nation's fight against Corona","post_type_id":"3","post_category_id":"1","short_description":"The Covid-19 crisis is arguably the biggest challenge being faced by the country and it's people.","description":"The Covid-19 crisis is arguably the biggest challenge being faced by the country and it's people. With all the efforts that the government is making, all of us are making, we are sure we are going to come out stronger out of this. Let's Stand Together to Fight Corona. We shall overcome.... He talks about Syngas and coal gasification technologies, their economic and technical viability. And plans of JSPL to reduce debt in next 3-4 years.","user_id":"5","slug":"","location":"","meta_title":"The Covid-19 crisis is arguably","meta_keywords":"","meta_description":"","schedule_timestamp":"0","time_ago":"2 days ago","save_timestamp":"05 Dec 2022","status":"1","featured_image":"https://jsp.coronation.in/api/assets/upload/feature_image/1670223008-video2_vimage2.jpg","likes_count":0,"shares_count":0,"is_liked":0,"media":[{"post_id":28,"file_name":"1670224323_9763.mp4","file_size":"10304944","file_type":"video/mp4","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670224323_9763.mp4","alt_tag":"videos","sort_order":0,"company_id":6}]},{"id":"27","title":"VR Sharma Exclusive Interview with Metalogic PMS","post_type_id":"3","post_category_id":"1","short_description":"VR Sharma, Managing Director at Jindal Steel & Power Limited, Exclusive Interview with Monica Bachchan, Founder Metalogic PMS","description":"VR Sharma, Managing Director at Jindal Steel & Power Limited, Exclusive Interview with Monica Bachchan, Founder Metalogic PMS. He talks about Syngas and coal gasification technologies, their economic and technical viability. And plans of JSPL to reduce debt in next 3-4 years.","user_id":"5","slug":"","location":"","meta_title":"Jindal Steel & Power Limited","meta_keywords":"","meta_description":"","schedule_timestamp":"0","time_ago":"2 days ago","save_timestamp":"05 Dec 2022","status":"1","featured_image":"https://jsp.coronation.in/api/assets/upload/feature_image/1670222866-Video3_image3.jpg","likes_count":0,"shares_count":0,"is_liked":0,"media":[{"post_id":27,"file_name":"1670225924_6601.mp4","file_size":"26002813","file_type":"video/mp4","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670225924_6601.mp4","alt_tag":"videos","sort_order":0,"company_id":6}]},{"id":"26","title":"VR Sharma On Supreme Court Order Allowing JSPL To Sell Some Of Its Iron Ore In Odisha","post_type_id":"3","post_category_id":"1","short_description":"JSPL's MD VR Sharma speaks about the Supreme Court order allowing the company to sell some of its iron ore in Odisha","description":"JSPL's MD VR Sharma speaks about the Supreme Court order allowing the company to sell some of its iron ore in Odisha","user_id":"5","slug":"slug","location":"","meta_title":"JSPL's MD VR Sharma speaks about the Supreme Court","meta_keywords":"","meta_description":"","schedule_timestamp":"0","time_ago":"2 days ago","save_timestamp":"05 Dec 2022","status":"1","featured_image":"https://jsp.coronation.in/api/assets/upload/feature_image/1670222720-Video1_Image1.jpg","likes_count":0,"shares_count":0,"is_liked":0,"media":[{"post_id":26,"file_name":"1670225374_3288.mp4","file_size":"10125366","file_type":"video/mp4","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670225374_3288.mp4","alt_tag":"videos","sort_order":0,"company_id":6}]}]

PostDetails postDetailsFromJson(String str) => PostDetails.fromJson(json.decode(str));
String postDetailsToJson(PostDetails data) => json.encode(data.toJson());
class PostDetails {
  PostDetails({
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
      String? featuredImage, 
      num? likesCount, 
      num? sharesCount, 
      num? isLiked, 
      List<Media>? media, 
      List<ReatedPosts>? reatedPosts,}){
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
    _featuredImage = featuredImage;
    _likesCount = likesCount;
    _sharesCount = sharesCount;
    _isLiked = isLiked;
    _media = media;
    _reatedPosts = reatedPosts;
}

  PostDetails.fromJson(dynamic json) {
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
    _featuredImage = json['featured_image'];
    _likesCount = json['likes_count'];
    _sharesCount = json['shares_count'];
    _isLiked = json['is_liked'];
    if (json['media'] != null) {
      _media = [];
      json['media'].forEach((v) {
        _media?.add(Media.fromJson(v));
      });
    }
    if (json['reated_posts'] != null) {
      _reatedPosts = [];
      json['reated_posts'].forEach((v) {
        _reatedPosts?.add(ReatedPosts.fromJson(v));
      });
    }
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
  String? _featuredImage;
  num? _likesCount;
  num? _sharesCount;
  num? _isLiked;
  List<Media>? _media;
  List<ReatedPosts>? _reatedPosts;
PostDetails copyWith({  String? id,
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
  String? featuredImage,
  num? likesCount,
  num? sharesCount,
  num? isLiked,
  List<Media>? media,
  List<ReatedPosts>? reatedPosts,
}) => PostDetails(  id: id ?? _id,
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
  featuredImage: featuredImage ?? _featuredImage,
  likesCount: likesCount ?? _likesCount,
  sharesCount: sharesCount ?? _sharesCount,
  isLiked: isLiked ?? _isLiked,
  media: media ?? _media,
  reatedPosts: reatedPosts ?? _reatedPosts,
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
  String? get featuredImage => _featuredImage;
  num? get likesCount => _likesCount;
  num? get sharesCount => _sharesCount;
  num? get isLiked => _isLiked;
  List<Media>? get media => _media;
  List<ReatedPosts>? get reatedPosts => _reatedPosts;

  set setIsLikeMain(num value) {
    _isLiked = value;
  }

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
    map['featured_image'] = _featuredImage;
    map['likes_count'] = _likesCount;
    map['shares_count'] = _sharesCount;
    map['is_liked'] = _isLiked;
    if (_media != null) {
      map['media'] = _media?.map((v) => v.toJson()).toList();
    }
    if (_reatedPosts != null) {
      map['reated_posts'] = _reatedPosts?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "28"
/// title : "JSPL in solidarity with nation's fight against Corona"
/// post_type_id : "3"
/// post_category_id : "1"
/// short_description : "The Covid-19 crisis is arguably the biggest challenge being faced by the country and it's people."
/// description : "The Covid-19 crisis is arguably the biggest challenge being faced by the country and it's people. With all the efforts that the government is making, all of us are making, we are sure we are going to come out stronger out of this. Let's Stand Together to Fight Corona. We shall overcome.... He talks about Syngas and coal gasification technologies, their economic and technical viability. And plans of JSPL to reduce debt in next 3-4 years."
/// user_id : "5"
/// slug : ""
/// location : ""
/// meta_title : "The Covid-19 crisis is arguably"
/// meta_keywords : ""
/// meta_description : ""
/// schedule_timestamp : "0"
/// time_ago : "2 days ago"
/// save_timestamp : "05 Dec 2022"
/// status : "1"
/// featured_image : "https://jsp.coronation.in/api/assets/upload/feature_image/1670223008-video2_vimage2.jpg"
/// likes_count : 0
/// shares_count : 0
/// is_liked : 0
/// media : [{"post_id":28,"file_name":"1670224323_9763.mp4","file_size":"10304944","file_type":"video/mp4","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670224323_9763.mp4","alt_tag":"videos","sort_order":0,"company_id":6}]

ReatedPosts reatedPostsFromJson(String str) => ReatedPosts.fromJson(json.decode(str));
String reatedPostsToJson(ReatedPosts data) => json.encode(data.toJson());
class ReatedPosts {
  ReatedPosts({
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
      String? featuredImage, 
      num? likesCount, 
      num? sharesCount, 
      num? isLiked, 
      List<Media>? media,}){
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
    _featuredImage = featuredImage;
    _likesCount = likesCount;
    _sharesCount = sharesCount;
    _isLiked = isLiked;
    _media = media;
}

  ReatedPosts.fromJson(dynamic json) {
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
    _featuredImage = json['featured_image'];
    _likesCount = json['likes_count'];
    _sharesCount = json['shares_count'];
    _isLiked = json['is_liked'];
    if (json['media'] != null) {
      _media = [];
      json['media'].forEach((v) {
        _media?.add(Media.fromJson(v));
      });
    }
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
  String? _featuredImage;
  num? _likesCount;
  num? _sharesCount;
  num? _isLiked;
  List<Media>? _media;
ReatedPosts copyWith({  String? id,
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
  String? featuredImage,
  num? likesCount,
  num? sharesCount,
  num? isLiked,
  List<Media>? media,
}) => ReatedPosts(  id: id ?? _id,
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
  featuredImage: featuredImage ?? _featuredImage,
  likesCount: likesCount ?? _likesCount,
  sharesCount: sharesCount ?? _sharesCount,
  isLiked: isLiked ?? _isLiked,
  media: media ?? _media,
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
  String? get featuredImage => _featuredImage;
  num? get likesCount => _likesCount;
  num? get sharesCount => _sharesCount;
  num? get isLiked => _isLiked;
  List<Media>? get media => _media;

  set setIsLike(num value) {
    _isLiked = value;
  }

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
    map['featured_image'] = _featuredImage;
    map['likes_count'] = _likesCount;
    map['shares_count'] = _sharesCount;
    map['is_liked'] = _isLiked;
    if (_media != null) {
      map['media'] = _media?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// post_id : 28
/// file_name : "1670224323_9763.mp4"
/// file_size : "10304944"
/// file_type : "video/mp4"
/// path : "assets/upload/posts/2022/12/"
/// media : "https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670224323_9763.mp4"
/// alt_tag : "videos"
/// sort_order : 0
/// company_id : 6

Media mediaFromJson(String str) => Media.fromJson(json.decode(str));
String mediaToJson(Media data) => json.encode(data.toJson());
class Media {
  Media({
      num? postId, 
      String? fileName, 
      String? fileSize, 
      String? fileType, 
      String? path, 
      String? media, 
      String? altTag, 
      num? sortOrder, 
      num? companyId,}){
    _postId = postId;
    _fileName = fileName;
    _fileSize = fileSize;
    _fileType = fileType;
    _path = path;
    _media = media;
    _altTag = altTag;
    _sortOrder = sortOrder;
    _companyId = companyId;
}

  Media.fromJson(dynamic json) {
    _postId = json['post_id'];
    _fileName = json['file_name'];
    _fileSize = json['file_size'];
    _fileType = json['file_type'];
    _path = json['path'];
    _media = json['media'];
    _altTag = json['alt_tag'];
    _sortOrder = json['sort_order'];
    _companyId = json['company_id'];
  }
  num? _postId;
  String? _fileName;
  String? _fileSize;
  String? _fileType;
  String? _path;
  String? _media;
  String? _altTag;
  num? _sortOrder;
  num? _companyId;
Media copyWith({  num? postId,
  String? fileName,
  String? fileSize,
  String? fileType,
  String? path,
  String? media,
  String? altTag,
  num? sortOrder,
  num? companyId,
}) => Media(  postId: postId ?? _postId,
  fileName: fileName ?? _fileName,
  fileSize: fileSize ?? _fileSize,
  fileType: fileType ?? _fileType,
  path: path ?? _path,
  media: media ?? _media,
  altTag: altTag ?? _altTag,
  sortOrder: sortOrder ?? _sortOrder,
  companyId: companyId ?? _companyId,
);
  num? get postId => _postId;
  String? get fileName => _fileName;
  String? get fileSize => _fileSize;
  String? get fileType => _fileType;
  String? get path => _path;
  String? get media => _media;
  String? get altTag => _altTag;
  num? get sortOrder => _sortOrder;
  num? get companyId => _companyId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['post_id'] = _postId;
    map['file_name'] = _fileName;
    map['file_size'] = _fileSize;
    map['file_type'] = _fileType;
    map['path'] = _path;
    map['media'] = _media;
    map['alt_tag'] = _altTag;
    map['sort_order'] = _sortOrder;
    map['company_id'] = _companyId;
    return map;
  }

}