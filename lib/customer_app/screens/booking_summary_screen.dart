import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../shared/models/service_model.dart';
import '../../shared/models/car_model.dart';
import '../../shared/utils/constants.dart';
import '../../shared/widgets/custom_button.dart';

class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final service = args['service'] as ServiceModel;
    final car = args['car'] as CarModel;
    final date = args['date'] as DateTime;
    final time = args['time'] as String;
    final location = args['location'] as String;
    final latitude = args['latitude'] as double;
    final longitude = args['longitude'] as double;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Review & Pay'),
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
                  const Text(
                    'Booking Summary',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSummaryRow(
                            icon: Icons.local_car_wash,
                            label: 'Service',
                            value: service.name,
                          ),
                          const Divider(height: AppSpacing.lg),
                          _buildSummaryRow(
                            icon: Icons.directions_car,
                            label: 'Car',
                            value: car.displayName,
                          ),
                          const Divider(height: AppSpacing.lg),
                          _buildSummaryRow(
                            icon: Icons.calendar_today,
                            label: 'Date',
                            value: DateFormat('dd MMM yyyy').format(date),
                          ),
                          const Divider(height: AppSpacing.lg),
                          _buildSummaryRow(
                            icon: Icons.access_time,
                            label: 'Time',
                            value: time,
                          ),
                          const Divider(height: AppSpacing.lg),
                          _buildSummaryRow(
                            icon: Icons.location_on,
                            label: 'Location',
                            value: location,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Text(
                    'Price Details',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Service Charge',
                                style: AppTextStyles.bodyMedium,
                              ),
                              Text(
                                service.priceDisplay,
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
                          ),
                          const Divider(height: AppSpacing.lg),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Amount',
                                style: AppTextStyles.heading3,
                              ),
                              Text(
                                service.priceDisplay,
                                style: AppTextStyles.heading2.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                text: 'Proceed to Payment',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.payment,
                    arguments: {
                      'service': service,
                      'car': car,
                      'date': date,
                      'time': time,
                      'location': location,
                      'latitude': latitude,
                      'longitude': longitude,
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

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
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
      ],
    );
  }
}
