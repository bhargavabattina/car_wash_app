import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/helpers.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/booking_provider.dart';
import '../../shared/services/firestore_service.dart';
import '../../shared/models/car_model.dart';
import '../../shared/models/service_model.dart';
import '../../shared/widgets/car_card.dart';
import '../../shared/widgets/service_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<CarModel> _cars = [];
  List<ServiceModel> _services = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      final cars = await _firestoreService.getUserCars(authProvider.currentUser!.id);
      final services = await _firestoreService.getServices();

      setState(() {
        _cars = cars;
        _services = services;
      });

      await bookingProvider.loadServices();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${Helpers.getGreeting()} 👋',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),
                Text(
                  authProvider.currentUser?.name ?? 'User',
                  style: AppTextStyles.heading3.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.customerProfile);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Your Cars', style: AppTextStyles.heading2),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.addCar).then((_) => _loadData());
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Car'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              if (_cars.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.directions_car_outlined,
                            size: 48,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'No cars added yet',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _cars.length > 2 ? 2 : _cars.length,
                  itemBuilder: (context, index) {
                    return CarCard(
                      car: _cars[index],
                      onTap: () {},
                    );
                  },
                ),
              const SizedBox(height: AppSpacing.lg),
              Text('Our Services', style: AppTextStyles.heading2),
              const SizedBox(height: AppSpacing.md),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _services.length,
                itemBuilder: (context, index) {
                  return ServiceCard(
                    service: _services[index],
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.serviceDetails,
                        arguments: _services[index],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.myBookings);
        },
        icon: const Icon(Icons.history),
        label: const Text('My Bookings'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
