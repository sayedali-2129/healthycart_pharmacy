import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/custom_buttons_and_search/common_button.dart';
import 'package:healthycart_pharmacy/core/custom/lottie/loading_lottie.dart';
import 'package:healthycart_pharmacy/core/custom/toast/toast.dart';
import 'package:healthycart_pharmacy/features/authenthication/application/authenication_provider.dart';
import 'package:healthycart_pharmacy/features/authenthication/presentation/widget/phone_field.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:healthycart_pharmacy/utils/constants/image/image.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
        builder: (context, authenticationProvider, _) {
      return Scaffold(
        appBar: AppBar(
          surfaceTintColor: BColors.white,
          backgroundColor: BColors.white,
        ),
        body: GestureDetector(
          onTap: (){
             FocusScope.of(context).unfocus();
          },
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     
                      SizedBox(
                        child: Center(
                          child: Image.asset(
                              height: 280, BImage.loginImage),
                        ),
                      ),
                      const Gap(48),
                      Text(
                        'Login',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.w700, fontSize: 28),
                      ),
                      const Gap(16),
                      SizedBox(
                        width: 300,
                        child: Text(
                          'Please select your Country code & enter the Phone number. ',
                          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Gap(48),
                      PhoneField(
                        phoneNumberController:
                            authenticationProvider.phoneNumberController,
                        countryCode: (value) {
                          authenticationProvider.countryCode = value;
                        },
                      ),
                      const Gap(40),
                      CustomButton(
                        width: double.infinity,
                        height: 48,
                        onTap: () async{
                          if (authenticationProvider.countryCode == null) return;
                          if (authenticationProvider.phoneNumberController.text.isEmpty ||
                              authenticationProvider.phoneNumberController.text.length < 10||
                              authenticationProvider.phoneNumberController.text.length > 10) {
                            CustomToast.sucessToast(
                                text: 'Please re-enter a valid number');
                            return;
                          }                 
                          LoadingLottie.showLoading(
                              context: context, text: 'Loading...');
                            
                         authenticationProvider.setNumber();
                         authenticationProvider.verifyPhoneNumber(context: context);
                            
                            
                        },
                        text: 'Send code',
                        buttonColor: BColors.buttonDarkColor,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(fontSize: 18, color: BColors.white),
                      ),

                    ],
                  ),
                )),
          ),
        ),
      );
    });
  }
}
