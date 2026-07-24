import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

extension LocalizationExtension on BuildContext {
  bool get isAr => Localizations.localeOf(this).languageCode == 'ar';

  String trContext(
    String key, {
    List<String>? args,
    Map<String, String>? namedArgs,
  }) {
    return key.tr(context: this, args: args, namedArgs: namedArgs);
  }
}
