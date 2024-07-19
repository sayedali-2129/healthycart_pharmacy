// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/custom_buttons_and_search/common_button.dart';
import 'package:healthycart_pharmacy/core/custom/lottie/loading_lottie.dart';
import 'package:healthycart_pharmacy/core/custom/text_formfield/custom_text_field.dart';
import 'package:healthycart_pharmacy/core/general/validator.dart';
import 'package:healthycart_pharmacy/features/add_pharmacy_form_page/domain/model/pharmacy_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_profile/application/profile_provider.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class BankDetailsSheet extends StatefulWidget {
  const BankDetailsSheet({
    super.key,
    this.pharmacyModel,
  });
  final PharmacyModel? pharmacyModel;

  @override
  State<BankDetailsSheet> createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<BankDetailsSheet> {
  final ifscRegExp = RegExp("^[A-Z]{4}0[A-Z0-9]{6}\$");
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final provider = context.read<ProfileProvider>();
        if (widget.pharmacyModel != null) {
          provider.setBankEditData(widget.pharmacyModel!);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, provider, _) {
      return PopScope(
        onPopInvoked: (didPop) {
          if (didPop) {
            provider.clearControllers();
          }
        },
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Form(
                    key: provider.bankFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Gap(10),
                        CustomTextField(
                          enableHeading: true,
                          fieldHeading: 'Account Holder Name*',
                          hintText: 'Enter Account Holder Name',
                          controller: provider.accountHolderNameController,
                          validator: BValidator.validate,
                        ),
                        const Gap(8),
                        CustomTextField(
                          enableHeading: true,
                          fieldHeading: 'Bank Name*',
                          hintText: 'Enter Bank Name',
                          controller: provider.bankNameController,
                          validator: BValidator.validate,
                        ),
                        const Gap(8),
                        CustomTextField(
                          enableHeading: true,
                          fieldHeading: 'Account Number*',
                          hintText: 'Enter Account Number',
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: provider.accountNumberController,
                          validator: BValidator.validate,
                        ),
                        const Gap(8),
                        CustomTextField(
                            textCapitalization: TextCapitalization.characters,
                            maxLendth: 11,
                            enableHeading: true,
                            fieldHeading: 'IFSC Code*',
                            hintText: 'Enter IFSC Code',
                            validator: (value) {
                              if (!ifscRegExp.hasMatch(value!)) {
                                return 'Enter a valid IFSC code';
                              } else if (value.isEmpty) {
                                return 'Enter IFSC code';
                              } else {
                                return null;
                              }
                            },
                            controller: provider.ifscCodeController),
                        const Gap(30),
                        CustomButton(
                          height: 40,
                          width: double.infinity,
                          buttonColor: BColors.mainlightColor,
                          text: 'Save Details',
                          style: const TextStyle(color: BColors.white),
                          onTap: () {
                            if (!provider.bankFormKey.currentState!
                                .validate()) {
                              provider.bankFormKey.currentState!.validate();
                              return;
                            }
                            LoadingLottie.showLoading(
                                context: context, text: 'Loading...');
                            provider
                                .addBankDetails(context: context)
                                .whenComplete(
                              () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                provider.clearControllers();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
