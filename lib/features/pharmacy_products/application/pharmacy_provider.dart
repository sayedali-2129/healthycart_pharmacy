// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/core/custom/keyword_builder/keyword_builder.dart';
import 'package:healthycart_pharmacy/core/custom/lottie/loading_lottie.dart';
import 'package:healthycart_pharmacy/core/custom/toast/toast.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/i_pharmacy_facade.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_category_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_product_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/product_type_model.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

@injectable
class PharmacyProvider extends ChangeNotifier {
  PharmacyProvider(this._iPharmacyFacade);
  final IPharmacyFacade _iPharmacyFacade;
/////////////////////////////////////

  ///////////////////////
  ///Image section ---------------------------
  bool fetchLoading = false;
  bool fetchAlertLoading = false;
  bool onTapBool = false;

  void onTapEditButton() {
    // to change to long press and ontap
    onTapBool = !onTapBool;
    notifyListeners();
  }

//////////////////////////
  /// adding pharmacy category -----------------------------------------
  ///
  /// radio button

  PharmacyCategoryModel? selectedRadioButtonCategoryValue;
  void selectedRadioButton({
    required PharmacyCategoryModel result,
  }) {
    selectedRadioButtonCategoryValue = result;

    notifyListeners();
  }

  List<PharmacyCategoryModel> pharmacyCategoryAllList = [];
  List<String> pharmacyCategoryIdList =
      []; // to get id of category from the product list
  List<PharmacyCategoryModel> pharmacyCategoryList = [];
  PharmacyCategoryModel? pharmacyCategory;
  List<PharmacyCategoryModel> pharmacyCategoryUniqueList = [];
////getting category of pharmacy from admin side
  Future<void> getPharmacyCategoryAll() async {
    if (pharmacyCategoryAllList.isNotEmpty) return;
    fetchAlertLoading = true;
    notifyListeners();
    final result = await _iPharmacyFacade.getPharmacyCategoryAll();
    result.fold((failure) {
      CustomToast.errorToast(text: "Couldn't able to fetch category");
      fetchLoading = false;
      notifyListeners();
    }, (categoryAllList) {
      pharmacyCategoryAllList.addAll(categoryAllList);
      pharmacyCategoryUniqueList.addAll(pharmacyCategoryAllList);
    });
    fetchAlertLoading = false;
    notifyListeners();
  }

  Future<void> getpharmacyCategory() async {
    if (pharmacyCategoryList.isNotEmpty) return;
    fetchLoading = true;
    notifyListeners();
    final result = await _iPharmacyFacade.getpharmacyCategory(
        categoryIdList: pharmacyCategoryIdList);
    result.fold((failure) {
      CustomToast.errorToast(text: "Couldn't able to fetch category");
      fetchLoading = false;
      notifyListeners();
    }, (categoryList) {
      pharmacyCategoryList.addAll(categoryList);
    });
    fetchLoading = false;
    notifyListeners();
  }

  void removingFromUniqueCategoryList() {
    for (var element in pharmacyCategoryList) {
      // removing selected category
      pharmacyCategoryUniqueList.removeWhere((cat) {
        return cat.id == element.id;
      });
      notifyListeners();
    }
  }

  /// update the category in pharmacy
  Future<void> updatePharmacyCategoryDetails(
      {required PharmacyCategoryModel categorySelected,
      required String pharmacyId}) async {
    final result = await _iPharmacyFacade.updatePharmacyCategoryDetails(
        pharmacyId: pharmacyId, category: categorySelected);
    result.fold((failure) {
      CustomToast.errorToast(text: "Couldn't able to update category");
    }, (categorymodel) {
      pharmacyCategoryList.insert(pharmacyCategoryList.length, categorymodel);
      removingFromUniqueCategoryList();
      notifyListeners();
    });
    return;
  }

///////////////////////
//////// Deleting pharmacy category-----------------------
  Future<void> deletePharmacyCategory(
      {required int index, required PharmacyCategoryModel category}) async {
    // check if there is any pharmacy inside category that is going to be deleted
    final boolResult =
        await _iPharmacyFacade.checkProductInsidePharmacyCategory(
            categoryId: category.id ?? 'No categoryId',
            pharmacyId: pharmacyId ?? ' No pharmacy Id is here..');
    boolResult.fold((failure) {
      CustomToast.errorToast(text: "Something went wrong,please try again");
    }, (sucess) async {
      if (sucess) {
        CustomToast.errorToast(text: "Can't remove, there is product's inside");
      } else {
        final result = await _iPharmacyFacade.deletePharmacyCategory(
            pharmacyId: pharmacyId!, category: category);
        result.fold((failure) {
          CustomToast.errorToast(
              text: "Can't able to remove the category,please try again.");
        }, (category) {
          pharmacyCategoryList.removeAt(index);
          pharmacyCategoryUniqueList.add(category);
          CustomToast.sucessToast(text: 'Sucessfully removed.');
          notifyListeners();
        });
      }
    });
  }

/////////////////////////////////////////////
//---------------------------Product  Section---------------------------------

