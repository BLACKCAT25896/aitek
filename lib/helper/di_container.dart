import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:aitek/api_handle/soap_client.dart';
import 'package:aitek/common/controller/paginate_dropdown_controller.dart';
import 'package:aitek/feature/promo/controller/promo_controller.dart';
import 'package:aitek/feature/promo/domain/repository/promo_repository.dart';
import 'package:aitek/localization/domain/repositories/localization_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:aitek/api_handle/api_client.dart';
import 'package:aitek/common/controller/datepicker_controller.dart';
import 'package:aitek/common/controller/pick_image_controller.dart';
import 'package:aitek/common/controller/splash_controller.dart';
import 'package:aitek/common/controller/theme_controller.dart';
import 'package:aitek/common/repository/splash_repository.dart';
import 'package:aitek/feature/authentication/domain/authentication_repository.dart';
import 'package:aitek/feature/authentication/logic/authentication_controller.dart';
import 'package:aitek/feature/dashboard/controller/dashboard_controller.dart';
import 'package:aitek/feature/profile/domain/repository/profile_repository.dart';
import 'package:aitek/feature/profile/logic/profile_controller.dart';
import 'package:aitek/localization/domain/model/language_model.dart';
import 'package:aitek/localization/controller/localization_controller.dart';
import 'package:aitek/util/app_constants.dart';

Future<Map<String, Map<String, String>>> init() async {



  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));
  Get.lazyPut(() => const SoapClient(baseUrl: AppConstants.soapBaseUrl));

  // Repository
  Get.lazyPut(() => SplashRepository(apiClient : Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => ProfileRepository(apiClient : Get.find()));
  Get.lazyPut(() => AuthenticationRepository(apiClient : Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => LocalizationRepository(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => PaginatedDropdownController());
  Get.lazyPut(() => ProfileController(profileRepository: Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => AuthenticationController(authenticationRepository: Get.find()));
  Get.lazyPut(() => DashboardController());

  Get.lazyPut(() => DatePickerController());
  Get.lazyPut(() => PickImageController());

  Get.lazyPut(() => PromoRepository(soapClient: Get.find()));
  Get.lazyPut(() => PromoController(promoRepository: Get.find()));






  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> languageJson = {};
    mappedJson.forEach((key, value) {
      languageJson[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = languageJson;
  }
  return languages;
}
