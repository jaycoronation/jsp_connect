import 'dart:convert';

import 'DashBoardDataResponse.dart';
/// success : 1
/// message : "List loaded successfully"
/// posts : [{"id":"78","title":"Champions At Work- Jagat Kalyan Kumar","post_type_id":"3","post_category_id":"","short_description":"","description":"<html>\n<head>\n\t<title></title>\n</head>\n<body>\n<p>Meet Jagat Kalyan Kumar, Quality Assurance Manager at our Machinery Division in Raipur, Chhattisgarh. Passionate about technology and heavy machinery, Jagat is one of the many young engineers working tirelessly to build the nation of our dreams. He is one of our <a dir=\"auto\" href=\"https://www.youtube.com/hashtag/championsatwork\" spellcheck=\"false\">#ChampionsAtWork</a></p>\n</body>\n</html>\n","user_id":"","slug":"","location":"","meta_title":"","meta_keywords":"","meta_description":"","status":"1","social_media_type":"","social_media_link":"","schedule_timestamp":"09 Dec 2022","save_timestamp":"09 Dec 2022","featured_image":"https://jsp.coronation.in/api/assets/upload/feature_image/1670603761_Screenshot_2022-12-09_at_9.55.07_PM.png","likes_count":0,"shares_count":12,"bookmark_count":0,"is_liked":0,"is_bookmarked":0,"media":[{"post_id":78,"file_name":"1670603263_Champions_At_Work-_Jagat_Kalyan_Kumar.mp4","file_size":"20762424","file_type":"video/mp4","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670603263_Champions_At_Work-_Jagat_Kalyan_Kumar.mp4","alt_tag":"","sort_order":0,"company_id":6}]}]

PostListResponse postListResponseFromJson(String str) => PostListResponse.fromJson(json.decode(str));
String postListResponseToJson(PostListResponse data) => json.encode(data.toJson());
class PostListResponse {
  PostListResponse({
      num? success, 
      String? message, 
      List<Posts>? posts,}){
    _success = success;
    _message = message;
    _posts = posts;
}

  PostListResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    if (json['posts'] != null) {
      _posts = [];
      json['posts'].forEach((v) {
        _posts?.add(Posts.fromJson(v));
      });
    }
  }
  num? _success;
  String? _message;
  List<Posts>? _posts;