  String? pharmacyId =
      FirebaseAuth.instance.currentUser?.uid; // user id and pharmacy id is same
  String? categoryId;

  /// these both are used in the category also to check wheather the user

  ///////////////////////////////////// 1.)  Adding ImageList----------

// image section of adding product
  List<String> imageProductUrlList = [];

  Future<void> getProductImageList({
    required BuildContext context,
  }) async {
    final maxImages = 3 - imageProductUrlList.length;
    await _iPharmacyFacade
        .getProductImageList(maxImages: maxImages)
        .then((result) {
      result.fold((failure) {
        CustomToast.errorToast(text: failure.errMsg);
      }, (imageFileList) async {
        LoadingLottie.showLoading(context: context, text: 'Please wait...');
        notifyListeners();
        await _iPharmacyFacade
            .saveProductImageList(imageFileList: imageFileList)
            .then((value) {
          value.fold((failure) {
            CustomToast.errorToast(text: failure.errMsg);
            EasyNavigation.pop(context: context);
          }, (imageUrlList) {
            imageProductUrlList.addAll(imageUrlList);
            notifyListeners();
            EasyNavigation.pop(context: context);
            CustomToast.sucessToast(text: 'Sucessfully picked an image');
          });
        });
      });
    });
  }

  int selectedIndex = 0;
  void selectedImageIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  List<String> deleteUrlList = [];
  void deletedUrl({required String selectedImageUrl}) {
    selectedIndex = 0;
    imageProductUrlList.remove(selectedImageUrl);
    deleteUrlList.add(selectedImageUrl);
    notifyListeners();
  }

  Future<void> deleteProductImageList({
    required BuildContext context,
    required int index,
    required String selectedImageUrl,

    /// check this when editing......
  }) async {
    await _iPharmacyFacade
        .deleteImage(imageUrl: selectedImageUrl)
        .then((value) {
      value.fold((failure) {
        CustomToast.errorToast(text: failure.errMsg);
      }, (sucess) {
        selectedIndex = 0;
        imageProductUrlList.removeAt(index);
        notifyListeners();
        CustomToast.sucessToast(text: 'Sucessfully removed');
      });
    });
  }

  Future<void> deletePharmacyImageList(
      {required List<String> imageUrls}) async {
    await _iPharmacyFacade.deletePharmacyImageList(imageUrlList: imageUrls);
  }

  ///Medicine form section
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productBrandNameController =
      TextEditingController();
  final TextEditingController productMRPController = TextEditingController();
  final TextEditingController productDiscountRateController =
      TextEditingController();
  final TextEditingController totalQuantityController = TextEditingController();
  final TextEditingController storeBelowController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController productFormNumberController =
      TextEditingController();
  final TextEditingController productPackageNumberController =
      TextEditingController();
  final TextEditingController measurementUnitNumberController =
      TextEditingController();
  final TextEditingController keyIngredientController = TextEditingController();
  final TextEditingController productInformationController =
      TextEditingController();
  final TextEditingController directionToUseController =
      TextEditingController();
  final TextEditingController safetyInformationController =
      TextEditingController();
  final TextEditingController keyBenefitController = TextEditingController();
  final TextEditingController productBoxContainsController =
      TextEditingController();
  final TextEditingController productWarrantyController =
      TextEditingController();

  bool? discountAvailable;
  bool? prescriptionNeeded;
  int? discountPercentage;
  DateTime? expiryDate;
  String? selectedCategoryText;

//bool setter
  void discountAvailableboolSetter(bool? value) {
    discountAvailable = value ?? false;
    notifyListeners();
  }

