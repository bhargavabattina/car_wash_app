import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/providers/auth_provider.dart';
import '../shared/providers/booking_provider.dart';
import '../shared/providers/technician_provider.dart';
import 'widgets/admin_sidebar.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/manage_services_screen.dart';
import 'screens/manage_technicians_screen.dart';
import 'screens/manage_pricing_screen.dart';
import 'screens/all_bookings_screen.dart';
import 'screens/payments_report_screen.dart';
import 'screens/customer_list_screen.dart';
import 'screens/offers_coupons_screen.dart';

class AdminWebApp extends StatelessWidget {
  const AdminWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => TechnicianProvider()),
      ],
      child: MaterialApp(
        title: 'Car Wash Admin Dashboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF2196F3),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.interTextTheme(),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          primaryColor: const Color(0xFF2196F3),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2196F3),
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.light,
        home: const AdminMainLayout(),
      ),
    );
  }
}

class AdminMainLayout extends StatefulWidget {
  const AdminMainLayout({super.key});

  @override
  State<AdminMainLayout> createState() => _AdminMainLayoutState();
}

class _AdminMainLayoutState extends State<AdminMainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AdminDashboardScreen(),
    const ManageServicesScreen(),
    const ManageTechniciansScreen(),
    const ManagePricingScreen(),
    const AllBookingsScreen(),
    const PaymentsReportScreen(),
    const CustomerListScreen(),
    const OffersAndCouponsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          AdminSidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          // Main Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[50]!,
                    Colors.blue[50]!,
                  ],
                ),
              ),
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
