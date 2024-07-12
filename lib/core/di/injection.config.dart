// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i6;
import 'package:firebase_auth/firebase_auth.dart' as _i4;
import 'package:firebase_storage/firebase_storage.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../features/add_pharmacy_form_page/application/pharmacy_form_provider.dart'
    as _i31;
import '../../features/add_pharmacy_form_page/domain/i_form_facade.dart'
    as _i12;
import '../../features/add_pharmacy_form_page/infrastructure/i_form_impl.dart'
    as _i13;
import '../../features/authenthication/application/authenication_provider.dart'
    as _i34;
import '../../features/authenthication/domain/i_auth_facade.dart' as _i26;
import '../../features/authenthication/infrastrucure/i_auth_impl.dart' as _i27;
import '../../features/location_picker/application/location_provider.dart'
    as _i33;
import '../../features/location_picker/domain/i_location_facde.dart' as _i21;
import '../../features/location_picker/infrastructure/i_location_impl.dart'
    as _i22;
import '../../features/pending_page/application/pending_provider.dart' as _i20;
import '../../features/pending_page/domain/i_pending_facade.dart' as _i18;
import '../../features/pending_page/infrastrucuture/i_pending_impl.dart'
    as _i19;
import '../../features/pharmacy_banner/application/add_banner_provider.dart'
    as _i35;
import '../../features/pharmacy_banner/domain/i_banner_facade.dart' as _i29;
import '../../features/pharmacy_banner/infrastrucuture/i_banner_impl.dart'
    as _i30;
import '../../features/pharmacy_orders/application/provider/request_pharmacy_provider.dart'
    as _i28;
import '../../features/pharmacy_orders/domain/i_order_facade.dart' as _i16;
import '../../features/pharmacy_orders/infrastructure/i_order_impl.dart'
    as _i17;
import '../../features/pharmacy_products/application/pharmacy_provider.dart'
    as _i25;
import '../../features/pharmacy_products/domain/i_pharmacy_facade.dart' as _i23;
import '../../features/pharmacy_products/infrastructure/i_pharmacy_impl.dart'
    as _i24;
import '../../features/pharmacy_profile/application/profile_provider.dart'
    as _i32;
import '../../features/pharmacy_profile/domain/i_profile_facade.dart' as _i14;
import '../../features/pharmacy_profile/infrastructure/i_profile_impl.dart'
    as _i15;
import '../services/get_network_time.dart' as _i11;
import '../services/image_picker.dart' as _i7;
import '../services/location_service.dart' as _i8;
import '../services/pdf_picker.dart' as _i9;
import '../services/url_launcher.dart' as _i10;
import 'firebase_injectable_module.dart' as _i3;
import 'general_injectable_module.dart' as _i36;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i1.GetIt> init(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final firebaseInjecatbleModule = _$FirebaseInjecatbleModule();
  final generalInjecatbleModule = _$GeneralInjecatbleModule();
  await gh.factoryAsync<_i3.FirebaseService>(
    () => firebaseInjecatbleModule.firebaseService,
    preResolve: true,
  );
  gh.lazySingleton<_i4.FirebaseAuth>(() => firebaseInjecatbleModule.auth);
  gh.lazySingleton<_i5.FirebaseStorage>(() => firebaseInjecatbleModule.storage);
  gh.lazySingleton<_i6.FirebaseFirestore>(() => firebaseInjecatbleModule.repo);
  gh.lazySingleton<_i7.ImageService>(
      () => generalInjecatbleModule.imageServices);
  gh.lazySingleton<_i8.LocationService>(
      () => generalInjecatbleModule.locationServices);
  gh.lazySingleton<_i9.PdfPickerService>(
      () => generalInjecatbleModule.pdfPickerService);
  gh.lazySingleton<_i10.UrlService>(() => generalInjecatbleModule.urlService);
  gh.lazySingleton<_i11.NetworkTimeService>(
      () => generalInjecatbleModule.networkTimeService);
  gh.lazySingleton<_i12.IFormFeildFacade>(() => _i13.IFormFieldImpl(
        gh<_i6.FirebaseFirestore>(),
        gh<_i7.ImageService>(),
        gh<_i9.PdfPickerService>(),
      ));
  gh.lazySingleton<_i14.IProfileFacade>(
      () => _i15.IProfileImpl(gh<_i6.FirebaseFirestore>()));
  gh.lazySingleton<_i16.IOrderFacade>(() => _i17.IOrderImpl(
        gh<_i6.FirebaseFirestore>(),
        gh<_i11.NetworkTimeService>(),
      ));
  gh.lazySingleton<_i18.IPendingFacade>(
      () => _i19.IPendingImpl(gh<_i10.UrlService>()));
  gh.factory<_i20.PendingProvider>(
      () => _i20.PendingProvider(gh<_i18.IPendingFacade>()));
  gh.lazySingleton<_i21.ILocationFacade>(() => _i22.ILocationImpl(
        gh<_i8.LocationService>(),
        gh<_i6.FirebaseFirestore>(),
      ));
  gh.lazySingleton<_i23.IPharmacyFacade>(() => _i24.IPharmacyImpl(
        gh<_i6.FirebaseFirestore>(),
        gh<_i7.ImageService>(),
      ));
  gh.factory<_i25.PharmacyProvider>(
      () => _i25.PharmacyProvider(gh<_i23.IPharmacyFacade>()));
  gh.lazySingleton<_i26.IAuthFacade>(() => _i27.IAuthImpl(
        gh<_i4.FirebaseAuth>(),
        gh<_i6.FirebaseFirestore>(),
      ));
  gh.factory<_i28.RequestPharmacyProvider>(
      () => _i28.RequestPharmacyProvider(gh<_i16.IOrderFacade>()));
  gh.lazySingleton<_i29.IBannerFacade>(() => _i30.IBannerImpl(
        gh<_i6.FirebaseFirestore>(),
        gh<_i7.ImageService>(),
      ));
  gh.factory<_i31.PharmacyFormProvider>(
      () => _i31.PharmacyFormProvider(gh<_i12.IFormFeildFacade>()));
  gh.factory<_i32.ProfileProvider>(
      () => _i32.ProfileProvider(gh<_i14.IProfileFacade>()));
  gh.factory<_i33.LocationProvider>(
      () => _i33.LocationProvider(gh<_i21.ILocationFacade>()));
  gh.factory<_i34.AuthenticationProvider>(
      () => _i34.AuthenticationProvider(gh<_i26.IAuthFacade>()));
  gh.factory<_i35.AddBannerProvider>(
      () => _i35.AddBannerProvider(gh<_i29.IBannerFacade>()));
  return getIt;
}

class _$FirebaseInjecatbleModule extends _i3.FirebaseInjecatbleModule {}

class _$GeneralInjecatbleModule extends _i36.GeneralInjecatbleModule {}