  void prescriptionNeededboolSetter(bool? value) {
    prescriptionNeeded = value ?? false;
    notifyListeners();
  }

//calculating the discount
  void discountPercentageCalculator() {
    double value = double.tryParse(productDiscountRateController.text)! /
        double.tryParse(productMRPController.text)!;
    double decimal = (1 - value);
    discountPercentage = (decimal * 100).toInt();
    log(discountAvailable.toString());
    notifyListeners();
  }

// adding the categoryId and type
  String? typeOfProduct;
  void selectedProductType({String? catId, String? selectedCategory}) {
    selectedCategoryText = selectedCategory;
    categoryId = catId ?? '';
    notifyListeners();
  }

  ///setting  expiryDate
  void expiryDateSetter(DateTime? date) {
    expiryDate = date;
    expiryDateController.text = DateFormat('yyyy-MM').format(date!);
    notifyListeners();
  }

  String expiryDateSetterFetched(Timestamp expiryDate) {
    final DateTime date =
        DateTime.fromMillisecondsSinceEpoch(expiryDate.millisecondsSinceEpoch);
    final String result = DateFormat('yyyy-MM').format(date);
    return result;
  }

  List<String> measurmentOptionList = [
    'L (Litre)',
    'mL (Millilitre)',
    'cc (Cubic cm)',
    'Kg (Kilogram)',
    'g (Gram)',
    'mg (Milligram)',
    'µg (Microgram)'
  ];
  List<String> warantyOptionList = ['Months', 'Years'];
  List<String> idealForOptionList = [
    'Infants',
    'Toddlers',
    'Children',
    'Teenagers',
    'Adults',
    'Elderly',
    'Men',
    'Women',
    'For both men & women',
    'For everyone'
  ];
  List<String> productFormList = []; //
  List<String> productPackageList = []; // getting from the admin side
  String? productForm;
  String? productPackage;
  String? productMeasurementUnit;
  String? selectedWarantyOption;
  String? idealFor;
  String? equipmentType;
  String? productType;
  List<String> equipmentTypeList = [];
  void setWarantyOption(String text) {
    selectedWarantyOption = text;
    notifyListeners();
  }

  void setDropFormText(String text) {
    productForm = text;
    notifyListeners();
  }

  void setDropPackageText(String text) {
    productPackage = text;
    notifyListeners();
  }

  void setDropMeasurementText(String text) {
    productMeasurementUnit = text;
    notifyListeners();
  }

  void setIdealForText(String text) {
    idealFor = text;
    notifyListeners();
  }

// getting the two list The package  and form of medicine
  MedicineData? medicineFormAndPackage;
  Future<void> getMedicineFormAndPackageList() async {
    if (productFormList.isNotEmpty && productPackageList.isNotEmpty) return;
    await _iPharmacyFacade.getMedicineFormAndPackageList().then((value) {
      value.fold((failure) {
        CustomToast.errorToast(text: failure.errMsg);
      }, (data) {
        medicineFormAndPackage = data;
        productFormList = medicineFormAndPackage?.productForm ?? [];
        productPackageList = medicineFormAndPackage?.productPackage ?? [];
        notifyListeners();
      });
    });
  }

  /// I.) Medicine section to add
  List<PharmacyProductAddModel> productList = [];
  PharmacyProductAddModel? medicineData;

  Future<void> addPharmacyMedicineDetails({
    required BuildContext context,
  }) async {
    fetchLoading = true;
    notifyListeners();
    medicineProductDetails();
    final result = await _iPharmacyFacade.addPharmacyProductDetails(
        productData: medicineData!,
        productMapData: medicineData!.toMapMedicine());
    result.fold((failure) {
      CustomToast.errorToast(
          text: "Couldn't able to add the medicine, please try again.");
      EasyNavigation.pop(context: context);
    }, (medicineReturned) {
      CustomToast.sucessToast(text: "Added medicine sucessfully");
      clearProductDetails();
      productList.insert(0, medicineReturned);
      notifyListeners();
      EasyNavigation.pop(context: context);
      EasyNavigation.pop(context: context);
    });
    fetchLoading = false;
    notifyListeners();
  }

  List<String> keywordProductNameBuilder() {
    List<String> combinedKeyWords = [];
    combinedKeyWords.addAll(keywordsBuilder(productNameController.text));
    combinedKeyWords.addAll(keywordsBuilder(productBrandNameController.text));
    return combinedKeyWords;
  }

