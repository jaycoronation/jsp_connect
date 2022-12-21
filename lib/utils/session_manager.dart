
import 'session_manager_methods.dart';

class SessionManager {
  /*
  "user_id": "18",
  "name": "Jay Mistry",
  "email": "jay.m@coronation.in",
  "phone": "7433036724",
  "dob": "04 Jun 2018",
  "referral_code": "YQB427",
  "has_login_pin": true,
  "image": "https://apis.roboadviso.com/assets/uploads/profiles/profile_1626788768_98.jpg"
*/
  final String isLoggedIn = "isLoggedIn";
  final String deviceToken = "deviceToken";
  final String userId = "user_id";
  final String firstName = "first_name";
  final String lastName = "last_name";
  final String email = "email";
  final String mobileNumber = "mobile";
  final String notifications = "notifications";
  final String profile_pic = "profile_pic";
  final String is_first_time = "is_first_time";
  final String Get_APP_INFO_SHOW = "appInfoDialog";
  final String accessToken = "accessToken";
  final String companyId = "companyId";
  final String isDarkMode = "isDarkMode";
  final String notificationCount = "notification_count";

  bool? checkIsLoggedIn() {
    return SessionManagerMethods.getBool(isLoggedIn);
  }

  //set data into shared preferences...
  Future createLoginSession(String apiUserId,String apiFirstName ,String apiLastName,String apiEmail,
      String apiMobileNumber,String apiProfilePic,String accessTokenAPI,String companyIdAPI) async {
    await SessionManagerMethods.setBool(isLoggedIn, true);
    await SessionManagerMethods.setString(userId,apiUserId);
    await SessionManagerMethods.setString(firstName,apiFirstName);
    await SessionManagerMethods.setString(lastName,apiLastName);
    await SessionManagerMethods.setString(email,apiEmail);
    await SessionManagerMethods.setString(mobileNumber,apiMobileNumber);
    await SessionManagerMethods.setString(profile_pic, apiProfilePic);
    await SessionManagerMethods.setString(accessToken, accessTokenAPI);
    await SessionManagerMethods.setString(companyId, companyIdAPI);
  }

  Future<void> setIsLoggedIn(bool apiFirstName)
  async {
    await SessionManagerMethods.setBool(isLoggedIn, apiFirstName);
  }

  String? getUserId() {
    return SessionManagerMethods.getString(userId);
  }

  Future<void> setDeviceToken(String apiDeviceToken)
  async {
    await SessionManagerMethods.setString(deviceToken, apiDeviceToken);
  }

  String? getDeviceToken() {
    return SessionManagerMethods.getString(deviceToken);
  }

  Future<void> setDarkMode(bool apiFirstName)
  async {
    await SessionManagerMethods.setBool(isDarkMode, apiFirstName);
  }

  bool? getDarkMode() {
    return SessionManagerMethods.getBool(isDarkMode);
  }

  Future<void> setName(String apiFirstName)
  async {
    await SessionManagerMethods.setString(firstName, apiFirstName);
  }

  String? getName() {
    return SessionManagerMethods.getString(firstName);
  }
  String? getFullName() {

    String name = "";

      if(SessionManagerMethods.getString(firstName) == null)
      {
        name = "";
      }
      else
        {
          if(SessionManagerMethods.getString(firstName).toString().isNotEmpty)
          {
            name = SessionManagerMethods.getString(firstName).toString().trim();
          }
        }

    return name;
  }

  Future<void> setInfo(bool apisetInfo)
  async {
    await SessionManagerMethods.setBool(Get_APP_INFO_SHOW, apisetInfo);
  }

    bool? appInfo(){
     return SessionManagerMethods.getBool(Get_APP_INFO_SHOW);
    }

  Future<void> setLastName(String apiLastName)
  async {
    await SessionManagerMethods.setString(lastName, apiLastName);
  }

  String? getLastName() {
    return SessionManagerMethods.getString(lastName);
  }

  Future<void> setEmail(String apiEmail)
  async {
    await SessionManagerMethods.setString(email, apiEmail);
  }

  String? getEmail() {
    return SessionManagerMethods.getString(email);
  }

  Future<void> setPhone(String apiMobileNumber)
  async {
    await SessionManagerMethods.setString(mobileNumber, apiMobileNumber);
  }

  String? getPhone() {
    return SessionManagerMethods.getString(mobileNumber);
  }

  Future<void> setGender(String apiNotification)
  async {
    await SessionManagerMethods.setString(notifications, apiNotification);
  }

  String? getGender() {
    return SessionManagerMethods.getString(notifications);
  }

  Future<void> setAddress(String apiIsFirstTime)
  async {
    await SessionManagerMethods.setString(is_first_time, apiIsFirstTime);
  }

  Future<void> setUnreadNotificationCount(int count)
  async {
    await SessionManagerMethods.setInt(notificationCount, count);
  }

  int? getUnreadNotificationCount() {
    return SessionManagerMethods.getInt(notificationCount);
  }

  String? getAddress() {
    return SessionManagerMethods.getString(is_first_time);
  }

  Future<void> setImage(String apiImage)
  async {
    await SessionManagerMethods.setString(profile_pic, apiImage);
  }

  String? getImagePic() {
    return SessionManagerMethods.getString(profile_pic);
  }

  String? getAccessToken() {
    return SessionManagerMethods.getString(accessToken);
  }

  String? getCompanyID() {
    return SessionManagerMethods.getString(companyId);
  }
}