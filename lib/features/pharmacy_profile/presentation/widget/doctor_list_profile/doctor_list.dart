import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/app_bar/sliver_appbar.dart';
import 'package:healthycart_pharmacy/core/custom/custom_cached_network/custom_cached_network_image.dart';
import 'package:healthycart_pharmacy/features/pharmacy_profile/application/profile_provider.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class DoctorProfileList extends StatelessWidget {
  const DoctorProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<ProfileProvider>().getAllDoctorDetails();
      },
    );
    return Scaffold(
        body: Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
      return CustomScrollView(
        slivers: [
          SliverCustomAppbar(
            title: 'All Products',
            onBackTap: () {
              Navigator.pop(context);
            },
          ),
          SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.builder(
                  itemCount: profileProvider.pharamacyProductTotalList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        PhysicalModel(
                          color: BColors.white,
                          borderRadius: BorderRadius.circular(12),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Container(
                                    height: 96,
                                    width: 96,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: CustomCachedNetworkImage(
                                            image: profileProvider
                                                    .pharamacyProductTotalList[index].productImage![0]
                                                     ??
                                                '')),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, bottom: 16, left: 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 232,
                                          child: Row(
                                            children: [
                                              const Gap(8),
                                              Expanded(
                                                child: Text(
                                                  profileProvider
                                                          .pharamacyProductTotalList[
                                                              index]
                                                          .productName ??
                                                      'Unknown Name',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Gap(4),
                                        SizedBox(
                                          width: 232,
                                          child: Row(
                                            children: [
                                              const Gap(8),
                                              Expanded(
                                                child: Text(
                                                  profileProvider
                                                          .pharamacyProductTotalList[
                                                              index].productBrandName
                                                           ??
                                                      'Unknown Qualification',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Gap(4),
                                        SizedBox(
                                          width: 232,
                                          child: Row(
                                            children: [
                                              const Gap(8),
                                              Expanded(
                                                child: Text(
                                                  profileProvider
                                                          .pharamacyProductTotalList[
                                                              index].productDiscountRate.toString()
                                                        ,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge!
                                                      .copyWith(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Gap(4),
                                     
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Gap(8)
                      ],
                    );
                  }))
        ],
      );
    }));
  }
}
