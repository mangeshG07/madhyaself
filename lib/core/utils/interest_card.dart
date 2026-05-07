import '../exporters/app_export.dart';

class InterestCard extends StatelessWidget {
  final Map<String, dynamic> interest;
  final InterestController controller;

  const InterestCard({
    super.key,
    required this.interest,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: Get.height * 0.2,
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      decoration: _cardDecoration(isDark),
      child: Row(
        children: [
          _InterestImage(interest: interest, controller: controller),
          _InterestContent(interest: interest, controller: controller),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? AppColors.grey900 : AppColors.catBgColor,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(
        color: isDark ? Colors.white10 : Colors.black12,
        width: 0.5,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.4)
              : Colors.black.withValues(alpha: 0.08),
          blurRadius: 10.r,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}

// ================= IMAGE =================
class _InterestImage extends StatelessWidget {
  final Map<String, dynamic> interest;
  final InterestController controller;

  const _InterestImage({required this.interest, required this.controller});

  @override
  Widget build(BuildContext context) {
    final image = _resolveImage();

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.r),
        bottomLeft: Radius.circular(20.r),
      ),
      child: SizedBox(
        width: 120.w,
        height: double.infinity,
        child: FadeInImage(
          placeholder: AssetImage(AppAssets.defaultImage),
          image: NetworkImage(interest['hide_photos'] == "0" ? image : ''),
          fit: BoxFit.cover,
          imageErrorBuilder: (_, __, ___) =>
              Image.asset(AppAssets.defaultImage),
        ),
      ),
    );
  }

  String _resolveImage() {
    final type = controller.selectedType.value;

    if (type == 0) {
      return interest['is_sent'] == true
          ? interest['receiver_profile_image']
          : interest['sender_profile_image'];
    }
    if (type == 1) {
      return interest['sender_profile_image'];
    }

    return interest['receiver_profile_image'] ?? '';
  }
}

// ================= CONTENT =================
class _InterestContent extends StatelessWidget {
  final Map<String, dynamic> interest;
  final InterestController controller;

  const _InterestContent({required this.interest, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final viewModel = _InterestViewModel.from(interest, controller);

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (viewModel.hasBadges) ...[
              _Badges(interest: interest),
              SizedBox(height: 4.h),
            ],

            _Title(viewModel: viewModel, colorScheme: colorScheme),
            _IdText(viewModel: viewModel, colorScheme: colorScheme),

            if (viewModel.isSelf) _SelfLabel(),

            if (viewModel.hasMessage) ...[
              SizedBox(height: 4.h),
              _Message(viewModel: viewModel, colorScheme: colorScheme),
              const Spacer(),
            ],

            _ActionButtons(viewModel: viewModel, controller: controller),
          ],
        ),
      ),
    );
  }
}

// ================= VIEW MODEL =================
class _InterestViewModel {
  final String name;
  final String username;
  final String id;
  final String interestId;
  final String message;
  final bool isSelf;
  final bool hasBadges;
  final ButtonType buttonType;

  bool get hasMessage => message.isNotEmpty;

  _InterestViewModel({
    required this.name,
    required this.username,
    required this.id,
    required this.interestId,
    required this.message,
    required this.isSelf,
    required this.hasBadges,
    required this.buttonType,
  });

  factory _InterestViewModel.from(
    Map<String, dynamic> data,
    InterestController controller,
  ) {
    final selectedType = controller.selectedType.value;

    final isSelf = selectedType == 0
        ? data['is_sent'] == true
        : selectedType == 2;

    final name = selectedType == 0
        ? (isSelf ? data['receiver_name'] : data['sender_name'])
        : selectedType == 1
        ? data['sender_name']
        : data['receiver_name'];

    final id = selectedType == 0
        ? (isSelf ? data['receiver_id'] : data['sender_id'])
        : selectedType == 1
        ? data['sender_id']
        : data['receiver_id'];

    final uName = selectedType == 0
        ? (isSelf ? data['receiver_username'] : data['sender_username'])
        : selectedType == 1
        ? data['sender_username']
        : data['receiver_username'];

    final hasBadges = data['isVerified'] == true || data['isPremium'] == true;

    return _InterestViewModel(
      username: uName ?? '',
      name: name ?? '',
      id: id?.toString() ?? '',
      interestId: data['id']?.toString() ?? '',
      message: data['message'] ?? '',
      isSelf: isSelf,
      hasBadges: hasBadges,
      buttonType: _resolveButtonType(data, isSelf),
    );
  }

