import '../../../core/exporters/app_export.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  final controller = Get.find<PlanController>();

  @override
  void initState() {
    controller.getPlanDetails(Get.arguments['id']?.toString() ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppbar(titleSpacing: 0, title: 'Checkout'),
      body: Obx(
        () => controller.isDetailsLoading.isTrue
            ? AppLoader.circular()
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 12,
                  children: [
                    AppText(
                      text: 'Plan : ${controller.planDetails['name']}',
                      fontSize: 18.sp,
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w600,
                    ),

                    AppText(
                      text: 'Price : ${controller.planDetails['final_price']}',
                      fontSize: 18.sp,
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w500,
                    ),

                    /// Feature Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: "Features",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(
                              Get.context!,
                            ).textTheme.titleLarge!.color,
                          ),
                          AppText(
                            text: "Limit",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(
                              Get.context!,
                            ).textTheme.bodyMedium!.color,
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      thickness: 1,
                      color: Colors.grey.withValues(alpha: 0.3),
                      height: 15.h,
                    ),

                    /// Feature List
                    ...controller.planDetails['features'].map(
                      (feature) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Theme.of(Get.context!).dividerColor,
                                    size: 18.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: AppText(
                                      text: feature['name'] ?? '',
                                      fontSize: 14.sp,
                                      color: Theme.of(
                                        Get.context!,
                                      ).textTheme.titleLarge!.color,
                                      textAlign: TextAlign.start,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppText(
                              text: feature['limit']?.toString() ?? '-',
                              fontSize: 14.sp,
                              color: Theme.of(
                                Get.context!,
                              ).textTheme.titleLarge!.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Divider(
                      thickness: 1,
                      color: Colors.grey.withValues(alpha: 0.3),
                      height: 15.h,
                    ),
                    SizedBox(height: 8.h),
                    _buildPayMethod(theme),
                    _buildPayNowButton(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPayMethod(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.h,
      children: [
        AppText(
          text: 'Select Payment Method',
          fontSize: 18.sp,
          textAlign: TextAlign.start,
          fontWeight: FontWeight.bold,
        ),

        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.paymentMethods.length,
            itemBuilder: (context, index) {
              final payMethod = controller.paymentMethods[index];
              return Card(
                surfaceTintColor: theme.scaffoldBackgroundColor,
                color: theme.scaffoldBackgroundColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: theme.dividerTheme.color!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    payMethod['name'] ?? '',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Theme.of(Get.context!).textTheme.bodySmall!.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  leading: Radio<int>(
                    value: index,
                    activeColor: AppColors.lightPrimary,
                    groupValue: controller.selectedPayment.value,
                    onChanged: (int? value) {
                      if (value != null) {
                        controller.selectedPayment.value = value;
                        // controller.paymentMethodList.value =
                        // payMethod['slug'];
                      }
                    },
                  ),
                  trailing: payMethod['image'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            payMethod['image'],
                            height: Get.height * 0.04,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.broken_image,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPayNowButton() {
    return Obx(
      () => controller.isCheckOutLoading.isTrue
          ? AppLoader.circular()
          : AppButton(
              text: 'Pay Now',
              onTap: () async {
                final pay = controller.paymentMethods.first;
                controller.selectedPaymentId.value = pay['id'].toString();

                await controller.checkout(
                  controller.planDetails['id'].toString(),
                  controller.planDetails['final_price'].toString(),
                  controller.selectedPaymentId.value,
                  controller.planDetails['type'].toString(),
                  pay['key_id'].toString(),
                );
              },
              backgroundColor: AppColors.lightSecondary,
            ),
    );
  }
}
