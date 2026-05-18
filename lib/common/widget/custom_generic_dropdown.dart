import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mighty_school/util/dimensions.dart';
import 'package:mighty_school/util/styles.dart';

/// Generic Dropdown
class CustomGenericDropdown<T> extends StatelessWidget {
  final double? width;
  final bool border;
  final String title;
  final List<T>? items;
  final T? selectedValue;
  final Function(T?)? onChanged;
  final String Function(T item) getLabel;

  const CustomGenericDropdown({
    super.key,
    this.width,
    this.border = false,
    required this.title,
    required this.getLabel,
    this.items,
    this.onChanged,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeSmall,
          vertical: 2),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        border: Border.all(width: .5, color: Theme.of(context).hintColor)),

      child: DropdownButton2<T>(
        isDense: true,
        isExpanded: true,
        underline: const SizedBox(),
        hint: Text(selectedValue != null ? getLabel(selectedValue as T) : title.tr,
          style: textRegular.copyWith(
            color: selectedValue != null ?
            Theme.of(context).textTheme.displayMedium?.color: Theme.of(context).hintColor,
            fontSize: Dimensions.fontSizeDefault,
          ),
        ),
        items: items != null ? items!.map((T item) => DropdownMenuItem<T>(
            value: item, child: Text(getLabel(item),
              style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall))))
            .toList() : [],
        value: (items != null && selectedValue != null && items!.contains(selectedValue))
            ? selectedValue : null,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: 35, width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: border ? Border.all(color: Colors.black26) : null,
            color: Colors.transparent),
          elevation: 0),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down_rounded),
          iconSize: 24,
          iconEnabledColor: Colors.grey,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).cardColor,
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 35,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