  void medicineProductDetails() {
    medicineData = PharmacyProductAddModel(
      categoryId: categoryId,
      pharmacyId: pharmacyId,
      productName: productNameController.text,
      productBrandName: productBrandNameController.text,
      productImage: imageProductUrlList,
      typeOfProduct: typeOfProduct,
      productMRPRate: num.tryParse(productMRPController.text),
      productDiscountRate: num.tryParse(productDiscountRateController.text),
      discountPercentage: discountPercentage,
      totalQuantity: int.parse(totalQuantityController.text),
      storingDegree: storeBelowController.text,
      idealFor: idealFor,
      expiryDate:
          Timestamp.fromMillisecondsSinceEpoch(//// want to double check here
              expiryDate?.millisecondsSinceEpoch ?? 0),
      createdAt: Timestamp.now(),
      productFormNumber: int.parse(productFormNumberController.text),
      productForm: productForm,
      productPackageNumber: int.parse(productPackageNumberController.text),
      productPackage: productPackage,
      productMeasurementNumber: int.parse(measurementUnitNumberController.text),
      productMeasurement: productMeasurementUnit,
      productInformation: productInformationController.text,
      keyIngrdients: keyIngredientController.text,
      directionToUse: directionToUseController.text,
      safetyInformation: safetyInformationController.text,
      requirePrescription: prescriptionNeeded,
      keyBenefits: keyBenefitController.text,
      keywords: keywordProductNameBuilder(),
    );
    notifyListeners();
  }

  void clearProductDetails() {
    productFormList.clear();
    productPackageList.clear();
    imageProductUrlList.clear();
    typeOfProduct = null;
    productNameController.clear();
    productBrandNameController.clear();
    productMRPController.clear();
    productDiscountRateController.clear();
    totalQuantityController.clear();
    storeBelowController.clear();
    expiryDateController.clear();
    productFormNumberController.clear();
    productPackageNumberController.clear();
    measurementUnitNumberController.clear();
    keyIngredientController.clear();
    productInformationController.clear();
    directionToUseController.clear();
    safetyInformationController.clear();
    keyBenefitController.clear();
    productWarrantyController.clear();
    productBoxContainsController.clear();
    selectedWarantyOption = null;
    discountAvailable = null;
    prescriptionNeeded = null;
    productForm = null;
    discountPercentage = null;
    productPackage = null;
    productMeasurementUnit = null;
    expiryDate = null;
    idealFor = null;
    equipmentType = null;
    productType = null;
    otherData = null;
    medicineData = null;
    equipmentData = null;
    notifyListeners();
  }

////II.) Equipment section to add
  PharmacyProductAddModel? equipmentData;

  Future<void> addPharmacyEquipmentDetails({
    required BuildContext context,
  }) async {
    fetchLoading = true;
    notifyListeners();
    equipmentProductDetails();
    final result = await _iPharmacyFacade.addPharmacyProductDetails(
        productData: equipmentData!,
        productMapData: equipmentData!.toEquipmentMap());
    result.fold((failure) {
      CustomToast.errorToast(
          text: "Couldn't able to add the equipment, please try again.");
      EasyNavigation.pop(context: context);
    }, (equipmentReturned) {
      CustomToast.sucessToast(text: "Added equipment sucessfully");
      productList.insert(0, equipmentReturned);
      clearProductDetails();
      notifyListeners();
      EasyNavigation.pop(context: context);
      EasyNavigation.pop(context: context);
    });
    fetchLoading = false;
    notifyListeners();
  }

  void equipmentProductDetails() {
    equipmentData = PharmacyProductAddModel(
      categoryId: categoryId,
      pharmacyId: pharmacyId,
      productName: productNameController.text,
      productBrandName: productBrandNameController.text,
      productImage: imageProductUrlList,
      typeOfProduct: typeOfProduct,
      productMRPRate: num.tryParse(productMRPController.text),
      productDiscountRate: num.tryParse(productDiscountRateController.text),
      discountPercentage: discountPercentage,
      totalQuantity: int.parse(totalQuantityController.text),
      productType: '',
      idealFor: idealFor,
      productBoxContains: productBoxContainsController.text,
      productMeasurementNumber: int.parse(measurementUnitNumberController.text),
      productMeasurement: productMeasurementUnit,
      equipmentWarranty: selectedWarantyOption,
      equipmentWarrantyNumber: double.tryParse(productWarrantyController.text),
      productInformation: productInformationController.text,
      directionToUse: directionToUseController.text,
      safetyInformation: safetyInformationController.text,
      specification: keyBenefitController.text,
      requirePrescription: prescriptionNeeded,
      createdAt: Timestamp.now(),
      keywords: keywordProductNameBuilder(),
    );
  }

