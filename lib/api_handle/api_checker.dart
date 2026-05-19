
import 'package:get/get.dart';
import 'package:aitek/api_handle/error_response.dart';
import 'package:aitek/common/widget/custom_snackbar.dart';
import 'package:aitek/feature/authentication/logic/authentication_controller.dart';
import 'package:aitek/feature/authentication/presentation/screen/login_screen.dart';


class ApiChecker {
  static void checkApi(Response response) {
    if(response.statusCode == 500) {
      Get.find<AuthenticationController>().clearSharedData();
      Get.offAll(()=> const LoginScreen());
    }else if(response.statusCode == 403){
      ErrorResponse errorResponse;
      errorResponse = ErrorResponse.fromJson(response.body);
      if(errorResponse.errors != null && errorResponse.errors!.isNotEmpty){
        showCustomSnackBar(errorResponse.errors![0].message!);
      }else{
        showCustomSnackBar(response.body['message']!);
      }
    }else {
      showCustomSnackBar(response.body['message']!);
    }
  }
}
