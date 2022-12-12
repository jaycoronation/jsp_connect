import 'dart:convert';
/// success : 1
/// message : "List loaded successfully"
/// posts : [{"id":"37","title":"Plant Photos","post_type_id":"5","post_category_id":"1","short_description":"Plant Photos","description":"Plant Photos","user_id":"5","slug":"","location":"","meta_title":"","meta_keywords":"","meta_description":"","schedule_timestamp":"0","time_ago":"2 days ago","save_timestamp":"05 Dec 2022","status":"1","featured_image":"https://jsp.coronation.in/api/assets/upload/feature_image/1670241016-pp1.jpg","likes_count":0,"shares_count":0,"is_liked":0,"media":[{"post_id":37,"file_name":"1670240990_1707.jpg","file_size":"346724","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670240990_1707.jpg","alt_tag":"internal photos","sort_order":0,"company_id":6},{"post_id":37,"file_name":"1670240990_17071.jpg","file_size":"76382","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670240990_17071.jpg","alt_tag":"internal photos","sort_order":0,"company_id":6},{"post_id":37,"file_name":"1670240990_17072.jpg","file_size":"300297","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670240990_17072.jpg","alt_tag":"internal photos","sort_order":0,"company_id":6},{"post_id":37,"file_name":"1670240990_17073.jpg","file_size":"307040","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670240990_17073.jpg","alt_tag":"internal photos","sort_order":0,"company_id":6},{"post_id":37,"file_name":"1670240990_17074.jpg","file_size":"617490","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670240990_17074.jpg","alt_tag":"internal photos","sort_order":0,"company_id":6}]},{"id":"36","title":"Internal Photos","post_type_id":"5","post_category_id":"1","short_description":"Internal Photos","description":"Internal Photos","user_id":"5","slug":"","location":"","meta_title":"","meta_keywords":"","meta_description":"","schedule_timestamp":"0","time_ago":"2 days ago","save_timestamp":"05 Dec 2022","status":"1","featured_image":"https://jsp.coronation.in/api/assets/upload/feature_image/1670240789-ip1.jpg","likes_count":0,"shares_count":0,"is_liked":0,"media":[{"post_id":36,"file_name":"1670240815_8373.jpg","file_size":"278445","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670240815_8373.jpg","alt_tag":"internal photos","sort_order":0,"company_id":6},{"post_id":36,"file_name":"1670240815_83731.jpg","file_size":"211434","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670240815_83731.jpg","alt_tag":"internal photos","sort_order":0,"company_id":6},{"post_id":36,"file_name":"1670240815_83732.jpg","file_size":"231444","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670240815_83732.jpg","alt_tag":"internal photos","sort_order":0,"company_id":6},{"post_id":36,"file_name":"1670240815_83733.jpg","file_size":"296350","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670240815_83733.jpg","alt_tag":"internal photos","sort_order":0,"company_id":6},{"post_id":36,"file_name":"1670240815_83734.jpg","file_size":"121454","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670240815_83734.jpg","alt_tag":"internal photos","sort_order":0,"company_id":6}]},{"id":"35","title":"Awards Recognition","post_type_id":"5","post_category_id":"1","short_description":"Awards Recognition","description":"Awards Recognition","user_id":"5","slug":"","location":"","meta_title":"","meta_keywords":"","meta_description":"","schedule_timestamp":"0","time_ago":"2 days ago","save_timestamp":"05 Dec 2022","status":"1","featured_image":"https://jsp.coronation.in/api/assets/upload/feature_image/1670238690-awards_recognition.jpg","likes_count":0,"shares_count":0,"is_liked":0,"media":[{"post_id":35,"file_name":"1670237357_5179.jpg","file_size":"276232","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670237357_5179.jpg","alt_tag":"awards recognition","sort_order":0,"company_id":6},{"post_id":35,"file_name":"1670237357_51791.jpg","file_size":"77089","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670237357_51791.jpg","alt_tag":"awards recognition","sort_order":0,"company_id":6},{"post_id":35,"file_name":"1670237357_51792.jpg","file_size":"299335","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670237357_51792.jpg","alt_tag":"awards recognition","sort_order":0,"company_id":6},{"post_id":35,"file_name":"1670237357_51793.jpg","file_size":"228803","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670237357_51793.jpg","alt_tag":"awards recognition","sort_order":0,"company_id":6},{"post_id":35,"file_name":"1670237357_51794.jpg","file_size":"76401","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670237357_51794.jpg","alt_tag":"awards recognition","sort_order":0,"company_id":6}]}]

PostListResponse postListResponseFromJson(String str) => PostListResponse.fromJson(json.decode(str));
String postListResponseToJson(PostListResponse data) => json.encode(data.toJson());
class PostListResponse {
  PostListResponse({
      num? success, 
      String? message, 
      List<PostsData>? posts,}){
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
        _posts?.add(PostsData.fromJson(v));
      });
    }
  }
  num? _success;
  String? _message;
  List<PostsData>? _posts;
PostListResponse copyWith({  num? success,
  String? message,
  List<PostsData>? posts,
}) => PostListResponse(  success: success ?? _success,
  message: message ?? _message,
  posts: posts ?? _posts,
);
  num? get success => _success;
  String? get message => _message;
  List<PostsData>? get posts => _posts;

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

/// id : "37"
/// title : "Plant Photos"
/// post_type_id : "5"
/// post_category_id : "1"
/// short_description : "Plant Photos"
/// description : "Plant Photos"
/// user_id : "5"
/// slug : ""
/// location : ""
/// meta_title : ""
/// meta_keywords : ""
/// meta_description : ""
/// schedule_timestamp : "0"
/// time_ago : "2 days ago"
/// save_timestamp : "05 Dec 2022"
/// status : "1"
/// featured_image : "https://jsp.coronation.in/api/assets/upload/feature_image/1670241016-pp1.jpg"
/// likes_count : 0
/// shares_count : 0
/// is_liked : 0
/// media : [{"post_id":37,"file_name":"1670240990_1707.jpg","file_size":"346724","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670240990_1707.jpg","alt_tag":"internal photos","sort_order":0,"company_id":6},{"post_id":37,"file_name":"1670240990_17071.jpg","file_size":"76382","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670240990_17071.jpg","alt_tag":"internal photos","sort_order":0,"company_id":6},{"post_id":37,"file_name":"1670240990_17072.jpg","file_size":"300297","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670240990_17072.jpg","alt_tag":"internal photos","sort_order":0,"company_id":6},{"post_id":37,"file_name":"1670240990_17073.jpg","file_size":"307040","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670240990_17073.jpg","alt_tag":"internal photos","sort_order":0,"company_id":6},{"post_id":37,"file_name":"1670240990_17074.jpg","file_size":"617490","file_type":"image/jpeg","path":"assets/upload/posts/2022/12/","media":"https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670240990_17074.jpg","alt_tag":"internal photos","sort_order":0,"company_id":6}]

PostsData postsFromJson(String str) => PostsData.fromJson(json.decode(str));
String postsToJson(PostsData data) => json.encode(data.toJson());
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
  String? scheduleTimestamp,
  String? timeAgo,
  String? saveTimestamp,
  String? status,
  String? featuredImage,
  num? likesCount,
  num? sharesCount,
  num? isLiked,
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
    return map;
  }

}

/// post_id : 37
/// file_name : "1670240990_1707.jpg"
/// file_size : "346724"
/// file_type : "image/jpeg"
/// path : "assets/upload/posts/2022/12/"
/// media : "https://jsp.coronation.in/api/assets/upload/posts/2022/12/1670240990_1707.jpg"
/// alt_tag : "internal photos"
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