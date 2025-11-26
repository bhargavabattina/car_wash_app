import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../utils/routes.dart';
import '../../services/firestore_service.dart';
import '../../models/user_model.dart';

class ManageTechniciansScreen extends StatefulWidget {
  const ManageTechniciansScreen({super.key});

  @override
  State<ManageTechniciansScreen> createState() => _ManageTechniciansScreenState();
}

class _ManageTechniciansScreenState extends State<ManageTechniciansScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<UserModel> _technicians = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTechnicians();
  }

  Future<void> _loadTechnicians() async {
    setState(() {
      _isLoading = true;
    });

    final technicians = await _firestoreService.getTechnicians();

    setState(() {
      _technicians = technicians;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Technicians'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                AppRoutes.addTechnician,
              );
              if (result == true) {
                _loadTechnicians();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _technicians.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person_off,
                        size: 80,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'No technicians found',
                        style: AppTextStyles.heading2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadTechnicians,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: _technicians.length,
                    itemBuilder: (context, index) {
                      final technician = _technicians[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Text(
                              technician.name[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            technician.name,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                technician.phone,
                                style: AppTextStyles.bodySmall,
                              ),
                              if (technician.email.isNotEmpty)
                                Text(
                                  technician.email,
                                  style: AppTextStyles.bodySmall,
                                ),
                            ],
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
                                  color: technician.isActive
                                      ? AppColors.success.withOpacity(0.1)
                                      : AppColors.error.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                                ),
                                child: Text(
                                  technician.isActive ? 'Active' : 'Inactive',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: technician.isActive
                                        ? AppColors.success
                                        : AppColors.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'toggle',
                                    child: Row(
                                      children: [
                                        Icon(
                                          technician.isActive
                                              ? Icons.block
                                              : Icons.check_circle,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(technician.isActive
                                            ? 'Deactivate'
                                            : 'Activate'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete,
                                            size: 20, color: AppColors.error),
                                        SizedBox(width: 8),
                                        Text('Delete',
                                            style: TextStyle(
                                                color: AppColors.error)),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) async {
                                  if (value == 'toggle') {
                                    try {
                                      await _firestoreService
                                          .updateTechnicianStatus(
                                        technician.id,
                                        !technician.isActive,
                                      );
                                      Helpers.showSnackBar(
                                        context,
                                        'Technician ${technician.isActive ? "deactivated" : "activated"} successfully',
                                      );
                                      _loadTechnicians();
                                    } catch (e) {
                                      Helpers.showSnackBar(
                                        context,
                                        'Failed to update status',
                                        isError: true,
                                      );
                                    }
                                  } else if (value == 'delete') {
                                    Helpers.showConfirmDialog(
                                      context: context,
                                      title: 'Delete Technician',
                                      message:
                                          'Are you sure you want to delete ${technician.name}?',
                                      onConfirm: () async {
                                        try {
                                          await _firestoreService
                                              .deleteTechnician(technician.id);
                                          Helpers.showSnackBar(
                                            context,
                                            'Technician deleted successfully',
                                          );
                                          _loadTechnicians();
                                        } catch (e) {
                                          Helpers.showSnackBar(
                                            context,
                                            'Failed to delete technician',
                                            isError: true,
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
