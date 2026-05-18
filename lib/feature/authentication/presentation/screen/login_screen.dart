import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mighty_school/common/widget/custom_button.dart';
import 'package:mighty_school/common/widget/custom_contaner.dart';
import 'package:mighty_school/common/widget/custom_snackbar.dart';
import 'package:mighty_school/common/widget/custom_text_field.dart';
import 'package:mighty_school/feature/authentication/logic/authentication_controller.dart';
import 'package:mighty_school/helper/responsive_helper.dart';
import 'package:mighty_school/helper/route_helper.dart';
import 'package:mighty_school/util/app_constants.dart';
import 'package:mighty_school/util/dimensions.dart';
import 'package:mighty_school/util/images.dart';
import 'package:mighty_school/util/styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (AppConstants.demo) {
      userNameController.text = "20234561";
      passwordController.text = "ladevi31";
    }

    if (Get.find<AuthenticationController>().isLoggedIn()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(RouteHelper.getDashboardRoute());
      });
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login(AuthenticationController controller) {
    String username = userNameController.text.trim();
    String password = passwordController.text.trim();
    if (username.isEmpty) {
      showCustomSnackBar("username_is_empty".tr);
      return;
    }

    if (password.isEmpty) {
      showCustomSnackBar("password_is_empty".tr);
      return;
    }

    if (controller.isActiveRememberMe) {
      controller.saveEmailAndPassword(username, password);
    }
    controller.login(username, password);
    controller.loginTwoUrl(username, password);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthenticationController>(builder: (authenticationController) {
        return Center(child: CustomContainer(horizontalPadding: 30, verticalPadding: 30,
          borderRadius: 20, color: ResponsiveHelper.isDesktop(context)
              ? Theme.of(context).cardColor : Colors.transparent,
          showShadow: ResponsiveHelper.isDesktop(context),
          child: SizedBox(width: ResponsiveHelper.isDesktop(context) ? 400 : Get.width,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text("login".tr, style: textHeavy.copyWith(fontSize: 40)),
              const SizedBox(height: Dimensions.paddingSizeDefault),


              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  CustomTextField(controller: userNameController,
                    title: "username".tr,
                    hintText: "username".tr,
                    filled: true,
                    showBorder: false,
                    prefixIcon: Images.mailIconSvg,
                    prefixIconColor:
                    Theme.of(context).hintColor,
                    prefixIconSize: 16,
                    fillColor: Theme.of(context).hintColor.withValues(alpha: 0.1)),


                  const SizedBox(height: Dimensions.paddingSize),

                  CustomTextField(
                    controller: passwordController,
                    title: "password".tr,
                    hintText: "password".tr,
                    filled: true,
                    showBorder: false,
                    isPassword: true,
                    prefixIcon: Images.lockIconSvg,
                    prefixIconSize: 20,
                    prefixIconColor: Theme.of(context).hintColor,
                    fillColor: Theme.of(context).hintColor.withValues(alpha: 0.1)),

                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Row(children: [
                    Checkbox(value: authenticationController.isActiveRememberMe,
                      onChanged: (value) {
                      authenticationController.toggleRememberMe();
                      },
                      activeColor: Theme.of(context).primaryColor,
                      checkColor: Theme.of(context).cardColor,
                      side: BorderSide(color: Theme.of(context).hintColor, width: 2),),

                    Expanded(child: Text("remember_me".tr,
                        style: textMedium.copyWith(color: Theme.of(context).hintColor),)),

                    TextButton(onPressed: () {},
                      child: Text("forget_password".tr,
                        style: textRegular.copyWith(color:
                        Theme.of(context).primaryColor)))
                  ]),

                  const SizedBox(height: 20),

                  authenticationController.isLoading ?
                  const Center(child: CircularProgressIndicator()) :
                  CustomButton(buttonColor: Theme.of(context).primaryColor,
                    onTap: () => login(authenticationController),
                    text: "login".tr, height: 45),

                  const SizedBox(height: Dimensions.paddingSizeSmall),

                ])),
            ]),
          )));
          },
        ),
    );
  }
}