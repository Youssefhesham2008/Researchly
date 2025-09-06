import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LocalizationHelper {
  static String translate(BuildContext context, String key) {
    return key.tr();
  }
}
