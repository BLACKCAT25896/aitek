import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:aitek/util/dimensions.dart';
import 'package:aitek/util/styles.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool isPassword;
  final bool isAmount;
  final Function(String text)? onChanged;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final bool isEnabled;
  final int maxLines;
  final int minLines;
  final TextCapitalization capitalization;
  final List<TextInputFormatter>? inputFormatters;
  final double borderRadius;
  final Color? borderColor;
  final String? prefixIcon;
  final Widget? prefix;
  final double? prefixIconSize;
  final String? suffixIcon;
  final Widget? suffix;
  final Color? suffixIconColor;
  final bool showBorder;
  final Color? fillColor;
  final bool limit;
  final Function()? onPressedSuffix;
  final Function()? onPressedPrefix;
  final void Function(String)? onSubmitted;
  final String? title;
  final bool readOnly;
  final bool filled;
  final Color? prefixIconColor;
  final int? maxLength;
  final bool isRequired;
  final double? contentPadding;

  const CustomTextField({
    super.key,
    this.hintText = 'Write something...',
    this.labelText,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onChanged,
    this.prefixIcon,
    this.prefixIconSize,
    this.capitalization = TextCapitalization.none,
    this.isPassword = false,
    this.isAmount = false,
    this.borderRadius = 5,
    this.showBorder = true,
    this.fillColor,
    this.suffixIcon,
    this.onPressedSuffix,
    this.onSubmitted,
    this.limit = false,
    this.maxLength,
    this.title,
    this.onTap,
    this.readOnly = false,
    this.filled = false,
    this.prefixIconColor,
    this.validator,
    this.suffixIconColor,
    this.inputFormatters,
    this.onEditingComplete,
    this.borderColor,
    this.textStyle,
    this.hintStyle,
    this.suffix,
    this.prefix,
    this.isRequired = false,
    this.minLines = 1,
    this.onPressedPrefix,
    this.contentPadding,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  bool _obscureText = true;
  bool _isHovering = false;
  bool _isFocused = false;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [


      if (widget.title != null) ...[
        Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
          child: Row(children: [
            Text(widget.title ?? "", style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
            if (widget.isRequired)
              Text('*', style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
              ])),
        const SizedBox(height: Dimensions.paddingSizeSeven),
      ],


      MouseRegion(onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: Focus(onFocusChange: (hasFocus) {
          setState(() => _isFocused = hasFocus);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            decoration: BoxDecoration(borderRadius:
            BorderRadius.circular(widget.borderRadius),
              boxShadow: (_isHovering || _isFocused) ? [
                BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
                  blurRadius: 14, spreadRadius: 1)]: []),
            child: TextFormField(
              //maxLength: widget.maxLength,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              controller: widget.controller,
              focusNode: widget.focusNode,
                validator: widget.validator,
                autovalidateMode:
                AutovalidateMode.onUserInteraction,
                onTap: widget.onTap,
                readOnly: widget.readOnly,
                style: widget.textStyle ?? Get.textTheme.titleMedium!.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.w400),
                textInputAction: widget.inputAction,
                keyboardType: (widget.isAmount || widget.inputType == TextInputType.phone)
                    ? const TextInputType.numberWithOptions(signed: false, decimal: true)
                    : widget.inputType,
                cursorColor: Theme.of(context).primaryColor,
                textCapitalization:
                widget.capitalization,
                enabled: widget.isEnabled,
                obscureText:
                widget.isPassword ? _obscureText : false,
                inputFormatters: widget.inputFormatters,
                onEditingComplete:
                widget.onEditingComplete,
                onFieldSubmitted:
                widget.onSubmitted ?? (text) => widget.nextFocus != null
                    ? FocusScope.of(context).requestFocus(widget.nextFocus) : null,
                onChanged: widget.onChanged,

              decoration: InputDecoration(isDense: true, filled: widget.filled,
                fillColor: widget.fillColor ?? Theme.of(context).cardColor,

                contentPadding: EdgeInsets.symmetric(vertical: widget.maxLines > 1 ? 14
                    : (widget.contentPadding ?? 14),
                  horizontal: Dimensions.paddingSizeDefault + 2),

                hintText: widget.hintText,
                hintStyle: widget.hintStyle ?? textRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).hintColor),

                enabledBorder: OutlineInputBorder(borderRadius:
                BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide(width: widget.showBorder ? (_isHovering ? 1 : .6) : 0,
                    color: widget.borderColor ?? Theme.of(context).hintColor.withValues(alpha: 0.6),),),

                focusedBorder: OutlineInputBorder(borderRadius:
                BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide(width: widget.showBorder ? 1.3 : 0, color: Theme.of(context).primaryColor)),

                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                    borderSide: BorderSide(width:
                      widget.showBorder ? 1 : 0, color: Theme.of(context).colorScheme.error)),

                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  borderSide: BorderSide(width: widget.showBorder ? 1 : 0,
                    color: Theme.of(context).colorScheme.error)),

                prefixIcon: widget.prefix ?? (widget.prefixIcon != null
                    ? GestureDetector(onTap:
                widget.onPressedPrefix, child: Padding(padding:
                const EdgeInsets.all(15),
                  child: SvgPicture.asset(widget.prefixIcon!,
                    colorFilter: ColorFilter.mode(widget.prefixIconColor ??
                        Theme.of(context).hintColor, BlendMode.srcIn),
                    height: widget.prefixIconSize ?? 20))) : null),

                suffixIcon: widget.suffix ?? (widget.suffixIcon != null
                    ? IconButton(onPressed: widget.onPressedSuffix, icon: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Image.asset(widget.suffixIcon!, height: 20, width: 20,
                      color: widget.suffixIconColor))) : widget.isPassword
                    ? IconButton(icon: Icon(_obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined, color: Theme.of(context).hintColor),
                    onPressed: _toggle) : null),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
