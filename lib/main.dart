import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/technician_provider.dart';

import 'utils/routes.dart';
import 'utils/constants.dart';

import 'screens/customer/splash_screen.dart';
import 'screens/customer/login_screen.dart';
import 'screens/customer/otp_verification_screen.dart';
import 'screens/customer/home_screen.dart';
import 'screens/customer/add_car_screen.dart';
import 'screens/customer/service_details_screen.dart';
import 'screens/customer/select_car_screen.dart';
import 'screens/customer/select_date_time_screen.dart';
import 'screens/customer/select_location_screen.dart';
import 'screens/customer/booking_summary_screen.dart';
import 'screens/customer/payment_screen.dart';
import 'screens/customer/booking_confirmation_screen.dart';
import 'screens/customer/booking_tracking_screen.dart';
import 'screens/customer/my_bookings_screen.dart';
import 'screens/customer/profile_screen.dart';
import 'screens/customer/subscription_plans_screen.dart';

import 'screens/technician/technician_dashboard_screen.dart';
import 'screens/technician/jobs_list_screen.dart';
import 'screens/technician/job_details_screen.dart';
import 'screens/technician/start_job_screen.dart';
import 'screens/technician/upload_photos_screen.dart';
import 'screens/technician/technician_profile_screen.dart';
import 'screens/technician/earnings_screen.dart';

import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/all_bookings_screen.dart';
import 'screens/admin/manage_technicians_screen.dart';
import 'screens/admin/add_technician_screen.dart';
import 'screens/admin/manage_services_screen.dart';
import 'screens/admin/manage_pricing_screen.dart';
import 'screens/admin/payments_report_screen.dart';
import 'screens/admin/customer_list_screen.dart';
import 'screens/admin/offers_coupons_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => TechnicianProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.accent,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            ),
          ),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.splash,
        routes: {
          // Customer Routes
          AppRoutes.splash: (context) => const SplashScreen(),
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.otpVerification: (context) => const OTPVerificationScreen(),
          AppRoutes.customerHome: (context) => const HomeScreen(),
          AppRoutes.addCar: (context) => const AddCarScreen(),
          AppRoutes.serviceDetails: (context) => const ServiceDetailsScreen(),
          AppRoutes.selectCar: (context) => const SelectCarScreen(),
          AppRoutes.selectDateTime: (context) => const SelectDateTimeScreen(),
          AppRoutes.selectLocation: (context) => const SelectLocationScreen(),
          AppRoutes.bookingSummary: (context) => const BookingSummaryScreen(),
          AppRoutes.payment: (context) => const PaymentScreen(),
          AppRoutes.bookingConfirmation: (context) => const BookingConfirmationScreen(),
          AppRoutes.bookingTracking: (context) => const BookingTrackingScreen(),
          AppRoutes.myBookings: (context) => const MyBookingsScreen(),
          AppRoutes.customerProfile: (context) => const ProfileScreen(),
          AppRoutes.subscriptionPlans: (context) => const SubscriptionPlansScreen(),

          // Technician Routes
          AppRoutes.technicianDashboard: (context) => const TechnicianDashboardScreen(),
          AppRoutes.jobsList: (context) => const JobsListScreen(),
          AppRoutes.jobDetails: (context) => const JobDetailsScreen(),
          AppRoutes.startJob: (context) => const StartJobScreen(),
          AppRoutes.uploadPhotos: (context) => const UploadPhotosScreen(),
          AppRoutes.technicianProfile: (context) => const TechnicianProfileScreen(),
          AppRoutes.technicianEarnings: (context) => const EarningsScreen(),

          // Admin Routes
          AppRoutes.adminDashboard: (context) => const AdminDashboardScreen(),
          AppRoutes.allBookings: (context) => const AllBookingsScreen(),
          AppRoutes.manageTechnicians: (context) => const ManageTechniciansScreen(),
          AppRoutes.addTechnician: (context) => const AddTechnicianScreen(),
          AppRoutes.manageServices: (context) => const ManageServicesScreen(),
          AppRoutes.managePricing: (context) => const ManagePricingScreen(),
          AppRoutes.paymentsReport: (context) => const PaymentsReportScreen(),
          AppRoutes.customerList: (context) => const CustomerListScreen(),
          AppRoutes.offersAndCoupons: (context) => const OffersAndCouponsScreen(),
        },
      ),
    );
  }
}
