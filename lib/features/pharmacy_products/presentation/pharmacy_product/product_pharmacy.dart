// ignore_for_file: use_build_context_synchronously
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/custom_buttons_and_search/search_field_button.dart';
import 'package:healthycart_pharmacy/core/custom/custom_cached_network/custom_cached_network_image.dart';
import 'package:healthycart_pharmacy/core/custom/lottie/loading_lottie.dart';
import 'package:healthycart_pharmacy/core/custom/pop_over/pop_over.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/application/pharmacy_provider.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_product/widgets/bottomsheet_product_choose.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_product/widgets/forms_widget/equipment_add_form.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_product/widgets/forms_widget/medicine_add_form.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_product/widgets/forms_widget/other_add_form.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_product/widgets/percentage_container.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../../../core/custom/app_bar/sliver_appbar.dart';

class PharmacyProductScreen extends StatefulWidget {
  const PharmacyProductScreen({super.key});

  @override
  State<PharmacyProductScreen> createState() => _PharmacyProductScreenState();
}

class _PharmacyProductScreenState extends State<PharmacyProductScreen> {
  final ScrollController scrollcontroller = ScrollController();
  @override
  void initState() {
    final pharmacyProvider = context.read<PharmacyProvider>();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      pharmacyProvider.clearFetchData();
      pharmacyProvider.getPharmacyProductDetails();
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
        body:
            Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {
          return CustomScrollView(
            controller: scrollcontroller,
            slivers: [
              SliverCustomAppbar(
                title: pharmacyProvider.selectedCategoryText ?? 'Product List',
                onBackTap: () {
                  Navigator.pop(context);
                },
                child: PreferredSize(
                  preferredSize: const Size(double.infinity, 68),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 8, top: 4),
                    child: Row(
                      children: [
                        Expanded(
                            child: SearchTextFieldButton(
                          text: "Search product's...",
                          controller: pharmacyProvider.searchController,
                          onChanged: (value) {
                            EasyDebounce.debounce('searchproduct',
                                const Duration(milliseconds: 500), () {
                              pharmacyProvider.searchProduct(value);
                            });
                          },
                        )),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: BColors.darkblue,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Icon(
                              Icons.filter_alt_outlined,
                              color: BColors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16, bottom: 8, left: 16, right: 16),
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
                  : (pharmacyProvider.productList.isEmpty)
                      ? SliverFillRemaining(
                          child: Center(
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "No Product's added in this category.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(fontSize: 14),
                                )),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          sliver: SliverList.builder(
                            itemCount: pharmacyProvider.productList.length,
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
                                                width: 104,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    child: (pharmacyProvider
                                                            .productList[index]
                                                            .productImage!
                                                            .isNotEmpty)
                                                        ? CustomCachedNetworkImage(
                                                            image: pharmacyProvider
                                                                .productList[
                                                                    index]
                                                                .productImage?[0]?? ''
                                                                )
                                                        : SizedBox())),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12, right: 16),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Gap(12),
                                                    Text(
                                                      pharmacyProvider
                                                              .productList[
                                                                  index]
                                                              .productName ??
                                                          '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    RichText(
                                                        text:
                                                            TextSpan(children: [
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
                                                        text: pharmacyProvider
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
                                                    ])),
                                                    const Gap(4),
                                                    RichText(
                                                        text:
                                                            TextSpan(children: [
                                                      TextSpan(
                                                        text:
                                                            'Product type : ', // remeber to put space
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
                                                        text: pharmacyProvider
                                                            .productList[index]
                                                            .typeOfProduct,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge!
                                                            .copyWith(
                                                                color: BColors
                                                                    .mainlightColor,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      ),
                                                    ])),
                                                    const Gap(4),
                                                    (pharmacyProvider
                                                                .productList[
                                                                    index]
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
                                                                    text:
                                                                        "${pharmacyProvider.productList[index].productMRPRate} ",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .labelLarge!
                                                                        .copyWith(
                                                                            fontSize:
                                                                                13,
                                                                            color:
                                                                                BColors.green,
                                                                            fontWeight: FontWeight.w700),
                                                                  ),
                                                                ]),
                                                          )
                                                        : RichText(
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
                                                                  text:
                                                                      "${pharmacyProvider.productList[index].productMRPRate}",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .labelLarge!
                                                                      .copyWith(
                                                                          fontSize:
                                                                              12,
                                                                          decoration: TextDecoration
                                                                              .lineThrough,
                                                                          decorationThickness:
                                                                              2.0,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                ),
                                                                const TextSpan(
                                                                    text: '  '),
                                                                TextSpan(
                                                                  text:
                                                                      "${pharmacyProvider.productList[index].productDiscountRate}",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .labelLarge!
                                                                      .copyWith(
                                                                          color: BColors
                                                                              .green,
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                ),
                                                              ])),
                                                    const Gap(8),
                                                    if (pharmacyProvider
                                                            .productList[index]
                                                            .productDiscountRate !=
                                                        null)
                                                      PercentageShowContainerWidget(
                                                        text:
                                                            '${pharmacyProvider.productList[index].discountPercentage} %',
                                                        textColor:
                                                            BColors.white,
                                                        boxColor:
                                                            BColors.offRed,
                                                        width: 64,
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
                                      child: PopOverEditDelete(editButton: () {
                                        if (pharmacyProvider.productList[index]
                                                .typeOfProduct ==
                                            'Medicine') {
                                          pharmacyProvider.setMedicineEditData(
                                              medicineEditData: pharmacyProvider
                                                  .productList[index]);
                                          EasyNavigation.push(
                                              type: PageTransitionType
                                                  .bottomToTop,
                                              context: context,
                                              page: MedicineAddFormWidget(
                                                typeOfProduct: pharmacyProvider
                                                        .productList[index]
                                                        .typeOfProduct ??
                                                    'Medicine',
                                                isEditing: true,
                                                productDetails: pharmacyProvider
                                                    .productList[index],
                                               index: index,     
                                              ));
                                        } else if (pharmacyProvider
                                                .productList[index]
                                                .typeOfProduct ==
                                            'Equipment') {
                                          pharmacyProvider.setEquipmentEditData(
                                              equipmentEditData:
                                                  pharmacyProvider
                                                      .productList[index]);
                                          EasyNavigation.push(
                                              type: PageTransitionType
                                                  .bottomToTop,
                                              context: context,
                                              page: EquipmentAddFormWidget(
                                                typeOfProduct: pharmacyProvider
                                                        .productList[index]
                                                        .typeOfProduct ??
                                                    'Equipment',
                                                isEditing: true,
                                                productDetails: pharmacyProvider
                                                    .productList[index],
                                               index: index,      
                                              ));
                                        } else {
                                          pharmacyProvider.setOtherEditData(
                                              othersEditData: pharmacyProvider
                                                  .productList[index]);
                                          EasyNavigation.push(
                                              type: PageTransitionType
                                                  .bottomToTop,
                                              context: context,
                                              page: OtherAddFormWidget(
                                                typeOfProduct: pharmacyProvider
                                                        .productList[index]
                                                        .typeOfProduct ??
                                                    "Other",
                                                isEditing: true,
                                                productDetails: pharmacyProvider
                                                    .productList[index],
                                              index: index,       
                                              ));
                                        }
                                      }, deleteButton: () async {
                                        LoadingLottie.showLoading(
                                            context: context,
                                            text: "Removing...");

                                        await pharmacyProvider
                                            .deletePharmacyImageList(
                                                imageUrls: pharmacyProvider
                                                        .productList[index]
                                                        .productImage ??
                                                    [])
                                            .then((value) async{
                                         await pharmacyProvider
                                              .deletePharmacyProductDetails(
                                                  index: index,
                                                  productData: pharmacyProvider
                                                      .productList[index])
                                              .then((value) {
                                            EasyNavigation.pop(
                                                context: context);
                                          });
                                        });
                                      }))
                                ],
                              );
                            },
                          ),
                        ),
              SliverToBoxAdapter(
                  child: (pharmacyProvider.fetchLoading == true &&
                          pharmacyProvider.productList.isNotEmpty)
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: BColors.darkblue,
                          ),
                        )
                      : null),
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
        ));
  }
}
