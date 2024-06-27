import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/core/custom/bottom_navigation/bottom_nav_widget.dart';
import 'package:healthycart_pharmacy/features/pharmacy_banner/presentation/banner_page.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/presentation/product_category/medicine_category.dart';
import 'package:healthycart_pharmacy/features/pharmacy_profile/presentation/profile_screen.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/request_page.dart';
import 'package:healthycart_pharmacy/utils/constants/image/icon.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationWidget(
      text1: 'Orders',
      text2: 'Product',
      text3: 'Banner',
      text4: 'Profile',
      tabItems: const [
        RequestScreen(),
        DoctorScreen(),
        BannerScreen(),
        ProfileScreen(),
      ],
      selectedImage1: Image.asset(
        BIcon.order,
        height: 30,
        width: 30,
      ),
      unselectedImage1: Image.asset(
        BIcon.orderBlack,
        height: 28,
        width: 28,
      ),
      selectedImage2: Image.asset(
        BIcon.addPharmacyProduct,
        height: 28,
        width: 28,
      ),
      unselectedImage2: Image.asset(
        BIcon.addPharmacyProductBlack,
        height: 24,
        width: 24,
      ),
    ));
  }
}
