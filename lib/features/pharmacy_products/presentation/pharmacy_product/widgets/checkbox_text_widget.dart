


import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';

class CheckboxTextWidget extends StatelessWidget {
  const CheckboxTextWidget({
    super.key, required this.text, required this.onChanged, required this.value,
  });
  final String text;
  final void Function(bool?) onChanged;
  final bool value;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.loose,
          child: Text(text,
              maxLines: 2,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontSize: 12,
                  )),
        ),
        Flexible(
            fit: FlexFit.loose,
            child: Checkbox(value: value, onChanged: onChanged, activeColor: BColors.offRed,)),
      ],
    );
  }
}
