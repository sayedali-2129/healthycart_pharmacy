import 'package:cloud_firestore/cloud_firestore.dart';

class PharmacyProductAddModel {
  String? id;
  final String? pharmacyId;
  final String? categoryId;
  final String? typeOfProduct;
  final num? productMRPRate;
  final num? productDiscountRate;
  final List<String>? productImage;
  final String? productName;
  final String? productBrandName;
  final List<String>? quantitiesAvailable;

  final String? productInformation;
  final String? keyIngrdients;
  final String? usesProduct;
  final String? keyBenefits;
  final String? specification;
  final String? directionToUse;
  final String? safetyInformation;
  final bool? requirePrescription;
  final Timestamp? expiryDate;
  final Timestamp? createdAt;
  final List<String>? keywords;
  PharmacyProductAddModel({
    this.id,
    this.pharmacyId,
    this.categoryId,
    this.typeOfProduct,
    this.productMRPRate,
    this.productDiscountRate,
    this.productImage,
    this.productName,
    this.productBrandName,
    this.quantitiesAvailable,
  
    this.productInformation,
    this.keyIngrdients,
    this.usesProduct,
    this.keyBenefits,
    this.specification,
    this.directionToUse,
    this.safetyInformation,
    this.requirePrescription,
    this.expiryDate,
    this.createdAt,
    this.keywords,
  });

  PharmacyProductAddModel copyWith({
    String? id,
    String? pharmacyId,
    String? categoryId,
    String? typeOfProduct,
    num? productMRPRate,
    num? productDiscountRate,
    List<String>? productImage,
    String? productName,
    String? productBrandName,
    List<String>? quantitiesAvailable,
   
    String? productInformation,
    String? keyIngrdients,
    String? usesProduct,
    String? keyBenefits,
    String? specification,
    String? directionToUse,
    String? safetyInformation,
    bool? requirePrescription,
    Timestamp? expiryDate,
    Timestamp? createdAt,
    List<String>? keywords,
  }) {
    return PharmacyProductAddModel(
      id: id ?? this.id,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      categoryId: categoryId ?? this.categoryId,
      productMRPRate: productMRPRate ?? this.productMRPRate,
      productDiscountRate: productDiscountRate ?? this.productDiscountRate,
      productImage: productImage ?? this.productImage,
      productName: productName ?? this.productName,
      productBrandName: productBrandName ?? this.productBrandName,
      quantitiesAvailable: quantitiesAvailable ?? this.quantitiesAvailable,

      productInformation: productInformation ?? this.productInformation,
      keyIngrdients: keyIngrdients ?? this.keyIngrdients,
      usesProduct: usesProduct ?? this.usesProduct,
      keyBenefits: keyBenefits ?? this.keyBenefits,
      specification: specification ?? this.specification,
      directionToUse: directionToUse ?? this.directionToUse,
      safetyInformation: safetyInformation ?? this.safetyInformation,
      requirePrescription: requirePrescription ?? this.requirePrescription,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
      keywords: keywords ?? this.keywords,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'pharmacyId': pharmacyId,
      'categoryId': categoryId,
      'productMRPRate': productMRPRate,
      'productDiscountRate': productDiscountRate,
      'productImage': productImage,
      'productName': productName,
      'productBrandName': productBrandName,
      'quantitiesAvailable': quantitiesAvailable,
     
      'productInformation': productInformation,
      'keyIngrdients': keyIngrdients,
      'usesProduct': usesProduct,
      'keyBenefits': keyBenefits,
      'specification': specification,
      'directionToUse': directionToUse,
      'safetyInformation': safetyInformation,
      'requirePrescription': requirePrescription,
      'expiryDate': expiryDate,
      'createdAt': createdAt,
      'keywords': keywords,
    };
  }

  factory PharmacyProductAddModel.fromMap(Map<String, dynamic> map) {
    return PharmacyProductAddModel(
      id: map['id'] != null ? map['id'] as String : null,
      pharmacyId:
          map['pharmacyId'] != null ? map['pharmacyId'] as String : null,
      categoryId:
          map['categoryId'] != null ? map['categoryId'] as String : null,
      productMRPRate:
          map['productMRPRate'] != null ? map['productMRPRate'] as num : null,
      productDiscountRate: map['productDiscountRate'] != null
          ? map['productDiscountRate'] as num
          : null,
      productImage: map['productImage'] != null
          ? List<String>.from((map['productImage'] as List<dynamic>))
          : null,
      productName:
          map['productName'] != null ? map['productName'] as String : null,
      productBrandName: map['productBrandName'] != null
          ? map['productBrandName'] as String
          : null,
      quantitiesAvailable: map['quantitiesAvailable'] != null
          ? List<String>.from((map['quantitiesAvailable'] as List<dynamic>))
          : null,

      productInformation: map['productInformation'] != null
          ? map['productInformation'] as String
          : null,
      keyIngrdients:
          map['keyIngrdients'] != null ? map['keyIngrdients'] as String : null,
      usesProduct:
          map['usesProduct'] != null ? map['usesProduct'] as String : null,
      keyBenefits:
          map['keyBenefits'] != null ? map['keyBenefits'] as String : null,
      specification:
          map['specification'] != null ? map['specification'] as String : null,
      directionToUse: map['directionToUse'] != null
          ? map['directionToUse'] as String
          : null,
      safetyInformation: map['safetyInformation'] != null
          ? map['safetyInformation'] as String
          : null,
      requirePrescription: map['requirePrescription'] != null
          ? map['requirePrescription'] as bool
          : null,
      expiryDate:
          map['expiryDate'] != null ? map['expiryDate'] as Timestamp : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      keywords: map['keywords'] != null
          ? List<String>.from((map['keywords'] as List<dynamic>))
          : null,
    );
  }
}
