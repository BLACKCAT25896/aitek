
import 'dart:developer';

import 'package:get/get.dart';
import 'package:aitek/api_handle/api_checker.dart';
import 'package:aitek/feature/authentication/logic/authentication_controller.dart';
import 'package:aitek/feature/profile/domain/model/profile_model.dart';
import 'package:aitek/feature/profile/domain/model/trading_signal_item.dart';
import 'package:aitek/feature/profile/domain/repository/profile_repository.dart';

class ProfileController extends GetxController implements GetxService{
  final ProfileRepository profileRepository;
  ProfileController({required this.profileRepository});


  bool isLoading = false;
  ProfileModel? profileModel;
  Future<Response> getProfileInfo() async {
    isLoading = true;
    profileModel = null;
    Response? response = await profileRepository.getProfileInfo(
        Get.find<AuthenticationController>().getUserName(), Get.find<AuthenticationController>().getToken()
    );
    if (response?.statusCode == 200) {
      profileModel = ProfileModel.fromJson(response?.body);
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response!);
    }
    update();
    return response!;
  }


  String lastFourNumber = '';
  Future<void> getLastFourNumberPhone() async {
    Response? response = await profileRepository.getLastFourNumberPhone(
        Get.find<AuthenticationController>().getUserName(), Get.find<AuthenticationController>().getToken()
    );
    if (response?.statusCode == 200) {
      lastFourNumber = response?.body.toString() ?? '';
    }else{
      ApiChecker.checkApi(response!);
    }
    update();
  }


  List<TradingSignalItem>? tradingSignalItems;
  Future<void> getAnalyticSignals(String login, String currency, String from, String to) async {
    isLoading = true;
    tradingSignalItems = null;
    update();
    Response? response = await profileRepository.getAnalyticSignals(
        Get.find<AuthenticationController>().getUserName(), currency, from, to
    );
    if (response?.statusCode == 200) {
      isLoading = false;
      tradingSignalItems = (response?.body as List).map((e) => TradingSignalItem.fromJson(e)).toList();
    }else{
      isLoading = false;
      ApiChecker.checkApi(response!);
    }
    update();
  }


  List<String> currencies = [
    "EURUSD",
    "GBPUSD",
    "USDJPY",
    "USDCHF",
    "USDCAD",
    "AUDUSD",
    "NZDUSD"
  ];
  String? selectedCurrency;

  void setSelectedCurrency(String currency) {
    selectedCurrency = currency;
    update();
  }




}