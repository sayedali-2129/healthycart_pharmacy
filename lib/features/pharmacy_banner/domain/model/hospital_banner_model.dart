

import 'package:cloud_firestore/cloud_firestore.dart';

class HospitalBannerModel {
  String? id;
  final String? image;
  final Timestamp? isCreated;
  final String hospitalId;
  HospitalBannerModel({
    this.id,
    this.image,
    this.isCreated,
    required this.hospitalId,
  });



  HospitalBannerModel copyWith({
    String? id,
    String? image,
    Timestamp? isCreated,
    String? hospitalId,
  }) {
    return HospitalBannerModel(
      id: id ?? this.id,
      image: image ?? this.image,
      isCreated: isCreated ?? this.isCreated,
      hospitalId: hospitalId ?? this.hospitalId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'isCreated': isCreated,
      'hospitalId': hospitalId,
    };
  }

  factory HospitalBannerModel.fromMap(Map<String, dynamic> map) {
    return HospitalBannerModel(
      id: map['id'] != null ? map['id'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      isCreated: map['isCreated'] != null ? map['isCreated'] as Timestamp : null,
      hospitalId: map['hospitalId'] as String,
    );
  }


}
