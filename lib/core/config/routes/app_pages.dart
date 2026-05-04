import 'package:madhya/presentation/auth/binding/login_bindings.dart';
import 'package:madhya/presentation/auth/binding/otp_binding.dart';
import 'package:madhya/presentation/auth/binding/register_bindings.dart';
import 'package:madhya/presentation/global_search/bindings/global_search_bindings.dart';
import 'package:madhya/presentation/global_search/view/global_search.dart';
import 'package:madhya/presentation/global_search/widget/search_result.dart';
import 'package:madhya/presentation/home/bindings/home_bindings.dart';
import 'package:madhya/presentation/mailbox/bindings/chat_binding.dart';
import 'package:madhya/presentation/matches/bindings/match_binding.dart';
import 'package:madhya/presentation/others_profile/binding/other_profile_binding.dart';
import 'package:madhya/presentation/profile/binding/partner_prefs_bindings.dart';
import 'package:madhya/presentation/profile/binding/profile_bindings.dart';
import 'package:madhya/presentation/profile/widget/block_list.dart';
import 'package:madhya/presentation/profile/widget/buy_package.dart';
import 'package:madhya/presentation/profile/widget/edit_profile_content/about_me_edit.dart';
import 'package:madhya/presentation/profile/widget/edit_profile_content/basic_details_edit.dart';
import 'package:madhya/presentation/profile/widget/edit_profile_content/family_details_edit.dart';
import 'package:madhya/presentation/profile/widget/edit_profile_content/horoscope_details_edit.dart';
import 'package:madhya/presentation/profile/widget/edit_profile_content/location_details_edit.dart';
import 'package:madhya/presentation/profile/widget/edit_profile_content/professional_details_edit.dart';
import 'package:madhya/presentation/profile/widget/edit_profile_content/religion_details_edit.dart';
import 'package:madhya/presentation/profile/widget/help_and_support.dart';
import 'package:madhya/presentation/profile/widget/manage_photos.dart';
import 'package:madhya/presentation/profile/widget/package.dart';
import 'package:madhya/presentation/profile/widget/partner_preference/partner_basic_edit.dart';
import 'package:madhya/presentation/profile/widget/partner_preference.dart';
import 'package:madhya/presentation/profile/widget/partner_preference/partner_professional_details_edit.dart';
import 'package:madhya/presentation/profile/widget/partner_preference/partner_religion_details_edit.dart';
import 'package:madhya/presentation/profile/widget/delete_screen.dart';
import 'package:madhya/presentation/profile/widget/reported_list.dart';
import '../../../presentation/profile/widget/partner_preference/partner_location_details_edit.dart';
import '../../exporters/app_export.dart';

class AppPages {
  static final routes = [
    GetPage(name: Routes.splash, page: () => SplashPage()),
    GetPage(name: Routes.onboarding, page: () => OnboardingScreen()),
    GetPage(
      name: Routes.login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.verifyOTP,
      page: () => VerifyOTPScreen(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: Routes.registerScreen,
      page: () => RegisterScreen(),
      binding: RegisterBindings(),
    ),
    GetPage(name: Routes.addProfile, page: () => ProfileAdd()),
    GetPage(
      name: Routes.mainScreen,
      page: () => NavigationScreen(),
      bindings: [
        HomeBindings(),
        ProfileBindings(),
        ChatBinding(),
        MatchBinding(),
        GlobalSearchBindings(),
      ],
    ),
    GetPage(
      name: Routes.profileScreen,
      page: () => ProfileScreen(),
      bindings: [ProfileBindings()],
    ),
    GetPage(
      name: Routes.searchScreen,
      page: () => GlobalSearch(),
      binding: GlobalSearchBindings(),
    ),
    GetPage(
      name: Routes.othersProfile,
      page: () => OtherProfile(),
      bindings: [OtherProfileBinding(), ProfileBindings()],
    ),
    GetPage(name: Routes.chatDetails, page: () => ChatDetails()),
    GetPage(name: Routes.chatProfileDetails, page: () => ChatUserProfile()),
    GetPage(
      name: Routes.shortList,
      page: () => Shortlist(),
      binding: ProfileBindings(),
    ),
    GetPage(
      name: Routes.viewed,
      page: () => Viewed(),
      bindings: [ProfileBindings()],
    ),
    GetPage(
      name: Routes.interest,
      page: () => Interest(),
      binding: ProfileBindings(),
    ),
    GetPage(
      name: Routes.editProfile,
      page: () => EditProfile(),
      binding: ProfileBindings(),
    ),
    GetPage(name: Routes.managePhotos, page: () => ManagePhotos()),
    GetPage(name: Routes.basicDetailsEdit, page: () => BasicDetailsEdit()),
    GetPage(name: Routes.aboutMeEdit, page: () => AboutMeEdit()),
    GetPage(name: Routes.deleteScreen, page: () => DeleteScreen()),
    GetPage(name: Routes.paymentScreen, page: () => PaymentMethod()),
    GetPage(
      name: Routes.packageScreen,
      page: () => Package(),
      binding: ProfileBindings(),
    ),

    GetPage(
      name: Routes.professionalDetailsEdit,
      page: () => ProfessionalDetailsEdit(),
    ),
    GetPage(
      name: Routes.religionDetailsEdit,
      page: () => ReligionDetailsEdit(),
    ),
    GetPage(
      name: Routes.locationDetailsEdit,
      page: () => LocationDetailsEdit(),
    ),
    GetPage(name: Routes.familyDetailsEdit, page: () => FamilyDetailsEdit()),
    GetPage(name: Routes.helpAndSupport, page: () => HelpAndSupport()),
    GetPage(
      name: Routes.blockedUserList,
      page: () => BlockUserList(),
      bindings: [
        ProfileBindings(),
        OtherProfileBinding(), // ✅ ADD THIS
      ],
    ),
    GetPage(name: Routes.reportedUserList, page: () => ReportedList(),binding: ProfileBindings(),),
    GetPage(
      name: Routes.searchResult,
      page: () => SearchResult(),
      binding: GlobalSearchBindings(),
    ),
    GetPage(
      name: Routes.horoscopeDetailsEdit,
      page: () => HoroscopeDetailsEdit(),
    ),
    GetPage(
      name: Routes.partnerPreference,
      page: () => PartnerPreference(),
      binding: PartnerPrefsBindings(),
    ),
    GetPage(
      name: Routes.partnerBasicDetailsEdit,
      page: () => PartnerBasicDetailsEdit(),
    ),
    GetPage(
      name: Routes.partnerProfessionalDetailsEdit,
      page: () => PartnerProfessionalDetailsEdit(),
    ),
    GetPage(
      name: Routes.partnerReligionDetailsEdit,
      page: () => PartnerReligionDetailsEdit(),
    ),
    GetPage(
      name: Routes.partnerLocationDetailsEdit,
      page: () => PartnerLocationDetailsEdit(),
    ),
  ];
}
