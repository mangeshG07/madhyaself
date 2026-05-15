import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:madhya/core/exporters/app_export.dart';

class AllDialogs {
  Future<void> noInternetDialog() async {
    if (GetPlatform.isIOS) {
      await Get.dialog(
        PopScope(
          canPop: false,
          child: CupertinoAlertDialog(
            title: const Text('No Internet Connection'),
            content: Column(
              children: [
                const SizedBox(height: 12),
                Image.asset(AppAssets.noInternet, width: Get.height * 0.20),
                const SizedBox(height: 12),
                const Text('Please check your internet connection.'),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Get.offAllNamed(Routes.splash);
                },
                child: const Text('Retry', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    } else {
      await Get.dialog(
        PopScope(
          canPop: false,
          child: AlertDialog(
            surfaceTintColor: Theme.of(Get.context!).scaffoldBackgroundColor,
            backgroundColor: Theme.of(Get.context!).cardColor,
            title: const Text(
              'No Internet Connection',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppAssets.noInternet, width: Get.height * 0.25),
                const SizedBox(height: 12),
                const Text('Please check your internet connection.'),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Get.offAllNamed(Routes.splash);
                },
                child: const Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  void changeNumber(String number) {
    if (Platform.isIOS) {
      // iOS style dialog
      showCupertinoDialog(
        context: Get.context!,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text('Change Number'),
          content: Text('Are you sure you want to change\n+91 $number'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(ctx),
              isDestructiveAction: true,
              child: const Text('No'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                getIt<LoginController>().numberController.clear();
                Get.offAllNamed(Routes.login);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    } else {
      // Android style dialog
      Get.dialog(
        AlertDialog(
          surfaceTintColor: Theme.of(Get.context!).scaffoldBackgroundColor,
          backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
          content: Text('Are you sure you want to change\n+91 $number'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(Get.context!),
              child: const Text('No', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Get.find<LoginController>().numberController.clear();
                Get.offAllNamed(Routes.login);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }
  }

  void showConfirmationDialog(
    String title,
    String message, {
    required VoidCallback onConfirm,
  }) {
    if (GetPlatform.isIOS) {
      // iOS Native Dialog
      Get.dialog(
        CupertinoAlertDialog(
          title: Text(title),
          content: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 45,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 8),
                Text(message, textAlign: TextAlign.center),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel',style: TextStyle(color: Colors.grey),),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Get.back();
                onConfirm();
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else {
      // Android / Material Dialog
      Get.dialog(
        Dialog(
          surfaceTintColor: Theme.of(Get.context!).scaffoldBackgroundColor,
          backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedLogoutSquare01,
                  size: 50.sp,
                  color: Colors.redAccent,
                ),
                SizedBox(height: 10.h),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel',style: TextStyle(color: Colors.grey),),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: () {
                        Get.back();
                        onConfirm();
                      },
                      child: const Text(
                        'Confirm',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  void showOrderSuccessDialog(
    void Function()? onPressed,
    String status,
    String msg,
  ) {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Lottie.asset(
                status == 'Order is Failed....'
                    ? AppAssets.paymentFailed
                    : AppAssets.paymentSuccess,
                height: Get.height * 0.25,
                width: double.infinity,
              ),

              Text(msg, textAlign: TextAlign.center),
              const SizedBox(height: 8.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                ),
                onPressed: onPressed,
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showPremiumDialog() {
    Get.dialog(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.stars, color: Colors.amber),
            SizedBox(width: 8),
            Text("Premium Feature"),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Upgrade to Premium to unlock this feature and more!"),
            SizedBox(height: 16),
            // Add premium benefits list
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Maybe Later"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed(Routes.packageScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: const Text("UPGRADE NOW"),
          ),
        ],
      ),
    );
  }
}
