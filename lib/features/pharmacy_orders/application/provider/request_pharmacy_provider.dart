import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/core/custom/toast/toast.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/home/presentation/home.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/domain/i_order_facade.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/domain/model/pharmacy_order_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/domain/model/product_quantity_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_product_model.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class RequestPharmacyProvider extends ChangeNotifier {
  RequestPharmacyProvider(this._iOrderFacade);
  final IOrderFacade _iOrderFacade;
  bool fetchloading = false;
  int tabIndex = 0;

  void changeTabINdex({
    required int index,
  }) {
    tabIndex = index;
    notifyListeners();
  }

  List<String> tabItems = [
    'New Order',
    'On Process',
    'Completed',
    'Cancelled',
  ];

  /* ----------------------------- PRODUCT SECTION ---------------------------- */
  String? pharmacyId = FirebaseAuth.instance.currentUser?.uid;
  List<ProductAndQuantityModel> pharmacyUserProducts = [];
  List<PharmacyOrderModel> newOrderList = [];
  num totalAmount = 0;
  num totalFinalAmount = 0;

  void addAllProductDetails(
      {required List<ProductAndQuantityModel> productDataList}) {
    if (pharmacyUserProducts.isNotEmpty) return;
    pharmacyUserProducts.addAll(productDataList);
  }

/* ---------------------------- PRICE CALCULATOR ---------------------------- */
  void totalAmountCalclator() {
    totalAmount = 0;
    totalFinalAmount = 0;
    num totalDiscountAmount = 0;
    num totalMRPAmount = 0;

    for (int i = 0; i < pharmacyUserProducts.length; i++) {
      if (pharmacyUserProducts[i].productData?.productDiscountRate == null) {
        totalDiscountAmount = (pharmacyUserProducts[i].quantity! *
            pharmacyUserProducts[i].productData!.productMRPRate!);
      } else {
        totalDiscountAmount = (pharmacyUserProducts[i].quantity! *
            pharmacyUserProducts[i].productData!.productDiscountRate!);
      }
      totalMRPAmount = (pharmacyUserProducts[i].quantity! *
          pharmacyUserProducts[i].productData!.productMRPRate!);

      totalAmount += totalMRPAmount;
      totalFinalAmount += totalDiscountAmount;
    }

    log("totalAmount  :$totalAmount");
    notifyListeners();
  }

/* -------------------------------------------------------------------------- */

/* ----------------------------- DATE CONVERTOR ----------------------------- */
  String dateFromTimeStamp(Timestamp createdAt) {
    final date =
        DateTime.fromMillisecondsSinceEpoch(createdAt.millisecondsSinceEpoch);
    return DateFormat('dd/MM/yyyy').format(date);
  }

/* -------------------------------------------------------------------------- */
/* ------------------------------ DELIVERY TYPE ----------------------------- */
  String deliveryType(String delivery) {
    if (delivery == "Home") {
      return 'Home Delivery';
    } else {
      return 'Pick-Up at pharmacy';
    }
  }

/* -------------------------------------------------------------------------- */
  /* ------------------------------ LAUNCH DIALER ----------------------------- */
  Future<void> lauchDialer({required String phoneNumber}) async {
    final Uri url = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      CustomToast.errorToast(text: 'Could not launch the dialer');
    }
  }

/* ------------------------ PRODUCT NEW ORDER STREAM SECTION ----------------------- */
  void getNewOrders() {
    fetchloading = true;
    notifyListeners();
    _iOrderFacade
        .pharmacyNewOrderData(pharmacyId: pharmacyId ?? '')
        .listen((event) {
      event.fold(
        (err) {
          CustomToast.errorToast(text: err.errMsg);
          fetchloading = false;
          notifyListeners();
        },
        (newOrders) {
          newOrderList = newOrders;
          fetchloading = false;
          notifyListeners();
        },
      );
    });

    notifyListeners();
  }

