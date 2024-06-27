import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/custom_alertbox/confirm_alertbox_widget.dart';
import 'package:healthycart_pharmacy/core/custom/custom_cached_network/custom_cached_network_image.dart';
import 'package:healthycart_pharmacy/core/custom/lottie/loading_lottie.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/pharmacy_banner/application/add_banner_provider.dart';
import 'package:healthycart_pharmacy/features/pharmacy_banner/domain/model/pharmacy_banner_model.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class BannerImageWidget extends StatelessWidget {
  const BannerImageWidget({
    super.key,
    required this.indexNumber,
    required this.bannerData,
    required this.index,
  });
  final String indexNumber;
  final PharmacyBannerModel bannerData;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer<AddBannerProvider>(
        builder: (context, addBannerProvider, _) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomCachedNetworkImage(image: bannerData.image ?? '', fit: BoxFit.contain,)),
          ),
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
              left: 4,
              top: 4,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.black,
                child: Text(
                  indexNumber,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Colors.white),
                ),
              )),
          GestureDetector(
            onTap: () {
              
              ConfirmAlertBoxWidget.showAlertConfirmBox(
                context: context,
                confirmButtonTap: () async{
                   LoadingLottie.showLoading(
                              context: context, text: 'Please wait ..'); 
                await addBannerProvider.deleteBanner(
                    bannerToDelete: bannerData,
                    imageUrl: bannerData.image ?? '',
                    context: context,
                    index: index,
                  );
                },
                titleText: 'Confirm to remove banner',
                subText: 'Are you sure tou want to remove this banner?',
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration:
                  BoxDecoration(color: BColors.lightGrey.withOpacity(.6)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Remove",
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                  const Gap(8),
                  const Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                  )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
