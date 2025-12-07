import 'package:flutter/material.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/helpers.dart';
import '../../shared/widgets/custom_input.dart';
import '../../shared/services/firestore_service.dart';
import '../../shared/models/service_model.dart';

class ManagePricingScreen extends StatefulWidget {
  const ManagePricingScreen({super.key});

  @override
  State<ManagePricingScreen> createState() => _ManagePricingScreenState();
}

class _ManagePricingScreenState extends State<ManagePricingScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<ServiceModel> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() => _isLoading = true);
    final services = await _firestoreService.getAllServices();
    setState(() {
      _services = services;
      _isLoading = false;
    });
  }

  void _updatePrice(ServiceModel service) {
    final priceController = TextEditingController(
      text: service.basePrice.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Price - ${service.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomInput(
              label: 'New Price (₹)',
              controller: priceController,
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'Current price: ${service.priceDisplay}',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newPrice = double.tryParse(priceController.text);
              if (newPrice == null || newPrice <= 0) {
                Helpers.showSnackBar(
                  context,
                  'Please enter a valid price',
                  isError: true,
                );
                return;
              }

              try {
                await _firestoreService.updateService(service.id, {
                  'basePrice': newPrice,
                });

                if (context.mounted) {
                  Navigator.pop(context);
                  Helpers.showSnackBar(
                    context,
                    'Price updated successfully!',
                  );
                  _loadServices();
                }
              } catch (e) {
                if (context.mounted) {
                  Helpers.showSnackBar(
                    context,
                    'Failed to update price',
                    isError: true,
                  );
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Pricing'),
        backgroundColor: AppColors.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _services.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.price_change_outlined,
                        size: 80,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'No services to price',
                        style: AppTextStyles.heading2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadServices,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: AppColors.primary.withAlpha(26),
                          child: const Padding(
                            padding: EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    'Tap on any service to update its price',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const Text(
                          'Service Pricing',
                          style: AppTextStyles.heading2,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ..._services.map((service) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(26),
                                  borderRadius: BorderRadius.circular(
                                      AppBorderRadius.md),
                                ),
                                child: const Icon(
                                  Icons.local_car_wash,
                                  color: AppColors.primary,
                                ),
                              ),
                              title: Text(
                                service.name,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                '${service.category} • ${service.durationDisplay}',
                                style: AppTextStyles.bodySmall,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    service.priceDisplay,
                                    style: AppTextStyles.heading3.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  const Icon(Icons.edit, size: 20),
                                ],
                              ),
                              onTap: () => _updatePrice(service),
                            ),
                          );
                        }),
                        const SizedBox(height: AppSpacing.xl),
                        const Text(
                          'Car Type Multipliers',
                          style: AppTextStyles.heading2,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Column(
                              children: [
                                _buildMultiplierRow('Hatchback', '1.0x', Colors.green),
                                const Divider(),
                                _buildMultiplierRow('Sedan', '1.0x', Colors.blue),
                                const Divider(),
                                _buildMultiplierRow('SUV', '1.5x', Colors.orange),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Note: SUV prices are automatically 50% higher',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildMultiplierRow(String carType, String multiplier, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.directions_car, color: color, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                carType,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
            child: Text(
              multiplier,
              style: AppTextStyles.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
