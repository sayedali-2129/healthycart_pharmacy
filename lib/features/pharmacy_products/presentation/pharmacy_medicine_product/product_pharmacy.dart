// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/custom_buttons_and_search/common_button.dart';
import 'package:healthycart_pharmacy/core/custom/custom_buttons_and_search/search_field_button.dart';
import 'package:healthycart_pharmacy/core/custom/custom_cached_network/custom_cached_network_image.dart';
import 'package:healthycart_pharmacy/core/custom/lottie/loading_lottie.dart';
import 'package:healthycart_pharmacy/core/custom/pop_over/pop_over.dart';
import 'package:healthycart_pharmacy/core/custom/toast/toast.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/application/pharmacy_provider.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_medicine_product/widgets/bottomsheet_product_choose.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_medicine_product/widgets/product_add_form.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_medicine_product/widgets/product_choose_button_widget.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../../../core/custom/app_bar/sliver_appbar.dart';

class PharmacyProductScreen extends StatelessWidget {
  const PharmacyProductScreen({super.key});
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {});

    return Scaffold(
        body:
            Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {
          return CustomScrollView(
            slivers: [
              SliverCustomAppbar(
                title: pharmacyProvider.selectedDoctorCategoryText ??
                    'Doctors List',
                onBackTap: () {
                  Navigator.pop(context);
                },
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: SearchTextFieldButton(
                        text: "Search product's...",
                        controller: TextEditingController(),
                      )),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: BColors.darkblue,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Icon(
                            Icons.filter_alt,
                            color: BColors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Product's List",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              (pharmacyProvider.fetchLoading)

                  /// loading is done here
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: LinearProgressIndicator(
                            color: BColors.darkblue,
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      sliver: SliverList.builder(
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Material(
                                  surfaceTintColor: BColors.white,
                                  color: BColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 96,
                                          width: 96,
                                          decoration: BoxDecoration(
                                            color: BColors.mainlightColor,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            // child: CustomCachedNetworkImage(
                                            //     image:  '')
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 16),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Gap(12),
                                                RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                    text:
                                                        'Citrizon ', // remeber to put space
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                          fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                  TextSpan(
                                                    text: '-',
                                                    style: Theme.of(context)
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
                                                  TextSpan(
                                                    text: ' by Cipla ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge!
                                                        .copyWith(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                ])),
                                                  const Gap(4),
                                                 RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                    text:
                                                        'Product type: ', // remeber to put space
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
                                                    text: 'Medicine',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge!
                                                        .copyWith(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                ])),
                                                const Gap(4),
                                                RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                    text: 'Our price: ',
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
                                                    text: 'MRP ₹499 ',
                                                    style: Theme.of(context)
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
                                                  TextSpan(
                                                    text: ' ₹225',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge!
                                                        .copyWith(
                                                            color:
                                                                BColors.green,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                ])),
                                                const Gap(8),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(8),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                      color: BColors.offRed),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 2),
                                                    child: Text(
                                                      '25 %',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelLarge!
                                                          .copyWith(
                                                              color: BColors
                                                                  .white),
                                                    ),
                                                  ),
                                                )
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
                                  top: 0,
                                  right: 0,
                                  child: PopOverEditDelete(
                                      editButton: () {}, deleteButton: () {}))
                            ],
                          );
                        },
                      ),
                    ),
            ],
          );
        }),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            bottom: 16,
          ),
          child: SizedBox(
            width: 136,
            child: FloatingActionButton(
              elevation: 10,
              tooltip: 'Add new product',
              clipBehavior: Clip.antiAlias,
              isExtended: true,
              backgroundColor: BColors.darkblue,
              onPressed: () {
                showModalBottomSheet(
                    showDragHandle: true,
                    elevation: 10,
                    backgroundColor: Colors.white,
                    context: context,
                    builder: (context) {
                      return const ChooseProductBottomSheet();
                    });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text('Add New',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(fontSize: 14, color: BColors.white)),
                    const Gap(8),
                    const Icon(
                      Icons.assignment_add,
                      color: BColors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )


        );
  }
}






                  // popup.showBottomSheet(
                  //     context:
                  //         context, //// adding nag in new doctor adding form from here
                  //     addImageTap: () {
                  //       pharmacyProvider.getImage();
                  //     },
                  //     saveButtonTap: () async {
                  //       if (pharmacyProvider.imageFile == null) {
                  //         CustomToast.errorToast(text: "Pick a product's image");
                  //         return;
                  //       }
                  //       if (pharmacyProvider.timeSlotListElementList!.isEmpty ||
                  //           pharmacyProvider.availableTotalTime == null) {
                  //         CustomToast.errorToast(
                  //             text: 'No available time slot is added');
                  //         return;
                  //       }
                  //       if (!pharmacyProvider.formKey.currentState!
                  //           .validate()) {
                  //         pharmacyProvider.formKey.currentState!.validate();
                  //         return;
                  //       }

                  //       LoadingLottie.showLoading(
                  //           context: context, text: 'Please wait...');

                  //       await pharmacyProvider.saveImage().then((value) async {
                    
                  //       });
                  //     });