
import 'package:file_picker/file_picker.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:mighty_school/api_handle/api_client.dart';
import 'package:mighty_school/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationRepository {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LocalizationRepository({required this.apiClient, required this.sharedPreferences});

  Future<Response> getAllLocalizationJson() async {
    return await apiClient.getData("");
  }

  Future<Response> setDefault(String name) async {
    return await apiClient.getData("${""}/set-default/$name");
  }

  Future<Response> deleteLocalizationJson() async {
    return await apiClient.getData("");
  }

  Future<Response> getLocalizationJson(String language) async {
    return await apiClient.getData("${""}?name=$language");
  }


  Future<Response> updateLocalizationSingleJson(String language, String key, String value) async {
    return await apiClient.postData("${""}/update-key/$language", {
      "key": key,
      "value": value
    });
  }



  Future<Response> addNewLanguage(String language, PlatformFile? jsonFile) async {
    return await apiClient.postMultipartData("",
      {},[],null, [MultipartDocument("file", jsonFile)]
    );
  }

  Future<Response> importJson(String language, PlatformFile? jsonFile) async {
    return await apiClient.postMultipartData("${""}/import/$language",
        {},[],null, [MultipartDocument("file", jsonFile)]
    );
  }

  Future<Response> exportJson(String language) async {
    return await apiClient.getData("${""}/export/$language");
  }


}