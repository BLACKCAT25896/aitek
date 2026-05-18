import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mighty_school/api_handle/api_client.dart';
import 'package:mighty_school/util/app_constants.dart';

class AuthenticationRepository{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthenticationRepository( {required this.apiClient, required this.sharedPreferences,});

  Future<Response?> login({required String email, required String password}) async {
    return await apiClient.postData(AppConstants.loginUri,
        {"login": email, "password": password});
  }
  Future<Response?> loginTwo({required String login, required String password}) async {
    return await apiClient.postFullUrlData("${AppConstants.secondBaseUrl}${AppConstants.loginTwoUri}",
        {"login": login, "password": password});
  }
  Future<bool?> saveUserToken(String token) async {
    return await sharedPreferences.setString(AppConstants.token, token);

  }

  Future<bool?> saveUserTokenTwo(String token) async {
    apiClient.updateHeader(token, null);
    return await sharedPreferences.setString(AppConstants.tokenTwo, token);

  }


  Future<bool?> setUserName(String userName) async {
    return await sharedPreferences.setString(AppConstants.username, userName);
  }

  String getUserName() {
    return sharedPreferences.getString(AppConstants.username) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }
  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  String getUserTokenTwo() {
    return sharedPreferences.getString(AppConstants.tokenTwo) ?? "";
  }

  Future<void> saveEmailAndPassword(String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.userPassword, password);
      await sharedPreferences.setString(AppConstants.userNumber, number);

    } catch (e) {
      rethrow;
    }
  }
  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.token);
    return true;
  }

}