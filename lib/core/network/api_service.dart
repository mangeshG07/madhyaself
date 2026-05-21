import 'package:retrofit/retrofit.dart';

import '../exporters/app_export.dart';

part 'api_service.g.dart';

@RestApi()
@injectable
abstract class ApiService {
  @factoryMethod
  factory ApiService(Dio dio) = _ApiService;

  @POST(ApiConstants.login)
  Future<dynamic> loginUser(@Part(name: "mobile_no") String mobileNumber);

  @POST(ApiConstants.verifyOTP)
  Future<dynamic> verifyOTP(
    @Part(name: "mobile_no") String mobileNumber,
    @Part(name: "otp") String otp,
  );

  @POST(ApiConstants.getCommonData)
  // @DioResponseType(ResponseType.plain)
  Future<dynamic> getCommonData();

  @POST(ApiConstants.getLocationData)
  // @DioResponseType(ResponseType.plain)
  Future<dynamic> getLocationData();

  @POST(ApiConstants.register)
  @MultiPart()
  Future<dynamic> registerUser(
    @Part(name: "name") String name,
    @Part(name: "mobile_no") String mobileNumber,
    @Part(name: "wp_no") String whatsappNumber,
    @Part(name: "gender") String gender,
    @Part(name: "birth_date") String birthDate,
    @Part(name: "age") String age,
    @Part(name: "religion") String religion,
    @Part(name: "caste") String caste,
    @Part(name: "sub_caste") String subCaste, {
    @Part(name: 'profile_picture') File? profilePicture,
    @Part(name: 'photos[]') List<MultipartFile>? attachment,
  });

  @POST(ApiConstants.getCasteByReligion)
  Future<dynamic> getCasteByReligion(
    @Part(name: "religion_id") String religionId,
  );

  @POST(ApiConstants.getSubCasteByCaste)
  Future<dynamic> getSubCasteByCaste(@Part(name: "caste_id") String casteId);

  @POST(ApiConstants.home)
  Future<dynamic> getHome(@Part(name: "user_id") String userId);

  @POST(ApiConstants.userProfile)
  Future<dynamic> getProfile(@Part(name: "user_id") String userId);

  @POST(ApiConstants.updateUserProfile)
  @MultiPart()
  Future<dynamic> updateUserProfile(@Body() FormData formData);

  @POST(ApiConstants.updatePartnerPreference)
  @MultiPart()
  Future<dynamic> updatePartnerPreference(@Body() dynamic formData);

  @POST(ApiConstants.getOtherProfile)
  Future<dynamic> getOtherProfile(
    @Part(name: "user_id") String userId,
    @Part(name: "profile_id") String otherProfileId,
  );

  @POST(ApiConstants.getChatList)
  Future<dynamic> getChatList(
    @Part(name: "user_id") String userId,
    @Part(name: "search") String search,
    @Part(name: "page_no") String pageNo,
  );

  @POST(ApiConstants.createChat)
  Future<dynamic> createChat(
    @Part(name: "participant_one_id") String partOneId,
    @Part(name: "participant_two_id") String partTwoId,
    @Part(name: "user_id") String userId,
  );

  @POST(ApiConstants.getChatDetails)
  Future<dynamic> getChatDetails(
    @Part(name: "user_id") String userId,
    @Part(name: "conversation_id") String conversationId,
    @Part(name: "last_message_id") String? lastMsgId,
  );

  @POST(ApiConstants.sendMsg)
  @MultiPart()
  Future<dynamic> sendMsg(
    @Part(name: "user_id") String userId,
    @Part(name: "conversation_id") String conversationId,
    @Part(name: "sender_id") String senderId,
    @Part(name: "message") String message, {
    @Part(name: 'file[]') List<MultipartFile>? attachment,
  });

  @POST(ApiConstants.msgDelivered)
  Future<dynamic> msgDelivered(
    @Part(name: "user_id") String userId,
    @Part(name: "conversation_id") String conversationId,
  );

  @POST(ApiConstants.msgRead)
  Future<dynamic> msgRead(
    @Part(name: "user_id") String userId,
    @Part(name: "conversation_id") String conversationId,
  );

  @POST(ApiConstants.typing)
  Future<dynamic> typing(
    @Part(name: "user_id") String userId,
    @Part(name: "conversation_id") String conversationId,
    @Part(name: "receiver_id") String receiverId,
  );

  @POST(ApiConstants.getView)
  Future<dynamic> getView(
    @Part(name: "user_id") String userId,
    @Part(name: "type") String type,
    @Part(name: "page_no") String pageNo,
  );

  @POST(ApiConstants.getShortlist)
  Future<dynamic> getShortlist(
    @Part(name: "user_id") String userId,
    @Part(name: "type") String type,
    @Part(name: "page_no") String pageNo,
  );

  @POST(ApiConstants.shortlistProfile)
  Future<dynamic> shortlistProfile(
    @Part(name: "user_id") String userId,
    @Part(name: "shortlisted_user_id") String otherUserId,
  );

