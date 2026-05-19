
import 'package:get/get.dart';
import 'package:aitek/api_handle/api_checker.dart';
import 'package:aitek/common/widget/custom_snackbar.dart';
import 'package:aitek/feature/authentication/domain/authentication_repository.dart';
import 'package:aitek/helper/route_helper.dart';


class AuthenticationController extends GetxController implements GetxService{
  final AuthenticationRepository authenticationRepository;
  AuthenticationController({required this.authenticationRepository});


  bool isLoading = false;
  Future<void> login(String email, String password) async {
    isLoading = true;
    update();
    final response = await authenticationRepository.login(email: email, password: password);
    isLoading = false;
    if (response?.statusCode == 200) {
      final token = response?.body['token'];
      setUserName(email);
      setUserToken(token);
      Get.offAllNamed(RouteHelper.getDashboardRoute());
    } else if (response?.statusCode == 1) {
      showCustomSnackBar("CORS ERROR");
    } else {
      ApiChecker.checkApi(response!);
    }

    update();
  }

  Future<void> loginTwoUrl(String email, String password) async {
    final response = await authenticationRepository.loginTwo(login: email, password: password);
    isLoading = false;
    if (response?.statusCode == 200) {
      final token = response?.body.toString() ?? '';
      setUserName(email);
      setUserTokenTwo(token);
    } else if (response?.statusCode == 1) {
      showCustomSnackBar("CORS ERROR");
    } else {
      ApiChecker.checkApi(response!);
    }

    update();
  }


  Future <void> setUserToken(String token) async{
    authenticationRepository.saveUserToken(token);
  }
  Future <void> setUserTokenTwo(String token) async{
    authenticationRepository.saveUserTokenTwo(token);
  }


  Future <void> setUserName(String userName) async{
    authenticationRepository.setUserName(userName);
  }

  String getUserName() {
    return authenticationRepository.getUserName();
  }


  bool isLoggedIn() {
    return authenticationRepository.isLoggedIn();
  }

  String getToken() {
    return authenticationRepository.getUserToken();
  }

  String getTokenTwo() {
    return authenticationRepository.getUserTokenTwo();
  }


  bool isActiveRememberMe = false;
  void toggleRememberMe() {
    isActiveRememberMe = !isActiveRememberMe;
    update();
  }


  void saveEmailAndPassword(String number, String password) {
    authenticationRepository.saveEmailAndPassword(number, password);
  }
  Future <bool> clearSharedData() async {
    return authenticationRepository.clearSharedData();
  }

}