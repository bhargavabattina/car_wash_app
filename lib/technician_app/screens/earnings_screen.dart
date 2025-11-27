import 'package:flutter/material.dart';
import '../../shared/utils/constants.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Earnings'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: AppColors.primary,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    Text(
                      'Total Earnings',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '₹12,450',
                      style: AppTextStyles.heading1.copyWith(
                        color: Colors.white,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'This Month',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 32,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '45',
                            style: AppTextStyles.heading2.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Completed',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.accent,
                            size: 32,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '4.8',
                            style: AppTextStyles.heading2.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Rating',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Recent Earnings',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildEarningItem(
              date: '24 Nov 2024',
              service: 'Premium Wash',
              amount: '₹349',
            ),
            _buildEarningItem(
              date: '23 Nov 2024',
              service: 'Basic Wash',
              amount: '₹199',
            ),
            _buildEarningItem(
              date: '23 Nov 2024',
              service: 'Detailing',
              amount: '₹899',
            ),
            _buildEarningItem(
              date: '22 Nov 2024',
              service: 'Premium Wash',
              amount: '₹349',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningItem({
    required String date,
    required String service,
    required String amount,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
          child: const Icon(
            Icons.monetization_on,
            color: AppColors.success,
          ),
        ),
        title: Text(
          service,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          date,
          style: AppTextStyles.bodySmall,
        ),
        trailing: Text(
          amount,
          style: AppTextStyles.heading3.copyWith(
            color: AppColors.success,
          ),
        ),
      ),
    );
  }
}
