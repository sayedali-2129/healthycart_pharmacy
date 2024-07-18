import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/authenthication/application/authenication_provider.dart';
import 'package:healthycart_pharmacy/features/pending_page/application/pending_provider.dart';
import 'package:healthycart_pharmacy/features/pharmacy_profile/presentation/widget/contact_us_sheet.dart';
import 'package:healthycart_pharmacy/features/splash_screen/splash_screen.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:healthycart_pharmacy/utils/constants/image/image.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PendingPageScreen extends StatelessWidget {
  const PendingPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final authProviderPharamacyDetails = context.read<AuthenticationProvider>();
         if (authProviderPharamacyDetails.isRequsetedPendingPage == 2) {
        // 2 means approved, 1 means pending and 0 means rejected
        EasyNavigation.pushAndRemoveUntil(
            type: PageTransitionType.bottomToTop,
            context: context,
            page: const SplashScreen());
      } 
    });
    return Consumer2<PendingProvider, AuthenticationProvider>(builder: (context, pendingProvider,authProviderPharamacyDetails, _) {
      return Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(BImage.lottieReviewRequested, height: 232),
            const Gap(32),
            (authProviderPharamacyDetails.pharmacyDataFetched?.rejectionReason != null)?
            Column(
              children: [
                Text(
              'Rejected!',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontSize: 18, color: BColors.red, 
                  ),
              textAlign: TextAlign.center,
            ),
                Text(
                 authProviderPharamacyDetails.pharmacyDataFetched?.rejectionReason ?? 'Your request got rejected please re-apply after sometime or contact our team.' ,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontSize: 14,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ):
            Text(
              'Please wait while our team reviews and accepts your request. Thank you for your patience!',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontSize: 14,
                  ),
              textAlign: TextAlign.center,
            ),
            const Gap(40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: BColors.white,
                    elevation: 5,
                    showDragHandle: true,
                    context: context,        
                    builder: (context) =>  ContactUsBottomSheet(message:  'Hi, I like to know the details of the request regarding${authProviderPharamacyDetails.pharmacyDataFetched?.pharmacyName} approval through  Healthy cart pharmacy admin.',),
                  );
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: BColors.buttonLightColor),
                icon: const Icon(
                  Icons.headset_mic,
                  color: BColors.white,
                ),
                label: Text(
                  'Contact Us',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontSize: 18, color: BColors.white),
                ),
              ),
            )
          ],
        ),
      ));
    });
  }
}
