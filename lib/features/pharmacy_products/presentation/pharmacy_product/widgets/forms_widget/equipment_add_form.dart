import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/app_bar/sliver_appbar.dart';
import 'package:healthycart_pharmacy/core/custom/lottie/loading_lottie.dart';
import 'package:healthycart_pharmacy/core/custom/text_formfield/textformfield.dart';
import 'package:healthycart_pharmacy/core/custom/toast/toast.dart';
import 'package:healthycart_pharmacy/core/general/validator.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/add_pharmacy_form_page/presentation/widgets/text_above_form_widdget.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/application/pharmacy_provider.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_product_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_product/widgets/checkbox_text_widget.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_product/widgets/dropdown_button.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_product/widgets/gallery_image_picker.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_product/widgets/help_button.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_product/widgets/percentage_container.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class EquipmentAddFormWidget extends StatelessWidget {
  const EquipmentAddFormWidget(
      {super.key,
      required this.typeOfProduct,
      required this.isEditing,
      this.productDetails,
      this.index});
  final String typeOfProduct;
  final bool isEditing;
  final PharmacyProductAddModel? productDetails;
  final int? index;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      final pharmacyProvider = context.read<PharmacyProvider>();
      pharmacyProvider.typeOfProduct = typeOfProduct;
      log('Product type:::::${pharmacyProvider.productType}');
      log('Product type List:::::${pharmacyProvider.equipmentTypeList}');
    });

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(body:
        Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {
      return PopScope(
        canPop: (isEditing == false &&
            pharmacyProvider.imageProductUrlList.isEmpty),
        onPopInvoked: (didPop) {
          if (isEditing == false &&
              pharmacyProvider.imageProductUrlList.isNotEmpty) {
            CustomToast.errorToast(text: 'Please remove the image selected.');
            return;
          }
        },
        child: CustomScrollView(slivers: [
          SliverCustomAppbar(
            onBackTap: () {
              if (isEditing == false &&
                  pharmacyProvider.imageProductUrlList.isNotEmpty) {
                CustomToast.errorToast(
                    text: 'Please remove the image selected.');
                return;
              }
              if (isEditing == true &&
                  pharmacyProvider.deleteUrlList.isNotEmpty) {
                CustomToast.errorToast(
                    text: 'Please save the changed details.');
                return;
              }
              pharmacyProvider.clearProductDetails();
              EasyNavigation.pop(context: context);
            },
            title: (isEditing) ? 'Edit Details' : 'Add Details',
          ),
          SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SingleChildScrollView(
                    child: Column(children: [
                      GalleryImagePicker(isEditing: isEditing),
                      const Gap(24),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'Product Type : ',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    )),
                            TextSpan(
                                text: typeOfProduct,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: BColors.mainlightColor))
                          ])),
                      const Gap(8),
                      Form(
                        key: formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextAboveFormFieldWidget(
                                text: "Equipment Name",
                                starText: true,
                              ),
                              TextfieldWidget(
                                hintText:
                                    'Enter the name eg : Asbob Healthcare 3 in 1 Vaporizers',
                                textInputAction: TextInputAction.next,
                                validator: BValidator.validate,
                                controller:
                                    pharmacyProvider.productNameController,
                              ),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                text: "Equipment Brand / Marketer",
                                starText: true,
                              ),
                              TextfieldWidget(
                                textInputAction: TextInputAction.next,
                                hintText: 'Enter the name eg: Asbob Healthcare',
                                validator: BValidator.validate,
                                controller:
                                    pharmacyProvider.productBrandNameController,
                              ),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                text: "Equipment MRP (₹)",
                                starText: true,
                              ),
                              TextfieldWidget(
                                prefixText: '₹ ',
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                hintText: 'Enter the price in rupees eg : 2000',
                                validator: BValidator.validate,
                                controller:
                                    pharmacyProvider.productMRPController,
                              ),
                              CheckboxTextWidget(
                                  text:
                                      'Please check the box if discount available :',
                                  onChanged: (value) {
                                    pharmacyProvider
                                        .discountAvailableboolSetter(value);
                                  },
                                  value: pharmacyProvider.discountAvailable ??
                                      false),
                              if (pharmacyProvider.discountAvailable == true)
                                Column(
                                  //// discount section
                                  children: [
                                    const TextAboveFormFieldWidget(
                                      text: "Equipment Discount rate (₹)",
                                    ),
                                    TextfieldWidget(
                                      prefixText: '₹ ',
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      hintText:
                                          'Enter the price in rupees eg : 1000',
                                      validator: BValidator.validate,
                                      controller: pharmacyProvider
                                          .productDiscountRateController,
                                      onChanged: (value) {
                                        pharmacyProvider
                                            .discountPercentageCalculator();
                                      },
                                    ),
                                    if (pharmacyProvider.discountPercentage !=
                                        null)
                                      Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8, bottom: 8, top: 8),
                                            child:
                                                PercentageShowContainerWidget(
                                              text:
                                                  '${pharmacyProvider.discountPercentage}% off',
                                              textColor: BColors.white,
                                              boxColor: BColors.offRed,
                                              width: 80,
                                              height: 32,
                                            ),
                                          )),
                                  ],
                                ),
                              const Gap(8),
                              // const TextAboveFormFieldWidget(
                              //   starText: true,
                              //   text: "Total Quantity",
                              // ),
                              // TextfieldWidget(
                              //   suffixText: 'Nos',
                              //   keyboardType: TextInputType.number,
                              //   textInputAction: TextInputAction.next,
                              //   hintText:
                              //       'Enter the total quantity available eg : 25 Nos',
                              //   validator: BValidator.validate,
                              //   controller:
                              //       pharmacyProvider.totalQuantityController,
                              // ),
                              // const Gap(8),
                              const TextAboveFormFieldWidget(
                                text: "Box / Package contains ",
                              ),
                              TextfieldWidget(
                                keyboardType: TextInputType.streetAddress,
                                textInputAction: TextInputAction.next,
                                hintText:
                                    'Enter the things inside eg : User manual, one charger',
                                validator: BValidator.validate,
                                controller: pharmacyProvider
                                    .productBoxContainsController,
                              ),
                              const Gap(16),
                              const HelpButtonWidget(
                                  text:
                                      "Following number text fields {Equipment weight, Equipment type} needed to be filled if only required for displaying product."),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                starText: true,
                                text: "Equipment Type",
                              ),
                              DropDownProductButton(
                                  value:pharmacyProvider.equipmentTypeList.contains(pharmacyProvider.productType)? pharmacyProvider.productType : '',
                                  hintText: 'Equipment type',
                                  onChanged: (value) {
                                    pharmacyProvider
                                        .setDropProductTypeText(value ?? '');
                                  },
                                  optionList:
                                      pharmacyProvider.equipmentTypeList),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                starText: true,
                                text: "Ideal for",
                              ),
                              DropDownProductButton(
                                  value: pharmacyProvider.idealFor,
                                  hintText: 'Ideal for',
                                  onChanged: (value) {
                                    pharmacyProvider
                                        .setIdealForText(value ?? '');
                                  },
                                  optionList:
                                      pharmacyProvider.idealForOptionList),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                starText: true,
                                text: "Waranty Period",
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: TextfieldWidget(
                                      keyboardType: TextInputType.number,
                                      hintText: 'Eg: 18 months',
                                      textInputAction: TextInputAction.next,
                                      validator: BValidator.validate,
                                      controller: pharmacyProvider
                                          .productWarrantyController,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    fit: FlexFit.loose,
                                    child: DropDownProductButton(
                                        value: pharmacyProvider
                                            .selectedWarantyOption,
                                        hintText: 'Time Period',
                                        onChanged: (value) {
                                          pharmacyProvider
                                              .setWarantyOption(value ?? '');
                                        },
                                        optionList:
                                            pharmacyProvider.warantyOptionList),
                                  ),
                                ],
                              ),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                starText: true,
                                text: "Equipment weight",
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: TextfieldWidget(
                                      keyboardType: TextInputType.number,
                                      hintText: 'Eg: 2 kg',
                                      textInputAction: TextInputAction.next,
                                      validator: BValidator.validate,
                                      controller: pharmacyProvider
                                          .measurementUnitNumberController,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    fit: FlexFit.loose,
                                    child: DropDownProductButton(
                                        value: pharmacyProvider
                                            .productMeasurementUnit,
                                        hintText: 'Unit',
                                        onChanged: (value) {
                                          pharmacyProvider
                                              .setDropMeasurementText(
                                                  value ?? '');
                                        },
                                        optionList: pharmacyProvider
                                            .measurmentOptionList),
                                  ),
                                ],
                              ),
                              const Gap(24),
                              const TextAboveFormFieldWidget(
                                text: "Product Information",
                                starText: true,
                              ),
                              TextfieldWidget(
                                keyboardType: TextInputType.multiline,
                                hintText:
                                    'Enter the product details eg : Asbob 3 in 1 steamer, vaporizer, steam inhaler for cold and cough (1.15 Meter) is composed of plastic and polymers, making it durable and comes with a 1.25-length in meter. It is commonly used for health care purposes and helps relieve allergies, and the sinus',
                                validator: BValidator.validate,
                                maxlines: 6,
                                controller: pharmacyProvider
                                    .productInformationController,
                              ),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                text: "Direction to use",
                              ),
                              TextfieldWidget(
                                keyboardType: TextInputType.multiline,
                                hintText:
                                    'Enter the direction to use the product',
                                maxlines: 6,
                                controller:
                                    pharmacyProvider.directionToUseController,
                              ),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                text: "Safety Information",
                              ),
                              TextfieldWidget(
                                keyboardType: TextInputType.multiline,
                                hintText: 'Enter the safety information ',
                                maxlines: 6,
                                controller: pharmacyProvider
                                    .safetyInformationController,
                              ),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                text: "Specification",
                              ),
                              TextfieldWidget(
                                textInputAction: TextInputAction.done,
                                hintText:
                                    'Enter the specification of equipment',
                                maxlines: 6,
                                controller:
                                    pharmacyProvider.keyBenefitController,
                              ),
                              const Gap(16),
                              const TextAboveFormFieldWidget(
                                text: "Important Note",
                                starText: true,
                              ),
                              CheckboxTextWidget(
                                  text:
                                      'Please check the box if prescription is needed :',
                                  onChanged: (value) {
                                    pharmacyProvider
                                        .prescriptionNeededboolSetter(value);
                                  },
                                  value: pharmacyProvider.prescriptionNeeded ??
                                      false),
                              const Gap(16),
                              SizedBox(
                                height: 48,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (pharmacyProvider
                                        .imageProductUrlList.isEmpty) {
                                      CustomToast.errorToast(
                                          text: 'Pick product images.');
                                      return;
                                    }
                                      if (pharmacyProvider
                                            .productType ==
                                        null) {
                                      CustomToast.errorToast(
                                          text: 'Pick a product type.');
                                      return;
                                    }
                                    if (pharmacyProvider
                                            .selectedWarantyOption ==
                                        null) {
                                      CustomToast.errorToast(
                                          text: 'Pick a warranty period.');
                                      return;
                                    }
                                     
                                    if (pharmacyProvider
                                            .productMeasurementUnit ==
                                        null) {
                                      CustomToast.errorToast(
                                          text: 'Pick a product weight.');
                                      return;
                                    }

                                    if (!formKey.currentState!.validate()) {
                                      formKey.currentState!.validate();
                                      return;
                                    }
                                    LoadingLottie.showLoading(
                                        context: context,
                                        text: 'Please wait...');
                                    if (productDetails == null &&
                                        isEditing == false) {
                                      await pharmacyProvider
                                          .addPharmacyEquipmentDetails(
                                              context: context);
                                    } else {
                                      await pharmacyProvider
                                          .updatePharmacyEquipmentDetails(
                                              index: index!,
                                              equipmentEditData:
                                                  productDetails!,
                                              context: context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: BColors.darkblue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16))),
                                  child: (pharmacyProvider.fetchLoading)
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
                                          (productDetails == null &&
                                                  isEditing == false)
                                              ? 'Save'
                                              : 'Update details',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Colors.white,
                                              ),
                                        ),
                                ),
                              ),
                              const Gap(24),
                            ]),
                      ),
                    ]),
                  ),
                ),
              )),
        ]),
      );
    }));
  }
}
