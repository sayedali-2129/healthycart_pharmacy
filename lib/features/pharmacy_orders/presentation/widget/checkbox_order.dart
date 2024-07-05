import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';

class OrderCheckBox extends StatelessWidget {
  const OrderCheckBox({
    super.key,
    required this.text,
    required this.onChanged, required this.value,
  });
  final String text;
  final void Function(bool?) onChanged;
  final bool value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: BColors.offRed,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: BColors.textLightBlack,
              fontWeight: FontWeight.w600,
              fontSize: 12),
        ),
      ],
    );
  }
}
