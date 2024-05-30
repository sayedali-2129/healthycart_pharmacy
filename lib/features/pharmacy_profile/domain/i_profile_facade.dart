import 'package:healthycart_pharmacy/core/general/typdef.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_product_model.dart';

abstract class IProfileFacade {
  FutureResult<List<PharmacyProductAddModel>> getAllPharmacyProductDetails();

  FutureResult<String> setActiveHospital(
      {required bool ishospitalON, required String hospitalId,});
}
