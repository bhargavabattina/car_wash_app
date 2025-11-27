import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/helpers.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/providers/booking_provider.dart';
import '../../shared/providers/technician_provider.dart';

class UploadPhotosScreen extends StatefulWidget {
  const UploadPhotosScreen({super.key});

  @override
  State<UploadPhotosScreen> createState() => _UploadPhotosScreenState();
}

class _UploadPhotosScreenState extends State<UploadPhotosScreen> {
  final ImagePicker _picker = ImagePicker();
  List<File> _beforePhotos = [];
  List<File> _afterPhotos = [];
  bool _isUploading = false;

  Future<void> _pickBeforeImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _beforePhotos = pickedFiles.map((file) => File(file.path)).toList();
    });
    }

  Future<void> _pickAfterImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _afterPhotos = pickedFiles.map((file) => File(file.path)).toList();
    });
    }

  Future<void> _submitAndComplete(String bookingId) async {
    if (_beforePhotos.isEmpty || _afterPhotos.isEmpty) {
      Helpers.showSnackBar(
        context,
        'Please upload both before and after photos',
        isError: true,
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final technicianProvider = Provider.of<TechnicianProvider>(context, listen: false);

    try {
      await bookingProvider.uploadBeforePhotos(bookingId, _beforePhotos);
      await bookingProvider.uploadAfterPhotos(bookingId, _afterPhotos);
      await bookingProvider.updateBookingStatus(bookingId, 'completed');

      final booking = bookingProvider.currentBooking;
      if (booking != null && booking.technicianId != null) {
        await technicianProvider.loadTechnicianJobs(booking.technicianId!);
      }

      if (mounted) {
        Helpers.showSnackBar(context, 'Job completed successfully!');
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.technicianDashboard,
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(
          context,
          'Failed to upload photos. Please try again.',
          isError: true,
        );
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Upload Photos'),
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
                    'Before Wash Photos',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Upload 2-4 images',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (_beforePhotos.isEmpty)
                    GestureDetector(
                      onTap: _pickBeforeImages,
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.divider.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                          border: Border.all(
                            color: AppColors.divider,
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 48,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(height: AppSpacing.sm),
                              Text('Tap to upload photos'),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _beforePhotos.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 100,
                                margin: const EdgeInsets.only(right: AppSpacing.sm),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                                  image: DecorationImage(
                                    image: FileImage(_beforePhotos[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextButton.icon(
                          onPressed: _pickBeforeImages,
                          icon: const Icon(Icons.edit),
                          label: const Text('Change Photos'),
                        ),
                      ],
                    ),
                  const SizedBox(height: AppSpacing.xl),
                  const Text(
                    'After Wash Photos',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Upload 2-4 images',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (_afterPhotos.isEmpty)
                    GestureDetector(
                      onTap: _pickAfterImages,
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.divider.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                          border: Border.all(
                            color: AppColors.divider,
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 48,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(height: AppSpacing.sm),
                              Text('Tap to upload photos'),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _afterPhotos.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 100,
                                margin: const EdgeInsets.only(right: AppSpacing.sm),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                                  image: DecorationImage(
                                    image: FileImage(_afterPhotos[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextButton.icon(
                          onPressed: _pickAfterImages,
                          icon: const Icon(Icons.edit),
                          label: const Text('Change Photos'),
                        ),
                      ],
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
                text: 'Submit & Complete Job',
                onPressed: _isUploading ? () {} : () => _submitAndComplete(bookingId),
                isLoading: _isUploading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
