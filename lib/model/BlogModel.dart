class BlogModel {
  String time ="";
  String title ="";
  String location = "";
  String date = "";
  String image = "";
  bool isLiked = false;

  BlogModel({required String timeStatic, required String titleStatic, required String locationStatic, required String dateStatic, required String imageStatic, bool isLikedStatic = false}) {
    time = timeStatic;
    title = titleStatic;
    location = locationStatic;
    date = dateStatic;
    image = imageStatic;
    isLiked = isLikedStatic;
  }
}