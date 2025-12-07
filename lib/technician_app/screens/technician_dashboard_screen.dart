import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/utils/constants.dart';
import '../../shared/widgets/booking_card.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/technician_provider.dart';
import '../../shared/utils/routes.dart';

class TechnicianDashboardScreen extends StatefulWidget {
  const TechnicianDashboardScreen({super.key});

  @override
  State<TechnicianDashboardScreen> createState() => _TechnicianDashboardScreenState();
}

class _TechnicianDashboardScreenState extends State<TechnicianDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final technicianProvider = Provider.of<TechnicianProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      await technicianProvider.loadTechnicianJobs(authProvider.currentUser!.id);
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
                  'Hello ${authProvider.currentUser?.name ?? "Technician"} 👋',
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
              Navigator.pushNamed(context, AppRoutes.technicianProfile);
            },
          ),
        ],
      ),
      body: Consumer<TechnicianProvider>(
        builder: (context, technicianProvider, child) {
          return RefreshIndicator(
            onRefresh: _loadJobs,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    color: AppColors.primary,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: "Today's Jobs",
                            count: technicianProvider.todayJobs.length.toString(),
                            icon: Icons.event,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _buildStatCard(
                            title: 'Pending',
                            count: technicianProvider.pendingJobs.length.toString(),
                            icon: Icons.pending,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: AppColors.primary,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'In Progress',
                            count: technicianProvider.inProgressJobs.length.toString(),
                            icon: Icons.work,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _buildStatCard(
                            title: 'Completed',
                            count: technicianProvider.completedJobs.length.toString(),
                            icon: Icons.check_circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'New Jobs',
                          style: AppTextStyles.heading2,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.jobsList);
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                  ),
                  if (technicianProvider.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: CircularProgressIndicator(),
                    )
                  else if (technicianProvider.pendingJobs.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.work_off,
                            size: 60,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'No pending jobs',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      itemCount: technicianProvider.pendingJobs.length > 3
                          ? 3
                          : technicianProvider.pendingJobs.length,
                      itemBuilder: (context, index) {
                        final job = technicianProvider.pendingJobs[index];
                        return BookingCard(
                          booking: job,
                          onTap: () {
                            technicianProvider.setCurrentJob(job);
                            Navigator.pushNamed(
                              context,
                              AppRoutes.jobDetails,
                              arguments: job,
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: AppSpacing.sm),
            Text(
              count,
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
