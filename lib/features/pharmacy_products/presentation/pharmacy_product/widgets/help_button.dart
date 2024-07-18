import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/features/pending_page/application/pending_provider.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:provider/provider.dart';

class HelpButtonWidget extends StatelessWidget {
  const HelpButtonWidget({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    final pendingPageProvider = Provider.of<PendingProvider>(context);
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Note:',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        textAlign: TextAlign.center,
                        text,
                        maxLines: 4,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontSize: 12,
                            )),
                    const Gap(6),
                    Text(
                        textAlign: TextAlign.center,
                        "Need any futher clarification on adding product tap to",
                        maxLines: 4,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontSize: 13,
                            )),
                    const Gap(8),
                    GestureDetector(
                      onTap: () {
                    pendingPageProvider.reDirectToWhatsApp(
                      message:
                          'Hi, I like to know the details how to add products in pharmacy.');
                      },
                      child: Text(
                          textAlign: TextAlign.center,
                          "Chat with us",
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    decorationColor: BColors.mainlightColor,
                                    decoration: TextDecoration.underline,
                                    color: BColors.mainlightColor,
                                    fontSize: 14,
                                  )),
                    ),
                  ],
                ),
              );
            });
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Text(
            textAlign: TextAlign.center,
            "Help",
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  decoration: TextDecoration.underline,
                  fontSize: 12,
                )),
        SizedBox(
          child: Icon(
            Icons.help_center_rounded,
            size: 20,
            color: BColors.offRed,
          ),
        )
      ]),
    );
  }
}
