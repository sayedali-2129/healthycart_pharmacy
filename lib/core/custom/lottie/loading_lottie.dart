import 'package:flutter/material.dart';

import 'package:healthycart_pharmacy/utils/constants/image/image.dart';
import 'package:lottie/lottie.dart';

class LoadingLottie {
  static  showLoading({required BuildContext context, required String text}) {
    showDialog(
        context: context,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              contentPadding: const EdgeInsets.only(bottom: 16),
              backgroundColor: Colors.white70,
              surfaceTintColor: Colors.transparent,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(BImage.lottieLoading,fit: BoxFit.fill, height: 120),
                  Text(text)
                ],
              ),
            ),
          );
        });
  }
}
