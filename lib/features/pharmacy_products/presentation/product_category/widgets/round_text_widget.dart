import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/custom_cached_network/custom_cached_network_image.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/application/pharmacy_provider.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class VerticalImageText extends StatelessWidget {
  const VerticalImageText({
    super.key,
    required this.image,
    required this.title,
    this.onTap,
    this.onLongPress,
  });
  final String title;
  final void Function()? onTap;
  final String image;
   final void Function()? onLongPress;
  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {
      
        return GestureDetector(
          onTap:(!pharmacyProvider.onTapBool)? onTap : null,
          onLongPress:(pharmacyProvider.onTapBool)? onLongPress : null,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                Material(
                  shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(64)
                  ),
                  elevation: 4,
                  child: Container(
                    width: 64,
                    height: 64,
                    clipBehavior: Clip.antiAlias,
                    decoration: const  BoxDecoration(
                    color:  BColors.white,
                      shape: BoxShape.circle,
                     // border: Border.all( color: BColors.grey)
                    ),
                    child: CustomCachedNetworkImage(
                      image: image,
                    ),
                  ),
                ),
                const Gap(8),
                SizedBox(
                  width: 88,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.black),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
