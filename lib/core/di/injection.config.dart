// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:madhya/core/exporters/app_export.dart' as _i571;
import 'package:madhya/core/network/api_service.dart' as _i466;
import 'package:madhya/core/network/register_module.dart' as _i571;
import 'package:madhya/data/repository_impl/auth_repository_impl.dart' as _i509;
import 'package:madhya/data/repository_impl/chat_repository_impl.dart' as _i497;
import 'package:madhya/data/repository_impl/home_repository_impl.dart' as _i815;
import 'package:madhya/data/repository_impl/matches_repository_impl.dart'
    as _i602;
import 'package:madhya/data/repository_impl/other_profile_repository_impl.dart'
    as _i847;
import 'package:madhya/data/repository_impl/partner_preference_repository_impl.dart'
    as _i375;
import 'package:madhya/data/repository_impl/profile_repository_impl.dart'
    as _i938;
import 'package:madhya/domain/usecase/block_user_usecase.dart' as _i419;
import 'package:madhya/domain/usecase/blocked_profile_usecase.dart' as _i377;
import 'package:madhya/domain/usecase/caste_by_rel_usecase.dart' as _i407;
import 'package:madhya/domain/usecase/chat_details_usecase.dart' as _i496;
import 'package:madhya/domain/usecase/chat_list_usecase.dart' as _i594;
import 'package:madhya/domain/usecase/checkout_usecase.dart' as _i331;
import 'package:madhya/domain/usecase/common_data_usecase.dart' as _i779;
import 'package:madhya/domain/usecase/create_chat_usecase.dart' as _i359;
import 'package:madhya/domain/usecase/delete_interest_usecase.dart' as _i703;
import 'package:madhya/domain/usecase/get_interest_usecase.dart' as _i144;
import 'package:madhya/domain/usecase/get_matches_usecase.dart' as _i332;
import 'package:madhya/domain/usecase/get_page_details_usecase.dart' as _i787;
import 'package:madhya/domain/usecase/get_page_usecase.dart' as _i562;
import 'package:madhya/domain/usecase/get_part_pref_usecase.dart' as _i590;
import 'package:madhya/domain/usecase/get_plan_details_usecase.dart' as _i753;
import 'package:madhya/domain/usecase/get_plan_usecase.dart' as _i158;
import 'package:madhya/domain/usecase/get_shortlist_usecase.dart' as _i681;
import 'package:madhya/domain/usecase/get_view_usecase.dart' as _i370;
import 'package:madhya/domain/usecase/global_search_usecase.dart' as _i483;
import 'package:madhya/domain/usecase/home_usecase.dart' as _i812;
import 'package:madhya/domain/usecase/location_data_usecase.dart' as _i412;
import 'package:madhya/domain/usecase/login_usecase.dart' as _i1012;
import 'package:madhya/domain/usecase/msg_delivered_usecase.dart' as _i332;
import 'package:madhya/domain/usecase/msg_read_usecase.dart' as _i329;
import 'package:madhya/domain/usecase/other_profile_usecase.dart' as _i737;
import 'package:madhya/domain/usecase/profile_usecase.dart' as _i285;
import 'package:madhya/domain/usecase/register_usecase.dart' as _i92;
import 'package:madhya/domain/usecase/report_profile_usecase.dart' as _i570;
import 'package:madhya/domain/usecase/reported_profile_usecase.dart' as _i240;
import 'package:madhya/domain/usecase/send_interest_usecase.dart' as _i851;
import 'package:madhya/domain/usecase/send_msg_usecase.dart' as _i799;
import 'package:madhya/domain/usecase/shortlist_profile_usecase.dart' as _i697;
import 'package:madhya/domain/usecase/subcaste_by_caste.dart' as _i240;
import 'package:madhya/domain/usecase/typing_usecase.dart' as _i182;
import 'package:madhya/domain/usecase/update_interest_usecase.dart' as _i585;
import 'package:madhya/domain/usecase/update_prefs_usecase.dart' as _i577;
import 'package:madhya/domain/usecase/update_profile_usecase.dart' as _i672;
import 'package:madhya/domain/usecase/verify_otp_usecase.dart' as _i791;
import 'package:madhya/domain/usecase/verify_payment_usecase.dart' as _i1021;
import 'package:madhya/presentation/auth/controller/onboarding_controller.dart'
    as _i20;
import 'package:madhya/presentation/navigation/controller/navigation_controller.dart'
    as _i272;
