import 'package:flutter/material.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/helpers.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_input.dart';
import '../../shared/services/firestore_service.dart';
import '../../shared/models/service_model.dart';

class ManageServicesScreen extends StatefulWidget {
  const ManageServicesScreen({super.key});

  @override
  State<ManageServicesScreen> createState() => _ManageServicesScreenState();
}

class _ManageServicesScreenState extends State<ManageServicesScreen> {
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

  void _showAddServiceDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    final durationController = TextEditingController();
    final includesController = TextEditingController();
    String selectedCategory = 'basic';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Service'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomInput(
                  label: 'Service Name',
                  controller: nameController,
                  placeholder: 'e.g., Premium Wash',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                CustomInput(
                  label: 'Description',
                  controller: descController,
                  placeholder: 'Short description',
                  maxLines: 2,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                CustomInput(
                  label: 'Base Price (₹)',
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  placeholder: '349',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                CustomInput(
                  label: 'Duration (minutes)',
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  placeholder: '45',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: ['basic', 'premium', 'detailing', 'interior', 'express']
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedCategory = value!;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                CustomInput(
                  label: 'Includes (comma separated)',
                  controller: includesController,
                  placeholder: 'Exterior wash, Polish, Vacuum',
                  maxLines: 3,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) {
                return;
              }

              final service = ServiceModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text.trim(),
                description: descController.text.trim(),
                basePrice: double.parse(priceController.text),
                estimatedMinutes: int.parse(durationController.text),
                category: selectedCategory,
                includes: includesController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList(),
                isActive: true,
              );

              try {
                await _firestoreService.createService(service);
                if (mounted) {
                  Navigator.pop(context);
                  Helpers.showSnackBar(context, 'Service added successfully!');
                  _loadServices();
                }
              } catch (e) {
                if (mounted) {
                  Helpers.showSnackBar(
                    context,
                    'Failed to add service: ${e.toString()}',
                    isError: true,
                  );
                }
              }
            },
            child: const Text('Add Service'),
          ),
        ],
      ),
    );
  }

  void _showEditServiceDialog(ServiceModel service) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: service.name);
    final descController = TextEditingController(text: service.description);
    final priceController = TextEditingController(text: service.basePrice.toString());
    final durationController = TextEditingController(text: service.estimatedMinutes.toString());
    final includesController = TextEditingController(text: service.includes.join(', '));
    String selectedCategory = service.category;
    bool isActive = service.isActive;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Service'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomInput(
                    label: 'Service Name',
                    controller: nameController,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomInput(
                    label: 'Description',
                    controller: descController,
                    maxLines: 2,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomInput(
                    label: 'Base Price (₹)',
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomInput(
                    label: 'Duration (minutes)',
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: ['basic', 'premium', 'detailing', 'interior', 'express']
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      selectedCategory = value!;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  CustomInput(
                    label: 'Includes (comma separated)',
                    controller: includesController,
                    maxLines: 3,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SwitchListTile(
                    title: const Text('Active'),
                    value: isActive,
                    onChanged: (value) {
                      setDialogState(() {
                        isActive = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                try {
                  await _firestoreService.updateService(service.id, {
                    'name': nameController.text.trim(),
                    'description': descController.text.trim(),
                    'basePrice': double.parse(priceController.text),
                    'estimatedMinutes': int.parse(durationController.text),
                    'category': selectedCategory,
                    'includes': includesController.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList(),
                    'isActive': isActive,
                  });

                  if (mounted) {
                    Navigator.pop(context);
                    Helpers.showSnackBar(context, 'Service updated successfully!');
                    _loadServices();
                  }
                } catch (e) {
                  if (mounted) {
                    Helpers.showSnackBar(
                      context,
                      'Failed to update service: ${e.toString()}',
                      isError: true,
                    );
                  }
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteService(ServiceModel service) {
    Helpers.showConfirmDialog(
      context: context,
      title: 'Delete Service',
      message: 'Are you sure you want to delete "${service.name}"?',
      onConfirm: () async {
        try {
          await _firestoreService.deleteService(service.id);
          Helpers.showSnackBar(context, 'Service deleted successfully!');
          _loadServices();
        } catch (e) {
          Helpers.showSnackBar(
            context,
            'Failed to delete service: ${e.toString()}',
            isError: true,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Services'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddServiceDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _services.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.local_car_wash_outlined,
                        size: 80,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'No services found',
                        style: AppTextStyles.heading2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Tap + to add your first service',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadServices,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: _services.length,
                    itemBuilder: (context, index) {
                      final service = _services[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(AppBorderRadius.md),
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
                            '${service.priceDisplay} • ${service.durationDisplay} • ${service.category}',
                            style: AppTextStyles.bodySmall,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: service.isActive
                                      ? AppColors.success.withOpacity(0.1)
                                      : AppColors.error.withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(AppBorderRadius.sm),
                                ),
                                child: Text(
                                  service.isActive ? 'Active' : 'Inactive',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: service.isActive
                                        ? AppColors.success
                                        : AppColors.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 20),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, size: 20, color: AppColors.error),
                                        SizedBox(width: 8),
                                        Text('Delete', style: TextStyle(color: AppColors.error)),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showEditServiceDialog(service);
                                  } else if (value == 'delete') {
                                    _deleteService(service);
                                  }
                                },
                              ),
                            ],
                          ),
                          onTap: () => _showEditServiceDialog(service),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
