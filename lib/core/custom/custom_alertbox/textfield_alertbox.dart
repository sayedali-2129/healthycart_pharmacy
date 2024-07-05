import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/text_formfield/textformfield.dart';
import 'package:healthycart_pharmacy/core/general/validator.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';

class TextFieldAlertBoxWidget {
  static void showAlertTextFieldBox({
    required BuildContext context,
    required VoidCallback confirmButtonTap,
    required String titleText,
    required String hintText,
    required String subText,
    required TextEditingController controller,
    required int? maxlines,
    TextInputType? keyboardType
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SizedBox(

          child: AlertDialog(
            backgroundColor: BColors.white,
            title:
                Text(titleText, style: Theme.of(context).textTheme.bodyLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subText,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Gap(4),
                TextfieldWidget(
                  hintText: hintText,
                  keyboardType:keyboardType,
                  textInputAction: TextInputAction.done,
                  validator: BValidator.validate,
                  controller: controller,
                  maxlines: maxlines,
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    EasyNavigation.pop(context: context);
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: BColors.darkblue),
                  )),
              ElevatedButton(
                onPressed: () {
                  
                  confirmButtonTap.call();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: BColors.mainlightColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: Text('Confirm',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
