import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';

class TextAboveFormFieldWidget extends StatelessWidget {
  const TextAboveFormFieldWidget({
    super.key,
    required this.text,
    this.starText,
  });
  final String text;
  final bool? starText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        children: [
          Text(text,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontSize: 14,
                  )),
          if (starText == true)
            Row(
              children: [
                const Gap(2),
                Text(
                  '*',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontSize: 14,
                        color: BColors.red,
                      ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
