import 'package:madhya/core/exporters/app_export.dart';

class ManagePhotos extends GetView<ProfileController> {
  const ManagePhotos({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return Scaffold(
      appBar: CustomAppbar(title: 'Manage Photos'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildToggle(isLight),
            Obx(() {
              if (controller.selectedType.value == 0) {
                return _myPhoto(theme, isLight);
              } else {
                return _verifiedProfile(theme, isLight);
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(bool isLight) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(6.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: isLight ? AppColors.grey100 : AppColors.grey800,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            toggleItem(
              title: 'My Photos',
              isSelected: controller.selectedType.value == 0,
              onTap: () => controller.selectedType.value = 0,
              isLight: isLight,
            ),
            SizedBox(width: 8.w),
            toggleItem(
              title: 'Verified Profile',
              isSelected: controller.selectedType.value == 1,
              onTap: () => controller.selectedType.value = 1,
              isLight: isLight,
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////MY Photos/////////////////////////////

  Widget _myPhoto(ThemeData theme, bool isLight) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 12.h,
        children: [
          AppText(
            text:
                'Photo will be visible to other users only after the admins approval.',
            fontSize: 12.sp,
            maxLines: 2,
            style: theme.textTheme.labelMedium!.copyWith(
              color: isLight
                  ? AppColors.lightTextMidColor
                  : AppColors.lightTextLowColor,
            ),
          ),
          _buildProfileImage(theme, isLight),
          _buildAdditionalImages(theme),

          _hidePhoto(theme),
          Obx(
            () => controller.isUpdateLoading.isTrue
                ? AppLoader.circular(
                    color: AppColors.lightPrimary,
                    strokeWidth: 2.5,
                    size: 22.r,
                  )
                : SafeArea(
                    child: AppButton(
                      text: 'Submit',
                      onTap: () async {
                        if (controller.profileImages.length < 3) {
                          Get.snackbar(
                            "Minimum Required",
                            "Please upload at least 3 images",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        await controller.updatePhotosDetails();
                      },
                      backgroundColor: AppColors.lightPrimary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(ThemeData theme, bool isLight) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          AppFilePicker.open(
            onPicked: (v) {
              controller.profileImage.value = v;
            },
          );
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(width: 0.5, color: AppColors.grey400),
              image: DecorationImage(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                image: AssetImage(
                  isLight ? AppAssets.bgImage : AppAssets.bgImageDark,
                ),
              ),
            ),
            child: controller.profileImage.value != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(
                      controller.profileImage.value!,
                      fit: BoxFit.cover,
                    ),
                  )
                : controller.profileDetails['profile_image'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      controller.profileDetails['profile_image'],
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedImageAdd01,
                      color: AppColors.lightPrimary,
                      size: 30.r,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalImages(ThemeData theme) {
    return Obx(() {
      final images = controller.profileImages;
      final int minSlots = 3;

      final int totalItems = images.length < minSlots
          ? minSlots
          : images.length + 1;

      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: totalItems,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          if (index < images.length) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: theme.dividerColor, width: 0.2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: images[index] is String
                        ? FadeInImage(
                            placeholder: const AssetImage(
                              AppAssets.defaultImage,
                            ),
                            image: NetworkImage(images[index] ?? ''),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                AppAssets.defaultImage,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: double.infinity,
                              );
                            },
                          )
                        : Image.file(
                            images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      final item = controller.profileImages[index];

                      if (item is String) {
                        final fileName = Uri.parse(item).pathSegments.last;
                        controller.removedFiles.add(fileName);
                      }

                      // Remove from main list
                      controller.profileImages.removeAt(index);
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // ✅ Show Add Button (for remaining slots)
          return GestureDetector(
            onTap: () {
              AppFilePicker.open(
                config: const AppFilePickerConfig(
                  allowMultiImage: true,
                  allowVideo: false,
                ),
                onMultiPicked: (files) {
                  if (files.isNotEmpty) {
                    controller.profileImages.addAll(files);
                  }
                },
                onPicked: (file) {
                  if (file.path.isNotEmpty) {
                    controller.profileImages.add(file);
                  }
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  width: 0.5,
                  color: AppColors.lightPrimary.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedImageAdd01,
                  color: AppColors.lightPrimary,
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _hidePhoto(ThemeData theme) {
    final isLight = theme.brightness == Brightness.light;
    return ListTile(
      tileColor: isLight ? Color(0xffFFF3E6) : theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: AppColors.lightSecondary, width: 0.5.w),
      ),

      title: AppText(
        text: 'Hide photos',
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.lightTextMidColor,
        style: theme.textTheme.bodyMedium!.copyWith(
          color: isLight
              ? AppColors.lightTextMidColor
              : AppColors.lightTextLowColor,
        ),
      ),
      subtitle: AppText(
        text: 'Hide your photos from other users',
        fontSize: 12.sp,
        style: theme.textTheme.bodySmall!.copyWith(
          color: isLight
              ? AppColors.lightTextMidColor
              : AppColors.lightTextLowColor,
        ),
      ),
      trailing: Switch(
        activeTrackColor: Colors.grey,
        trackOutlineColor: WidgetStatePropertyAll(Colors.grey),
        inactiveThumbColor: Colors.grey,
        activeThumbColor: AppColors.lightSecondary,
        trackColor: WidgetStatePropertyAll(theme.scaffoldBackgroundColor),
        value: controller.isHide.value,
        onChanged: (v) {
          controller.isHide.toggle();
        },
      ),
    );
  }

  ////////////////////////////////VERIFIED PROFILE/////////////////////////////

  Widget _verifiedProfile(ThemeData theme, bool isLight) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 12.h,
        children: [
          AppText(
            text:
                'Upload a valid ID (Aadhaar Card, Passport, or Driving License). After verification, your profile will receive a Verified Badge. ✔️',
            fontSize: 12.sp,
            maxLines: 5,
            style: theme.textTheme.labelMedium!.copyWith(
              color: isLight
                  ? AppColors.lightTextMidColor
                  : AppColors.lightTextLowColor,
            ),
          ),
          _buildUploadDocuments(theme),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(text: 'Supported formats: Documents', fontSize: 12.sp),
              AppText(text: 'Maximum size: 2MB', fontSize: 12.sp),
            ],
          ),

          ListView.separated(
            shrinkWrap: true,
            itemCount: controller.documentList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final file = controller.documentList[index];

              return _documentList(file, index, theme, isLight);
            },
          ),
          Obx(
            () => controller.isUpdateLoading.isTrue
                ? AppLoader.circular(
                    color: AppColors.lightPrimary,
                    strokeWidth: 2.5,
                    size: 22.r,
                  )
                : AppButton(
                    text: 'Submit',
                    onTap: () async {
                      await controller.updateDocumentsDetails();
                    },
                    backgroundColor: AppColors.lightPrimary,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadDocuments(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.scaffoldBackgroundColor,
      ),
      child: GestureDetector(
        onTap: () {
          if (controller.documentList.length < 3) {
            AppFilePicker.open(
              config: AppFilePickerConfig(
                allowDocument: true,
                allowMultiDocument: true,
              ),

              onMultiPicked: (files) {
                if (files.isNotEmpty) {
                  controller.documentList.addAll(files);
                }
              },
              onPicked: (file) {
                if (file.path.isNotEmpty) {
                  controller.documentList.add(file);
                }
              },
            );
          } else {
            CustomSnackbar.show(
              type: SnackbarType.warning,
              context: Get.context!,
              message: 'You can upload only 3 documents.',
            );
          }
        },
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            radius: Radius.circular(12.r),
            dashPattern: [5, 1],
            color: AppColors.lightTextMidColor,
            strokeWidth: 0.5,
            padding: const EdgeInsets.all(16),
          ),
          child: Container(
            width: Get.width,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
            child: Column(
              spacing: 8.h,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedCloudUpload,
                  color: AppColors.grey700,
                ),
                Text(
                  'Upload Documents'.tr,
                  style: TextStyle(color: AppColors.grey700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _documentList(dynamic file, int index, ThemeData theme, bool isLight) {
    String fileName = '';
    String filePath = '';
    String status = '';
    String reason = '';

    if (file is Map<String, dynamic>) {
      // API data
      filePath = file['path'] ?? '';
      fileName = Uri.parse(filePath).pathSegments.last;
      status = file['status'] ?? '';
      reason = file['reason'] ?? '';
    } else if (file is String) {
      // String URL
      filePath = file;
      fileName = Uri.parse(filePath).pathSegments.last;
    } else if (file is File) {
      // Local file
      filePath = file.path;
      fileName = file.path.split('/').last;
    }

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: isLight ? AppColors.lightSecondary : theme.dividerTheme.color!,
          width: 0.5.w,
        ),
      ),
      leading: HugeIcon(
        icon: HugeIcons.strokeRoundedPdf01,
        size: 20.r,
        color: Colors.red,
      ),
      title: AppText(
        text: fileName,
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: isLight ? AppColors.lightTextMidColor : AppColors.grey300,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (status.isNotEmpty)
            AppText(
              text: capitalizeFirst(status),
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: getStatusColor(capitalizeFirst(status)),
            ),
          if (reason.isNotEmpty)
            AppText(
              text: 'Reason : $reason',
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.lightTextMidColor,
            ),
        ],
      ),
      // isThreeLine: true,
      trailing: GestureDetector(
        onTap: () {
          final item = controller.documentList[index];

          // For API docs
          if (item is Map<String, dynamic>) {
            final fileName = Uri.parse(item['path']).pathSegments.last;

            controller.removedDocuments.add(fileName);
          }
          // For String URLs
          else if (item is String) {
            final fileName = Uri.parse(item).pathSegments.last;

            controller.removedDocuments.add(fileName);
          }

          controller.documentList.removeAt(index);
          controller.documentList.refresh(); // if using RxList
        },
        child: Icon(Icons.delete, color: Colors.red, size: 20.r),
      ),
    );
  }

  // Widget _documentList(dynamic file, int index) {
  //   String fileName = '';
  //   if (file is String) {
  //     fileName = Uri.parse(file).pathSegments.last;
  //   } else if (file is File) {
  //     fileName = file.path.split('/').last;
  //   }
  //   return ListTile(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12.r),
  //       side: BorderSide(color: AppColors.lightSecondary, width: 0.5.w),
  //     ),
  //     leading: HugeIcon(
  //       icon: HugeIcons.strokeRoundedPdf01,
  //       size: 20.r,
  //       color: Colors.red,
  //     ),
  //     title: AppText(
  //       text: fileName,
  //       fontSize: 14.sp,
  //       fontWeight: FontWeight.bold,
  //       color: AppColors.lightTextMidColor,
  //     ),
  //     trailing: GestureDetector(
  //       child: Icon(Icons.delete, color: Colors.red, size: 20.r),
  //       onTap: () {
  //         final item = controller.documentList[index];
  //
  //         if (item is String) {
  //           final fileName = Uri.parse(item).pathSegments.last;
  //           controller.removedDocuments.add(fileName);
  //         }
  //         controller.documentList.removeAt(index);
  //       },
  //     ),
  //   );
  // }
}
