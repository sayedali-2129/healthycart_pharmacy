import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/custom_cached_network/custom_cached_network_image.dart';
import 'package:healthycart_pharmacy/core/custom/divider/divider.dart';
import 'package:healthycart_pharmacy/core/custom/lottie/loading_lottie.dart';
import 'package:healthycart_pharmacy/core/custom/toast/toast.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/application/pharmacy_provider.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/pharmacy_product/widgets/image_add_conatainer.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class GalleryImagePicker extends StatelessWidget {
  const GalleryImagePicker({
    super.key,
    this.isEditing,
  });
  final bool? isEditing;
  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyProvider>(builder: (context, pharmacyProvider, _) {

      return Column(
        children: [
        AddProductImageWidget(
          addTap: () {
            if (pharmacyProvider.imageProductUrlList.length >= 3) {
              return CustomToast.sucessToast(
                  text: 'Maximum images are selected, remove to add new.');
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
                  image: pharmacyProvider
                      .imageProductUrlList[pharmacyProvider.selectedImageIndex], fit: BoxFit.contain,),
        ),
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
                    itemCount: pharmacyProvider.imageProductUrlList.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Container(
                              decoration: (pharmacyProvider.selectedImageIndex ==
                                      index)
                                  ? BoxDecoration(
                                      border: Border.all(
                                        color: BColors.mainlightColor,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10))
                                  : null,
                              child: AddProductImageWidget(
                                  addTap: () {
                                    pharmacyProvider.setselectedImageIndex(index);
                                  },
                                  height: 56,
                                  width: 64,
                                  child: (pharmacyProvider
                                          .imageProductUrlList.isEmpty)
                                      ? const Center(
                                          child: (Icon(
                                            Icons.image,
                                            size: 40,
                                          )),
                                        )
                                      : CustomCachedNetworkImage(
                                          image: pharmacyProvider
                                              .imageProductUrlList[index], fit: BoxFit.contain,)),
                            ),
                          ),
                          Positioned(
                              right: -2,
                              top: -2,
                              child: GestureDetector(
                                onTap: () {
                                  if (isEditing == true) {
                                    pharmacyProvider.deletedUrl(
                                        selectedImageUrl: pharmacyProvider
                                            .imageProductUrlList[index]);
                                  } else {
                                    LoadingLottie.showLoading(
                                        context: context, text: 'Please wait');
                                    pharmacyProvider
                                        .deleteProductImage(
                                      context: context,
                                      index: index,
                                      selectedImageUrl: pharmacyProvider.imageProductUrlList[index],
                                    )
                                        .then((value) {
                                      EasyNavigation.pop(context: context);
                                    });
                                  }
                                },
                                child:  Icon(
                                  Icons.cancel,
                                  color: BColors.darkGrey,
                                ),
                              ))
                        ],
                      );
                    },
                  ),
                ),
              )
            : const SizedBox(),
      ]);
    });
  }
}
