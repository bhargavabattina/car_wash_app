import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../shared/models/booking_model.dart';
import '../../shared/utils/constants.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/providers/technician_provider.dart';

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = ModalRoute.of(context)!.settings.arguments as BookingModel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Job Details'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking ID: CW${booking.id}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Divider(height: AppSpacing.lg),
                          _buildDetailRow(
                            icon: Icons.person,
                            label: 'Customer Name',
                            value: booking.customerName,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildDetailRow(
                            icon: Icons.phone,
                            label: 'Contact',
                            value: booking.customerPhone,
                            actionIcon: Icons.call,
                            onAction: () {},
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildDetailRow(
                            icon: Icons.directions_car,
                            label: 'Car',
                            value: booking.carDetails,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildDetailRow(
                            icon: Icons.local_car_wash,
                            label: 'Service',
                            value: booking.serviceName,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildDetailRow(
                            icon: Icons.payment,
                            label: 'Payment',
                            value: '${booking.paymentMethod} - ${booking.paymentStatus}',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildDetailRow(
                            icon: Icons.location_on,
                            label: 'Address',
                            value: booking.location,
                            actionIcon: Icons.map,
                            onAction: () {},
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildDetailRow(
                            icon: Icons.calendar_today,
                            label: 'Scheduled',
                            value: '${DateFormat('dd MMM yyyy').format(booking.scheduledDate)}, ${booking.scheduledTime}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Card(
                    color: AppColors.primary.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Service Amount',
                            style: AppTextStyles.heading3,
                          ),
                          Text(
                            booking.priceDisplay,
                            style: AppTextStyles.heading2.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (booking.bookingStatus == 'assigned')
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
                child: Consumer<TechnicianProvider>(
                  builder: (context, technicianProvider, child) {
                    return CustomButton(
                      text: 'Start Job',
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.startJob,
                          arguments: booking,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    IconData? actionIcon,
    VoidCallback? onAction,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (actionIcon != null)
          IconButton(
            icon: Icon(actionIcon, color: AppColors.primary),
            onPressed: onAction,
          ),
      ],
    );
  }
}
