// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/shared/style/text_size.dart';

class CustomTextField extends StatelessWidget {
  final Widget? prefix;
  final String? label;
  final bool hint;
  final bool password;
  final TextEditingController? controller;
  final bool? enable;
  final bool moreRadius;
  final TextInputType? inputType;
  final BuildContext? context;
  final FormFieldValidator<String>? validator;
  final bool alignEnd;
  final List<TextInputFormatter>? inputFormatter;
  final Function(String value)? onChanged;
  final Function(bool value)? changeVisiblePass;
  final bool visiblepass;
  const CustomTextField({
    super.key,
    this.prefix,
    this.label,
    this.hint = true,
    this.password = false,
    this.controller,
    this.enable,
    this.moreRadius = false,
    this.inputType,
    this.context,
    this.validator,
    this.alignEnd = false,
    this.inputFormatter,
    this.onChanged,
    this.changeVisiblePass,
    this.visiblepass = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: alignEnd ? TextAlign.end : TextAlign.start,
      validator: validator,
      keyboardType: inputType ?? TextInputType.text,
      enabled: enable,
      controller: controller,
      style: lv05TextStyle,
      obscureText: password ? !visiblepass : false,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppPropertyColor.primary, width: 2),
        ),
        suffixIcon: password
            ? IconButton(
                icon: Icon(
                  visiblepass ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  changeVisiblePass!(!visiblepass);
                },
              )
            : null,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: label != null ? Text(label!, style: lv1TextStyle) : null,
        hint: hint ? Text("${label ?? ""}...", style: lv05TextStyle) : null,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 9, horizontal: 5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(moreRadius ? 13 : 6),
        ),
        errorStyle: lv05TextStyleRed,
        prefixIcon: prefix,
      ),
      onChanged: (value) {
        onChanged != null ? onChanged!(value) : null;
      },
    );
  }
}
