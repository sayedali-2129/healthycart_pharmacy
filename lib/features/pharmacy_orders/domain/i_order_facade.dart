import 'package:dartz/dartz.dart';
import 'package:healthycart_pharmacy/core/failures/main_failure.dart';
import 'package:healthycart_pharmacy/core/general/typdef.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/domain/model/pharmacy_order_model.dart';

abstract class IOrderFacade {
  Stream<Either<MainFailure, List<PharmacyOrderModel>>> pharmacyNewOrderData(
      {required String pharmacyId,});
  Future<void> cancelStream();
    FutureResult<PharmacyOrderModel> updateProductOrderDetails(
      {required String orderId,
      required PharmacyOrderModel orderProducts}); 
      

}
