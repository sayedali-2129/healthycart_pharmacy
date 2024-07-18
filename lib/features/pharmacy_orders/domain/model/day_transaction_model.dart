import 'package:cloud_firestore/cloud_firestore.dart';

class DayTransactionModel {
  Timestamp? createdAt;
  num? onlinePayment;
  num? offlinePayment;
  num? totalAmount;
  num? commission;
  DayTransactionModel(
      {this.createdAt,
      this.onlinePayment,
      this.offlinePayment,
      this.totalAmount,
      this.commission});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'createdAt': createdAt,
      'onlinePayment': onlinePayment,
      'offlinePayment': offlinePayment,
      'totalAmount': totalAmount,
      'commission': commission,
    };
  }

  factory DayTransactionModel.fromMap(Map<String, dynamic> map) {
    return DayTransactionModel(
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
      onlinePayment:
          map['onlinePayment'] != null ? map['onlinePayment'] as num : null,
      offlinePayment:
          map['offlinePayment'] != null ? map['offlinePayment'] as num : null,
      totalAmount:
          map['totalAmount'] != null ? map['totalAmount'] as num : null,
      commission: map['commission'] != null ? map['commission'] as num : null,
    );
  }

  DayTransactionModel copyWith({
    Timestamp? createdAt,
    num? onlinePayment,
    num? offlinePayment,
    num? totalAmount,
    num? commission,
  }) {
    return DayTransactionModel(
      createdAt: createdAt ?? this.createdAt,
      onlinePayment: onlinePayment ?? this.onlinePayment,
      offlinePayment: offlinePayment ?? this.offlinePayment,
      totalAmount: totalAmount ?? this.totalAmount,
      commission: commission ?? this.commission,
    );
  }
}