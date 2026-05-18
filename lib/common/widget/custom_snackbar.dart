import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mighty_school/helper/responsive_helper.dart';
import 'package:mighty_school/util/dimensions.dart';
import 'package:mighty_school/util/styles.dart';
import 'package:toastification/toastification.dart';

void showCustomSnackBar(String? message, {bool isError = true, double margin = Dimensions.paddingSizeSmall}) {

  if(message != null && message.isNotEmpty) {
   if(ResponsiveHelper.isDesktop(Get.context!)){
     toastification.show(
       context: Get.context!,
       type: ToastificationType.success,
       style: ToastificationStyle.flatColored,
       autoCloseDuration: const Duration(seconds: 5),
      title: Text(!isError?"success".tr : "failed".tr, style: textRegular.copyWith(color: Colors.white)),

       description: RichText(text: TextSpan(text: message, style: textRegular.copyWith(color: Colors.white))),
       alignment: Alignment.topRight,
       direction: TextDirection.ltr,
       animationDuration: const Duration(milliseconds: 300),
       animationBuilder: (context, animation, alignment, child) {
         return FadeTransition(opacity: animation, child: child);
       },
       icon: Icon(isError? Icons.clear : Icons.check),
       showIcon: true, // show or hide the icon
       primaryColor: isError ? Colors.red : Colors.green,
       backgroundColor: isError ? Colors.red : Colors.black,
       foregroundColor: Colors.black,
       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
       // margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
       borderRadius: BorderRadius.circular(5,),

       showProgressBar: true,
       closeButtonShowType: CloseButtonShowType.onHover,
       closeOnClick: false,
       pauseOnHover: true,
       dragToClose: true,
       applyBlurEffect: true,
       callbacks: ToastificationCallbacks(
         onTap: (toastItem) => log('Toast ${toastItem.id} tapped'),
         onCloseButtonTap: (toastItem) => log('Toast ${toastItem.id} close button tapped'),
         onAutoCompleteCompleted: (toastItem) => log('Toast ${toastItem.id} auto complete completed'),
         onDismissed: (toastItem) => log('Toast ${toastItem.id} dismissed'),
       ),
     );
   }else{
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: isError ? Colors.red : Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
   }
  }
}