  /// III.) other's  section to add

  PharmacyProductAddModel? otherData;
  Future<void> addPharmacyOthersDetails({
    required BuildContext context,
  }) async {
    fetchLoading = true;
    notifyListeners();
    otherProductDetails();
    final result = await _iPharmacyFacade.addPharmacyProductDetails(
        productData: otherData!, productMapData: otherData!.toMapOther());
    result.fold((failure) {
      CustomToast.errorToast(
          text: "Couldn't able to add the product, please try again.");
      EasyNavigation.pop(context: context);
    }, (otherReturned) {
      CustomToast.sucessToast(text: "Added product sucessfully");
      productList.insert(0, otherReturned);
      clearProductDetails();
      notifyListeners();
      EasyNavigation.pop(context: context);
      EasyNavigation.pop(context: context);
    });
    fetchLoading = false;
    notifyListeners();
  }

  void otherProductDetails() {
    otherData = PharmacyProductAddModel(
      categoryId: categoryId,
      pharmacyId: pharmacyId,
      productName: productNameController.text,
      productBrandName: productBrandNameController.text,
      productImage: imageProductUrlList,
      typeOfProduct: typeOfProduct,
      productMRPRate: num.tryParse(productMRPController.text),
      productDiscountRate: num.tryParse(productDiscountRateController.text),
      discountPercentage: discountPercentage,
      totalQuantity: int.parse(totalQuantityController.text),
      storingDegree: storeBelowController.text,
      idealFor: idealFor,
      productType: '',
      expiryDate:
          Timestamp.fromMillisecondsSinceEpoch(//// want to double check here
              expiryDate?.millisecondsSinceEpoch ?? 0),
      createdAt: Timestamp.now(),
      productFormNumber: int.parse(productFormNumberController.text),
      productForm: productForm,
      productPackageNumber: int.parse(productPackageNumberController.text),
      productPackage: productPackage,
      productMeasurementNumber: int.parse(measurementUnitNumberController.text),
      productMeasurement: productMeasurementUnit,
      productInformation: productInformationController.text,
      keyIngrdients: keyIngredientController.text,
      directionToUse: directionToUseController.text,
      safetyInformation: safetyInformationController.text,
      keyBenefits: keyBenefitController.text,
      keywords: keywordProductNameBuilder(),
    );
    notifyListeners();
  }

//// 2.)  Getting product details according to the category and pharmacy-------

  Future<void> getPharmacyProductDetails({String? searchText}) async {
    fetchLoading = true;
    notifyListeners();
    final result = await _iPharmacyFacade.getPharmacyProductDetails(
        categoryId: categoryId!,
        pharmacyId: pharmacyId!,
        searchText: searchText);
    result.fold((failure) {
      CustomToast.errorToast(text: "Couldn't able to fetch product's");
    }, (products) {
      productList.addAll(products); //// here we are assigning the doctor
    });
    fetchLoading = false;
    notifyListeners();
  }

  void clearFetchData() {
    log('CLEAR IS CallED ::::');
    searchController.clear();
    productList.clear();
    _iPharmacyFacade.clearFetchData();
  }

  final TextEditingController searchController = TextEditingController();
  void searchProduct(String searchText) {
    productList.clear();
    _iPharmacyFacade.clearFetchData();
    getPharmacyProductDetails(searchText: searchText);
  }

// /////// 3.) deleting the doctor field

