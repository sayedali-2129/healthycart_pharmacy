
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/domain/model/pharmacy_order_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/quantity_container.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';

class ProductShowContainer extends StatelessWidget {
  const ProductShowContainer({
    super.key,
    required this.orderData,
  });

  final PharmacyOrderModel orderData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius:
              BorderRadius.circular(8)),
      child: ListView.builder(
        padding: const EdgeInsets.only(
          left: 6,
          right: 8,
          top: 8,
        ),
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(),
        itemCount: orderData.productDetails?.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: Text(
                      orderData
                              .productDetails?[
                                  index]
                              .productData
                              ?.productName ??
                          'Unknown Product',
                      overflow: TextOverflow
                          .ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(
                              color: BColors
                                  .black,
                              fontWeight:
                                  FontWeight
                                      .w500,
                              fontSize: 12),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: QuantitiyBox(
                      productQuantity:
                          '${orderData.productDetails?[index].quantity ?? '0'}',
                    ),
                  ),
                ],
              ),
                const Gap(6),
            ],
          );
        },
      ),
    );
  }
}
