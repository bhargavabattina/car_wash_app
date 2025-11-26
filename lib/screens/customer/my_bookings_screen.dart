import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/booking_card.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      await bookingProvider.loadUserBookings(authProvider.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          if (bookingProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (bookingProvider.bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.event_busy,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'No bookings yet',
                    style: AppTextStyles.heading2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Your booking history will appear here',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadBookings,
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: bookingProvider.bookings.length,
              itemBuilder: (context, index) {
                final booking = bookingProvider.bookings[index];
                return BookingCard(
                  booking: booking,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.bookingTracking,
                      arguments: booking.id,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
