import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/core/custom/date_and_time_picker/date_picker.dart';
import 'package:healthycart_pharmacy/core/custom/lottie/loading_lottie.dart';
import 'package:healthycart_pharmacy/core/custom/toast/toast.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_product_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_product/widgets/checkbox_text_widget.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_product/widgets/dropdown_button.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_product/widgets/gallery_image_picker.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_product/widgets/help_button.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/app_bar/sliver_appbar.dart';
import 'package:healthycart_pharmacy/core/custom/text_formfield/textformfield.dart';
import 'package:healthycart_pharmacy/core/general/validator.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/add_pharmacy_form_page/presentation/widgets/text_above_form_widdget.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/application/pharmacy_provider.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_product/widgets/percentage_container.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class MedicineAddFormWidget extends StatelessWidget {
  const MedicineAddFormWidget(
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
    });

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    DatePicker datepicker = DatePicker.instance;
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

                                /// it determines if it is  equipment or other
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
                                text: "Medicine Name",
                                starText: true,
                              ),
                              TextfieldWidget(
                                hintText: 'Enter the name eg : Cetirizine',
                                textInputAction: TextInputAction.next,
                                validator: BValidator.validate,
                                controller:
                                    pharmacyProvider.productNameController,
                              ),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                text: "Medicine Brand / Marketer",
                                starText: true,
                              ),
                              TextfieldWidget(
                                textInputAction: TextInputAction.next,
                                hintText: 'Enter the name eg: Cipla',
                                validator: BValidator.validate,
                                controller:
                                    pharmacyProvider.productBrandNameController,
                              ),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                text: "Medicine MRP (₹)",
                                starText: true,
                              ),
                              TextfieldWidget(
                                prefixText: '₹ ',
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                hintText: 'Enter the price in rupees eg : 200',
                                validator: BValidator.validate,
                                controller:
                                    pharmacyProvider.productMRPController,
                              ),
                              CheckboxTextWidget(
                                  text:
                                      'Please check the box if discount available :',
                                  onChanged: (value) {
                                    pharmacyProvider
                                        .productDiscountRateController
                                        .clear();
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
                                      text: "Medicine Discount rate (₹)",
                                    ),
                                    TextfieldWidget(
                                      prefixText: '₹ ',
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      hintText:
                                          'Enter the price in rupees eg : 200',
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
                              //       'Enter the total quantity available eg : 250 Nos',
                              //   validator: BValidator.validate,
                              //   controller:
                              //       pharmacyProvider.totalQuantityController,
                              // ),
                              // const Gap(8),
                              const TextAboveFormFieldWidget(
                                text: "Store Below Celsius",
                              ),
                              TextfieldWidget(
                                suffixText: '°C',
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                hintText:
                                    'Enter the temperature to store in °C eg : 30°C',
                                validator: BValidator.validate,
                                controller:
                                    pharmacyProvider.storeBelowController,
                              ),

                              ///// expiry section
                              const Gap(8),
                              const TextAboveFormFieldWidget(
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
                                text: "Expiry Date",
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    fit: FlexFit.loose,
                                    child: TextfieldWidget(
                                      readOnly: true,
                                      hintText: 'YYYY-MM',
                                      textInputAction: TextInputAction.next,
                                      validator: BValidator.validate,
                                      controller:
                                          pharmacyProvider.expiryDateController,
                                    ),
                                  ),
                                  const Gap(4),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.loose,
                                    child: InkWell(
                                      onTap: () async {
                                        final DateTime? selectedDate =
                                            await datepicker.showMonthYearPicker(
                                                context,
                                                (pharmacyProvider.expiryDate !=
                                                        null)
                                                    ? pharmacyProvider
                                                        .expiryDate!
                                                    : DateTime.now(),
                                                DateTime.now(),
                                                DateTime(2100),
                                                'Select the expiry year and month');
                                        if (selectedDate == null) return;
                                        pharmacyProvider
                                            .expiryDateSetter(selectedDate);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                            color: BColors.darkblue,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: const Icon(
                                          Icons.calendar_month,
                                          color: BColors.white,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const Gap(16),

                              const HelpButtonWidget(
                                text:
                                    "Following number text fields {Product Form, Product Package} needed to be filled if only required for displaying product.",
                              ),

                              const TextAboveFormFieldWidget(
                                starText: true,
                                text: "Medicine Form",
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
                                      hintText: 'Eg: 30 tablet',
                                      textInputAction: TextInputAction.next,
                                      controller: pharmacyProvider
                                          .productFormNumberController,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    fit: FlexFit.loose,
                                    child: DropDownProductButton(
                                        value: pharmacyProvider.medicineFormList
                                                .contains(pharmacyProvider
                                                    .productForm)
                                            ? pharmacyProvider.productForm
                                            : '',
                                        hintText: 'Medicine Form',
                                        onChanged: (value) {
                                          pharmacyProvider
                                              .setDropFormText(value ?? '');
                                        },
                                        optionList:
                                            pharmacyProvider.medicineFormList),
                                  ),
                                ],
                              ),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                starText: true,
                                text: "Measurement Unit",
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
                                      hintText: 'Eg: 20 ml',
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
                                        hintText: "Medicine Unit",
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
                              const Gap(8),

                              const TextAboveFormFieldWidget(
                                starText: true,
                                text: "Medicine Package",
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
                                      hintText: 'Eg: 1 Strip',
                                      textInputAction: TextInputAction.next,
                                      validator: BValidator.validate,
                                      controller: pharmacyProvider
                                          .productPackageNumberController,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    fit: FlexFit.loose,
                                    child: DropDownProductButton(
                                        value: pharmacyProvider
                                                .medicinePackageList
                                                .contains(pharmacyProvider
                                                    .productPackage)
                                            ? pharmacyProvider.productPackage
                                            : '',
                                        hintText: 'Medicine Package',
                                        onChanged: (value) {
                                          pharmacyProvider
                                              .setDropPackageText(value ?? '');
                                        },
                                        optionList: pharmacyProvider
                                            .medicinePackageList),
                                  ),
                                ],
                              ),

                              const Gap(24),
                              const TextAboveFormFieldWidget(
                                starText: true,
                                text: "Salt Composition / Key Ingredients",
                              ),
                              TextfieldWidget(
                                hintText:
                                    'Enter the salt composition eg : Cetrizon(5mg)',
                                textInputAction: TextInputAction.next,
                                validator: BValidator.validate,
                                controller:
                                    pharmacyProvider.keyIngredientController,
                              ),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                text: "Product Information",
                                starText: true,
                              ),
                              TextfieldWidget(
                                keyboardType: TextInputType.multiline,
                                hintText:
                                    'Enter the product details eg : Cetrizine Tablet belongs to a group of medicines called antihistamines. It is used to treat various allergic conditions such as hay fever, conjunctivitis and some skin reactions, and reactions to bites and stings. It relieves watery eyes, runny nose, sneezing, and itching.',
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
                                    'Enter the direction to use the product eg :  Take this medicine in the dose and duration as advised by your doctor. Swallow it as a whole. Do not chew, crush or break it. Cetrizine Tablet may be taken with or without food, but it is better to take it at a fixed time.',
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
                                hintText:
                                    'Enter the safety information eg : Cetrizine Tablet provides relief from symptoms such as blocked or runny nose, sneezing, and itchy or watery eyes. It can also give relief from allergic reactions after insect bites and symptoms of hives and eczema such as rash, swelling, itching, and irritation ',
                                maxlines: 6,
                                controller: pharmacyProvider
                                    .safetyInformationController,
                              ),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                text: "Key Benefits",
                              ),
                              TextfieldWidget(
                                textInputAction: TextInputAction.done,
                                hintText:
                                    'Enter the key benefits with medicine if any.',
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
                                          text: 'Pick medicine images.');
                                      return;
                                    }
                                    if (pharmacyProvider.productForm == null) {
                                      CustomToast.errorToast(
                                          text: 'Pick a medicine form.');
                                      return;
                                    }
                                    if (pharmacyProvider.productPackage ==
                                        null) {
                                      CustomToast.errorToast(
                                          text: 'Pick a medicine package.');
                                      return;
                                    }
                                    if (pharmacyProvider
                                            .productMeasurementUnit ==
                                        null) {
                                      CustomToast.errorToast(
                                          text: 'Pick a medicine unit.');
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
                                      if (pharmacyProvider.expiryDate == null) {
                                        CustomToast.errorToast(
                                            text: 'Pick the expiry date.');
                                        return;
                                      }
                                      await pharmacyProvider
                                          .addPharmacyMedicineDetails(
                                              context: context);
                                    } else {
                                      await pharmacyProvider
                                          .updatePharmacyMedicineDetails(
                                              index: index!,
                                              medicineEditData: productDetails!,
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
