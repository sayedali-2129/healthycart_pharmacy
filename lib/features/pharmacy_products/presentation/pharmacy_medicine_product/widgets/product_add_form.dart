import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/app_bar/sliver_appbar.dart';
import 'package:healthycart_pharmacy/core/custom/custom_cached_network/custom_cached_network_image.dart';
import 'package:healthycart_pharmacy/core/custom/divider/divider.dart';
import 'package:healthycart_pharmacy/core/custom/lottie/loading_lottie.dart';
import 'package:healthycart_pharmacy/core/custom/text_formfield/textformfield.dart';
import 'package:healthycart_pharmacy/core/custom/toast/toast.dart';
import 'package:healthycart_pharmacy/core/general/validator.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/add_pharmacy_form_page/presentation/widgets/text_above_form_widdget.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/application/pharmacy_provider.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_medicine_product/widgets/image_add_conatainer.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class ProductAddFormWidget extends StatelessWidget {
  const ProductAddFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
        Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {
      return CustomScrollView(slivers: [
        SliverCustomAppbar(
          onBackTap: () {
            EasyNavigation.pop(context: context);
          },
          title: 'Add Details',
        ),
        SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverFillRemaining(
              child: SingleChildScrollView(
                child: Column(children: [
                  AddProductImageWidget(
                      addTap: () {
                        if (pharmacyProvider.imageProductUrlList.length >= 3) {
                          return CustomToast.sucessToast(
                              text:
                                  'Maximum images are selected, remove to add new.');
                        }
                        pharmacyProvider.getProductImageList(context: context);
                      },
                      height: 160,
                      width: 200,
                      child: (pharmacyProvider.imageProductUrlList.isEmpty)
                          ? const Center(
                              child: (Icon(
                                Icons.add_circle_outline_rounded,
                                size: 64,
                              )),
                            )
                          : CustomCachedNetworkImage(
                              image: pharmacyProvider.imageProductUrlList[
                                  pharmacyProvider.selectedIndex])),
                  const Gap(8),
                  DividerWidget(
                      text: (pharmacyProvider.imageProductUrlList.length < 3)
                          ? 'Tap above to add images'
                          : 'Maximum images are selected'),
                  (pharmacyProvider.imageProductUrlList.isNotEmpty)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 56,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  pharmacyProvider.imageProductUrlList.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: Container(
                                        decoration: (pharmacyProvider
                                                    .selectedIndex ==
                                                index)
                                            ? BoxDecoration(
                                                border: Border.all(
                                                  color: BColors.mainlightColor,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10))
                                            : null,
                                        child: AddProductImageWidget(
                                            addTap: () {
                                              pharmacyProvider
                                                  .selectedImageIndex(index);
                                            },
                                            height: 56,
                                            width: 64,
                                            child: (pharmacyProvider
                                                    .imageProductUrlList
                                                    .isEmpty)
                                                ? const Center(
                                                    child: (Icon(
                                                      Icons.image,
                                                      size: 40,
                                                    )),
                                                  )
                                                : CustomCachedNetworkImage(
                                                    image: pharmacyProvider
                                                            .imageProductUrlList[
                                                        index])),
                                      ),
                                    ),
                                    Positioned(
                                        right: -2,
                                        top: -2,
                                        child: GestureDetector(
                                          onTap: () {
                                            LoadingLottie.showLoading(
                                                context: context,
                                                text: 'Please wait...');
                                            pharmacyProvider
                                                .deleteProductImageList(
                                              context: context,
                                              index: index,
                                              selectedImageUrl: pharmacyProvider
                                                  .imageProductUrlList[index],
                                            )
                                                .then((value) {
                                              EasyNavigation.pop(
                                                  context: context);
                                            });
                                          },
                                          child: const Icon(
                                            Icons.cancel,
                                            color: BColors.darkgrey,
                                          ),
                                        ))
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const Gap(24),
                  const TextAboveFormFieldWidget(
                    // type
                    text: "Product Type: Medicine",
                  ),
                  const Gap(8),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextAboveFormFieldWidget(
                          text: "Medicine Name",
                        ),
                        TextfieldWidget(
                          hintText: 'Enter the name eg: Cetirizine',
                          validator: BValidator.validate,
                          controller: TextEditingController(),
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontSize: 16,
                                  ),
                        ),
                        const Gap(8),
                        const TextAboveFormFieldWidget(
                          text: "Medicine Brand / Marketer",
                        ),
                        TextfieldWidget(
                          hintText: 'Enter the name eg: Cipla',
                          validator: BValidator.validate,
                          controller: TextEditingController(),
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontSize: 16,
                                  ),
                        ),
                        const Gap(8),
                        const TextAboveFormFieldWidget(
                          text: "Medicine MRP (₹)",
                        ),
                        TextfieldWidget(
                          keyboardType: TextInputType.number,
                          hintText: 'Enter the price in rupees eg: 200',
                          validator: BValidator.validate,
                          controller: TextEditingController(),
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontSize: 16,
                                  ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                'Please check the box if discount available :',
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontSize: 11,
                                    )),
                            Checkbox(value: false, onChanged: (_) {}),
                          ],
                        ),
                        const Gap(8),
                        const TextAboveFormFieldWidget(
                          text: "Medicine discount rate (₹)",
                        ),
                        TextfieldWidget(
                          keyboardType: TextInputType.number,
                          hintText: 'Enter the price in rupees eg: 200',
                          validator: BValidator.validate,
                          controller: TextEditingController(),
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontSize: 16,
                                  ),
                        ),
                        const Gap(8),
                        const TextAboveFormFieldWidget(
                          text: "Product Information",
                          starText: true,
                        ),
                        TextfieldWidget(
                          hintText: 'Enter the product details',
                          validator: BValidator.validate,
                          maxlines: 6,
                          controller: TextEditingController(),
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontSize: 16,
                                  ),
                        ),
                        const Gap(16),
                        SizedBox(
                          height: 48,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: BColors.darkblue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16))),
                            child: (false)
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 4,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Save',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                          ),
                        ),
                      ]),
                ]),
              ),
            )),
      ]);
    }));
  }
}
