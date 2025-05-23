import 'package:stepowner/retrofit/models/owner_setting_model.dart';
import 'package:stepowner/retrofit/models/setting_model.dart';
import 'package:stepowner/retrofit/models/delete_image_model.dart';
import 'package:stepowner/retrofit/models/get_all_space_model.dart';
import 'package:stepowner/retrofit/models/get_available_guard.dart';
import 'package:stepowner/retrofit/models/get_buy_plan_model.dart';
import 'package:stepowner/retrofit/models/get_image_space.dart';
import 'package:stepowner/retrofit/models/get_stripe_key_model.dart';
import 'package:stepowner/retrofit/models/guard_forgot_password_model.dart';
import 'package:stepowner/retrofit/models/order_scanner_model.dart';
import 'package:stepowner/retrofit/models/owner_card_delete_model.dart';
import 'package:stepowner/retrofit/models/parking_space_added_model.dart';
import 'package:stepowner/retrofit/models/facility_model.dart';
import 'package:stepowner/retrofit/models/profile_setting_update_model.dart';
import 'package:stepowner/retrofit/models/review_model.dart';
import 'package:stepowner/retrofit/models/get_all_guard.dart';
import 'package:stepowner/retrofit/models/get_owner_profile.dart';
import 'package:stepowner/retrofit/models/post_guard_add.dart';
import 'package:stepowner/retrofit/models/profile_password_update.dart';
import 'package:stepowner/retrofit/models/profile_picture_update.dart';
import 'package:stepowner/retrofit/models/profile_update.dart';
import 'package:retrofit/http.dart';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'apis.dart';
import 'models/get_subscription_model.dart';
import 'models/subscription_history_model.dart';
import 'models/common_model.dart';
import 'models/space_id_live_model.dart';
import 'models/image_upload_model.dart';
import 'models/login_model.dart';
import 'models/register_model.dart';
import 'models/space_id_model.dart';
import 'models/transaction_model.dart';
part 'client_api.g.dart';

@RestApi(baseUrl: "Enter_Your_Base_Url/api/owner/")
abstract class ClientApi {
  factory ClientApi(Dio dio, {String baseUrl}) = _ClientApi;

  @POST(Apis.login)
  Future<LoginModel> postLogin(@Body() Map<String, String> body);

  @POST(Apis.forgotPasswordGuard)
  Future<OwnerForgotPasswordModel> forgotPasswordCall(
      @Body() Map<String, String> body);

  @GET(Apis.setting)
  Future<SettingModel> settingApiCall();

  @GET(Apis.ownerSetting)
  Future<OwnerSettingModel> ownerSettingApiCall();

  @POST(Apis.register)
  Future<RegisterModel> postRegisterUser(@Body() Map<String, String> body);

  @POST(Apis.profilePasswordUpdate)
  Future<ProfilePasswordUpdate> changePassword(
      @Body() Map<String, String> body);

  @GET(Apis.getProfile)
  Future<GetOwnerProfile> getProfile();

  @POST(Apis.profileSettingUpdate)
  Future<ProfileSettingUpdateModel> profileSettingUpdate(
      @Body() Map<String, dynamic> body);

  @POST(Apis.profileUpdate)
  Future<ProfileUpdate> profileUpdate(@Body() Map<String, String> body);

  @POST(Apis.profilePictureUpdate)
  Future<ProfilePictureUpdate> pictureUpdate(@Body() Map<String, String> body);

  @GET(Apis.getGuard)
  Future<GetAllGuard> getAllGuardData();

  @POST(Apis.addGuard)
  Future<PostGuardAdd> guardAdd(@Body() Map<String, String> body);

  @POST(Apis.updateGuard)
  Future<CommonModel> guardUpdate(@Body() Map<String, dynamic> body);

  @GET(Apis.getOwnerPlanEndPoint)
  Future<GetSubscriptionModel> getPlanD();

  @POST(Apis.purchaseSubscription)
  Future<CommonModel> purchaseSubscriptionCall(
      @Body() Map<String, dynamic> body);

  @GET(Apis.review)
  Future<ReviewModel> getAllReview();

  @GET(Apis.facilities)
  Future<FacilityModel> getFacilities();

  @POST(Apis.addSpaceEndPoint)
  Future<ParkingSpaceAddedModel> spaceAdded(@Body() Map<String, dynamic> body);

  @GET(Apis.getSpace)
  Future<GetAllSpaceModel> getSpaces();

  @GET("${Apis.getsSpaceImage}/{id}/space")
  Future<GetImageSpace> getImageSpace(@Path() String id);

  @POST(Apis.imageUpload)
  Future<ImageUploadModel> uploadImage(@Body() Map<String, dynamic> body);

  @DELETE("${Apis.imageDelete}/{id}")
  Future<DeleteImageModel> imageDelete(@Path() String id);

  @GET("${Apis.transaction}/{id}/{every}")
  Future<TransactionModel> transactionHistory(
      @Path() String id, @Path() String every);

  @GET(Apis.subscriptionHistory)
  Future<SubscriptionHistoryModel> subscriptionHistoryCall();

  @POST("${Apis.customTransaction}/{id}/custom")
  Future<TransactionModel> customTransactionCall(
      @Body() Map<String, String> body);

  @DELETE("${Apis.deleteCard}/{id}")
  Future<OwnerCardDeleteModel> cardDeleteCall(@Path() String id);

  @GET("${Apis.buyPlan}/{id}/buy")
  Future<GetBuyPlanModel> buyPlanHistory(@Path() String id);

  @GET("${Apis.getSpaceIdData}/{id}")
  Future<GetSpaceId> spaceIDData(@Path() String id);

  @GET(Apis.getAvailableGuard)
  Future<GetAvailableGuard> availableGuard();

  @GET(Apis.getStripeKey)
  Future<GetStripeKeyModel> stripeKeyCall();

  @GET("${Apis.spaceIdLive}/{id}/live")
  Future<SpaceIdLiveModel> getSpaceIdLive(@Path() String id);

  @GET("${Apis.scanOrder}/{order}")
  Future<OrderScannerModel> scanOrderCall(@Path() String order);

  @POST(Apis.selfDelete)
  Future<CommonModel> accountDeleteCall();
}
