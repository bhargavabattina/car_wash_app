import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/helpers.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_input.dart';
import '../../shared/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _sendOTP() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      try {
        await authProvider.sendOTP(_phoneController.text);
        if (mounted) {
          Navigator.pushNamed(
            context,
            AppRoutes.otpVerification,
            arguments: {
              'phone': _phoneController.text,
              'name': _nameController.text,
            },
          );
        }
      } catch (e) {
        if (mounted) {
          Helpers.showSnackBar(context, e.toString(), isError: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  const Text(
                    'Welcome Back 👋',
                    style: AppTextStyles.heading1,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomInput(
                    label: 'Your Name',
                    placeholder: 'e.g., John Doe',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      if (!Helpers.isValidPhone(value)) {
                        return 'Please enter a valid 10-digit mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  CustomButton(
                    text: 'Send OTP',
                    onPressed: _sendOTP,
                    isLoading: authProvider.isLoading,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Center(
                    child: Text(
                      AppConstants.termsAndConditions,
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
