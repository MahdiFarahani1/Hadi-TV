import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pro_dialog/pro_dialog.dart';
import 'package:haditv/core/utils/extension.dart';

class AppDialog {
  AppDialog._();

  /// Displays a modern confirmation dialog.
  static Future<void> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    Color? confirmColor,
    DialogType type = DialogType.question,
    required Future<void> Function() onConfirm,
  }) async {
    final finalConfirmText = confirmText ?? context.tr('confirm');
    final finalCancelText = cancelText ?? context.tr('cancel');

    await showProDialog(
      context,
      type: type,
      title: title,
      description: content,
      buttons: [
        DialogButton(
          text: finalCancelText,
          style: DialogButtonStyle.text,
          color: Colors.grey,
          onPressed: () {
            context.pop();
          },
        ),
        DialogButton(
          text: finalConfirmText,
          isPrimary: true,
          color: confirmColor,
          onPressed: () async {
            await onConfirm();
          },
        ),
      ],
    );
  }

  /// Displays an information dialog.
  static Future<void> showInfoDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) async {
    final finalButtonText = buttonText ?? context.tr('ok');

    await showProDialog(
      context,
      type: DialogType.info,
      title: title,
      description: message,
      buttons: [
        DialogButton(
          text: finalButtonText,
          isPrimary: true,
          onPressed: () {
            onPressed?.call();
          },
        ),
      ],
    );
  }

  /// Displays a warning dialog.
  static Future<void> showWarningDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    required Future<void> Function() onConfirm,
  }) async {
    final finalConfirmText = confirmText ?? context.tr('got_it');
    final finalCancelText = cancelText ?? context.tr('cancel');

    await showProDialog(
      context,
      type: DialogType.warning,
      title: title,
      description: message,
      buttons: [
        DialogButton(
          text: finalCancelText,
          style: DialogButtonStyle.text,
          color: Colors.grey,
          onPressed: () {
            context.pop();
          },
        ),
        DialogButton(
          text: finalConfirmText,
          isPrimary: true,
          color: Colors.orange,
          onPressed: () async {
            await onConfirm();
          },
        ),
      ],
    );
  }

  /// Displays a custom field text input dialog.
  static Future<void> showFieldDialog(
    BuildContext context, {
    required String title,
    required String content,
    String labelText = 'Value',
    String? confirmText,
    String? cancelText,
    required Future<void> Function(String value) onConfirm,
  }) async {
    final TextEditingController controller = TextEditingController();
    final finalConfirmText = confirmText ?? context.tr('confirm');
    final finalCancelText = cancelText ?? context.tr('cancel');

    await showProDialog(
      context,
      type: DialogType.custom,
      title: title,
      description: content,
      customContent: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      buttons: [
        DialogButton(
          text: finalCancelText,
          style: DialogButtonStyle.text,
          color: Colors.grey,
          onPressed: () {
            context.pop();
          },
        ),
        DialogButton(
          text: finalConfirmText,
          isPrimary: true,
          onPressed: () async {
            await onConfirm(controller.text);
          },
        ),
      ],
    );
  }

  /// Displays a loading dialog.
  static Future<void> showLoadingDialog(
    BuildContext context, {
    String? message,
  }) async {
    await showProDialog(
      context,
      type: DialogType.custom,
      title: message ?? context.tr('processing'),
      isLoading: true,
      barrierDismissible: false,
    );
  }

  /// Dismisses the loading dialog if open.
  static void hideLoadingDialog(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      context.pop();
    }
  }
}
