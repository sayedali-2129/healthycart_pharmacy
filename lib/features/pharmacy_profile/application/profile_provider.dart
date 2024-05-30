import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/core/custom/toast/toast.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_product_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_profile/domain/i_profile_facade.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileProvider extends ChangeNotifier {
  ProfileProvider(this.iProfileFacade);
  final IProfileFacade iProfileFacade;
  final hospitalId = FirebaseAuth.instance.currentUser?.uid;
  List<PharmacyProductAddModel> pharamacyProductTotalList = [];
  bool ishospitalON = false;

  void hospitalStatus(bool status) {
    ishospitalON = status;
    notifyListeners();
  }

  Future<void> getAllDoctorDetails() async {
    final result = await iProfileFacade.getAllPharmacyProductDetails();
    result.fold((failure) {
      CustomToast.errorToast(text: "Couldn't able to get all Products details");
    }, (pharamacyProductData) {
      pharamacyProductTotalList = pharamacyProductData;
    });
  }

  Future<void> setActiveHospital() async {
    final result = await iProfileFacade.setActiveHospital(
        ishospitalON: ishospitalON, hospitalId: hospitalId ?? '');
    result.fold((failure) {
      CustomToast.errorToast(text: "Couldn't able to update hospital state");
    }, (sucess) {
      CustomToast.sucessToast(text: sucess);
    });
    notifyListeners();
  }
}
