import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/application/provider/request_pharmacy_provider.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/domain/model/user_model.dart';
import 'package:provider/provider.dart';

class UserDetailsContainer extends StatelessWidget {
  const UserDetailsContainer({
    super.key,
    required this.userData,
  });
  final UserModel userData;
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<RequestPharmacyProvider>(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userData.userName ?? 'Unknown Name',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const Gap(4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RowTwoTextWidget(
                            text1: 'Age',
                            text2: userData.userAge ?? 'Unknown Age',
                            gap: 48),
                        const Gap(4),
                        RowTwoTextWidget(
                            text1: 'Gender',
                            text2: userData.gender ?? 'Gender Unknown',
                            gap: 24),
                        const Gap(4),
                        RowTwoTextWidget(
                            text1: 'Phone No',
                            text2: userData.phoneNo ?? 'Unknown PhoneNo',
                            gap: 8),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // PhysicalModel(
                      //   elevation: 2,
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.circular(16),
                      //   child: SizedBox(
                      //     width: 40,
                      //     height: 40,
                      //     child: Center(
                      //       child: IconButton(
                      //         onPressed: () {},
                      //         icon: const Icon(
                      //           Icons.location_on_sharp,
                      //           size: 24,
                      //           color: Colors.blue,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const Gap(12),
                      PhysicalModel(
                        elevation: 2,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                orderProvider.lauchDialer(
                                    phoneNumber: userData.phoneNo ?? '');
                              },
                              icon: const Icon(Icons.phone,
                                  size: 24, color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RowTwoTextWidget extends StatelessWidget {
  const RowTwoTextWidget({
    super.key,
    required this.text1,
    required this.text2,
    required this.gap,
  });
  final String text1;
  final String text2;
  final double gap;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text1,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        Gap(gap),
        Expanded(
          child: Text(
            text2,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
