import 'package:madhya/core/exporters/app_export.dart';

@lazySingleton
class MatchController extends GetxController with PaginationMixin {
  final GetMatchesUsecase _getMatchesUsecase;
  MatchController(this._getMatchesUsecase);

  final topMatchList = [
    {
      'image':
          'https://s3.ap-south-1.amazonaws.com/awsimages.imagesbazaar.com/1200x1800-old/19805/SM964729.jpg?date=Mon%20Mar%2023%202026%2017:48:41%20GMT+0530%20(India%20Standard%20Time)',
      'name': 'Sneha Patil',
      'id': 'MDYST0123M',
      'age': "27 Yrs, 5'0 (152cm), Doctor",
      'address': 'Pune, Maharashtra',
      'isVerified': false,
      'isPremium': true,
    },
    {
      'image':
          'https://s3.ap-south-1.amazonaws.com/awsimages.imagesbazaar.com/1200x1800-old/18763/SM859820.jpg?date=Mon%20Mar%2023%202026%2017:46:49%20GMT+0530%20(India%20Standard%20Time)',
      'name': 'Kavya Joshi',
      'id': 'MDYST0123M',
      'age': "28 yrs , 5'2 (157cm) Software Developer",
      'address': 'Mumbai, Maharashtra',
      'isVerified': true,
      'isPremium': true,
    },
    {
      'image':
          'https://s3.ap-south-1.amazonaws.com/awsimages.imagesbazaar.com/1200x1800-old/18763/SM859820.jpg?date=Mon%20Mar%2023%202026%2017:46:49%20GMT+0530%20(India%20Standard%20Time)',
      'name': 'Rutuja Jadhav',
      'id': 'MDYST0120M',
      'age': "25 yrs , 5'2 (157cm)Architect",
      'address': 'Sangli, Maharashtra',
      'isVerified': true,
      'isPremium': false,
    },
  ].obs;
  final selectedCategory = '0'.obs;
  final category = [
    {'name': 'All Matches', 'icon': HugeIcons.strokeRoundedUserMultiple02},
    {'name': 'Top Matches', 'icon': HugeIcons.strokeRoundedDashboardSpeed01},
    {'name': 'New Profiles', 'icon': HugeIcons.strokeRoundedUserLove02},
    {'name': 'Premium Profiles', 'icon': HugeIcons.strokeRoundedCrown},
    {'name': 'Nearby Matches', 'icon': HugeIcons.strokeRoundedLocation04},
  ].obs;

  Future<void> getMatchList({
    bool isRefresh = false,
    bool showLoading = true,
  }) async {
    if (isRefresh) resetPagination();

    startLoading(showLoading: showLoading);

    final userid = await SecureStorageService.read('user_id') ?? '';

    try {
      final response = await _getMatchesUsecase.call(
        UserRequest(
          userid,
          type: selectedCategory.value.toString(),
          pageNo: currentPage.toString(),
        ),
      );
      if (response['common']['status'] == true) {
        final List list = response['data']['matches'] ?? [];

        handleSuccess(list);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      stopLoading();
    }
  }
}
