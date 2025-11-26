import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Total Earnings',
                    value: '₹1,24,500',
                    icon: Icons.monetization_on,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _buildStatCard(
                    title: 'Total Bookings',
                    value: '342',
                    icon: Icons.event,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Active Technicians',
                    value: '15',
                    icon: Icons.person,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _buildStatCard(
                    title: 'Active Subscriptions',
                    value: '48',
                    icon: Icons.card_membership,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Quick Actions',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildMenuItem(
              context,
              icon: Icons.event_note,
              title: 'All Bookings',
              subtitle: 'View and manage all bookings',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.allBookings);
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.people,
              title: 'Manage Technicians',
              subtitle: 'Add, edit, or remove technicians',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.manageTechnicians);
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.local_car_wash,
              title: 'Manage Services',
              subtitle: 'Add or modify services',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.manageServices);
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.attach_money,
              title: 'Manage Pricing',
              subtitle: 'Update service pricing',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.managePricing);
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.receipt,
              title: 'Payments Report',
              subtitle: 'View payment history and analytics',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.paymentsReport);
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.person_outline,
              title: 'Customer List',
              subtitle: 'View all registered customers',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.customerList);
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.local_offer,
              title: 'Offers & Coupons',
              subtitle: 'Create and manage promotional offers',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.offersAndCoupons);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: AppSpacing.md),
            Text(
              value,
              style: AppTextStyles.heading2.copyWith(color: color),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySmall,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
