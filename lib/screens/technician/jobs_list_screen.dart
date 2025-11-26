import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../utils/routes.dart';
import '../../widgets/booking_card.dart';
import '../../providers/technician_provider.dart';

class JobsListScreen extends StatelessWidget {
  const JobsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('All Jobs'),
          backgroundColor: AppColors.primary,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'In Progress'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: Consumer<TechnicianProvider>(
          builder: (context, technicianProvider, child) {
            return TabBarView(
              children: [
                _buildJobsList(
                  context,
                  technicianProvider.pendingJobs,
                  technicianProvider,
                ),
                _buildJobsList(
                  context,
                  technicianProvider.inProgressJobs,
                  technicianProvider,
                ),
                _buildJobsList(
                  context,
                  technicianProvider.completedJobs,
                  technicianProvider,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildJobsList(
    BuildContext context,
    List jobs,
    TechnicianProvider provider,
  ) {
    if (jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.work_off,
              size: 60,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No jobs found',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return BookingCard(
          booking: job,
          onTap: () {
            provider.setCurrentJob(job);
            Navigator.pushNamed(
              context,
              AppRoutes.jobDetails,
              arguments: job,
            );
          },
        );
      },
    );
  }
}
