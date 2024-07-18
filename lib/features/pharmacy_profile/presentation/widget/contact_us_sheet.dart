import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/launch_dialer.dart';
import 'package:healthycart_pharmacy/core/custom/toast/toast.dart';
import 'package:healthycart_pharmacy/core/services/url_launcher.dart';
import 'package:healthycart_pharmacy/utils/app_details/app_details.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';

class ContactUsBottomSheet extends StatelessWidget {
  const ContactUsBottomSheet({
    super.key, required this.message,
  });
  final String message;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      decoration: const BoxDecoration(
          color: BColors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Info :',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: BColors.black,
              ),
            ),
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    LaunchDialer.lauchDialer(
                        phoneNumber: AppDetails.phoneNumber);
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                        color: BColors.darkblue,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            color: BColors.white,
                          ),
                          Gap(8),
                          Text(
                            'Call',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: BColors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    UrlService().redirectToLink(
                      link: 'mailto:<${AppDetails.email}>?subject=&body=',
                      onFailure: () async {
                        await Clipboard.setData(
                            const ClipboardData(text: AppDetails.email));
                        CustomToast.sucessToast(text: "Email Copied");
                      },
                    );
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                        color: BColors.darkblue,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: BColors.white,
                          ),
                          Gap(8),
                          Text(
                            'E-Mail',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: BColors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {

                    UrlService().redirectToWhatsapp(
                        'https://wa.me/${AppDetails.phoneNumber}?text=$message');
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                        color: BColors.darkblue,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: BColors.white,
                          ),
                          Gap(8),
                          Text(
                            'Chat',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: BColors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
