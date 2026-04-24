import 'package:madhya/core/exporters/app_export.dart';

abstract class ProfileRepository {
  Future<dynamic> getLocationData();

  Future<dynamic> getPages();

  Future<dynamic> getPageDetails(UserRequest request);

  Future<dynamic> getProfile(UserRequest request);

  Future<dynamic> getView(UserRequest request);

  Future<dynamic> getShortList(UserRequest request);

  Future<dynamic> shortListProfile(InterestRequested request);

  Future<dynamic> getInterest(UserRequest request);

  Future<dynamic> sendInterest(InterestRequested request);

  Future<dynamic> updateInterest(InterestRequested request);

  Future<dynamic> deleteInterest(InterestRequested request);

  Future<dynamic> updateProfile(UpdateUserProfileRequest request);


  Future<dynamic> getBlockUserList(UserRequest request);

  Future<dynamic> getReportedUserList(UserRequest request);
}
