import 'package:flutter/material.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/helpers.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_input.dart';
import '../../shared/services/firestore_service.dart';
import '../../shared/models/user_model.dart';

class AddTechnicianScreen extends StatefulWidget {
  const AddTechnicianScreen({super.key});

  @override
  State<AddTechnicianScreen> createState() => _AddTechnicianScreenState();
}

class _AddTechnicianScreenState extends State<AddTechnicianScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _addTechnician() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final technician = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        phone: '+91${_phoneController.text.trim()}',
        email: _emailController.text.trim(),
        userType: 'technician',
        createdAt: DateTime.now(),
        isActive: true,
      );

      try {
        await _firestoreService.createTechnician(technician);

        if (mounted) {
          Helpers.showSnackBar(
            context,
            'Technician added successfully! They can now login with phone: ${_phoneController.text}',
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          Helpers.showSnackBar(
            context,
            'Failed to add technician: ${e.toString()}',
            isError: true,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Technician'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Technician will receive login credentials via phone',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              CustomInput(
                label: 'Full Name',
                placeholder: 'e.g., Ramesh Kumar',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter technician name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              CustomInput(
                label: 'Mobile Number',
                placeholder: 'e.g., 9876543210',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    '+91',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  if (!Helpers.isValidPhone(value)) {
                    return 'Please enter a valid 10-digit mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              CustomInput(
                label: 'Email (Optional)',
                placeholder: 'e.g., technician@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!Helpers.isValidEmail(value)) {
                      return 'Please enter a valid email';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Card(
                color: AppColors.primary.withOpacity(0.05),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Default Settings',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildInfoRow('Status', 'Active'),
                      _buildInfoRow('User Type', 'Technician'),
                      _buildInfoRow('Login Method', 'Phone OTP'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              CustomButton(
                text: 'Add Technician',
                onPressed: _addTechnician,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall,
          ),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
