import 'package:flutter/material.dart';
import '../../shared/utils/constants.dart';
import '../../shared/widgets/custom_button.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Subscription Plans'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Your Plan',
              style: AppTextStyles.heading1,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Save more with our monthly subscription plans',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildPlanCard(
              title: 'Basic Plan',
              price: '₹999',
              duration: 'per month',
              features: [
                '4 Basic Washes',
                'Priority Booking',
                'Free Doorstep Service',
              ],
              isPopular: false,
            ),
            _buildPlanCard(
              title: 'Premium Plan',
              price: '₹1,999',
              duration: 'per month',
              features: [
                '4 Premium Washes',
                'Priority Booking',
                'Free Doorstep Service',
                '1 Free Detailing',
                '24/7 Support',
              ],
              isPopular: true,
            ),
            _buildPlanCard(
              title: 'Ultimate Plan',
              price: '₹2,999',
              duration: 'per month',
              features: [
                'Unlimited Basic Washes',
                '2 Premium Washes',
                '1 Full Detailing',
                'Priority Booking',
                'Free Doorstep Service',
                '24/7 Support',
              ],
              isPopular: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String duration,
    required List<String> features,
    required bool isPopular,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        side: BorderSide(
          color: isPopular ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: Text(
                  'MOST POPULAR',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (isPopular) const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: AppTextStyles.heading1.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    duration,
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            ...features.map((feature) {
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
                        feature,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: AppSpacing.lg),
            CustomButton(
              text: 'Subscribe Now',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
