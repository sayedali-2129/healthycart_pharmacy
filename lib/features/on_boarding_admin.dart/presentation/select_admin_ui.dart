import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/app_bar/main_logo_appbar.dart';
import 'package:healthycart_pharmacy/core/custom/custom_buttons_and_search/common_button.dart';
import 'package:healthycart_pharmacy/features/authenthication/presentation/login_ui.dart';
import 'package:healthycart_pharmacy/features/add_pharmacy_form_page/application/pharmacy_form_provider.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:healthycart_pharmacy/utils/constants/image/image.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PharmacyFormProvider>(context);
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const AppBarCurved(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Image.asset(width: 218, height: 184, BImage.getStartedImage),
                const Gap(48),
                Text(
                  'Choose your Admin platform',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const Gap(24),
                CustomButton(
                  width: 240,
                  height: 48,
                  onTap: () {
                  

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  text: 'Hospital Admin',
                  buttonColor: BColors.buttonDarkColor,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: BColors.textWhite),
                  icon: Icons.arrow_circle_right_outlined,
                  iconColor: BColors.textWhite,
                  iconSize: 32,
                ),
                const Gap(24),
                CustomButton(
                  width: 240,
                  height: 48,
                  onTap: () {
                  

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  text: 'Pharmacy Admin',
                  buttonColor: BColors.buttonDarkColor,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: BColors.textWhite),
                  icon: Icons.arrow_circle_right_outlined,
                  iconColor: BColors.textWhite,
                  iconSize: 32,
                ),
                const Gap(24),
                CustomButton(
                  width: 240,
                  height: 48,
                  onTap: () {
                   

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  text: 'Laboratory Admin',
                  buttonColor: BColors.buttonDarkColor,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: BColors.textWhite),
                  icon: Icons.arrow_circle_right_outlined,
                  iconColor: BColors.textWhite,
                  iconSize: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
