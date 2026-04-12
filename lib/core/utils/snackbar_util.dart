import 'package:flutter/material.dart';
import 'package:scorelivepro/widget/custom_snackbar.dart';

class SnackBarUtil {
  static void showSuccess(BuildContext context, String message) {
    CustomSnackBar.show(
      context: context,
      message: message,
      isError: false,
    );
  }

  static void showError(BuildContext context, String message) {
    CustomSnackBar.show(
      context: context,
      message: message,
      isError: true,
    );
  }
}
