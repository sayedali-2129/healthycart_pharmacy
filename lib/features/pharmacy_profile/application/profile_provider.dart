import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/core/custom/toast/toast.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_product_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_profile/domain/i_profile_facade.dart';
import 'package:healthycart_pharmacy/features/pharmacy_profile/domain/model/transaction_model.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@injectable
class ProfileProvider extends ChangeNotifier {
  ProfileProvider(this.iProfileFacade);
  final IProfileFacade iProfileFacade;
  final pharmacyId = FirebaseAuth.instance.currentUser?.uid;
  bool isPharmacyON = false;
  bool isHomeDeliveryON = false;

  void pharmacyStatus(bool status) {
    isPharmacyON = status;
    notifyListeners();
  }

  Future<void> setActivePharmacy() async {
    final result = await iProfileFacade.setActivePharmacy(
        isPharmacyON: isPharmacyON, pharmacyId: pharmacyId ?? '');
    result.fold((failure) {
      CustomToast.errorToast(text: "Couldn't able to update pharmacy status");
    }, (sucess) {
      CustomToast.sucessToast(text: sucess);
    });
    notifyListeners();
  }
  void homeDeliveryStatus(bool status) {
    isHomeDeliveryON = status;
    notifyListeners();
  }
  Future<void> setPharmacyHomeDelivery() async {
    final result = await iProfileFacade.setPharmacyHomeDelivery(
        isHomeDeliveryON: isHomeDeliveryON, pharmacyId: pharmacyId ?? '');
    result.fold((failure) {
      CustomToast.errorToast(text: "Couldn't able to update delivery status");
    }, (sucess) {
      CustomToast.sucessToast(text: sucess);
    });
    notifyListeners();
  }

  /* ---------------------------GET ALL PRODUCT SECTION -------------------------- */
  final TextEditingController searchController = TextEditingController();
  List<PharmacyProductAddModel> productList = [];
  bool fetchLoading = false;

  String expiryDateSetterFetched(Timestamp expiryDate) {
    final DateTime date =
        DateTime.fromMillisecondsSinceEpoch(expiryDate.millisecondsSinceEpoch);
    final String result = DateFormat('yyyy-MM').format(date);
    return result;
  }

  Future<void> getPharmacyProductDetails({String? searchText}) async {
    fetchLoading = true;
    notifyListeners();
    final result = await iProfileFacade.getPharmacyAllProductDetails(
        pharmacyId: pharmacyId!, searchText: searchText);
    result.fold((failure) {
      CustomToast.errorToast(text: "Couldn't able to show products");
    }, (products) {
      log(products.length.toString());
      productList.addAll(products); //// here we are assigning the doctor
    });
    fetchLoading = false;
    notifyListeners();
  }

  void clearFetchData() {
    log('CLEAR IS CallED ::::');
    searchController.clear();
    productList.clear();
    iProfileFacade.clearFetchData();
  }

  void searchProduct(String searchText) {
    productList.clear();
    iProfileFacade.clearFetchData();
    getPharmacyProductDetails(searchText: searchText);
    notifyListeners();
  }
  /* -------------------------------------------------------------------------- */

/* --------------------------- TRANSCATION SECTION -------------------------- */

  List<TransferTransactionsModel> adminTransactionList = [];
  Future<void> getAdminTransactions() async {
    fetchLoading = true;
    notifyListeners();
    final result = await iProfileFacade.getAdminTransactionList(pharmacyId: pharmacyId ?? '');
    result.fold((err) {
      log('ERROR :;  ${err.errMsg}');
    }, (succes) {
      adminTransactionList.addAll(succes);
    });
    fetchLoading = false;
    notifyListeners();
  }

  void transactionInit(
      {required ScrollController scrollController,}) {
    scrollController.addListener(
      () {
        if (scrollController.position.atEdge &&
            scrollController.position.pixels != 0 &&
            fetchLoading == false) {
          getAdminTransactions();
        }
      },
    );
  }

  void clearTransactionData() {
    iProfileFacade.clearTransactionData();
    adminTransactionList = [];
    notifyListeners();
  }

}
