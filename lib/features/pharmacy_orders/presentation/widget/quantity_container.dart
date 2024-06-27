import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';

class QuantitiyBox extends StatelessWidget {
  const QuantitiyBox({
    super.key,
    required this.productQuantity,
  });

  final String? productQuantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: BColors.textLightBlack),
          borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text(
              'Qty:',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: BColors.textBlack),
            ),
            const Gap(4),
            Text(
              productQuantity ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:Theme.of(context).textTheme.labelLarge!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: BColors.textBlack),
            ),
          ],
        ),
      ),
    );
  }
}