  Future<void> deletePharmacyProductDetails(
      {required int index,
      required PharmacyProductAddModel productData}) async {
    final result = await _iPharmacyFacade.deletePharmacyProductDetails(
        productId: productData.id ?? '', productData: productData);
    result.fold((failure) {
      CustomToast.errorToast(
          text: "Couldn't able to remove product details, please try again.");
    }, (doctorsData) {
      CustomToast.sucessToast(text: "Removed product sucessfully");
      productList.removeAt(index); //// here we are removing from local list
    });
    notifyListeners();
  }

// /////////////////////////// 3.) update the product field------------------------------
  void setMedicineEditData(
      {required PharmacyProductAddModel medicineEditData}) {
    typeOfProduct = medicineEditData.typeOfProduct;
    imageProductUrlList.addAll(medicineEditData.productImage ?? []);
    productNameController.text = medicineEditData.productName ?? '';
    productBrandNameController.text = medicineEditData.productBrandName ?? '';
    productMRPController.text = medicineEditData.productMRPRate.toString();
    discountAvailable = (medicineEditData.productDiscountRate != null);
    productDiscountRateController.text =
        medicineEditData.productDiscountRate.toString();
    idealFor = medicineEditData.idealFor;
    discountPercentage = medicineEditData.discountPercentage;
    totalQuantityController.text = medicineEditData.totalQuantity.toString();
    storeBelowController.text = medicineEditData.storingDegree ?? '';
    expiryDateController.text =
        expiryDateSetterFetched(medicineEditData.expiryDate ?? Timestamp.now());

    productFormNumberController.text =
        '${medicineEditData.productFormNumber ?? ''}';
    productForm = medicineEditData.productForm;
    measurementUnitNumberController.text =
        '${medicineEditData.productMeasurementNumber ?? ''}';
    productMeasurementUnit = medicineEditData.productMeasurement;
    productPackageNumberController.text =
        '${medicineEditData.productPackageNumber ?? ''}';
    productPackage = medicineEditData.productPackage;
    keyIngredientController.text = medicineEditData.keyIngrdients ?? '';
    productInformationController.text =
        medicineEditData.productInformation ?? '';
    directionToUseController.text = medicineEditData.directionToUse ?? '';
    safetyInformationController.text = medicineEditData.safetyInformation ?? '';
    keyBenefitController.text = medicineEditData.keyBenefits ?? '';
    prescriptionNeeded = medicineEditData.requirePrescription;
    notifyListeners();
  }

  void setEquipmentEditData(
      {required PharmacyProductAddModel equipmentEditData}) {
    typeOfProduct = equipmentEditData.typeOfProduct;
    imageProductUrlList.addAll(equipmentEditData.productImage ?? []);
    productNameController.text = equipmentEditData.productName ?? '';
    productBrandNameController.text = equipmentEditData.productBrandName ?? '';
    productMRPController.text = equipmentEditData.productMRPRate.toString();
    productDiscountRateController.text =
        equipmentEditData.productDiscountRate.toString();
    discountAvailable = (equipmentEditData.productDiscountRate != null);
    discountPercentage = equipmentEditData.discountPercentage;
    totalQuantityController.text = equipmentEditData.totalQuantity.toString();
    equipmentType = equipmentEditData.productType;
    idealFor = equipmentEditData.idealFor;
    productBoxContainsController.text =
        equipmentEditData.productBoxContains ?? '';
    productWarrantyController.text =
        '${equipmentEditData.equipmentWarrantyNumber ?? ''}';
    selectedWarantyOption = equipmentEditData.equipmentWarranty ?? '';
    measurementUnitNumberController.text =
        '${equipmentEditData.productMeasurementNumber ?? ''}';
    productMeasurementUnit = equipmentEditData.productMeasurement;
    productInformationController.text =
        equipmentEditData.productInformation ?? '';
    directionToUseController.text = equipmentEditData.directionToUse ?? '';
    safetyInformationController.text =
        equipmentEditData.safetyInformation ?? '';
    keyBenefitController.text = equipmentEditData.specification ?? '';
    prescriptionNeeded = equipmentEditData.requirePrescription;
    notifyListeners();
  }

  void setOtherEditData({required PharmacyProductAddModel othersEditData}) {
    typeOfProduct = othersEditData.typeOfProduct;
    imageProductUrlList.addAll(othersEditData.productImage ?? []);
    productNameController.text = othersEditData.productName ?? '';
    productBrandNameController.text = othersEditData.productBrandName ?? '';
    productMRPController.text = othersEditData.productMRPRate.toString();
    discountAvailable = (othersEditData.productDiscountRate != null);
    productDiscountRateController.text =
        othersEditData.productDiscountRate.toString();
    idealFor = othersEditData.idealFor;
    discountPercentage = othersEditData.discountPercentage;
    totalQuantityController.text = othersEditData.totalQuantity.toString();
    expiryDateController.text =
        expiryDateSetterFetched(othersEditData.expiryDate ?? Timestamp.now());
    productFormNumberController.text =
        '${othersEditData.productFormNumber ?? ''}';
    productForm = othersEditData.productForm;
    measurementUnitNumberController.text =
        '${othersEditData.productMeasurementNumber ?? ''}';
    productMeasurementUnit = othersEditData.productMeasurement;
    productPackageNumberController.text =
        '${othersEditData.productPackageNumber ?? ''}';
    productPackage = othersEditData.productPackage;
    keyIngredientController.text = othersEditData.keyIngrdients ?? '';
    productInformationController.text = othersEditData.productInformation ?? '';
    directionToUseController.text = othersEditData.directionToUse ?? '';
    safetyInformationController.text = othersEditData.safetyInformation ?? '';
    keyBenefitController.text = othersEditData.keyBenefits ?? '';
    prescriptionNeeded = othersEditData.requirePrescription;
    notifyListeners();
  }

