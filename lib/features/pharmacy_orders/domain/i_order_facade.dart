import 'package:dartz/dartz.dart';
import 'package:healthycart_pharmacy/core/failures/main_failure.dart';
import 'package:healthycart_pharmacy/core/general/typdef.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/domain/model/pharmacy_order_model.dart';

abstract class IOrderFacade {
  Stream<Either<MainFailure, List<PharmacyOrderModel>>> pharmacyNewOrderData({
    required String pharmacyId,
  });
  Stream<Either<MainFailure, List<PharmacyOrderModel>>> pharmacyOnProcessData({
    required String pharmacyId,
  });
  Future<void> cancelStream();
  FutureResult<PharmacyOrderModel> updateProductOrderPendingDetails(
      {required String orderId, required PharmacyOrderModel orderProducts,});
  FutureResult<PharmacyOrderModel> updateProductOrderOnProcessDetails(
      {required String orderId, required PharmacyOrderModel orderProducts,required String pharmacyId,});
  FutureResult<List<PharmacyOrderModel>> getCompletedOrderDetails({
    required String pharmacyId, required int limit,
  });
  FutureResult<List<PharmacyOrderModel>> getCancelledOrderDetails({
    required String pharmacyId,
  });
  void clearFetchData();
}
