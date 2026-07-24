import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';

class SearchInputField extends StatelessWidget {
  const SearchInputField({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onClear,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
      style: context.text.bodyMedium!.copyWith(
        color: context.ext.colors.textPrimary,
        fontSize: 16.sp,
      ),
      decoration: InputDecoration(
        hintText: context.trContext(TK.weatherSearchHint),
        hintStyle: context.text.bodyMedium!.copyWith(
          color: context.ext.colors.textSecondary,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: context.ext.colors.textSecondary,
          size: 20.sp,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear_rounded, color: context.ext.colors.textSecondary),
                onPressed: onClear,
              )
            : null,
        filled: true,
        fillColor: context.ext.colors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(color: context.ext.colors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(color: context.ext.colors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(color: context.ext.colors.primary, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      ),
      onChanged: onChanged,
    );
  }
}
