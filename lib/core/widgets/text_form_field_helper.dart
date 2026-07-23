import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';

class TextFormFieldHelper extends StatefulWidget {
  final TextEditingController? controller;
  final bool isPassword, isVisible;
  final String? hint, obscuringCharacter, labelText, label;
  final bool enabled;
  final int? maxLines, minLines, maxLength;
  final String? Function(String?)? onValidate;
  final void Function(String?)? onChanged, onFieldSubmitted, onSaved;
  final void Function()? onEditingComplete, onTap;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixWidget, prefixIcon, prefix;
  final IconData? icon;
  final TextInputAction? action;
  final FocusNode? focusNode;

  final BorderRadius? borderRadius;
  final bool? isMobile;
  final bool? isReadOnly;
  final TextStyle? hintStyle;
  final Color? borderColor;
  final Color? fillColor;
  final Iterable<String>? autoFillHint;
  final bool enableShadow;
  /// Legacy parameter kept for chatbot compatibility.
  /// When provided, overrides [enableShadow] and uses a BoxShadow with this radius.
  final double? blurShadowRadius;

  const TextFormFieldHelper({
    super.key,
    this.controller,
    this.isPassword = false,
    this.isVisible = false,
    this.hint,
    this.label,
    this.labelText,
    this.enabled = true,
    this.obscuringCharacter,
    this.onValidate,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onSaved,
    this.onTap,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.suffixWidget,
    this.icon,
    this.prefixIcon,
    this.prefix,
    this.action,
    this.focusNode,
    this.borderRadius,
    this.isMobile,
    this.hintStyle,
    this.borderColor,
    this.fillColor,
    this.isReadOnly,
    this.enableShadow = true,
    this.autoFillHint,
    this.blurShadowRadius,
  });

  @override
  State<TextFormFieldHelper> createState() => _TextFormFieldHelperState();
}

class _TextFormFieldHelperState extends State<TextFormFieldHelper> {
  late bool obscureText;
  TextDirection _textDirection = TextDirection.ltr;

  final bool _hasError = false;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;
  }

  void _toggleObscureText() {
    setState(() => obscureText = !obscureText);
  }

  void _updateTextDirection(String text) {
    if (text.isEmpty) return;
    final isArabic = RegExp(r'^[\u0600-\u06FF]').hasMatch(text);
    final newDirection = isArabic ? TextDirection.rtl : TextDirection.ltr;

    if (_textDirection != newDirection) {
      setState(() {
        _textDirection = newDirection;
      });
    }
  }

  String? _validator(String? value) {
    final result = widget.onValidate?.call(value);

    // Avoid setState during validation to prevent infinite rebuild loops or ANRs
    // We can track error state via onChanged or just keep the shadow
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(8.r);

    // Support legacy blurShadowRadius (chatbot uses it)
    final bool showShadow =
        widget.blurShadowRadius != null ? true : (widget.enableShadow && !_hasError);
    final double shadowBlur = widget.blurShadowRadius ?? (showShadow ? 6 : 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(visible: widget.isVisible, child: Text(widget.label ?? "")),

        Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          elevation: (widget.blurShadowRadius == null && showShadow) ? 6 : 0,
          shadowColor: context.ext.colors.textPrimary.withAlpha(26),
          child: Container(
            decoration: widget.blurShadowRadius != null
                ? BoxDecoration(
                    borderRadius: borderRadius,
                    boxShadow: [
                      BoxShadow(
                        color: context.ext.colors.textPrimary.withAlpha(38),
                        blurRadius: shadowBlur,
                        offset: const Offset(0, 0),
                        spreadRadius: 0,
                        blurStyle: BlurStyle.outer,
                      ),
                    ],
                  )
                : null,
            child: TextFormField(
              controller: widget.controller,
              validator: _validator,
              onChanged: (text) {
                widget.onChanged?.call(text);
                _updateTextDirection(text);
              },
              onEditingComplete: widget.onEditingComplete,
              onFieldSubmitted: widget.onFieldSubmitted,
              onSaved: widget.onSaved,
              onTap: widget.onTap,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              maxLength: widget.maxLength,
              obscureText: obscureText,
              obscuringCharacter: widget.obscuringCharacter ?? '*',
              keyboardType: widget.keyboardType,
              enabled: widget.enabled,
              textInputAction: widget.action ?? TextInputAction.next,
              focusNode: widget.focusNode,
              autofillHints: widget.autoFillHint?.toList(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              cursorColor: context.colors.primary,
              textAlign: widget.isMobile != null
                  ? TextAlign.left
                  : TextAlign.start,
              textDirection: widget.isMobile != null
                  ? TextDirection.ltr
                  : _textDirection,
              readOnly: widget.isReadOnly ?? false,
              textAlignVertical: TextAlignVertical.center,
              style: context.text.titleSmall!.copyWith(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: widget.hint,
                hintStyle: (widget.hintStyle ??
                        context.text.bodyLarge!.copyWith(fontWeight: FontWeight.w400))
                    .copyWith(
                  color: Colors.grey[600],
                ),
                errorMaxLines: 4,
                errorStyle: const TextStyle(color: Colors.red),
                prefixIcon: widget.prefixIcon,
                prefixIconColor: Colors.grey[600],
                prefix: widget.prefix,
                suffixIcon: widget.isPassword
                    ? IconButton(
                        onPressed: _toggleObscureText,
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                      )
                    : widget.suffixWidget,
                suffixIconColor: Colors.grey[600],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 19,
                ),
                border: outlineInputBorder(
                  color: widget.borderColor ?? context.colors.primary,
                  width: 1,
                ),
                enabledBorder: outlineInputBorder(
                  color: widget.borderColor ?? context.colors.primary,
                  width: 1,
                ),
                focusedBorder: outlineInputBorder(
                  color: widget.borderColor ?? context.ext.colors.primaryDark,
                  width: 1.5,
                ),
                errorBorder: outlineInputBorder(color: Colors.red, width: 1),
                focusedErrorBorder: outlineInputBorder(
                  color: Colors.red,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder outlineInputBorder({
    required Color color,
    required double width,
  }) {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
