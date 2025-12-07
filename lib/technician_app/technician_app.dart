import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/providers/auth_provider.dart';
import '../shared/providers/booking_provider.dart';
import '../shared/providers/technician_provider.dart';
import '../shared/utils/constants.dart';
import 'screens/technician_dashboard_screen.dart';
import 'screens/jobs_list_screen.dart';
import 'screens/job_details_screen.dart';
import 'screens/start_job_screen.dart';
import 'screens/upload_photos_screen.dart';
import 'screens/technician_profile_screen.dart';
import 'screens/earnings_screen.dart';

class TechnicianMobileApp extends StatelessWidget {
  const TechnicianMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => TechnicianProvider()),
      ],
      child: MaterialApp(
        title: 'Car Wash - Technician',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.orange[700],
          scaffoldBackgroundColor: Colors.grey[50],
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orange[700]!,
            primary: Colors.orange[700]!,
            secondary: Colors.deepOrange[600]!,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.orange[700],
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              elevation: 3,
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.orange[700],
            foregroundColor: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(color: Colors.orange[700]!, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const TechnicianDashboardScreen(),
          '/jobs-list': (context) => const JobsListScreen(),
          '/job-details': (context) => const JobDetailsScreen(),
          '/start-job': (context) => const StartJobScreen(),
          '/upload-photos': (context) => const UploadPhotosScreen(),
          '/profile': (context) => const TechnicianProfileScreen(),
          '/earnings': (context) => const EarningsScreen(),
        },
      ),
    );
  }
}
