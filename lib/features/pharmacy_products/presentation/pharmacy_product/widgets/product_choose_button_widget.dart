
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';

class PharmacyProductChooseButton extends StatelessWidget {
  const PharmacyProductChooseButton({
    super.key,
    required this.text,
    required this.icon,
    required this.iconColor,
    required this.buttonTap,
  });
  final String text;
  final IconData icon;
  final Color iconColor;
  final VoidCallback buttonTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: BColors.white,
      surfaceTintColor: BColors.white,
      child: InkWell(
        onTap: buttonTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: SizedBox(
            width: 72,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: iconColor),
                const Gap(8),
                Text(text,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 13,
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}