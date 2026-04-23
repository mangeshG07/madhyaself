//System//
export 'dart:io';
export 'dart:async';
export 'dart:convert';
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:flutter/gestures.dart';

//Theme//
export 'package:madhya/core/theme/dark_theme.dart';
export 'package:madhya/core/theme/light_theme.dart';
export 'package:madhya/core/theme/app_colors.dart';
export 'package:madhya/core/theme/text_styles.dart';

//Plugins//
export 'package:get/get.dart'
    hide Response, FormData, MultipartFile, HeaderValue;
export 'package:injectable/injectable.dart';
export 'package:flutter_screenutil/flutter_screenutil.dart';
export 'package:ui_package/ui_package.dart'
    hide AppTheme, AppColors, ListTileStyle, AppTextStyles;
export 'package:google_fonts/google_fonts.dart';
export 'package:pinput/pinput.dart';
export 'package:sms_autofill/sms_autofill.dart' hide Orientation;
export 'package:hugeicons/hugeicons.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:carousel_slider/carousel_slider.dart';
export 'package:dotted_border/dotted_border.dart';
export 'package:dio/dio.dart';
export 'package:web_socket_channel/web_socket_channel.dart';
export 'package:hugeicons/styles/stroke_rounded.dart';
export 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

//Common//
export 'package:madhya/core/constants/app_constants.dart';
export 'package:madhya/core/config/routes/app_routes.dart';
export 'package:madhya/core/config/routes/app_pages.dart';
export 'package:madhya/core/constants/app_assets.dart';
export 'package:madhya/core/theme/app_theme.dart';
export 'package:madhya/core/utils/logger.dart';
export 'package:madhya/core/di/injection.dart';
export 'package:madhya/presentation/auth/widget/onboarding_component.dart';
export 'package:madhya/core/component/dialogs.dart';
export 'package:madhya/core/utils/common.dart';
export 'package:madhya/core/network/interceptors/logger_interceptor.dart';
export 'package:madhya/core/network/interceptors/retry_interceptors.dart';
export 'package:madhya/core/network/interceptors/auth_interceptor.dart';
export 'package:madhya/core/constants/api_constants.dart';
export 'package:madhya/core/network/api_service.dart';
export 'package:madhya/core/utils/documents_preparation.dart';

//Pages//
export 'package:madhya/presentation/splash/view/splash_screen.dart';
export 'package:madhya/presentation/auth/widget/onboarding_screen.dart';
export 'package:madhya/presentation/auth/view/login_screen.dart';
export 'package:madhya/presentation/auth/view/verify_otp_screen.dart';
export 'package:madhya/presentation/auth/view/register_screen.dart';
export 'package:madhya/presentation/auth/view/profile_add.dart';
export 'package:madhya/presentation/navigation/view/navigation_screen.dart';
export 'package:madhya/presentation/home/view/home_screen.dart';
export 'package:madhya/presentation/matches/view/match_screen.dart';
export 'package:madhya/presentation/others_profile/view/other_profile.dart';
export 'package:madhya/presentation/mailbox/view/mailbox_screen.dart';
export 'package:madhya/presentation/mailbox/widget/chat_details.dart';
export 'package:madhya/presentation/mailbox/widget/chat_user_profile.dart';
export 'package:madhya/presentation/profile/widget/shortlist.dart';
export 'package:madhya/presentation/profile/widget/viewed.dart';
export 'package:madhya/presentation/profile/widget/interest.dart';
export 'package:madhya/presentation/profile/widget/edit_profile.dart';
export 'package:madhya/core/utils/policy_data.dart';

//Controller//
export 'package:madhya/presentation/splash/controller/splash_controller.dart';
export 'package:madhya/presentation/auth/controller/login_controller.dart';
export 'package:madhya/presentation/auth/controller/otp_controller.dart';
export 'package:madhya/presentation/auth/controller/register_controller.dart';
export 'package:madhya/presentation/auth/controller/onboarding_controller.dart';
export 'package:madhya/presentation/navigation/controller/navigation_controller.dart';
export 'package:madhya/presentation/home/controller/home_controller.dart';
export 'package:madhya/presentation/matches/controller/match_controller.dart';
export 'package:madhya/presentation/others_profile/controller/other_profile_controller.dart';
export 'package:madhya/presentation/mailbox/controller/chat_controller.dart';
export 'package:madhya/presentation/profile/controller/profile_controller.dart';
export 'package:madhya/presentation/profile/controller/shortlist_controller.dart';
export 'package:madhya/presentation/profile/controller/viewed_controller.dart';
export 'package:madhya/presentation/profile/controller/interest_controller.dart';
export 'package:madhya/presentation/global_search/controller/global_search_controller.dart';
export 'package:madhya/presentation/profile/controller/preference_controller.dart';

