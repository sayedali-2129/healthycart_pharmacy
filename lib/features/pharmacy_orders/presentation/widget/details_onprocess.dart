import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/core/custom/app_bar/sliver_appbar.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/domain/model/pharmacy_order_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/domain/model/product_quantity_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/product_list_widget.dart';

class DetailsOnProcessScreen extends StatelessWidget {
  const DetailsOnProcessScreen({super.key, required this.data});
  final PharmacyOrderModel data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverCustomAppbar(
              title: 'Ordered Items',
              onBackTap: () {
                EasyNavigation.pop(context: context);
              }),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const Divider(),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ProductDetailsWidget(
                      detailsPage: false,
                      index: index,
                      productData: data.productDetails?[index] ??
                          ProductAndQuantityModel(),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: data.productDetails?.length ?? 0,
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