  static ButtonType _resolveButtonType(Map data, bool isSelf) {
    final status = data['status'];

    if (status == '1') return ButtonType.chatNow;
    if (isSelf) return ButtonType.deleteRequest;
    if (status == '2') return ButtonType.undo;

    return ButtonType.pending;
  }
}

// ================= SMALL WIDGETS =================
class _Title extends StatelessWidget {
  final _InterestViewModel viewModel;
  final ColorScheme colorScheme;

  const _Title({required this.viewModel, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: viewModel.name,
      fontSize: 15.sp,
      fontWeight: FontWeight.w700,
      color: colorScheme.onSurface,
      maxLines: 1,
    );
  }
}

class _IdText extends StatelessWidget {
  final _InterestViewModel viewModel;
  final ColorScheme colorScheme;

  const _IdText({required this.viewModel, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: viewModel.username,
      fontSize: 11.sp,
      color: colorScheme.onSurface.withValues(alpha: 0.6),
    );
  }
}

class _SelfLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: AppText(
        text: "You sent request",
        fontSize: 10.sp,
        color: Colors.blue,
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final _InterestViewModel viewModel;
  final ColorScheme colorScheme;

  const _Message({required this.viewModel, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: viewModel.message,
      maxLines: 3,
      fontSize: 11.sp,
      color: colorScheme.onSurface.withValues(alpha: 0.75),
    );
  }
}

class _Badges extends StatelessWidget {
  final Map<String, dynamic> interest;

  const _Badges({required this.interest});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (interest['isVerified'] == true)
          badge(
            "Verified",
            AppColors.lightPrimary,
            HugeIcons.strokeRoundedCheckmarkBadge01,
          ),
        if (interest['isPremium'] == true)
          badge(
            "Premium",
            AppColors.lightSecondary,
            HugeIcons.strokeRoundedCrown02,
          ),
      ],
    );
  }
}

// ================= BUTTONS =================
class _ActionButtons extends StatelessWidget {
  final _InterestViewModel viewModel;
  final InterestController controller;