  @POST(ApiConstants.getInterest)
  Future<dynamic> getInterest(
    @Part(name: "user_id") String userId,
    @Part(name: "type") String type,
    @Part(name: "page_no") String pageNo,
  );

  @POST(ApiConstants.sendInterest)
  Future<dynamic> sendInterest(
    @Part(name: "user_id") String userId,
    @Part(name: "receiver_id") String receiverId,
    @Part(name: "message") String msg,
  );

  @POST(ApiConstants.updateInterest)
  Future<dynamic> updateInterest(
    @Part(name: "user_id") String userId,
    @Part(name: "interest_id") String interestId,
    @Part(name: "status") String status,
  );

  @POST(ApiConstants.deleteInterest)
  Future<dynamic> deleteInterest(
    @Part(name: "user_id") String userId,
    @Part(name: "interest_id") String interestId,
  );

  @POST(ApiConstants.getPartnerPreference)
  Future<dynamic> getPartnerPreference(@Part(name: "user_id") String userId);

  @POST(ApiConstants.getMatches)
  Future<dynamic> getMatches(
    @Part(name: "user_id") String userId,
    @Part(name: "type") String type,
    @Part(name: "page_no") String pageNo,
    @Part(name: "view") String view,
  );

  @POST(ApiConstants.getPages)
  // @DioResponseType(ResponseType.plain)
  Future<dynamic> getPages();

  @POST(ApiConstants.getPageDetails)
  Future<dynamic> getPageDetails(@Part(name: "slug") String slug);

  @POST(ApiConstants.blockUser)
  Future<dynamic> blockUser(
    @Part(name: "user_id") String userId,
    @Part(name: "blocked_user_id") String blockUserId,
  );

  @POST(ApiConstants.blockUserList)
  Future<dynamic> blockProfileList(
    @Part(name: "user_id") String userId,
    @Part(name: "page_no") String pageNo,
  );

  @POST(ApiConstants.reportProfile)
  Future<dynamic> reportProfile(
    @Part(name: "user_id") String userId,
    @Part(name: "report_profile_id") String reportProfileId,
    @Part(name: "reason") String reason,
  );

  @POST(ApiConstants.reportProfileList)
  Future<dynamic> reportProfileList(
    @Part(name: "user_id") String userId,
    @Part(name: "page_no") String pageNo,
  );

  @POST(ApiConstants.globalSearch)
  Future<dynamic> globalSearch(@Body() dynamic formData);

  @POST(ApiConstants.getPlans)
  Future<dynamic> getPlans(@Part(name: "user_id") String userId);

  @POST(ApiConstants.getPlanDetails)
  Future<dynamic> getPlanDetails(
    @Part(name: "user_id") String userId,
    @Part(name: "plan_id") String planId,
  );

  @POST(ApiConstants.checkout)
  Future<dynamic> checkout(
    @Part(name: "user_id") String userId,
    @Part(name: "plan_id") String planId,
    @Part(name: "price") String price,
    @Part(name: "payment_method") String payMethod,
    @Part(name: "type") String type,
  );

  @POST(ApiConstants.verifyPayment)
  Future<dynamic> verifyPayment(
    @Part(name: "user_id") String userId,
    @Part(name: "razorpay_payment_id") String razorpayPaymentId,
    @Part(name: "razorpayOrderId") String razorpayOrderId,
    @Part(name: "payment_id") String paymentId,
    @Part(name: "razorpay_signature") String razorpaySignature,
    @Part(name: "status") String status,
  );

  @POST(ApiConstants.whatsappConnect)
  Future<dynamic> whatsappConnect(@Part(name: "user_id") String userId);

  @POST(ApiConstants.viewContact)
  Future<dynamic> viewContact(
    @Part(name: "user_id") String userId,
    @Part(name: "profile_id") String profileId,
  );

  @POST(ApiConstants.deleteAccount)
  Future<dynamic> deleteAccount(
    @Part(name: "user_id") String userId,
    @Part(name: "reason") String reason,
  );

  @POST(ApiConstants.updateFirebaseToken)
  Future<dynamic> updateFirebaseToken(
    @Part(name: "user_id") String userId,
    @Part(name: "firebase_token") String token,
  );

  @POST(ApiConstants.getNotification)
  Future<dynamic> getNotification(
    @Part(name: "user_id") String userId,
    @Part(name: "page_no") String pageNo,
  );

  @POST(ApiConstants.readNotification)
  Future<dynamic> readNotification(
    @Part(name: "user_id") String userId,
    @Part(name: "notification_id") String notificationId,
  );

  @POST(ApiConstants.getMultiCasteByReligion)
  Future<dynamic> getMultiCasteByReligion(@Body() dynamic formData);

  @POST(ApiConstants.getMultiSubCasteByCaste)
  Future<dynamic> getMultiSubCasteByCaste(@Body() dynamic formData);
}
