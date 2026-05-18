import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mighty_school/common/widget/custom_generic_dropdown.dart';
import 'package:mighty_school/feature/profile/logic/profile_controller.dart';
import 'package:mighty_school/util/styles.dart';



class SelectCurrencyWidget extends StatelessWidget {
  const SelectCurrencyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text("Currency".tr, style: textRegular,)),
      GetBuilder<ProfileController>(
        builder: (controller) {
          return CustomGenericDropdown<String>(
            title: "select",
            items: controller.currencies,
            selectedValue: controller.selectedCurrency,
            onChanged: (val) {
              controller.setSelectedCurrency(val!);
            },
            getLabel: (item) => item,
          );
        },
      ),
    ],
    );
  }
}
