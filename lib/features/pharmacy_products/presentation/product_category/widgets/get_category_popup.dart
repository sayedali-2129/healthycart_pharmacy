import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/custom_buttons_and_search/common_button.dart';
import 'package:healthycart_pharmacy/core/custom/lottie/circular_loading.dart';
import 'package:healthycart_pharmacy/core/custom/lottie/loading_lottie.dart';
import 'package:healthycart_pharmacy/core/custom/toast/toast.dart';
import 'package:healthycart_pharmacy/core/custom/custom_cached_network/custom_cached_network_image.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/application/pharmacy_provider.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class PopupDoctorCategoryShower {
  PopupDoctorCategoryShower._();
  static final PopupDoctorCategoryShower _instance =
      PopupDoctorCategoryShower._();
  static PopupDoctorCategoryShower get instance => _instance;

  Future<void> showDoctorCategoryDialouge({
    required BuildContext context,
  }) async {
    //main provider to get user id

    await showDialog(
        context: context,
        builder: (context) {
          return const AddDoctorsCategoryDilogue();
        });
  }
}

class AddDoctorsCategoryDilogue extends StatefulWidget {
  const AddDoctorsCategoryDilogue({
    super.key,
  });

  @override
  State<AddDoctorsCategoryDilogue> createState() =>
      _AddDoctorsCategoryDilogueState();
}

class _AddDoctorsCategoryDilogueState extends State<AddDoctorsCategoryDilogue> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final pharmacyProvider =
          Provider.of<PharmacyProvider>(context, listen: false);
      pharmacyProvider.getPharmacyCategoryAll().whenComplete(
        () {
          pharmacyProvider.selectedRadioButtonCategoryValue = null;
          pharmacyProvider.removingFromUniqueCategoryList();
        },
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyProvider>(builder: (context, value, _) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(12),
        surfaceTintColor: Colors.white,
        backgroundColor: BColors.lightGrey,
        title: Text('Add Prefered Category',
            style:
                Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 14)),
        content: (value.fetchAlertLoading)

            /// loading is done here
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child : LoadingIndicater(),
                ),
              )
            : (value.pharmacyCategoryUniqueList.isEmpty)
                ? SizedBox(
                    height: 200,
                    child: Center(
                      child: Text('No more category available.',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  )
                : SizedBox(
                    height: 520,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: value.pharmacyCategoryUniqueList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 3),
                          child: Material(
                            surfaceTintColor: Colors.white,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            elevation: 3,
                            child: RadioMenuButton(
                              
                                clipBehavior: Clip.antiAlias,
                                value:
                                    value.pharmacyCategoryUniqueList[index],
                                groupValue:
                                    value.selectedRadioButtonCategoryValue,
                                onChanged: (result) {
                                  value.selectedRadioButton(result: result!);
                                },
                                child: Padding(
                                 padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 2),
                                  child:SizedBox(
                                    width: 188,
                                    child: Row(
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          clipBehavior: Clip.antiAlias,
                                          height: 56,
                                          width: 56,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle),
                                          child: CustomCachedNetworkImage(
                                              image: value
                                                  .pharmacyCategoryUniqueList[
                                                      index]
                                                  .image),
                                        ),
                                        const Gap(8),
                                        Expanded(
                                          child: Text(
                                              value
                                              .pharmacyCategoryUniqueList[index]
                                              .category,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!.copyWith(color: BColors.black, fontSize: 12),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,),
                                  
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        );
                      },
                    ),
                  ),
        actions: [
          (value.pharmacyCategoryUniqueList.isNotEmpty)
              ? CustomButton(
                  width: double.infinity,
                  height: 48,
                  onTap: () async {
                    if (value.selectedRadioButtonCategoryValue == null) {
                      CustomToast.errorToast(text: 'Please select a category');
                      return;
                    }

                    LoadingLottie.showLoading(
                        context: context, text: 'Adding category...');
                    await value
                        .updatePharmacyCategoryDetails(
                      categorySelected: value.selectedRadioButtonCategoryValue!,
                    )
                        .whenComplete(
                      () {
                        value.removingFromUniqueCategoryList();
                        value.selectedRadioButtonCategoryValue = null;
                        EasyNavigation.pop(context: context);
                        EasyNavigation.pop(context: context);
                      },
                    );
                  },
                  text: 'Save',
                  buttonColor: BColors.mainlightColor,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Colors.white,
                      ),
                )
              : const SizedBox()
        ],
      );
    });
  }
}
