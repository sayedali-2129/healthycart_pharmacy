// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/domain/model/user_address_model.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.addressData,
  });
  final UserAddressModel addressData;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        addressData.name ?? 'User',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: BColors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                      const Gap(8),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Center(
                            child: Text(
                              addressData.addressType ?? 'Home',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      color: BColors.textLightBlack,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(4),
                  Text(
                    '${addressData.address ?? 'Address'} ${addressData.landmark}, pincode : ${addressData.pincode}',
                    // overflow: TextOverflow.ellipsis,
                    // maxLines: 3,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: BColors.textBlack,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                  const Gap(4)
                ],
              ),
              Text(
                addressData.phoneNumber ?? 'Unknown Number',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: BColors.textBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              )
            ],
          ),
        ),
      ],
    );
  }
}