/* -------------------------------------------------------------------------- */
/* -------------------------- UPDATE PENDING ORDER -------------------------- */
  final reasonController = TextEditingController();
  final rejectionReasonController = TextEditingController();
  final deliveryController = TextEditingController();
  num? deliveryCharge = 0;
  num? previousDeliveryCharge = 0;
  PharmacyOrderModel? orderProducts;

  void removeProduct({required int index}) {
    pharmacyUserProducts.removeAt(index);
    totalAmountCalclator();
    notifyListeners();
  }

  void setDeliveryCharge() {
    deliveryCharge = num.parse(deliveryController.text);
    if (deliveryCharge != null) {
      totalFinalAmount -= previousDeliveryCharge!;
      totalFinalAmount += deliveryCharge!;
    }
    previousDeliveryCharge = deliveryCharge;
    notifyListeners();
  }

  void clearFiledAndData() {
    deliveryCharge = 0;
    previousDeliveryCharge = 0;
    reasonController.clear();
    deliveryController.clear();
    rejectionReasonController.clear();
    pharmacyUserProducts.clear();
    productMap.clear();// clearing in the case of prescription
    notifyListeners();
  }

  Future<void> updateProductOrderDetails(
      {required PharmacyOrderModel productData,
      required int cancelOrApprove,
      required BuildContext context}) async {
    detailsPageProductsDetails(
        productData: productData, cancelOrApprove: cancelOrApprove);
    final result = await _iOrderFacade.updateProductOrderDetails(
      orderId: productData.id ?? '',
      orderProducts: orderProducts!,
    );
    result.fold(
      (failure) {
        CustomToast.errorToast(text: failure.errMsg);
        EasyNavigation.pop(context: context);
        notifyListeners();
      },
      (orderProduct) {
        clearFiledAndData();
        CustomToast.sucessToast(
            text: (cancelOrApprove == 1)
                ? "The order is sent to user"
                : "The order is sucessfully cancelled.");
        EasyNavigation.pop(context: context);
        EasyNavigation.push(context: context, page: const HomeScreen());
        notifyListeners();
      },
    );
  }

  void detailsPageProductsDetails(
      {required PharmacyOrderModel productData, required int cancelOrApprove}) {
    orderProducts = PharmacyOrderModel(
      pharmacyId: productData.pharmacyId,
      userId: productData.userId,
      userDetails: productData.userDetails,
      addresss: productData.addresss,
      productId: productData.productId,
      productDetails: pharmacyUserProducts,
      orderStatus: cancelOrApprove,
      paymentStatus: 0,
      deliveryCharge: deliveryCharge,
      pharmacyDetails: productData.pharmacyDetails,
      deliveryType: productData.deliveryType,
      totalDiscountAmount: (deliveryCharge == 0 || deliveryCharge == null)
          ? totalFinalAmount
          : totalFinalAmount - deliveryCharge!,
      totalAmount: totalAmount,
      finalAmount: totalFinalAmount,
      createdAt: productData.createdAt,
      prescription: productData.prescription,
      rejectReason: reasonController.text.isEmpty
          ? rejectionReasonController.text
          : reasonController.text,
      acceptedAt: (cancelOrApprove == 1) ? Timestamp.now() : null,
      rejectedAt: (cancelOrApprove == 3) ? Timestamp.now() : null,
    );
  }

  /* -------------------------------------------------------------------------- */
  /* ------------------------ PRESCRIPTION ADD QUANTITY ----------------------- */
  int quantityCount = 1;
  ProductAndQuantityModel? productPrescriptionAdd;
  Map<String, ProductAndQuantityModel> productMap = {};
  int? selectedIndex = -1;

  void setPrescriptionProductMap(
      {required PharmacyProductAddModel productDetail}) {
    if (productMap.containsKey(productDetail.id)) {
      productPrescriptionAdd = ProductAndQuantityModel(
          productData: productDetail,
          productId: productDetail.id,
          quantity: quantityCount);
      productMap[productDetail.id!] =
          productPrescriptionAdd ?? ProductAndQuantityModel();
    } else {
      quantityCount = 1;
      productPrescriptionAdd = ProductAndQuantityModel(
          productData: productDetail,
          productId: productDetail.id,
          quantity: quantityCount);
      productMap[productDetail.id!] =
          productPrescriptionAdd ?? ProductAndQuantityModel();
    }
    notifyListeners();
  }

  void removePrescriptionProduct({required String id}) {
    productMap.removeWhere(
      (key, value) => key == id,
    );
    notifyListeners();
  }

  // increment of the quantity from product details page
  void increment({required PharmacyProductAddModel productDetail}) {
    quantityCount++;
    setPrescriptionProductMap(productDetail: productDetail);
    notifyListeners();
  }

  // decrement of the quantity from product details page
  void decrement({required PharmacyProductAddModel productDetail}) {
    if (quantityCount <= 1) return;
    quantityCount--;
    setPrescriptionProductMap(productDetail: productDetail);
    notifyListeners();
  }

  /// add locally to list product for approve from productMap in case of prescription
  void addProductsFromMap() {
    pharmacyUserProducts = productMap.values.toList();
    notifyListeners();
  }
}