PostListResponse copyWith({  num? success,
  String? message,
  List<Posts>? posts,
}) => PostListResponse(  success: success ?? _success,
  message: message ?? _message,
  posts: posts ?? _posts,
);
  num? get success => _success;
  String? get message => _message;
  List<Posts>? get posts => _posts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_posts != null) {
      map['posts'] = _posts?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "78"
/// title : "Champions At Work- Jagat Kalyan Kumar"
/// post_type_id : "3"
/// post_category_id : ""
/// short_description : ""
/// description : "<html>\n<head>\n\t<title></title>\n</head>\n<body>\n<p>Meet Jagat Kalyan Kumar, Quality Assurance Manager at our Machinery Division in Raipur, Chhattisgarh. Passionate about technology and heavy machinery, Jagat is one of the many young engineers working tirelessly to build the nation of our dreams. He is one of our <a dir=\"auto\" href=\"https://www.youtube.com/hashtag/championsatwork\" spellcheck=\"false\">#ChampionsAtWork</a></p>\n</body>\n</html>\n"
/// user_id : ""
/// slug : ""
/// location : ""
/// meta_title : ""
/// meta_keywords : ""
/// meta_description : ""
/// status : "1"
/// social_media_type : ""
/// social_media_link : ""
/// schedule_timestamp : "09 Dec 2022"
/// save_timestamp : "09 Dec 2022"
/// featured_image : "https://jsp.coronation.in/api/assets/upload/feature_image/1670603761_Screenshot_2022-12-09_at_9.55.07_PM.png"
/// likes_count : 0
/// shares_count : 12
/// bookmark_count : 0
/// is_liked : 0
/// is_bookmarked : 0
/// media : [{"post_id":78,"file_name":"1670603263_Champions_At_Work-_Jagat_Kalyan_Kumar.mp4","file_size":"20762424","file_type":"video/mp4","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670603263_Champions_At_Work-_Jagat_Kalyan_Kumar.mp4","alt_tag":"","sort_order":0,"company_id":6}]

Posts postsFromJson(String str) => Posts.fromJson(json.decode(str));
String postsToJson(Posts data) => json.encode(data.toJson());
class PostsData {
  PostsData({
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
      String? status, 
      String? socialMediaType, 
      String? socialMediaLink, 
      String? scheduleTimestamp, 
      String? saveTimestamp, 
      String? featuredImage, 
      num? likesCount, 
      num? sharesCount, 
      num? bookmarkCount, 
      num? isLiked, 
      num? isBookmarked, 
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
    _status = status;
    _socialMediaType = socialMediaType;
    _socialMediaLink = socialMediaLink;
    _scheduleTimestamp = scheduleTimestamp;
    _saveTimestamp = saveTimestamp;
    _featuredImage = featuredImage;
    _likesCount = likesCount;
    _sharesCount = sharesCount;
    _bookmarkCount = bookmarkCount;
    _isLiked = isLiked;
    _isBookmarked = isBookmarked;
    _media = media;
}

  PostsData.fromJson(dynamic json) {
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
    _status = json['status'];
    _socialMediaType = json['social_media_type'];
    _socialMediaLink = json['social_media_link'];
    _scheduleTimestamp = json['schedule_timestamp'];
    _saveTimestamp = json['save_timestamp'];
    _featuredImage = json['featured_image'];
    _likesCount = json['likes_count'];
    _sharesCount = json['shares_count'];
    _bookmarkCount = json['bookmark_count'];
    _isLiked = json['is_liked'];
    _isBookmarked = json['is_bookmarked'];
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
  String? _status;
  String? _socialMediaType;
  String? _socialMediaLink;
  String? _scheduleTimestamp;
  String? _saveTimestamp;
  String? _featuredImage;
  num? _likesCount;
  num? _sharesCount;
  num? _bookmarkCount;
  num? _isLiked;
  num? _isBookmarked;
  List<Media>? _media;
PostsData copyWith({  String? id,
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
  String? status,
  String? socialMediaType,
  String? socialMediaLink,
  String? scheduleTimestamp,
  String? saveTimestamp,
  String? featuredImage,
  num? likesCount,
  num? sharesCount,
  num? bookmarkCount,
  num? isLiked,
  num? isBookmarked,
  List<Media>? media,
}) => PostsData(  id: id ?? _id,
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
  status: status ?? _status,
  socialMediaType: socialMediaType ?? _socialMediaType,
  socialMediaLink: socialMediaLink ?? _socialMediaLink,
  scheduleTimestamp: scheduleTimestamp ?? _scheduleTimestamp,
  saveTimestamp: saveTimestamp ?? _saveTimestamp,
  featuredImage: featuredImage ?? _featuredImage,
  likesCount: likesCount ?? _likesCount,
  sharesCount: sharesCount ?? _sharesCount,
  bookmarkCount: bookmarkCount ?? _bookmarkCount,
  isLiked: isLiked ?? _isLiked,
  isBookmarked: isBookmarked ?? _isBookmarked,
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
  String? get status => _status;
  String? get socialMediaType => _socialMediaType;
  String? get socialMediaLink => _socialMediaLink;
  String? get scheduleTimestamp => _scheduleTimestamp;
  String? get saveTimestamp => _saveTimestamp;
  String? get featuredImage => _featuredImage;
  num? get likesCount => _likesCount;
  num? get sharesCount => _sharesCount;
  num? get bookmarkCount => _bookmarkCount;
  num? get isLiked => _isLiked;
  num? get isBookmarked => _isBookmarked;
  List<Media>? get media => _media;

  set setIsLikeMain(num value) {
    _isLiked = value;
  }

  set setSharesCount(num value) {
    _sharesCount = value;
  }

  set setIsBookmarked(num value) {
    _isBookmarked = value;
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
    map['status'] = _status;
    map['social_media_type'] = _socialMediaType;
    map['social_media_link'] = _socialMediaLink;
    map['schedule_timestamp'] = _scheduleTimestamp;
    map['save_timestamp'] = _saveTimestamp;
    map['featured_image'] = _featuredImage;
    map['likes_count'] = _likesCount;
    map['shares_count'] = _sharesCount;
    map['bookmark_count'] = _bookmarkCount;
    map['is_liked'] = _isLiked;
    map['is_bookmarked'] = _isBookmarked;
    if (_media != null) {
      map['media'] = _media?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// post_id : 78
/// file_name : "1670603263_Champions_At_Work-_Jagat_Kalyan_Kumar.mp4"
/// file_size : "20762424"
/// file_type : "video/mp4"
/// path : "assets/upload/posts/2022/12/"
/// media : "https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670603263_Champions_At_Work-_Jagat_Kalyan_Kumar.mp4"
/// alt_tag : ""
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