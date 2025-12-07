import 'package:flutter/material.dart';
import '../../shared/models/service_model.dart';
import '../../shared/models/car_model.dart';
import '../../shared/utils/constants.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_input.dart';
import '../../shared/utils/routes.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final _addressController = TextEditingController();
  String _selectedLocation = '';
  double _latitude = 0.0;
  double _longitude = 0.0;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _useCurrentLocation() {
    setState(() {
      _selectedLocation = 'Current Location';
      _latitude = 12.9716;
      _longitude = 77.5946;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final service = args['service'] as ServiceModel;
    final car = args['car'] as CarModel;
    final date = args['date'] as DateTime;
    final time = args['time'] as String;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Service Location'),
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
                    'Choose where the technician should arrive',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomButton(
                    text: 'Use Current Location',
                    onPressed: _useCurrentLocation,
                    icon: Icons.my_location,
                    isOutlined: true,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: Text(
                          'OR',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomInput(
                    label: 'Add Address Manually',
                    placeholder: 'Enter your complete address',
                    controller: _addressController,
                    maxLines: 3,
                    onChanged: (value) {
                      setState(() {
                        _selectedLocation = value;
                        _latitude = 12.9716;
                        _longitude = 77.5946;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Text(
                    'Saved Addresses',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildSavedAddressCard(
                    title: 'Home',
                    address: 'Radiant Orchid Apartments\nBuilding A, Flat 204',
                    onTap: () {
                      setState(() {
                        _selectedLocation = 'Radiant Orchid Apartments, Building A, Flat 204';
                        _latitude = 12.9716;
                        _longitude = 77.5946;
                      });
                    },
                  ),
                  _buildSavedAddressCard(
                    title: 'Office',
                    address: 'Tech Park, Tower B\n5th Floor',
                    onTap: () {
                      setState(() {
                        _selectedLocation = 'Tech Park, Tower B, 5th Floor';
                        _latitude = 12.9352;
                        _longitude = 77.6245;
                      });
                    },
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
                text: 'Confirm Location',
                onPressed: _selectedLocation.isEmpty
                    ? () {}
                    : () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.bookingSummary,
                          arguments: {
                            'service': service,
                            'car': car,
                            'date': date,
                            'time': time,
                            'location': _selectedLocation,
                            'latitude': _latitude,
                            'longitude': _longitude,
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

  Widget _buildSavedAddressCard({
    required String title,
    required String address,
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
          child: const Icon(
            Icons.location_on,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.heading3,
        ),
        subtitle: Text(
          address,
          style: AppTextStyles.bodySmall,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
