import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_medicine_product/widgets/product_add_form.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_medicine_product/widgets/product_choose_button_widget.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';

class ChooseProductBottomSheet extends StatelessWidget {
  const ChooseProductBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            child: Text('Choose product type :',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 15,
                    )),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PharmacyProductChooseButton(
                buttonTap: () {
                  EasyNavigation.push(
                      context: context, page: const ProductAddFormWidget());
                },
                text: 'Medicine',
                icon: Icons.medication,
                iconColor: BColors.mainlightColor,
              ),
              PharmacyProductChooseButton(
                buttonTap: () {},
                text: 'Equipment',
                icon: Icons.devices_other_rounded,
                iconColor: BColors.mainlightColor,
              ),
            ],
          ),
          const Gap(16),
          PharmacyProductChooseButton(
            buttonTap: () {},
            text: "Other's",
            icon: Icons.shopping_bag_rounded,
            iconColor: BColors.mainlightColor,
          ),
        ],
      ),
    );
  }
}
