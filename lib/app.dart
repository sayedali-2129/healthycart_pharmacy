import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/core/di/injection.dart';
import 'package:healthycart_pharmacy/features/add_pharmacy_form_page/application/pharmacy_form_provider.dart';
import 'package:healthycart_pharmacy/features/authenthication/application/authenication_provider.dart';
import 'package:healthycart_pharmacy/features/pharmacy_banner/application/add_banner_provider.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/application/pharmacy_provider.dart';
import 'package:healthycart_pharmacy/features/pharmacy_profile/application/profile_provider.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/application/provider/request_doctor_provider.dart';
import 'package:healthycart_pharmacy/features/location_picker/application/location_provider.dart';
import 'package:healthycart_pharmacy/features/pending_page/application/pending_provider.dart';
import 'package:healthycart_pharmacy/features/splash_screen/splash_screen.dart';
import 'package:healthycart_pharmacy/main.dart';
import 'package:healthycart_pharmacy/utils/theme/theme.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
   
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => sl<PharmacyFormProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<PharmacyProvider>(),
        ),
        ChangeNotifierProvider(
          create: (context) => RequestDoctorProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => sl<AddBannerProvider>(),
        ),
       ChangeNotifierProvider(
          create: (context) => sl<LocationProvider>(),
        ),

      ChangeNotifierProvider(
          create: (context) => sl<AuthenticationProvider>(),
        ), 
        
      ChangeNotifierProvider(
          create: (context) => sl<PendingProvider>(),
        ), 
       ChangeNotifierProvider(
          create: (context) => sl<ProfileProvider>(),
        ),
      ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            theme: BAppTheme.lightTheme,
            darkTheme: BAppTheme.darkTheme,
            home: const SplashScreen()),
      
    );
  }
}
