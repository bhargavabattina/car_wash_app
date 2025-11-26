import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/service_model.dart';
import '../../models/car_model.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/custom_button.dart';

class SelectDateTimeScreen extends StatefulWidget {
  const SelectDateTimeScreen({super.key});

  @override
  State<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;

  List<DateTime> _getNext7Days() {
    return List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final service = args['service'] as ServiceModel;
    final car = args['car'] as CarModel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Choose Date & Time'),
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
                  Text(
                    'Select Date',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _getNext7Days().length,
                      itemBuilder: (context, index) {
                        final date = _getNext7Days()[index];
                        final isSelected = _selectedDate.day == date.day &&
                            _selectedDate.month == date.month &&
                            _selectedDate.year == date.year;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = date;
                            });
                          },
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.divider,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('EEE').format(date),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  DateFormat('dd').format(date),
                                  style: AppTextStyles.heading2.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  DateFormat('MMM').format(date),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Available Time Slots',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: AppConstants.timeSlots.map((slot) {
                      final isSelected = _selectedTimeSlot == slot;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTimeSlot = slot;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.md,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.divider,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            slot,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
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
                text: 'Proceed',
                onPressed: _selectedTimeSlot == null
                    ? () {}
                    : () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.selectLocation,
                          arguments: {
                            'service': service,
                            'car': car,
                            'date': _selectedDate,
                            'time': _selectedTimeSlot,
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
}
