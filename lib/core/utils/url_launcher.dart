import 'package:flutter/material.dart';
import 'package:haditv/core/widgets/snackbar_common.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUrlService {
  static Future<void> urlOpener(BuildContext context, String url) async {
    if (url.isEmpty) {
      if (context.mounted) {
        AppSnackBar.error(context, "الرابط غير موجود");
      }
      return;
    }
    final Uri uri = Uri.parse(url);

    try {
      if (!await launchUrl(uri)) {
        if (context.mounted) {
          AppSnackBar.error(context, "لا يمكن فتح الرابط");
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.error(context, "خطأ في فتح الرابط");
      }
    }
  }
}
