import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/core/custom/keyword_builder/keyword_builder.dart';
import 'package:healthycart_pharmacy/core/custom/lottie/loading_lottie.dart';
import 'package:healthycart_pharmacy/core/custom/toast/toast.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/i_pharmacy_facade.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_product_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_category_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class PharmacyProvider extends ChangeNotifier {
  PharmacyProvider(this._iPharmacyFacade);
  final IPharmacyFacade _iPharmacyFacade;
/////////////////////////////////////

  ///////////////////////
  ///Image section ---------------------------
  String? imageUrl;
  File? imageFile;
  bool fetchLoading = false;
  bool fetchAlertLoading = false;
  bool onTapBool = false;

  void onTapEditButton() {
    // to change to long press and ontap
    onTapBool = !onTapBool;
    notifyListeners();
  }

  Future<void> getImage() async {
    final result = await _iPharmacyFacade.getImage();
    notifyListeners();
    result.fold((failure) {
      CustomToast.errorToast(text: failure.errMsg);
    }, (imageFilesucess) async {
      if (imageUrl != null) {
        await _iPharmacyFacade.deleteImage(imageUrl: imageUrl!);
        imageUrl = null;
      } // when editing  this will make the url null when we pick a new file
      imageFile = imageFilesucess;
      notifyListeners();
    });
  }

  Future<void> saveImage() async {
    if (imageFile == null) {
      CustomToast.errorToast(text: 'Please check the image selected.');
      return;
    }
    fetchLoading = true;

    /// fetch loading is true because I am using this function along with add function
    notifyListeners();
    final result = await _iPharmacyFacade.saveImage(imageFile: imageFile!);
    result.fold((failure) {
      CustomToast.errorToast(text: failure.errMsg);
    }, (imageurlGet) {
      imageUrl = imageurlGet;
      notifyListeners();
    });
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
      []; // to get id of category from the doctors list
  List<PharmacyCategoryModel> pharmacyCategoryList = [];
  PharmacyCategoryModel? pharmacyCategory;
  List<PharmacyCategoryModel> pharmacyCategoryUniqueList = [];
////getting category of doctor from admin side
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

  /// update the category in hospital model
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
//////// Deleting doctor category-----------------------
  Future<void> deletePharmacyCategory(
      {required int index, required PharmacyCategoryModel category}) async {
    // check if there is any doctors inside category that is going to be deleted
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
//        Doctor  Section---------------------------------
  String? pharmacyId =
      FirebaseAuth.instance.currentUser?.uid; // user id and hospital id is same
  String? categoryId;

  /// these both are used in the category also to check wheather the user
  String? selectedDoctorCategoryText;

  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>(); // formkey for the user
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController doctorNameController = TextEditingController();
  final TextEditingController doctorFeeController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController aboutDoctorController = TextEditingController();
  String? timeSlotListElement1;
  String? timeSlotListElement2;
  String? availableTotalTimeSlot1;
  String? availableTotalTimeSlot2;
  String? availableTotalTime;
  List<String>? timeSlotListElementList = [];
// adding the userId/hospital and categoryId
  void selectedCategoryDetail({
    required String catId,
    required String catName,
  }) {
    categoryId = catId;
    selectedDoctorCategoryText = catName;
    specializationController.text =
        selectedDoctorCategoryText ?? 'No category selected';
    notifyListeners();
  }

  ///setting total time slot
  void totalAvailableTimeSetter(String time) {
    availableTotalTime = time;
    notifyListeners();
  }

// setting available time slot
  void addTimeslot() {
    if (timeSlotListElement1 != null && timeSlotListElement2 != null) {
      timeSlotListElementList!
          .add('$timeSlotListElement1 - $timeSlotListElement2');
      timeSlotListElement1 = null;
      timeSlotListElement2 = null;
      notifyListeners();
    } else {
      CustomToast.errorToast(text: 'Select both start and end time');
      notifyListeners();
    }
  }

// removing timeslot from the list
  void removeTimeSlot(int index) {
    timeSlotListElementList!.removeAt(index);
    notifyListeners();
  }

  ///////////////////////////////////// 1.)  Adding doctor----------

// image section of adding doctor
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
            CustomToast.sucessToast(text: 'Sucessfully Picked');
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

  Future<void> deleteProductImageList({
    required BuildContext context,
    required int index,
    required String selectedImageUrl,
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
//   ///
//   List<PharmacyProductAddModel> doctorList = [];
//   PharmacyProductAddModel? doctorDetails;
//   List<PharmacyProductAddModel> doctorData = [];

//   Future<void> addDoctorDetail({
//     required BuildContext context,
//   }) async {
//     fetchLoading = true;
//     notifyListeners();
//     doctorDataList();
//     final result =
//         await _iPharmacyFacade.addDoctorDetails(doctorData: doctorDetails!);
//     result.fold((failure) {
//       CustomToast.errorToast(
//           text: "Couldn't able to add doctor, please try again.");
//       EasyNavigation.pop(context: context);
//     }, (doctorReturned) {
//       CustomToast.sucessToast(text: "Added doctor sucessfully");
//       EasyNavigation.pop(context: context);
//       EasyNavigation.pop(context: context);
//       doctorList.insert(doctorList.length, doctorReturned);
//       clearDoctorDetails();
//       notifyListeners();
//     });
//     fetchLoading = false;
//     notifyListeners();
//   }

//   List<String> keywordDoctorBuilder() {
//     List<String> combinedKeyWords = [];
//     combinedKeyWords.addAll(keywordsBuilder(doctorNameController.text));
//     combinedKeyWords.addAll(keywordsBuilder(specializationController.text));
//     return combinedKeyWords;
//   }

//   void doctorDataList() {
//     doctorDetails = PharmacyProductAddModel(
//         categoryId: categoryId,
//         hospitalId: pharmacyId,
//         doctorImage: imageUrl,
//         doctorName: doctorNameController.text,
//         doctorTotalTime: availableTotalTime,
//         doctorTimeList: timeSlotListElementList,
//         doctorFee: int.parse(doctorFeeController.text),
//         doctorSpecialization: specializationController.text,
//         doctorExperience: int.parse(experienceController.text),
//         doctorQualification: qualificationController.text,
//         doctorAbout: aboutController.text,
//         createdAt: Timestamp.now(),
//         keywords: keywordDoctorBuilder());
//     notifyListeners();
//   }

//   void clearDoctorDetails() {
//     imageFile = null;
//     availableTotalTimeSlot2 = null;
//     availableTotalTimeSlot1 = null;
//     availableTotalTime = null;
//     doctorNameController.clear();
//     doctorFeeController.clear();
//     experienceController.clear();
//     qualificationController.clear();
//     aboutController.clear();
//     timeSlotListElementList?.clear();
//     notifyListeners();
//     if (imageUrl != null) {
//       imageUrl = null;
//     }
//     notifyListeners();
//   }
//   ///////////////// 2.)  Getting doctor details according to the category and user-------

//   Future<void> getDoctorsData() async {
//     fetchLoading = true;
//     notifyListeners();
//     doctorList.clear();
//     final result = await _iPharmacyFacade.getDoctorDetails(
//         categoryId: categoryId!, pharmacyId: pharmacyId!);
//     result.fold((failure) {
//       CustomToast.errorToast(text: "Couldn't able to fetch product's");
//     }, (doctors) {
//       doctorList.addAll(doctors); //// here we are assigning the doctor
//     });
//     fetchLoading = false;
//     notifyListeners();
//   }
// /////////////////////////// 3.) deleting the doctor field

//   Future<void> deleteDoctorDetails(
//       {required int index, required PharmacyProductAddModel doctorData}) async {
//     final result = await _iPharmacyFacade.deleteDoctorDetails(
//         doctorId: doctorData.id ?? '', doctorData: doctorData);
//     result.fold((failure) {
//       CustomToast.errorToast(
//           text: "Couldn't able to remove doctor details, please try again.");
//     }, (doctorsData) {
//       CustomToast.sucessToast(text: "Removed doctor sucessfully");
//       doctorList.removeAt(index); //// here we are assigning the doctor
//     });
//     notifyListeners();
//   }

// /////////////////////////// 3.) update the doctor field
//   void setDoctorEditData({required PharmacyProductAddModel doctorEditData}) {
//     imageUrl = doctorEditData.doctorImage;
//     doctorNameController.text = doctorEditData.doctorName ?? 'Unknown Name';
//     availableTotalTime = doctorEditData.doctorTotalTime;
//     timeSlotListElementList = doctorEditData.doctorTimeList;
//     doctorFeeController.text = doctorEditData.doctorFee.toString();
//     specializationController.text =
//         doctorEditData.doctorSpecialization ?? 'Unknown Specialization';
//     experienceController.text = doctorEditData.doctorExperience.toString();
//     qualificationController.text =
//         doctorEditData.doctorQualification ?? 'Unknown qualification';
//     aboutController.text = doctorEditData.doctorAbout ?? 'Unknown About';
//     notifyListeners();
//   }

//   Future<void> updateDoctorDetails({
//     required int index,
//     required PharmacyProductAddModel doctorData,
//     required BuildContext context,
//   }) async {
//     fetchLoading = true;
//     notifyListeners();
//     doctorDetails = PharmacyProductAddModel(
//       id: doctorData.id,
//       categoryId: doctorData.categoryId,
//       hospitalId: doctorData.hospitalId,
//       doctorImage: imageUrl,
//       doctorName: doctorNameController.text,
//       doctorTotalTime: availableTotalTime,
//       doctorTimeList: timeSlotListElementList,
//       doctorFee: int.parse(doctorFeeController.text),
//       doctorSpecialization: specializationController.text,
//       doctorExperience: int.parse(experienceController.text),
//       doctorQualification: qualificationController.text,
//       doctorAbout: aboutController.text,
//       createdAt: doctorData.createdAt,
//       keywords: keywordDoctorBuilder(),
//     );
//     final result = await _iPharmacyFacade.updateDoctorDetails(
//         doctorId: doctorData.id ?? '', doctorData: doctorDetails!);
//     result.fold((failure) {
//       CustomToast.errorToast(
//           text: "Couldn't able to delete doctor details, please try again.");
//     }, (doctorsData) {
//       CustomToast.sucessToast(text: "Edited doctor details sucessfully");
//       doctorList.removeAt(index);
//       doctorList.insert(
//           index, doctorsData); //// here we are assigning the doctor
//       clearDoctorDetails();
//       notifyListeners();
//     });
//     fetchLoading = false;
//     notifyListeners();
//   }
}
