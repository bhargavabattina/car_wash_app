import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/helpers.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_input.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/services/firestore_service.dart';
import '../../shared/models/car_model.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _numberPlateController = TextEditingController();
  String _selectedCarType = 'Sedan';
  bool _isLoading = false;

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _numberPlateController.dispose();
    super.dispose();
  }

  void _saveCar() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final car = CarModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: authProvider.currentUser!.id,
        brand: _brandController.text,
        model: _modelController.text,
        numberPlate: _numberPlateController.text.toUpperCase(),
        carType: _selectedCarType,
        createdAt: DateTime.now(),
      );

      try {
        await _firestoreService.addCar(car);
        if (mounted) {
          Helpers.showSnackBar(context, 'Car added successfully!');
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          Helpers.showSnackBar(context, 'Failed to add car', isError: true);
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Your Car'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInput(
                label: 'Car Brand',
                placeholder: 'e.g., Honda',
                controller: _brandController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter car brand';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              CustomInput(
                label: 'Car Model',
                placeholder: 'e.g., City',
                controller: _modelController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter car model';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              CustomInput(
                label: 'Number Plate',
                placeholder: 'e.g., TN 01 AB 1234',
                controller: _numberPlateController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number plate';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Car Type',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: AppConstants.carTypes.map((type) {
                  return ChoiceChip(
                    label: Text(type),
                    selected: _selectedCarType == type,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCarType = type;
                      });
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: _selectedCarType == type
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.xl),
              CustomButton(
                text: 'Save Car',
                onPressed: _saveCar,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
