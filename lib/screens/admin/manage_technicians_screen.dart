import 'package:flutter/material.dart';
import '../../utils/constants.dart';
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
            onPressed: () {},
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
                          subtitle: Text(
                            technician.phone,
                            style: AppTextStyles.bodySmall,
                          ),
                          trailing: Container(
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
                          onTap: () {},
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
