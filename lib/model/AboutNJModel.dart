class AboutNJModel {
  String image ="";
  String title ="";
  String description = "";
  bool isOpen = false;

  AboutNJModel({
    String imageStatic = "",String titleStatic = "", String descriptionStatic = "", bool isOpenStatic = false}) {
    image = imageStatic;
    title = titleStatic;
    description = descriptionStatic;
    isOpen = isOpenStatic;
  }
}