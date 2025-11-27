import 'package:flutter/material.dart';
import '../../shared/utils/constants.dart';
import '../../shared/widgets/custom_button.dart';

class OffersAndCouponsScreen extends StatefulWidget {
  const OffersAndCouponsScreen({super.key});

  @override
  State<OffersAndCouponsScreen> createState() => _OffersAndCouponsScreenState();
}

class _OffersAndCouponsScreenState extends State<OffersAndCouponsScreen> {
  final List<Map<String, dynamic>> _coupons = [
    {
      'code': 'FIRST50',
      'discount': '50% OFF',
      'description': 'First booking discount',
      'validUntil': '31 Dec 2024',
      'isActive': true,
    },
    {
      'code': 'WASH20',
      'discount': '₹20 OFF',
      'description': 'On all services',
      'validUntil': '30 Nov 2024',
      'isActive': true,
    },
    {
      'code': 'PREMIUM100',
      'discount': '₹100 OFF',
      'description': 'On premium wash only',
      'validUntil': '15 Dec 2024',
      'isActive': false,
    },
  ];

  void _showAddCouponDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Coupon'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Coupon Code',
                  hintText: 'e.g., WASH50',
                ),
              ),
              SizedBox(height: AppSpacing.md),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Discount',
                  hintText: 'e.g., 50% or ₹100',
                ),
              ),
              SizedBox(height: AppSpacing.md),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g., First wash discount',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Add Coupon'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Offers & Coupons'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCouponDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: AppColors.accent.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_offer,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Offers',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_coupons.where((c) => c['isActive'] == true).length} active coupons',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'All Coupons',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: AppSpacing.md),
            ..._coupons.map((coupon) {
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                  AppBorderRadius.md),
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Text(
                              coupon['code'],
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: coupon['isActive']
                                  ? AppColors.success.withOpacity(0.1)
                                  : AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                  AppBorderRadius.sm),
                            ),
                            child: Text(
                              coupon['isActive'] ? 'Active' : 'Inactive',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: coupon['isActive']
                                    ? AppColors.success
                                    : AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          const Icon(
                            Icons.discount,
                            size: 16,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            coupon['discount'],
                            style: AppTextStyles.heading3.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        coupon['description'],
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                'Valid until ${coupon['validUntil']}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 18),
                                onPressed: () {},
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: 18,
                                  color: AppColors.error,
                                ),
                                onPressed: () {},
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
