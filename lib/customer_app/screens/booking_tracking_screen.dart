import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/models/booking_model.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/helpers.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/providers/booking_provider.dart';

class BookingTrackingScreen extends StatefulWidget {
  const BookingTrackingScreen({super.key});

  @override
  State<BookingTrackingScreen> createState() => _BookingTrackingScreenState();
}

class _BookingTrackingScreenState extends State<BookingTrackingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookingId = ModalRoute.of(context)!.settings.arguments as String;
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
      bookingProvider.loadBooking(bookingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Booking Status'),
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          final booking = bookingProvider.currentBooking;

          if (booking == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
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
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _buildStatusTimeline(booking),
                      ],
                    ),
                  ),
                ),
                if (booking.technicianId != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  const Text(
                    'Technician Info',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Text(
                          booking.technicianName?[0] ?? 'T',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        booking.technicianName ?? 'Technician',
                        style: AppTextStyles.heading3,
                      ),
                      subtitle: Text(
                        booking.technicianPhone ?? '',
                        style: AppTextStyles.bodySmall,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.phone, color: AppColors.primary),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                if (booking.beforePhotos.isNotEmpty) ...[
                  const Text(
                    'Before Photos',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: booking.beforePhotos.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          ),
                          child: const Icon(Icons.photo),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                if (booking.afterPhotos.isNotEmpty) ...[
                  const Text(
                    'After Photos',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: booking.afterPhotos.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          ),
                          child: const Icon(Icons.photo),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusTimeline(BookingModel booking) {
    final statuses = [
      {'key': 'pending', 'label': 'Pending'},
      {'key': 'assigned', 'label': 'Technician Assigned'},
      {'key': 'on_the_way', 'label': 'On the Way'},
      {'key': 'in_progress', 'label': 'Washing Started'},
      {'key': 'completed', 'label': 'Completed'},
    ];

    final currentStatusIndex = statuses.indexWhere(
      (s) => s['key'] == booking.bookingStatus,
    );

    return Column(
      children: statuses.asMap().entries.map((entry) {
        final index = entry.key;
        final status = entry.value;
        final isCompleted = index <= currentStatusIndex;
        final isCurrent = index == currentStatusIndex;

        return Row(
          children: [
            Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.primary
                        : AppColors.divider,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : Icons.circle,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                if (index < statuses.length - 1)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted
                        ? AppColors.primary
                        : AppColors.divider,
                  ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Text(
                  status['label'] as String,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