  ///upadting medicine section----------------------------------------------
  ///

  Future<void> updatePharmacyMedicineDetails({
    required int index,
    required PharmacyProductAddModel medicineEditData,
    required BuildContext context,
  }) async {
    fetchLoading = true;
    notifyListeners();
    medicineEditProductDetails(medicineEditData);
    final result = await _iPharmacyFacade.updatePharmacyProductDetails(
        productId: medicineEditData.id ?? '',
        productData: medicineData!,
        productMapData: medicineData!.toMapMedicine());
    result.fold((failure) {
      CustomToast.errorToast(
          text: "Couldn't able to update details, please try again.");
      EasyNavigation.pop(context: context);
    }, (productData) async{
        if (deleteUrlList.isNotEmpty) {
        await deletePharmacyImageList(imageUrls: deleteUrlList).then((value) {
          deleteUrlList.clear();
        });
      }
      CustomToast.sucessToast(text: "Updated sucessfully");
      productList.removeAt(index);
      productList.insert(
          index, productData); //// here we are assigning the doctor
      clearProductDetails();
      notifyListeners();
      EasyNavigation.pop(context: context);
      EasyNavigation.pop(context: context);
    });
    fetchLoading = false;
    notifyListeners();
  }

  void medicineEditProductDetails(PharmacyProductAddModel medicineEditData) {
    medicineData = PharmacyProductAddModel(
      categoryId: categoryId,
      pharmacyId: pharmacyId,
      productName: productNameController.text,
      productBrandName: productBrandNameController.text,
      productImage: (imageProductUrlList.isEmpty)
          ? medicineEditData.productImage
          : imageProductUrlList,
      typeOfProduct: typeOfProduct,
      productMRPRate: num.tryParse(productMRPController.text),
      productDiscountRate: num.tryParse(productDiscountRateController.text),
      discountPercentage: discountPercentage,
      totalQuantity: int.parse(totalQuantityController.text),
      storingDegree: storeBelowController.text,
      idealFor: idealFor,
      expiryDate:
          Timestamp.fromMillisecondsSinceEpoch(//// want to double check here
              expiryDate?.millisecondsSinceEpoch ?? 0),
      createdAt: medicineEditData.createdAt,
      productFormNumber: int.parse(productFormNumberController.text),
      productForm: productForm,
      productPackageNumber: int.parse(productPackageNumberController.text),
      productPackage: productPackage,
      productMeasurementNumber: int.parse(measurementUnitNumberController.text),
      productMeasurement: productMeasurementUnit,
      productInformation: productInformationController.text,
      keyIngrdients: keyIngredientController.text,
      directionToUse: directionToUseController.text,
      safetyInformation: safetyInformationController.text,
      requirePrescription: prescriptionNeeded,
      keyBenefits: keyBenefitController.text,
      keywords: keywordProductNameBuilder(),
    );
    notifyListeners();
  }

  ///upadting equipment section----------------------------------------------
  Future<void> updatePharmacyEquipmentDetails({
    required int index,
    required PharmacyProductAddModel equipmentEditData,
    required BuildContext context,
  }) async {
    fetchLoading = true;
    notifyListeners();
    equipmentEditProductDetails(equipmentEditData);
    final result = await _iPharmacyFacade.updatePharmacyProductDetails(
        productId: equipmentEditData.id ?? '',
        productData: equipmentData!,
        productMapData: equipmentData!.toEquipmentMap());
    result.fold((failure) {
      CustomToast.errorToast(
          text: "Couldn't able to update details, please try again.");
      EasyNavigation.pop(context: context);
    }, (productData) async{
      if (deleteUrlList.isNotEmpty) {
        await deletePharmacyImageList(imageUrls: deleteUrlList).then((value) {
          deleteUrlList.clear();
        });
      }
      CustomToast.sucessToast(text: "Updated sucessfully");
      productList.removeAt(index);
      productList.insert(
          index, productData); //// here we are assigning the doctor
      clearProductDetails();
      notifyListeners();
      EasyNavigation.pop(context: context);
      EasyNavigation.pop(context: context);
    });
    fetchLoading = false;
    notifyListeners();
  }

