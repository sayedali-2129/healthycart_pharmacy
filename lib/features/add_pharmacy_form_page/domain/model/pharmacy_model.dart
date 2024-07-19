import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:healthycart_pharmacy/features/location_picker/domain/model/location_model.dart';

class PharmacyModel {
  String? id;
  final String? phoneNo;
  PlaceMark? placemark;
  final String? pharmacyName;
  final String? pharmacyAddress;
  final String? pharmacyownerName;
  final String? pharmacyDocumentLicense;
  final String? pharmacyImage;
  final int? pharmacyRequested;
  final bool? isActive;
  final bool? isHomeDelivery;
  final bool? isPharmacyON;
  final Timestamp? createdAt;
  final List<String>? selectedCategoryId;
  final List<String>? pharmacyKeywords;
  final String? rejectionReason;
  final String? fcmToken;
  final String? email;
  final String? dayTransaction;
  String? accountHolderName;
  String? bankName;
  String? ifscCode;
  String? accountNumber;
  PharmacyModel({
    this.id,
    this.phoneNo,
    this.placemark,
    this.pharmacyName,
    this.pharmacyAddress,
    this.pharmacyownerName,
    this.pharmacyDocumentLicense,
    this.pharmacyImage,
    this.pharmacyRequested,
    this.isActive,
    this.isHomeDelivery,
    this.isPharmacyON,
    this.createdAt,
    this.selectedCategoryId,
    this.fcmToken,
    this.email,
    this.pharmacyKeywords,
    this.rejectionReason,
    this.dayTransaction,
    this.accountHolderName,
    this.bankName,
    this.ifscCode,
    this.accountNumber,
  });

  PharmacyModel copyWith({
    String? id,
    String? phoneNo,
    PlaceMark? placemark,
    String? pharmacyName,
    String? pharmacyAddress,
    String? pharmacyownerName,
    String? pharmacyDocumentLicense,
    String? pharmacyImage,
    List<String>? selectedCategoryId,
    int? pharmacyRequested,
    bool? isActive,
    bool? isHomeDelivery,
    bool? isPharmacyON,
    Timestamp? createdAt,
    List<String>? pharmacyKeywords,
    String? fcmToken,
    String? email,
    String? rejectionReason,
    String? dayTransaction,
    String? accountHolderName,
    String? bankName,
    String? ifscCode,
    String? accountNumber,
  }) {
    return PharmacyModel(
      id: id ?? this.id,
      phoneNo: phoneNo ?? this.phoneNo,
      placemark: placemark ?? this.placemark,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      pharmacyAddress: pharmacyAddress ?? this.pharmacyAddress,
      pharmacyownerName: pharmacyownerName ?? this.pharmacyownerName,
      pharmacyDocumentLicense:
          pharmacyDocumentLicense ?? this.pharmacyDocumentLicense,
      pharmacyImage: pharmacyImage ?? this.pharmacyImage,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      pharmacyRequested: pharmacyRequested ?? this.pharmacyRequested,
      isHomeDelivery: isHomeDelivery ?? this.isHomeDelivery,
      isActive: isActive ?? this.isActive,
      fcmToken: fcmToken ?? this.fcmToken,
      email: email ?? this.email,
      isPharmacyON: isPharmacyON ?? this.isPharmacyON,
      createdAt: createdAt ?? this.createdAt,
      pharmacyKeywords: pharmacyKeywords ?? this.pharmacyKeywords,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      dayTransaction: dayTransaction ?? this.dayTransaction,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      bankName: bankName ?? this.bankName,
      ifscCode: ifscCode ?? this.ifscCode,
      accountNumber: accountNumber ?? this.accountNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'phoneNo': phoneNo,
      'placemark': placemark?.toMap(),
      'pharmacyName': pharmacyName,
      'pharmacyAddress': pharmacyAddress,
      'pharmacyownerName': pharmacyownerName,
      'pharmacyDocumentLicense': pharmacyDocumentLicense,
      'pharmacyImage': pharmacyImage,
      'selectedCategoryId': selectedCategoryId,
      'pharmacyRequested': pharmacyRequested,
      'isActive': isActive,
      'isHomeDelivery': isHomeDelivery,
      'isPharmacyON': isPharmacyON,
      'createdAt': createdAt,
      'pharmacyKeywords': pharmacyKeywords,
      'email': email,
      'fcmToken': fcmToken,
      'rejectionReason': rejectionReason,
      'dayTransaction': dayTransaction,
      'accountHolderName': accountHolderName,
      'bankName': bankName,
      'ifscCode': ifscCode,
      'accountNumber': accountNumber,
    };
  }

