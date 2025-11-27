import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/models/service_model.dart';
import '../../shared/models/car_model.dart';
import '../../shared/utils/constants.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/car_card.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/services/firestore_service.dart';

class SelectCarScreen extends StatefulWidget {
  const SelectCarScreen({super.key});

  @override
  State<SelectCarScreen> createState() => _SelectCarScreenState();
}

class _SelectCarScreenState extends State<SelectCarScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<CarModel> _cars = [];
  CarModel? _selectedCar;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cars = await _firestoreService.getUserCars(authProvider.currentUser!.id);

    setState(() {
      _cars = cars;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final service = ModalRoute.of(context)!.settings.arguments as ServiceModel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select Your Car'),
        backgroundColor: AppColors.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Car',
                          style: AppTextStyles.heading2,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (_cars.isEmpty)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.directions_car_outlined,
                                    size: 48,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  const Text(
                                    'No cars added yet',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, AppRoutes.addCar)
                                          .then((_) => _loadCars());
                                    },
                                    child: const Text('Add Car'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _cars.length,
                            itemBuilder: (context, index) {
                              return CarCard(
                                car: _cars[index],
                                isSelected: _selectedCar?.id == _cars[index].id,
                                onTap: () {
                                  setState(() {
                                    _selectedCar = _cars[index];
                                  });
                                },
                              );
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
                      text: 'Continue',
                      onPressed: _selectedCar == null
                          ? () {}
                          : () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.selectDateTime,
                                arguments: {
                                  'service': service,
                                  'car': _selectedCar,
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
