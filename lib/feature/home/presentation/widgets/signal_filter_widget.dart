import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mighty_school/common/controller/datepicker_controller.dart';
import 'package:mighty_school/common/widget/custom_button.dart';
import 'package:mighty_school/common/widget/custom_contaner.dart';
import 'package:mighty_school/common/widget/custom_snackbar.dart';
import 'package:mighty_school/common/widget/date_selection_widget.dart';
import 'package:mighty_school/feature/authentication/logic/authentication_controller.dart';
import 'package:mighty_school/feature/profile/logic/profile_controller.dart';
import 'package:mighty_school/feature/profile/presentation/widgets/select_currency_widget.dart';
import 'package:mighty_school/util/dimensions.dart';

class SignalFilterWidget extends StatefulWidget {
  const SignalFilterWidget({super.key});

  @override
  State<SignalFilterWidget> createState() => _SignalFilterWidgetState();
}

class _SignalFilterWidgetState extends State<SignalFilterWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (controller) {
        return CustomContainer(child: Column(spacing: Dimensions.paddingSizeDefault, children: [
          const SelectCurrencyWidget(),
          const Row(spacing: Dimensions.paddingSizeDefault, children: [
            Expanded(child: DateSelectionWidget(title: "From")),
            Expanded(child: DateSelectionWidget(title: "To", end: true)),
          ]),


          controller.isLoading? const Center(child: CircularProgressIndicator()):
          CustomButton(onTap: (){
            String login = Get.find<AuthenticationController>().getUserName();
            String? currency = controller.selectedCurrency;
            int? from = Get.find<DatePickerController>().fromTime;
            int? to = Get.find<DatePickerController>().toTime;

            if(currency == null){
              showCustomSnackBar("Select currency");
            }else if(from == null){
              showCustomSnackBar("Select from date");
            }else if(to == null){
              showCustomSnackBar("Select to date");
            }else{
              controller.getAnalyticSignals(login, currency, from.toString(), to.toString());
            }


          }, text: "Confirm")

        ]));
      }
    );
  }
}
