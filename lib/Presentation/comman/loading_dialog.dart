import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingDialog {
  static Future<void> showLoadingDialog(BuildContext context,
      {Widget? child, bool? barrierDismissible}) async {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black12,
      barrierDismissible: barrierDismissible ?? false,
      builder: (BuildContext context) {
        return loadingWidget(child: child);
      },
    );
  }

  static Widget loadingWidget({Widget? child}) {
    return Dialog(
      insetPadding: const EdgeInsets.all(15),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: child ??
          Lottie.asset(
            'assets/animations/loading.json',
            height: 100,
            width: 100,
            //  color: Colors.transparent,
            //frameRate: 30, // default is 15 FPS
          ),
    );
  }
}
