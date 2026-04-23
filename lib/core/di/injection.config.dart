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
import 'package:madhya/domain/usecase/get_page_details_usecase.dart' as _i787;
import 'package:madhya/domain/usecase/get_page_usecase.dart' as _i562;
import 'package:madhya/presentation/auth/controller/login_controller.dart'
    as _i539;
import 'package:madhya/presentation/auth/controller/onboarding_controller.dart'
    as _i20;
import 'package:madhya/presentation/auth/controller/otp_controller.dart'
    as _i593;
import 'package:madhya/presentation/auth/controller/register_controller.dart'
    as _i335;
import 'package:madhya/presentation/global_search/controller/global_search_controller.dart'
    as _i337;
import 'package:madhya/presentation/home/controller/home_controller.dart'
    as _i109;
import 'package:madhya/presentation/mailbox/controller/chat_controller.dart'
    as _i212;
import 'package:madhya/presentation/matches/controller/match_controller.dart'
    as _i742;
import 'package:madhya/presentation/navigation/controller/navigation_controller.dart'
    as _i272;
import 'package:madhya/presentation/others_profile/controller/other_profile_controller.dart'
    as _i1019;
import 'package:madhya/presentation/profile/controller/interest_controller.dart'
    as _i598;
import 'package:madhya/presentation/profile/controller/preference_controller.dart'
    as _i843;
import 'package:madhya/presentation/profile/controller/profile_controller.dart'
    as _i951;
import 'package:madhya/presentation/profile/controller/shortlist_controller.dart'
    as _i148;
import 'package:madhya/presentation/profile/controller/viewed_controller.dart'
    as _i977;
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
    gh.lazySingleton<_i109.HomeController>(
      () => _i109.HomeController(gh<_i571.HomeUsecase>()),
    );
    gh.lazySingleton<_i598.InterestController>(
      () => _i598.InterestController(
        gh<_i571.GetInterestUsecase>(),
        gh<_i571.UpdateInterestUsecase>(),
        gh<_i571.DeleteInterestUsecase>(),
        gh<_i571.SendInterestUsecase>(),
      ),
    );
    gh.lazySingleton<_i337.GlobalSearchController>(
      () => _i337.GlobalSearchController(
        gh<_i571.CommonDataUsecase>(),
        gh<_i571.LocationDataUsecase>(),
      ),
    );
    gh.lazySingleton<_i539.LoginController>(
      () => _i539.LoginController(gh<_i571.LoginUsecase>()),
    );
    gh.lazySingleton<_i742.MatchController>(
      () => _i742.MatchController(gh<_i571.GetMatchesUsecase>()),
    );
    gh.factory<_i466.ApiService>(() => _i466.ApiService(gh<_i361.Dio>()));
    gh.lazySingleton<_i593.OtpController>(
      () => _i593.OtpController(gh<_i571.VerifyOtpUsecase>()),
    );
    gh.lazySingleton<_i148.ShortlistController>(
      () => _i148.ShortlistController(
        gh<_i571.GetShortlistUsecase>(),
        gh<_i571.ShortlistProfileUsecase>(),
      ),
    );
    gh.lazySingleton<_i212.ChatController>(
      () => _i212.ChatController(
        gh<_i571.ChatListUsecase>(),
        gh<_i571.ChatDetailsUsecase>(),
        gh<_i571.SendMsgUsecase>(),
        gh<_i571.MsgDeliveredUsecase>(),
        gh<_i571.MsgReadUsecase>(),
        gh<_i571.CreateChatUsecase>(),
        gh<_i571.TypingUsecase>(),
      ),
    );
    gh.lazySingleton<_i977.ViewedController>(
      () => _i977.ViewedController(gh<_i571.GetViewUsecase>()),
    );
    gh.lazySingleton<_i335.RegisterController>(
      () => _i335.RegisterController(
        gh<_i571.CommonDataUsecase>(),
        gh<_i571.RegisterUsecase>(),
        gh<_i571.CasteByRelUsecase>(),
        gh<_i571.SubCasteByCasteUsecase>(),
      ),
    );
    gh.lazySingleton<_i843.PreferenceController>(
      () => _i843.PreferenceController(
        gh<_i571.GetPartPrefUsecase>(),
        gh<_i571.CommonDataUsecase>(),
        gh<_i571.LocationDataUsecase>(),
        gh<_i571.UpdatePrefsUsecase>(),
      ),
    );
    gh.lazySingleton<_i951.ProfileController>(
      () => _i951.ProfileController(
        gh<_i571.ProfileUsecase>(),
        gh<_i571.CommonDataUsecase>(),
        gh<_i571.UpdateProfileUsecase>(),
        gh<_i571.LocationDataUsecase>(),
        gh<_i787.GetPageDetailsUsecase>(),
        gh<_i562.GetPageUsecase>(),
      ),
    );
    gh.lazySingleton<_i1019.OtherProfileController>(
      () => _i1019.OtherProfileController(
        gh<_i571.OtherProfileUsecase>(),
        gh<_i571.BlockUserUsecase>(),
        gh<_i571.ReportProfileUsecase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i571.RegisterModule {}