//Component//
export 'package:madhya/core/component/onboarding_indicator.dart';
export '../../../core/component/app_dropdown.dart';
export 'package:madhya/core/utils/match_card_compact.dart';
export 'package:madhya/core/component/app_slider.dart';
export 'package:madhya/core/utils/match_card_overlay.dart';
export 'package:madhya/core/component/app_icon_buttons.dart';
export 'package:madhya/core/component/app_bottomsheet_layout.dart';
export 'package:madhya/core/component/bottom_header.dart';
export 'package:madhya/presentation/others_profile/widget/contact_bottomsheet.dart';
export 'package:madhya/presentation/others_profile/widget/interested_bottomsheet.dart';
export 'package:madhya/presentation/others_profile/widget/shortlist_bottomsheet.dart';
export 'package:madhya/core/component/app_toggle.dart';
export 'package:madhya/presentation/profile/widget/interest_card.dart';
export 'package:madhya/core/component/custom_appbar.dart';
export 'package:madhya/core/component/custom_dropdown_normal.dart';
export 'package:madhya/presentation/mailbox/widget/chat_tile.dart';

//Repository//
export 'package:madhya/domain/repository/login_repository.dart';
export 'package:madhya/domain/repository/home_repository.dart';
export 'package:madhya/domain/repository/profile_repository.dart';
export 'package:madhya/domain/repository/other_user_repository.dart';
export 'package:madhya/domain/repository/chat_repository.dart';
export 'package:madhya/domain/repository/partner_preference_repository.dart';
export 'package:madhya/domain/repository/matches_repository.dart';

//Entity//
export 'package:madhya/domain/entity/login_request.dart';
export 'package:madhya/domain/entity/verify_otp_request.dart';
export 'package:madhya/domain/entity/register_request.dart';
export 'package:madhya/domain/entity/religion_request.dart';
export 'package:madhya/domain/entity/user_request.dart';
export 'package:madhya/domain/entity/other_user_request.dart';
export 'package:madhya/domain/usecase/other_profile_usecase.dart';
export 'package:madhya/domain/entity/chat_details_request.dart';
export 'package:madhya/domain/entity/send_msg_request.dart';
export 'package:madhya/domain/entity/interest_requested.dart';
export 'package:madhya/domain/entity/create_chat_request.dart';
export 'package:madhya/domain/entity/update_user_profile_request.dart';
export 'package:madhya/domain/entity/update_prefs_request.dart';

//Repository Implementation//
export 'package:madhya/data/repository_impl/auth_repository_impl.dart';
export 'package:madhya/data/repository_impl/home_repository_impl.dart';
export 'package:madhya/data/repository_impl/profile_repository_impl.dart';
export 'package:madhya/data/repository_impl/other_profile_repository_impl.dart';
export 'package:madhya/data/repository_impl/chat_repository_impl.dart';
export 'package:madhya/data/repository_impl/partner_preference_repository_impl.dart';
export '../../../data/repository_impl/matches_repository_impl.dart';

//Use case//
export 'package:madhya/domain/usecase/login_usecase.dart';
export 'package:madhya/domain/usecase/verify_otp_usecase.dart';
export 'package:madhya/domain/usecase/common_data_usecase.dart';
export 'package:madhya/domain/usecase/register_usecase.dart';
export 'package:madhya/domain/usecase/caste_by_rel_usecase.dart';
export 'package:madhya/domain/usecase/subcaste_by_caste.dart';
export 'package:madhya/domain/usecase/home_usecase.dart';
export 'package:madhya/domain/usecase/profile_usecase.dart';
export 'package:madhya/domain/usecase/chat_list_usecase.dart';
export 'package:madhya/domain/usecase/chat_details_usecase.dart';
export 'package:madhya/domain/usecase/send_msg_usecase.dart';
export 'package:madhya/domain/usecase/msg_delivered_usecase.dart';
export 'package:madhya/domain/usecase/msg_read_usecase.dart';
export '../../../domain/usecase/typing_usecase.dart';
export 'package:madhya/domain/usecase/get_view_usecase.dart';
export 'package:madhya/domain/usecase/get_shortlist_usecase.dart';
export 'package:madhya/domain/usecase/get_interest_usecase.dart';
export 'package:madhya/domain/usecase/delete_interest_usecase.dart';
export 'package:madhya/domain/usecase/update_interest_usecase.dart';
export 'package:madhya/domain/usecase/send_interest_usecase.dart';
export 'package:madhya/domain/usecase/create_chat_usecase.dart';
export 'package:madhya/domain/usecase/update_profile_usecase.dart';
export 'package:madhya/domain/usecase/location_data_usecase.dart';
export 'package:madhya/domain/usecase/get_part_pref_usecase.dart';
export 'package:madhya/domain/usecase/update_prefs_usecase.dart';
export '../../../domain/usecase/get_matches_usecase.dart';
export 'package:madhya/domain/usecase/shortlist_profile_usecase.dart';
export 'package:madhya/domain/usecase/block_user_usecase.dart';
export 'package:madhya/domain/usecase/report_profile_usecase.dart';
