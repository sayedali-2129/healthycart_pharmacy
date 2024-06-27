import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/app_bar/sliver_appbar.dart';
import 'package:healthycart_pharmacy/core/custom/custom_buttons_and_search/search_field_button.dart';
import 'package:healthycart_pharmacy/core/custom/custom_cached_network/custom_cached_network_image.dart';
import 'package:healthycart_pharmacy/core/custom/lottie/circular_loading.dart';
import 'package:healthycart_pharmacy/core/custom/no_data/no_data_widget.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_product/widgets/percentage_container.dart';
import 'package:healthycart_pharmacy/features/pharmacy_profile/application/profile_provider.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class PharmacyProfileProductList extends StatefulWidget {
  const PharmacyProfileProductList({super.key});

  @override
  State<PharmacyProfileProductList> createState() =>
      _PharmacyProfileProductListState();
}

class _PharmacyProfileProductListState
    extends State<PharmacyProfileProductList> {
  final ScrollController _scrollcontroller = ScrollController();
  @override
  void initState() {
    final profileProvider = context.read<ProfileProvider>();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      profileProvider.clearFetchData();
      profileProvider.getPharmacyProductDetails();
    });

    _scrollcontroller.addListener(() {
      if (_scrollcontroller.position.atEdge &&
          _scrollcontroller.position.pixels != 0 &&
          profileProvider.fetchLoading == false) {
        profileProvider.getPharmacyProductDetails();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    EasyDebounce.cancel('searchproduct');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
      return CustomScrollView(
        controller: _scrollcontroller,
        slivers: [
          SliverCustomAppbar(
            title: 'All Product',
            onBackTap: () {
              EasyNavigation.pop(context: context);
            },
            child: PreferredSize(
              preferredSize: const Size(double.infinity, 68),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 8, top: 4),
                child: SearchTextFieldButton(
                  text: "Search product's...",
                  controller: profileProvider.searchController,
                  onChanged: (value) {
                    EasyDebounce.debounce(
                        'searchproduct', const Duration(milliseconds: 500), () {
                      profileProvider.searchProduct(value);
                    });
                  },
                ),
              ),
            ),
          ),
          (profileProvider.fetchLoading && profileProvider.productList.isEmpty)

              /// loading is done here
              ? const SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: LoadingIndicater()
                    ),
                  ),
                )
              : (profileProvider.productList.isEmpty)
                  ? const ErrorOrNoDataPage(
                      text: "No item's found.",
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList.builder(
                          itemCount:
                              profileProvider.productList.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Material(
                                    color: BColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 96,
                                            width: 104,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: CustomCachedNetworkImage(
                                                  fit: BoxFit.contain,
                                                    image: profileProvider
                                                            .productList[
                                                                index]
                                                            .productImage?[0] ??
                                                        ''),
                                                        ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const  EdgeInsets.only(left: 12, right: 16),
                                              child: Column(
                                                 mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Gap(8),
                                                  Text(
                                                    profileProvider
                                                            .productList[
                                                                index]
                                                            .productName ??
                                                        'Unknown Name',
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    maxLines: 2,
                                                    style: Theme.of(
                                                            context)
                                                        .textTheme
                                                        .labelLarge!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                  const Gap(4),
                                                  RichText(
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                        text:
                                                            'by : ', // remeber to put space
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge!
                                                            .copyWith(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      ),
                                                      TextSpan(
                                                        text: profileProvider
                                                            .productList[index]
                                                            .productBrandName,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge!
                                                            .copyWith(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      ),
                                                    ]),
                                                  ),
                                        
                                  
                                                  const Gap(4),
                                                  (profileProvider
                                                              .productList[index]
                                                              .productDiscountRate ==
                                                          null)
                                                      ? RichText(
                                                          text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      'Our price : ',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .labelLarge!
                                                                      .copyWith(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                ),
                                                                TextSpan(
                                                                    text: "₹ ",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .labelLarge!
                                                                        .copyWith(
                                                                            fontSize:
                                                                                13,
                                                                            color: BColors
                                                                                .green,
                                                                            fontWeight:
                                                                                FontWeight.w700)),
                                                                TextSpan(
                                                                  text:
                                                                      "${profileProvider.productList[index].productMRPRate} ",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .labelLarge!
                                                                      .copyWith(
                                                                          fontSize:
                                                                              13,
                                                                          color: BColors
                                                                              .green,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                ),
                                                              ]),
                                                        )
                                                      : RichText(
                                                          text:
                                                              TextSpan(children: [
                                                          TextSpan(
                                                            text: 'Our price : ',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge!
                                                                .copyWith(
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          ),
                                                          TextSpan(
                                                              text: "₹ ",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .labelLarge!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          13,
                                                                      color: BColors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700)),
                                                          TextSpan(
                                                            text:
                                                                "${profileProvider.productList[index].productDiscountRate}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge!
                                                                .copyWith(
                                                                    color: BColors
                                                                        .green,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          ),
                                                          const TextSpan(
                                                              text: '  '),
                                                          TextSpan(
                                                            text:
                                                                "${profileProvider.productList[index].productMRPRate}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge!
                                                                .copyWith(
                                                                    fontSize: 12,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                    decorationThickness:
                                                                        2.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          ),
                                                        ])),
                                                  const Gap(8),
                                                  if (profileProvider
                                                          .productList[index]
                                                          .productDiscountRate !=
                                                      null)
                                                    PercentageShowContainerWidget(
                                                      text:
                                                          '${profileProvider.productList[index].discountPercentage}% off',
                                                      textColor: BColors.white,
                                                      boxColor: BColors.offRed,
                                                      width: 74,
                                                      height: 26,
                                                    ),
                                                  const Gap(4),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child:  (profileProvider
                                                        .productList[index]
                                                        .expiryDate !=
                                                    null)?
                                                  RichText(
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                        text:
                                                            'Expiry Date : ', // remeber to put space
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge!
                                                            .copyWith(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      ),
                                                      TextSpan(
                                                        text: profileProvider
                                                            .expiryDateSetterFetched(
                                                                profileProvider
                                                                    .productList[
                                                                        index]
                                                                    .expiryDate!),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge!
                                                            .copyWith(
                                                              color: BColors.mainlightColor,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      ),
                                                    ]),
                                                  ) : const SizedBox()
                                                  )
                              ],
                            );
                          }),
                    ),
          SliverToBoxAdapter(
              child: (profileProvider.fetchLoading == true &&
                      profileProvider.productList.isNotEmpty)
                  ? const Center(child: LoadingIndicater())
                  : null),
        ],
      );
    }));
  }
}
