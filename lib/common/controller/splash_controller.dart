
import 'package:get/get.dart';
import 'package:mighty_school/api_handle/api_checker.dart';
import 'package:mighty_school/common/repository/splash_repository.dart';
import 'package:mighty_school/common/widget/custom_snackbar.dart';

class SplashController extends GetxController {
  final SplashRepository splashRepo;
  SplashController({required this.splashRepo});
  bool _firstTimeConnectionCheck = true;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  Future<void> getConfigData() async {
    Response response = await splashRepo.getConfigData();
    if(response.hasError) {
      ApiChecker.checkApi(response);
    }else {
      showCustomSnackBar("${response.body}'");
    }
  }

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo.removeSharedData();
  }




  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }
}