  void equipmentEditProductDetails(PharmacyProductAddModel equipmentEditData) {
    equipmentData = PharmacyProductAddModel(
      categoryId: categoryId,
      pharmacyId: pharmacyId,
      productName: productNameController.text,
      productBrandName: productBrandNameController.text,
      productImage: imageProductUrlList,
      typeOfProduct: typeOfProduct,
      productMRPRate: num.tryParse(productMRPController.text),
      productDiscountRate: num.tryParse(productDiscountRateController.text),
      discountPercentage: discountPercentage,
      totalQuantity: int.parse(totalQuantityController.text),
      productType: '',
      idealFor: idealFor,
      productBoxContains: productBoxContainsController.text,
      productMeasurementNumber: int.parse(measurementUnitNumberController.text),
      productMeasurement: productMeasurementUnit,
      equipmentWarranty: selectedWarantyOption,
      equipmentWarrantyNumber: double.tryParse(productWarrantyController.text),
      productInformation: productInformationController.text,
      directionToUse: directionToUseController.text,
      safetyInformation: safetyInformationController.text,
      specification: keyBenefitController.text,
      requirePrescription: prescriptionNeeded,
      createdAt: equipmentEditData.createdAt,
      keywords: keywordProductNameBuilder(),
    );
  }

  ///upadting other section----------------------------------------------
  Future<void> updatePharmacyOtherDetails({
    required int index,
    required PharmacyProductAddModel othersEditData,
    required BuildContext context,
  }) async {
    fetchLoading = true;
    notifyListeners();
    otherEditProductDetails(othersEditData);
    final result = await _iPharmacyFacade.updatePharmacyProductDetails(
        productId: othersEditData.id ?? '',
        productData: otherData!,
        productMapData: otherData!.toMapOther());
    result.fold((failure) {
      CustomToast.errorToast(
          text: "Couldn't able to update details, please try again.");
      EasyNavigation.pop(context: context);
    }, (productData) async {
      if (deleteUrlList.isNotEmpty) {
        await deletePharmacyImageList(imageUrls: deleteUrlList).then((value) {
          deleteUrlList.clear();
        });
      }
      CustomToast.sucessToast(text: "Updated sucessfully");
      productList.removeAt(index);
      productList.insert(
          index, productData); //// here we are assigning the doctor
      clearProductDetails();
      notifyListeners();
      EasyNavigation.pop(context: context);
      EasyNavigation.pop(context: context);
    });
    fetchLoading = false;
    notifyListeners();
  }

  void otherEditProductDetails(PharmacyProductAddModel othersEditData) {
    otherData = PharmacyProductAddModel(
      categoryId: categoryId,
      pharmacyId: pharmacyId,
      productName: productNameController.text,
      productBrandName: productBrandNameController.text,
      productImage: imageProductUrlList,
      typeOfProduct: typeOfProduct,
      productMRPRate: num.tryParse(productMRPController.text),
      productDiscountRate: num.tryParse(productDiscountRateController.text),
      discountPercentage: discountPercentage,
      totalQuantity: int.parse(totalQuantityController.text),
      storingDegree: storeBelowController.text,
      idealFor: idealFor,
      productType: '',
      expiryDate:
          Timestamp.fromMillisecondsSinceEpoch(//// want to double check here
              expiryDate?.millisecondsSinceEpoch ?? 0),
      createdAt: othersEditData.createdAt,
      productFormNumber: int.parse(productFormNumberController.text),
      productForm: productForm,
      productPackageNumber: int.parse(productPackageNumberController.text),
      productPackage: productPackage,
      productMeasurementNumber: int.parse(measurementUnitNumberController.text),
      productMeasurement: productMeasurementUnit,
      productInformation: productInformationController.text,
      keyIngrdients: keyIngredientController.text,
      directionToUse: directionToUseController.text,
      safetyInformation: safetyInformationController.text,
      keyBenefits: keyBenefitController.text,
      keywords: keywordProductNameBuilder(),
    );
    notifyListeners();
  }
}
