import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mighty_school/api_handle/api_client.dart';
import 'package:mighty_school/util/app_constants.dart';

class ProfileRepository{
  final ApiClient apiClient;
  ProfileRepository({required this.apiClient});


  Future<Response?> getProfileInfo(String login, String token) async {
    return await apiClient.postData(AppConstants.profile, {
      "login": login,
      "token": token
    });
  }


  Future<Response?> getLastFourNumberPhone(String login, String token) async {
    return await apiClient.postData(AppConstants.getLastFourNumberPhone, {
      "login": login,
      "token": token
    });
  }


  Future<Response?> getAnalyticSignals(String login, String currency, String from, String to) async {
    return await apiClient.getFullUrlData("${AppConstants.secondBaseUrl}${AppConstants.getAnalyticSignals}/$login?tradingsystem=3&pairs=$currency&from=$from&to=$to");
  }


}