  Map<String, dynamic> toFormMap() {
    return <String, dynamic>{
      'id': id,
      'phoneNo': phoneNo,
      'placemark': placemark?.toMap(),
      'pharmacyName': pharmacyName,
      'pharmacyAddress': pharmacyAddress,
      'pharmacyownerName': pharmacyownerName,
      'pharmacyDocumentLicense': pharmacyDocumentLicense,
      'pharmacyImage': pharmacyImage,
      'selectedCategoryId': selectedCategoryId,
      'pharmacyRequested': pharmacyRequested,
      'isActive': isActive,
      'isHomeDelivery': isHomeDelivery,
      'isPharmacyON': isPharmacyON,
      'createdAt': createdAt,
      'pharmacyKeywords': pharmacyKeywords,
      'email': email,
      'rejectionReason': rejectionReason,
      'dayTransaction': dayTransaction,
    };
  }

  Map<String, dynamic> toEditMap() {
    return <String, dynamic>{
      'pharmacyName': pharmacyName,
      'pharmacyAddress': pharmacyAddress,
      'pharmacyownerName': pharmacyownerName,
      'pharmacyDocumentLicense': pharmacyDocumentLicense,
      'pharmacyImage': pharmacyImage,
      'email': email,
      'pharmacyKeywords': pharmacyKeywords,
    };
  }

  Map<String, dynamic> toProductMap() {
    return <String, dynamic>{
      'pharmacyName': pharmacyName,
      'pharmacyAddress': pharmacyAddress,
      'pharmacyImage': pharmacyImage,
      'phoneNo': phoneNo,
      'fcmToken': fcmToken,
      'email': email,
    };
  }

  Map<String, dynamic> toBankDetailsMap() {
    return <String, dynamic>{
      'accountHolderName': accountHolderName,
      'bankName': bankName,
      'ifscCode': ifscCode,
      'accountNumber': accountNumber,
    };
  }

  factory PharmacyModel.fromMap(Map<String, dynamic> map) {
    return PharmacyModel(
      id: map['id'] != null ? map['id'] as String : null,
      phoneNo: map['phoneNo'] != null ? map['phoneNo'] as String : null,
      placemark: map['placemark'] != null
          ? PlaceMark.fromMap(map['placemark'] as Map<String, dynamic>)
          : null,
      pharmacyName:
          map['pharmacyName'] != null ? map['pharmacyName'] as String : null,
      pharmacyAddress: map['pharmacyAddress'] != null
          ? map['pharmacyAddress'] as String
          : null,
      pharmacyownerName: map['pharmacyownerName'] != null
          ? map['pharmacyownerName'] as String
          : null,
      pharmacyDocumentLicense: map['pharmacyDocumentLicense'] != null
          ? map['pharmacyDocumentLicense'] as String
          : null,
      pharmacyImage:
          map['pharmacyImage'] != null ? map['pharmacyImage'] as String : null,
      selectedCategoryId: map['selectedCategoryId'] != null
          ? List<String>.from((map['selectedCategoryId'] as List<dynamic>))
          : null,
      pharmacyRequested: map['pharmacyRequested'] != null
          ? map['pharmacyRequested'] as int
          : null,
      isActive: map['isActive'] != null ? map['isActive'] as bool : null,
      isHomeDelivery:
          map['isHomeDelivery'] != null ? map['isHomeDelivery'] as bool : null,
      isPharmacyON:
          map['isPharmacyON'] != null ? map['isPharmacyON'] as bool : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      email: map['email'] != null ? map['email'] as String : null,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
      pharmacyKeywords: map['pharmacyKeywords'] != null
          ? List<String>.from((map['pharmacyKeywords'] as List<dynamic>))
          : null,
      rejectionReason: map['rejectionReason'] != null
          ? map['rejectionReason'] as String
          : null,
      dayTransaction: map['dayTransaction'] != null
          ? map['dayTransaction'] as String
          : null,
      accountHolderName: map['accountHolderName'] != null
          ? map['accountHolderName'] as String
          : null,
      bankName: map['bankName'] != null ? map['bankName'] as String : null,
      ifscCode: map['ifscCode'] != null ? map['ifscCode'] as String : null,
      accountNumber:
          map['accountNumber'] != null ? map['accountNumber'] as String : null,
    );
  }
}
