import 'package:flutter/material.dart';
import 'package:task_manager/app_properties/app_properties.dart';
import 'package:task_manager/shared/style/text_size.dart';

class WidgetDropDown<T extends Enum> extends StatelessWidget {
  final T? initialValue;
  final List<T> filters;
  final String text;
  final Function(T extension)? extension;
  final Function(T selectedEnum) selectedValue;

  const WidgetDropDown({
    super.key,
    this.initialValue,
    required this.filters,
    required this.text,
    this.extension,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      style: lv05TextStyle,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppPropertyColor.primary, width: 2),
        ),
        label: Text(text, style: lv1TextStyle),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
      initialValue: initialValue,
      items: filters
          .map(
            (map) => DropdownMenuItem(
              value: map,
              child: Text(
                extension != null ? extension!(map).toString() : map.name,
                style: lv05TextStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) selectedValue(value);
      },
    );
  }
}
