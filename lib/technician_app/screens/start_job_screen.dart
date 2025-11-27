import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/models/booking_model.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/helpers.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/providers/technician_provider.dart';
import '../../shared/providers/booking_provider.dart';

class StartJobScreen extends StatefulWidget {
  const StartJobScreen({super.key});

  @override
  State<StartJobScreen> createState() => _StartJobScreenState();
}

class _StartJobScreenState extends State<StartJobScreen> {
  bool _isStarting = false;

  void _startJob(BookingModel booking) async {
    setState(() {
      _isStarting = true;
    });

    final technicianProvider = Provider.of<TechnicianProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    try {
      await bookingProvider.updateBookingStatus(booking.id, 'in_progress');
      await technicianProvider.loadTechnicianJobs(booking.technicianId!);

      if (mounted) {
        Helpers.showSnackBar(context, 'Job started successfully!');
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.uploadPhotos,
          arguments: booking.id,
        );
      }
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(context, 'Failed to start job', isError: true);
        setState(() {
          _isStarting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = ModalRoute.of(context)!.settings.arguments as BookingModel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Start Job'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Spacer(),
            const Icon(
              Icons.play_circle_outline,
              size: 100,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              'Ready to Start?',
              style: AppTextStyles.heading1,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Make sure you have reached the location and are ready to begin the service.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    _buildChecklistItem('Reached customer location', true),
                    _buildChecklistItem('Tools and equipment ready', true),
                    _buildChecklistItem('Customer vehicle accessible', true),
                  ],
                ),
              ),
            ),
            const Spacer(),
            CustomButton(
              text: 'Start Job',
              onPressed: _isStarting ? () {} : () => _startJob(booking),
              isLoading: _isStarting,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'You will be able to upload before photos after starting',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String text, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(
            isChecked ? Icons.check_circle : Icons.circle_outlined,
            color: isChecked ? AppColors.success : AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
