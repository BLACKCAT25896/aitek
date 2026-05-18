import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mighty_school/common/controller/datepicker_controller.dart';
import 'package:mighty_school/common/widget/custom_contaner.dart';
import 'package:mighty_school/common/widget/custom_title.dart';
import 'package:mighty_school/helper/date_converter.dart';

class DateSelectionWidget extends StatelessWidget {
  final String? title;
  final bool end;
  final bool allowPast;
  final bool allowFuture;
  const DateSelectionWidget({super.key, this.title,  this.end = false,  this.allowPast = true, this.allowFuture = true});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DatePickerController>(builder: (datePickerController) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
         CustomTitle(title: title?? "date".tr),

          Padding(padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CustomContainer(border: Border.all(width: .5,
                color: Theme.of(context).hintColor),
              showShadow: false,borderRadius: 5, width: Get.width,
              onTap: ()=> datePickerController.setSelectDate(context, end: end, allowFuture: allowFuture, allowPast: allowPast),
              child: Text(end? DateConverter.quotationDate(
                  datePickerController.selectedEndDate) :
              DateConverter.quotationDate(datePickerController.selectedDate)),
            ),
          ),
        ],
      );
        }
    );
  }
}
