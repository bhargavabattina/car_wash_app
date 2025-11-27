import 'package:flutter/material.dart';
import '../../shared/utils/constants.dart';
import '../../shared/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadCurrentUser();

    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      if (authProvider.currentUser?.userType == 'customer') {
        Navigator.pushReplacementNamed(context, AppRoutes.customerHome);
      } else if (authProvider.currentUser?.userType == 'technician') {
        Navigator.pushReplacementNamed(context, AppRoutes.technicianDashboard);
      } else if (authProvider.currentUser?.userType == 'admin') {
        Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Icon(
              Icons.local_car_wash,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              AppConstants.appName,
              style: AppTextStyles.heading1.copyWith(
                color: Colors.white,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppConstants.appTagline,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white70,
              ),
            ),
            const Spacer(),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              AppConstants.poweredBy,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
