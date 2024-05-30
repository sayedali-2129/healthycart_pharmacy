import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/core/custom/toast/toast.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/location_picker/domain/i_location_facde.dart';
import 'package:healthycart_pharmacy/features/location_picker/domain/model/location_model.dart';
import 'package:healthycart_pharmacy/features/pending_page/presentation/pending_page.dart';
import 'package:healthycart_pharmacy/features/splash_screen/splash_screen.dart';
import 'package:injectable/injectable.dart';

@injectable
class LocationProvider extends ChangeNotifier {
  LocationProvider(this.iLocationFacade);
  bool locationGetLoading = false;
  final ILocationFacade iLocationFacade;
  PlaceMark? selectedPlaceMark;
  final searchController = TextEditingController();

  List<PlaceMark> searchResults = [];
  bool searchLoading = false;
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  Future<bool> getLocationPermisson() async {
    locationGetLoading = true;
    notifyListeners();
    await iLocationFacade.getLocationPermisson();
    locationGetLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> getCurrentLocationAddress() async {
    searchLoading = true;
    final result = await iLocationFacade.getCurrentLocationAddress();
    result.fold((error) {

      //  CustomToast.errorToast(text: error.errMsg);
      searchLoading = false;
    }, (placeMark) {
      selectedPlaceMark = placeMark;
      searchLoading = false;
      notifyListeners();
    });
  }

  Future<void> searchPlaces() async {
    searchLoading = true;
    notifyListeners();
    final result = await iLocationFacade.getSearchPlaces(searchController.text);
    result.fold((error) {
      CustomToast.errorToast(text: error.errMsg);
      searchLoading = false;
      notifyListeners();
    }, (placeList) {
      searchResults = placeList ?? [];
      searchLoading = false;
      notifyListeners();
    });
  }

  Future<void> setLocationByHospital(
      {required BuildContext context,
      required bool isHospitaEditProfile,
      required int? hospitalModelrequestedCount}) async {
    log('Location selected::::$selectedPlaceMark');
    final result =
        await iLocationFacade.setLocationByHospital(selectedPlaceMark!);
    result.fold((failure) {
      CustomToast.errorToast(text: failure.errMsg);
    }, (sucess) async {
      log('$userId');
      final result =
          await iLocationFacade.updateUserLocation(selectedPlaceMark!, userId!);
      result.fold((failure) {
        Navigator.pop(context);
        CustomToast.errorToast(
            text: "Can't able to add location, please try again");
      }, (sucess) {
        Navigator.pop(context);
        CustomToast.sucessToast(text: 'Location added sucessfully');
        (isHospitaEditProfile)
            ? Navigator.pop(
                context,
              )
            : EasyNavigation.pushAndRemoveUntil(
                context: context,
                page: (hospitalModelrequestedCount == 2)
                    ? const SplashScreen()
                    : const PendingPageScreen());
        notifyListeners();
      });
    });
  }

  void setSelectedPlaceMark(PlaceMark place) {
    selectedPlaceMark = place;
    notifyListeners();
  }

  void clearLocationData() {
    selectedPlaceMark = null;
    searchResults.clear();
    searchController.clear();
    notifyListeners();
  }
}
