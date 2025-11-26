import 'package:flutter/material.dart';
import '../../models/service_model.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/custom_button.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ModalRoute.of(context)!.settings.arguments as ServiceModel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(service.name),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    color: AppColors.primary.withOpacity(0.1),
                    child: const Icon(
                      Icons.local_car_wash,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                service.name,
                                style: AppTextStyles.heading1,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                              ),
                              child: Text(
                                service.priceDisplay,
                                style: AppTextStyles.heading2.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          service.description,
                          style: AppTextStyles.bodyLarge,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Includes:',
                          style: AppTextStyles.heading3,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ...service.includes.map((include) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.success,
                                  size: 20,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    include,
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Estimated Duration: ${service.durationDisplay}',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: CustomButton(
                text: 'Continue',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.selectCar,
                    arguments: service,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