  _ActionButtons({required this.viewModel, required this.controller});
  final chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    switch (viewModel.buttonType) {
      case ButtonType.chatNow:
        return Obx(
          () => GestureDetector(
            onTap: () async {
              await chatController.createChat(viewModel.id);
            },
            child: chatController.creatingChatId.value == viewModel.id
                ? AppLoader.circular(color: AppColors.lightPrimary, size: 18.r)
                : _PrimaryButton(text: "Chat Now", color: Colors.green),
          ),
        );

      case ButtonType.deleteRequest:
        return _LoadingButton(
          text: "Delete Request",
          onTap: () => controller.deleteInterest(viewModel.interestId),
          controller: controller,
          id: viewModel.interestId,
        );

      case ButtonType.undo:
        return _LoadingButton(
          text: "Undo",
          onTap: () => controller.updateInterest(viewModel.interestId, '0'),
          controller: controller,
          id: viewModel.interestId,
        );

      case ButtonType.pending:
        return Row(
          children: [
            Expanded(
              child: _LoadingButton(
                text: "Decline",
                onTap: () =>
                    controller.updateInterest(viewModel.interestId, '2'),
                controller: controller,
                id: viewModel.interestId,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _LoadingButton(
                text: "Accept",
                onTap: () =>
                    controller.updateInterest(viewModel.interestId, '1'),
                controller: controller,
                id: viewModel.interestId,
                isPrimary: true,
              ),
            ),
          ],
        );
    }
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final Color color;

  const _PrimaryButton({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: AppText(
        text: text,
        color: Colors.white,
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _LoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final InterestController controller;
  final String id;
  final bool isPrimary;

  const _LoadingButton({
    required this.text,
    required this.onTap,
    required this.controller,
    required this.id,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.deletingId.value == id;

      return GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 6.h),
          decoration: BoxDecoration(
            color: isPrimary
                ? AppColors.lightPrimary
                : Get.isDarkMode
                ? AppColors.grey800
                : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: isLoading
              ? AppLoader.circular(size: 18.r)
              : AppText(
                  text: text,
                  fontSize: 13.sp,
                  color: isPrimary ? Colors.white : null,
                ),
        ),
      );
    });
  }
}

enum ButtonType { chatNow, deleteRequest, undo, pending }

// import '../../../core/exporters/app_export.dart';
//
// class InterestCard extends StatelessWidget {
//   final dynamic interest;
//   final InterestController controller;
//   const InterestCard({
//     super.key,
//     required this.interest,
//     required this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Container(
//       width: 0.9.sw,
//       height: Get.height * 0.2.h,
//       margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
//       decoration: _cardDecoration(isDark),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [ _InterestImage(interest: interest, controller: controller),_buildContent(context)],
//       ),
//     );
//   }
//
//   BoxDecoration _cardDecoration(bool isDark) {
//     return BoxDecoration(
//       color: AppColors.catBgColor,
//       borderRadius: BorderRadius.circular(20.r),
//       border: Border.all(
//         color: isDark ? Colors.white10 : Colors.black12,
//         width: 0.5,
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: isDark
//               ? Colors.black.withValues(alpha: 0.4)
//               : Colors.black.withValues(alpha: 0.08),
//           blurRadius: 10.r,
//           offset: const Offset(0, 3),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildImage() {
//     final image = controller.selectedType.value == 0
//         ? (interest['is_sent'] == true
//               ? interest['receiver_profile_image']
//               : interest['sender_profile_image'])
//         : interest['receiver_profile_image'] ?? '';
//
//     return ClipRRect(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(20.r),
//         bottomLeft: Radius.circular(20.r),
//       ),
//       child: SizedBox(
//         width: 120.w,
//         height: double.infinity,
//         child: FadeInImage(
//           placeholder: AssetImage(AppAssets.appLogo),
//           image: NetworkImage(image),
//           imageErrorBuilder: (_, __, ___) => Container(
//             color: Colors.grey.shade200,
//             child: Image.asset(AppAssets.appLogo),
//           ),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContent(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final selectedType = controller.selectedType.value;
//
//     /// ✅ SINGLE SOURCE OF TRUTH
//     final bool isSelf = selectedType == 0
//         ? interest['is_sent'] == true
//         : selectedType == 2;
//
//     /// Name
//     final name = selectedType == 0
//         ? (isSelf ? interest['receiver_name'] : interest['sender_name'])
//         : interest['receiver_name'];
//
//     /// ID
//     final id = selectedType == 0
//         ? (isSelf ? interest['receiver_id'] : interest['sender_id'])
//         : interest['receiver_id'];
//
//     // Get message content
//     final message = interest['message'] ?? '';
//     final hasMessage = message.isNotEmpty;
//
//     // Check if there are any badges to show
//     final hasVerified = interest['isVerified'] == true;
//     final hasPremium = interest['isPremium'] == true;
//     final hasBadges = hasVerified || hasPremium;
//
//     final buttonType = _getButtonType(isSelf);
//     final isSingleButton =
//         buttonType == ButtonType.chatNow ||
//         buttonType == ButtonType.deleteRequest ||
//         buttonType == ButtonType.undo;
//
//     return Expanded(
//       child: Padding(
//         padding: EdgeInsets.all(10.r),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Badges section - only show if badges exist
//             if (hasBadges) ...[_buildBadges(), SizedBox(height: 2.h)],
//             if (!hasBadges) SizedBox(height: 12.h),
//             // Name row
//             AppText(
//               text: name ?? '',
//               fontSize: 15.sp,
//               fontWeight: FontWeight.w600,
//               maxLines: 1,
//               textAlign: TextAlign.start,
//               style: theme.textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.w700,
//                 color: colorScheme.onSurface,
//               ),
//             ),
//
//             // ID with icon
//             AppText(
//               text: 'ID : ${id ?? ''}',
//               fontSize: 11.sp,
//               textAlign: TextAlign.start,
//               style: theme.textTheme.bodySmall?.copyWith(
//                 color: colorScheme.onSurface.withValues(alpha: 0.6),
//               ),
//             ),
//
//             /// SELF LABEL
//             if (isSelf)
//               Container(
//                 margin: EdgeInsets.only(top: 2.h),
//                 padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.withValues(alpha: 0.1),
//                   borderRadius: BorderRadius.circular(6.r),
//                 ),
//                 child: AppText(
//                   text: "You sent request",
//                   fontSize: 10.sp,
//                   color: Colors.blue,
//                 ),
//               ),
//             SizedBox(height: 4.h),
//
//             // Message section - flexible spacing based on content
//             if (hasMessage) ...[
//               AppText(
//                 text: message,
//                 maxLines: 3,
//                 fontSize: 11.sp,
//                 textAlign: TextAlign.start,
//                 style: theme.textTheme.bodySmall?.copyWith(
//                   height: 1,
//                   fontSize: 11.sp,
//                   color: colorScheme.onSurface.withValues(alpha: 0.75),
//                 ),
//               ),
//               Spacer(),
//             ] else ...[
//               // Add some spacing when no message
//               SizedBox(height: 8.h),
//             ],
//             if (isSingleButton) SizedBox(height: 4.h),
//             _buildButtons(buttonType, isSelf),
//             // // Buttons section with proper spacing
//
//             // if (isSingleButton)
//             //   _buildSingleButton(buttonType, isSelf)
//             // else
//             //   Column(
//             //     children: [
//             //       if (!isSingleButton) SizedBox(height: 4.h),
//             //       _buildActionButtons(),
//             //     ],
//             //   ),
//             // // Add a small bottom padding for better spacing
//             // SizedBox(height: 2.h),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBadges() {
//     return Row(
//       spacing: 6.w,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         if (interest['isVerified'] == true)
//           badge(
//             "Verified",
//             AppColors.lightPrimary,
//             HugeIcons.strokeRoundedCheckmarkBadge01,
//           ),
//         if (interest['isPremium'] == true)
//           badge(
//             "Premium",
//             AppColors.lightSecondary,
//             HugeIcons.strokeRoundedCrown02,
//           ),
//       ],
//     );
//   }
//
//   ButtonType _getButtonType(bool isSelf) {
//     final status = interest['status'];
//
//     if (status == '1') return ButtonType.chatNow;
//     if (isSelf) return ButtonType.undo;
//     if (status == '2') return ButtonType.undo;
//     return ButtonType.pending; // Default for status null or other values
//   }
//
//   // ================= BUTTONS =================
//   Widget _buildButtons(ButtonType type, bool isSelf) {
//     /// CHAT
//     if (type == ButtonType.chatNow) {
//       return _button(
//         text: "Chat Now",
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//       );
//     }
//
//     /// SELF → Cancel
//     if (isSelf) {
//       return Obx(() {
//         final isLoading =
//             controller.deletingId.value == interest['id']?.toString();
//
//         return _button(
//           onTap: () async {
//             await controller.deleteInterest(interest['id']?.toString() ?? '');
//           },
//           text: "Delete Request",
//           isLoading: isLoading, // 👈 HERE
//           backgroundColor: Colors.white,
//           textColor: AppColors.lightTextLowColor,
//           borderColor: AppColors.lightTextLowColor.withValues(alpha: 0.3),
//         );
//       });
//     }
//
//     if (type == ButtonType.undo) {
//       return Obx(() {
//         final isLoading =
//             controller.deletingId.value == interest['id']?.toString();
//
//         return _button(
//           onTap: () async {
//             await controller.updateInterest(
//               interest['id']?.toString() ?? '',
//               '0',
//             );
//           },
//           text: "Undo",
//           isLoading: isLoading, // 👈 HERE
//           backgroundColor: Colors.white,
//           textColor: AppColors.lightTextLowColor,
//           borderColor: AppColors.lightTextLowColor.withValues(alpha: 0.3),
//         );
//       });
//     }
//
//     /// RECEIVED → Accept / Decline
//     return Row(
//       children: [
//         Expanded(
//           child: Obx(() {
//             final isLoading =
//                 controller.deletingId.value == interest['id']?.toString();
//
//             return _button(
//               onTap: () async {
//                 await controller.updateInterest(
//                   interest['id']?.toString() ?? '',
//                   '2',
//                 );
//               },
//               text: "Decline",
//               isLoading: isLoading, // 👈 HERE
//               backgroundColor: Colors.white24,
//               textColor: AppColors.lightTextLowColor,
//               borderColor: AppColors.lightTextLowColor.withValues(alpha: 0.3),
//             );
//           }),
//         ),
//         SizedBox(width: 8.w),
//         Expanded(
//           child: Obx(() {
//             final isLoading =
//                 controller.deletingId.value == interest['id']?.toString();
//
//             return _button(
//               onTap: () async {
//                 await controller.updateInterest(
//                   interest['id']?.toString() ?? '',
//                   '1',
//                 );
//               },
//               text: "Accept",
//               isLoading: isLoading, // 👈 HERE
//               backgroundColor: AppColors.lightPrimary,
//               textColor: Colors.white,
//               isPrimary: true,
//             );
//           }),
//         ),
//       ],
//     );
//   }
//
//   Widget _button({
//     required String text,
//     required Color backgroundColor,
//     required Color textColor,
//     Color? borderColor,
//     bool isPrimary = false,
//     bool isLoading = false,
//     void Function()? onTap,
//   }) {
//     return GestureDetector(
//       onTap: isLoading ? null : onTap,
//       child: Container(
//         alignment: Alignment.center,
//         padding: EdgeInsets.symmetric(vertical: 5.h),
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(10.r),
//           border: borderColor != null
//               ? Border.all(color: borderColor, width: 1.w)
//               : null,
//         ),
//         child: isLoading
//             ? AppLoader.circular(
//                 color: isPrimary ? Colors.white : AppColors.lightPrimary,
//                 size: 20.r,
//                 strokeWidth: 2.5,
//               )
//             : AppText(
//                 text: text,
//                 color: textColor,
//                 fontSize: 13.sp,
//                 fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
//               ),
//       ),
//     );
//   }
// }
//
//
//
// // ================= IMAGE =================
// class _InterestImage extends StatelessWidget {
//   final Map<String, dynamic> interest;
//   final InterestController controller;
//
//   const _InterestImage({
//     required this.interest,
//     required this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final image = _resolveImage();
//
//     return ClipRRect(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(20.r),
//         bottomLeft: Radius.circular(20.r),
//       ),
//       child: SizedBox(
//         width: 120.w,
//         child: FadeInImage(
//           placeholder: AssetImage(AppAssets.appLogo),
//           image: NetworkImage(image),
//           fit: BoxFit.cover,
//           imageErrorBuilder: (_, __, ___) => Image.asset(AppAssets.appLogo),
//         ),
//       ),
//     );
//   }
//
//   String _resolveImage() {
//     final type = controller.selectedType.value;
//
//     if (type == 0) {
//       return interest['is_sent'] == true
//           ? interest['receiver_profile_image']
//           : interest['sender_profile_image'];
//     }
//
//     return interest['receiver_profile_image'] ?? '';
//   }
// }
//
// enum ButtonType { chatNow, deleteRequest, undo, pending }