import 'package:madhya/presentation/splash/controller/splash_controller.dart'
    as _i572;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i571.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i20.AuthController>(() => _i20.AuthController());
    gh.lazySingleton<_i272.NavigationController>(
      () => _i272.NavigationController(),
    );
    gh.lazySingleton<_i572.SplashController>(() => _i572.SplashController());
    gh.factory<_i466.ApiService>(() => _i466.ApiService(gh<_i361.Dio>()));
    gh.lazySingleton<_i571.AuthRepository>(
      () => _i509.AuthRepositoryImpl(gh<_i571.ApiService>()),
    );
    gh.lazySingleton<_i571.HomeRepository>(
      () => _i815.HomeRepositoryImpl(gh<_i571.ApiService>()),
    );
    gh.lazySingleton<_i571.OtherUserRepository>(
      () => _i847.OtherProfileRepositoryImpl(gh<_i571.ApiService>()),
    );
    gh.lazySingleton<_i571.ProfileRepository>(
      () => _i938.ProfileRepositoryImpl(gh<_i571.ApiService>()),
    );
    gh.lazySingleton<_i571.MatchesRepository>(
      () => _i602.MatchesRepositoryImpl(gh<_i571.ApiService>()),
    );
    gh.lazySingleton<_i407.CasteByRelUsecase>(
      () => _i407.CasteByRelUsecase(gh<_i571.AuthRepository>()),
    );
    gh.lazySingleton<_i92.RegisterUsecase>(
      () => _i92.RegisterUsecase(gh<_i571.AuthRepository>()),
    );
    gh.lazySingleton<_i240.SubCasteByCasteUsecase>(
      () => _i240.SubCasteByCasteUsecase(gh<_i571.AuthRepository>()),
    );
    gh.lazySingleton<_i791.VerifyOtpUsecase>(
      () => _i791.VerifyOtpUsecase(gh<_i571.AuthRepository>()),
    );
    gh.lazySingleton<_i571.PartnerPreferenceRepository>(
      () => _i375.PartnerPreferenceRepositoryImpl(gh<_i571.ApiService>()),
    );
    gh.lazySingleton<_i419.BlockUserUsecase>(
      () => _i419.BlockUserUsecase(gh<_i571.OtherUserRepository>()),
    );
    gh.lazySingleton<_i570.ReportProfileUsecase>(
      () => _i570.ReportProfileUsecase(gh<_i571.OtherUserRepository>()),
    );
    gh.lazySingleton<_i812.HomeUsecase>(
      () => _i812.HomeUsecase(gh<_i571.HomeRepository>()),
    );
    gh.lazySingleton<_i577.UpdatePrefsUsecase>(
      () => _i577.UpdatePrefsUsecase(gh<_i571.PartnerPreferenceRepository>()),
    );
    gh.lazySingleton<_i571.ChatRepository>(
      () => _i497.ChatRepositoryImpl(gh<_i571.ApiService>()),
    );
    gh.lazySingleton<_i787.GetPageDetailsUsecase>(
      () => _i787.GetPageDetailsUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i562.GetPageUsecase>(
      () => _i562.GetPageUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i697.ShortlistProfileUsecase>(
      () => _i697.ShortlistProfileUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i590.GetPartPrefUsecase>(
      () => _i590.GetPartPrefUsecase(gh<_i571.PartnerPreferenceRepository>()),
    );
    gh.lazySingleton<_i1012.LoginUsecase>(
      () => _i1012.LoginUsecase(gh<_i571.AuthRepository>()),
    );
    gh.lazySingleton<_i737.OtherProfileUsecase>(
      () => _i737.OtherProfileUsecase(gh<_i571.OtherUserRepository>()),
    );
    gh.lazySingleton<_i377.BlockedProfileUsecase>(
      () => _i377.BlockedProfileUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i331.CheckoutUsecase>(
      () => _i331.CheckoutUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i753.GetPlanDetailsUsecase>(
      () => _i753.GetPlanDetailsUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i158.GetPlanUsecase>(
      () => _i158.GetPlanUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i240.ReportedProfileUsecase>(
      () => _i240.ReportedProfileUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i1021.VerifyPaymentUsecase>(
      () => _i1021.VerifyPaymentUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i483.GlobalSearchUsecase>(
      () => _i483.GlobalSearchUsecase(gh<_i571.HomeRepository>()),
    );
    gh.lazySingleton<_i779.CommonDataUsecase>(
      () => _i779.CommonDataUsecase(gh<_i571.AuthRepository>()),
    );
    gh.lazySingleton<_i703.DeleteInterestUsecase>(
      () => _i703.DeleteInterestUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i144.GetInterestUsecase>(
      () => _i144.GetInterestUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i681.GetShortlistUsecase>(
      () => _i681.GetShortlistUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i370.GetViewUsecase>(
      () => _i370.GetViewUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i412.LocationDataUsecase>(
      () => _i412.LocationDataUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i285.ProfileUsecase>(
      () => _i285.ProfileUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i851.SendInterestUsecase>(
      () => _i851.SendInterestUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i585.UpdateInterestUsecase>(
      () => _i585.UpdateInterestUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i672.UpdateProfileUsecase>(
      () => _i672.UpdateProfileUsecase(gh<_i571.ProfileRepository>()),
    );
    gh.lazySingleton<_i332.GetMatchesUsecase>(
      () => _i332.GetMatchesUsecase(gh<_i571.MatchesRepository>()),
    );
    gh.lazySingleton<_i496.ChatDetailsUsecase>(
      () => _i496.ChatDetailsUsecase(gh<_i571.ChatRepository>()),
    );
    gh.lazySingleton<_i594.ChatListUsecase>(
      () => _i594.ChatListUsecase(gh<_i571.ChatRepository>()),
    );
    gh.lazySingleton<_i359.CreateChatUsecase>(
      () => _i359.CreateChatUsecase(gh<_i571.ChatRepository>()),
    );
    gh.lazySingleton<_i332.MsgDeliveredUsecase>(
      () => _i332.MsgDeliveredUsecase(gh<_i571.ChatRepository>()),
    );
    gh.lazySingleton<_i329.MsgReadUsecase>(
      () => _i329.MsgReadUsecase(gh<_i571.ChatRepository>()),
    );
    gh.lazySingleton<_i799.SendMsgUsecase>(
      () => _i799.SendMsgUsecase(gh<_i571.ChatRepository>()),
    );
    gh.lazySingleton<_i182.TypingUsecase>(
      () => _i182.TypingUsecase(gh<_i571.ChatRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i571.RegisterModule {}
