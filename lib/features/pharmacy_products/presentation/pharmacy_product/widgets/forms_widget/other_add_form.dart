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

class OtherAddFormWidget extends StatelessWidget {
  const OtherAddFormWidget(
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
      pharmacyProvider.getMedicineFormAndPackageList();
    });

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    DatePicker datepicker = DatePicker.instance;
    return Scaffold(body:
        Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {
      return PopScope(
        canPop:  (isEditing == false &&
                  pharmacyProvider.imageProductUrlList.isEmpty),
         onPopInvoked: (didPop) {
            if (isEditing == false &&
                  pharmacyProvider.imageProductUrlList.isNotEmpty) {
                CustomToast.errorToast(text: 'Please remove the image selected');
                return;
              }
         },         
        child: CustomScrollView(slivers: [
          SliverCustomAppbar(
            onBackTap: () {
              if (isEditing == false &&
                  pharmacyProvider.imageProductUrlList.isNotEmpty) {
                CustomToast.errorToast(text: 'Please remove the image selected');
                return;
              }
              if (isEditing == true &&
                  pharmacyProvider.deleteUrlList.isNotEmpty) {
                CustomToast.errorToast(text: 'Please save the changed details');
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
                      GalleryImagePicker(
                        isEditing: isEditing,
                      ),
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
                                text: "Product Name",
                                starText: true,
                              ),
                              TextfieldWidget(
                                hintText: 'Enter the name eg : Himalaya Facewash',
                                textInputAction: TextInputAction.next,
                                validator: BValidator.validate,
                                controller:
                                    pharmacyProvider.productNameController,
                              ),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                text: "Product Brand / Marketer",
                                starText: true,
                              ),
                              TextfieldWidget(
                                textInputAction: TextInputAction.next,
                                hintText: 'Enter the name eg: Himalaya Pvt.LTD',
                                validator: BValidator.validate,
                                controller:
                                    pharmacyProvider.productBrandNameController,
                              ),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                text: "Product MRP (₹)",
                                starText: true,
                              ),
                              TextfieldWidget(
                                prefixText: '₹ ',
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                hintText: 'Enter the price in rupees eg : 200',
                                validator: BValidator.validate,
                                controller: pharmacyProvider.productMRPController,
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
                                      text: "Product Discount rate (₹)",
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
                                            child: PercentageShowContainerWidget(
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
                              const TextAboveFormFieldWidget(
                                starText: true,
                                text: "Total Quantity",
                              ),
                              TextfieldWidget(
                                suffixText: 'Nos',
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                hintText:
                                    'Enter the total quantity available eg : 150 Nos',
                                validator: BValidator.validate,
                                controller:
                                    pharmacyProvider.totalQuantityController,
                              ),
        
                              ///// expiry section
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                starText: true,
                                text: "Expiry Date",
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                DateTime.now(),
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
                                    "Following number fields {Product Form, Product Package} needed to be filled if only required for displaying product.",
                              ),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                starText: true,
                                text: "Category type",
                              ),
                              DropDownProductButton(
                                  value: pharmacyProvider.productForm,
                                  hintText: 'Category type',
                                  onChanged: (value) {
                                    pharmacyProvider.setDropFormText(value ?? '');
                                  },
                                  optionList: pharmacyProvider.productFormList),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                text: "Ideal for",
                              ),
                              DropDownProductButton(
                                  value: pharmacyProvider.idealFor,
                                  hintText: 'Ideal for',
                                  onChanged: (value) {
                                    pharmacyProvider.setIdealForText(value ?? '');
                                  },
                                  optionList:
                                      pharmacyProvider.idealForOptionList),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                starText: true,
                                text: "Product Form",
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: TextfieldWidget(
                                      keyboardType: TextInputType.number,
                                      hintText: 'Eg: Liquid',
                                      textInputAction: TextInputAction.next,
                                      controller: pharmacyProvider
                                          .productFormNumberController,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    fit: FlexFit.loose,
                                    child: DropDownProductButton(
                                        value: pharmacyProvider.productForm,
                                        hintText: 'Product Form',
                                        onChanged: (value) {
                                          pharmacyProvider
                                              .setDropFormText(value ?? '');
                                        },
                                        optionList:
                                            pharmacyProvider.productFormList),
                                  ),
                                ],
                              ),
        
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                starText: true,
                                text: "Product weight",
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: TextfieldWidget(
                                      keyboardType: TextInputType.number,
                                      hintText: 'Eg: 150 ml',
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
                                        hintText: 'Product Unit',
                                        onChanged: (value) {
                                          pharmacyProvider.setDropMeasurementText(
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
                                text: "Product Package",
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: TextfieldWidget(
                                      keyboardType: TextInputType.number,
                                      hintText: 'Eg: 1 tube',
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
                                        value: pharmacyProvider.productPackage,
                                        hintText: 'Product Package',
                                        onChanged: (value) {
                                          pharmacyProvider
                                              .setDropPackageText(value ?? '');
                                        },
                                        optionList:
                                            pharmacyProvider.productPackageList),
                                  ),
                                ],
                              ),
        
                              const Gap(24),
                              const TextAboveFormFieldWidget(
                                starText: true,
                                text: "Key Ingredients",
                              ),
                              TextfieldWidget(
                                hintText:
                                    'Enter the key ingredients eg : Alovera gel',
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
                                    'Enter the product details eg : Face Cleansing Foam contains a gentle cleanser and salt-free wash dynamic substance that reduces sebum and dirt without drying the skin. ',
                                validator: BValidator.validate,
                                maxlines: 6,
                                controller:
                                    pharmacyProvider.productInformationController,
                              ),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                text: "Direction to use",
                              ),
                              TextfieldWidget(
                                keyboardType: TextInputType.multiline,
                                hintText:
                                    'Enter the direction to use the product eg : Soak your face and neck with water. Foam a limited quantity in your grasp and back rub your body with the item',
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
                                    'Enter the safety information eg : Read the label carefully before use. Keep out of reach of children',
                                maxlines: 6,
                                controller:
                                    pharmacyProvider.safetyInformationController,
                              ),
                              const Gap(8),
                              const TextAboveFormFieldWidget(
                                text: "Key Benefits",
                              ),
                              TextfieldWidget(
                                textInputAction: TextInputAction.done,
                                hintText:
                                    "Enter the key benefits eg : It supports the skin's characteristic obstruction with pH 5.5,It adequately enters the pores for gentle pore-profound purging",
                                maxlines: 6,
                                controller: pharmacyProvider.keyBenefitController,
                              ),
                              const Gap(16),
        
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
                                    if (pharmacyProvider.productForm == null) {
                                      CustomToast.errorToast(
                                          text: 'Pick a product form.');
                                      return;
                                    }
                                    if (pharmacyProvider.productPackage == null) {
                                      CustomToast.errorToast(
                                          text: 'Pick a product package.');
                                      return;
                                    }
                                    if (pharmacyProvider.productMeasurementUnit ==
                                        null) {
                                      CustomToast.errorToast(
                                          text: 'Pick a product unit.');
                                      return;
                                    }
                                    
                                    if (!formKey.currentState!.validate()) {
                                      formKey.currentState!.validate();
                                      return;
                                    }
                                    LoadingLottie.showLoading(
                                        context: context, text: 'Please wait...');
                                    if (productDetails == null &&
                                        isEditing == false) {
                                      if (pharmacyProvider.expiryDate == null) {
                                      CustomToast.errorToast(
                                          text: 'Pick the expiry date.');
                                      return;
                                    }    
                                      await pharmacyProvider
                                          .addPharmacyOthersDetails(
                                              context: context);
                                    } else {
                                      await pharmacyProvider
                                          .updatePharmacyOtherDetails(
                                              index: index!,
                                              othersEditData: productDetails!,
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
