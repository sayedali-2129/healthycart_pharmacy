import 'package:healthycart_pharmacy/core/general/typdef.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_product_model.dart';

abstract class IProfileFacade {
  FutureResult<String> setActivePharmacy({
    required bool isPharmacyON,
    required String pharmacyId,
  });
  FutureResult<List<PharmacyProductAddModel>> getPharmacyAllProductDetails({
    required String pharmacyId,
    required String? searchText,
  });
   void clearFetchData();
}
