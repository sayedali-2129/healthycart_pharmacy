import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/app_bar/sliver_appbar.dart';
import 'package:healthycart_pharmacy/core/custom/custom_alertbox/confirm_alertbox_widget.dart';
import 'package:healthycart_pharmacy/core/custom/custom_alertbox/textfield_alertbox.dart';
import 'package:healthycart_pharmacy/core/custom/custom_buttons_and_search/common_button.dart';
import 'package:healthycart_pharmacy/core/custom/image_view/image_view.dart';
import 'package:healthycart_pharmacy/core/custom/lottie/loading_lottie.dart';
import 'package:healthycart_pharmacy/core/custom/text_formfield/textformfield.dart';
import 'package:healthycart_pharmacy/core/custom/toast/toast.dart';
import 'package:healthycart_pharmacy/core/general/validator.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/application/provider/request_pharmacy_provider.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/domain/model/user_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/product_list_widget.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/row_text_widget.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/user_detail_container.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.index});
  final int index;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final orderProvider = context.read<RequestPharmacyProvider>();
        orderProvider.addAllProductDetails(
            productDataList:
                orderProvider.newOrderList[widget.index].productDetails ?? []);
        orderProvider.totalAmountCalclator();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestPharmacyProvider>(
        builder: (context, orderProvider, _) {
      final orderData = orderProvider.newOrderList[widget.index];
      return Scaffold(
        body: PopScope(
          canPop: (orderData.productDetails?.length ==
              orderProvider.pharmacyUserProducts.length),
          onPopInvoked: (didPop) {
            if (orderData.productDetails?.length !=
                orderProvider.pharmacyUserProducts.length) {
              ConfirmAlertBoxWidget.showAlertConfirmBox(
                  context: context,
                  confirmButtonTap: () {
                    orderProvider.clearFiledAndData();
                    EasyNavigation.pop(context: context);
                  },
                  titleText: 'Remove all changes',
                  subText: "Are you sure to undo all the changes?");
            } else {
              orderProvider.clearFiledAndData();
            }
          },
          child: CustomScrollView(
            slivers: [
              SliverCustomAppbar(
                  title: 'Order Details',
                  onBackTap: () {
                    if (orderData.productDetails?.length !=
                        orderProvider.pharmacyUserProducts.length) {
                      ConfirmAlertBoxWidget.showAlertConfirmBox(
                          context: context,
                          confirmButtonTap: () {
                            orderProvider.clearFiledAndData();
                            EasyNavigation.pop(context: context);
                          },
                          titleText: 'Remove all changes',
                          subText: "Are you sure to undo all the changes?");
                    } else {
                      orderProvider.clearFiledAndData();
                      EasyNavigation.pop(context: context);
                    }
                  }),
              SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: PhysicalModel(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 28,
                                      width: 128,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: BColors.darkblue),
                                      child: Center(
                                        child: Text(
                                            'Order No-${widget.index + 1}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .copyWith(color: Colors.white)),
                                      ),
                                    ),
                                    Container(
                                      height: 28,
                                      width: 128,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(),
                                          color: BColors.offWhite),
                                      child: Center(
                                        child: Text(
                                          orderProvider.dateFromTimeStamp(
                                              orderProvider
                                                  .newOrderList[widget.index]
                                                  .createdAt!),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: BColors.darkblue),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(8),
                                const Divider(),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ProductDetailsWidget(
                                      detailsPage: true,
                                      index: index,
                                      productData: orderProvider
                                          .pharmacyUserProducts[index],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider();
                                  },
                                  itemCount:
                                      orderProvider.pharmacyUserProducts.length,
                                ),
                                const Divider(),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      fit: FlexFit.loose,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RowTextContainerWidget(
                                            text1: 'Delivery :',
                                            text2: orderProvider.deliveryType(
                                                orderData.deliveryType ?? ''),
                                            text1Color: BColors.textLightBlack,
                                            fontSizeText1: 12,
                                            fontSizeText2: 12,
                                            fontWeightText1: FontWeight.w600,
                                            text2Color: BColors.black,
                                          ),
                                          const Gap(8),
                                          (orderData.prescription != null &&
                                                  orderData
                                                      .prescription!.isNotEmpty)
                                              ? const Column(
                                                  children: [
                                                    RowTextContainerWidget(
                                                      text1: 'Prescription :',
                                                      text2: 'Included',
                                                      text1Color: BColors
                                                          .textLightBlack,
                                                      fontSizeText1: 12,
                                                      fontSizeText2: 12,
                                                      fontWeightText1:
                                                          FontWeight.w600,
                                                      text2Color: BColors.black,
                                                    ),
                                                    Gap(8),
                                                  ],
                                                )
                                              : const SizedBox(),
                                          RowTextContainerWidget(
                                            text1: 'Total Amount :',
                                            text2:
                                                "₹ ${orderProvider.totalAmount}",
                                            text1Color: BColors.textLightBlack,
                                            fontSizeText1: 12,
                                            fontSizeText2: 12,
                                            fontWeightText1: FontWeight.w600,
                                            text2Color: BColors.textBlack,
                                          ),
                                          const Gap(8),
                                          RowTextContainerWidget(
                                            text1: 'Total Discount :',
                                            text2:
                                                "- ₹ ${orderProvider.totalAmount - orderProvider.totalFinalAmount}",
                                            text1Color: BColors.textLightBlack,
                                            fontSizeText1: 12,
                                            fontSizeText2: 12,
                                            fontWeightText1: FontWeight.w600,
                                            text2Color: BColors.green,
                                          ),
                                          if (orderData.deliveryType == 'Home')
                                            Column(
                                              children: [
                                                const Gap(8),
                                                RowTextContainerWidget(
                                                  text1: 'Delivery Charge :',
                                                  text2: (orderProvider
                                                                  .deliveryCharge ==
                                                              0 ||
                                                          orderProvider
                                                                  .deliveryCharge ==
                                                              null)
                                                      ? "Free Delivery"
                                                      : '₹ ${orderProvider.deliveryCharge}',
                                                  text1Color:
                                                      BColors.textLightBlack,
                                                  fontSizeText1: 12,
                                                  fontSizeText2: 12,
                                                  fontWeightText1:
                                                      FontWeight.w600,
                                                  text2Color: (orderProvider
                                                                  .deliveryCharge ==
                                                              0 ||
                                                          orderProvider
                                                                  .deliveryCharge ==
                                                              null)
                                                      ? BColors.green
                                                      : BColors.textBlack,
                                                ),
                                                const Gap(8),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      orderProvider
                                                          .deliveryController
                                                          .clear();
                                                      TextFieldAlertBoxWidget
                                                          .showAlertTextFieldBox(
                                                        context: context,
                                                        confirmButtonTap: () {
                                                          orderProvider
                                                              .setDeliveryCharge();
                                                          EasyNavigation.pop(
                                                              context: context);
                                                        },
                                                        titleText:
                                                            'Home Delivery Charge',
                                                        hintText:
                                                            'Enter the delivery charge',
                                                        subText:
                                                            'Please enter a delivery amount or leave it blank if the delivery is free.',
                                                        controller: orderProvider
                                                            .deliveryController,
                                                        maxlines: 1,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                      );
                                                    },
                                                    child: Text(
                                                      'Add delivery Charge',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                            color: BColors
                                                                .darkblue,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          const Divider(),
                                          RowTextContainerWidget(
                                            text1: 'Amount To Be Paid : ',
                                            text2:
                                                "₹ ${orderProvider.totalFinalAmount}",
                                            text1Color: BColors.textBlack,
                                            fontSizeText1: 13,
                                            fontSizeText2: 14,
                                            fontWeightText1: FontWeight.w600,
                                            text2Color: BColors.green,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Gap(12),
                                  ],
                                ),
                                const Divider(),
                                if (orderData.prescription != null &&
                                    orderData.prescription!.isNotEmpty)
                                  CustomButton(
                                    width: 160,
                                    height: 40,
                                    onTap: () {
                                      EasyNavigation.push(
                                        context: context,
                                        type: PageTransitionType.rightToLeft,
                                        page: ImageView(
                                          imageUrl: orderData.prescription!,
                                        ),
                                      );
                                    },
                                    text: 'View Prescription',
                                    buttonColor: BColors.darkblue,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                  ),
                                const Gap(12),
                                if (orderData.productDetails?.length !=
                                    orderProvider.pharmacyUserProducts.length)
                                  Column(
                                    children: [
                                      TextfieldWidget(
                                        hintText:
                                            'Enter the reason for the change',
                                        textInputAction: TextInputAction.done,
                                        validator: BValidator.validate,
                                        controller:
                                            orderProvider.reasonController,
                                        maxlines: 4,
                                      ),
                                      const Divider(),
                                    ],
                                  ),
                                UserDetailsContainer(
                                  userData:
                                      orderData.userDetails ?? UserModel(),
                                ),
                                const Gap(16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      width: 136,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          TextFieldAlertBoxWidget
                                              .showAlertTextFieldBox(
                                                  context: context,
                                                  confirmButtonTap: () {
                                                    if (orderProvider
                                                        .rejectionReasonController
                                                        .text
                                                        .isEmpty) {
                                                      return CustomToast.errorToast(
                                                          text:
                                                              'Please enter reason for the cancelling order');
                                                    }
                                                    EasyNavigation.pop(
                                                        context: context);
                                                    LoadingLottie.showLoading(
                                                        context: context,
                                                        text: 'Please wait...');
                                                    orderProvider
                                                        .updateProductOrderDetails(
                                                            context: context,
                                                            productData:
                                                                orderData,
                                                            cancelOrApprove: 3);
                                                  },
                                                  titleText:
                                                      'Confirm To Cancel',
                                                  hintText:
                                                      'Enter the reason for cancel',
                                                  subText:
                                                      'Are you sure to cancel the order ?',
                                                  controller: orderProvider
                                                      .rejectionReasonController,
                                                  maxlines: 5);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            surfaceTintColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(),
                                                borderRadius:
                                                    BorderRadius.circular(8))),
                                        child: Text('Cancel',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 136,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (orderData
                                                      .productDetails?.length !=
                                                  orderProvider
                                                      .pharmacyUserProducts
                                                      .length &&
                                              orderProvider.reasonController
                                                  .text.isEmpty) {
                                            return CustomToast.errorToast(
                                                text:
                                                    'Please enter reason for the change in order');
                                          }
                                          ConfirmAlertBoxWidget
                                              .showAlertConfirmBox(
                                                  context: context,
                                                  confirmButtonTap: () {
                                                    LoadingLottie.showLoading(
                                                        context: context,
                                                        text: 'Please wait...');
                                                    orderProvider
                                                        .updateProductOrderDetails(
                                                            context: context,
                                                            productData:
                                                                orderData,
                                                            cancelOrApprove: 1);
                                                  },
                                                  titleText:
                                                      'Confirm the order',
                                                  subText: (orderData
                                                              .deliveryType ==
                                                          'Home')
                                                      ? 'Please tap yes to confirm this order as a Home Delivery order.'
                                                      : 'Please tap yes to confirm this order as a Pick-Up at pharmacy order.');
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            surfaceTintColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8))),
                                        child: Text('Approve',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      );
    });
  }
}
