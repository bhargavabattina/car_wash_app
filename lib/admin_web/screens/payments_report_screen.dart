import 'package:flutter/material.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/helpers.dart';
import '../../shared/services/firestore_service.dart';
import '../../shared/models/booking_model.dart';

class PaymentsReportScreen extends StatefulWidget {
  const PaymentsReportScreen({super.key});

  @override
  State<PaymentsReportScreen> createState() => _PaymentsReportScreenState();
}

class _PaymentsReportScreenState extends State<PaymentsReportScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<BookingModel> _bookings = [];
  bool _isLoading = true;

  double _totalRevenue = 0;
  int _totalBookings = 0;
  Map<String, double> _paymentMethodBreakdown = {};
  Map<String, int> _paymentMethodCount = {};

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    setState(() => _isLoading = true);

    final bookings = await _firestoreService.getAllBookings();
    final paidBookings = bookings
        .where((b) => b.paymentStatus == 'paid' || b.bookingStatus == 'completed')
        .toList();

    double totalRevenue = 0;
    Map<String, double> methodBreakdown = {};
    Map<String, int> methodCount = {};

    for (var booking in paidBookings) {
      totalRevenue += booking.totalPrice;

      methodBreakdown[booking.paymentMethod] =
          (methodBreakdown[booking.paymentMethod] ?? 0) + booking.totalPrice;

      methodCount[booking.paymentMethod] =
          (methodCount[booking.paymentMethod] ?? 0) + 1;
    }

    setState(() {
      _bookings = paidBookings;
      _totalRevenue = totalRevenue;
      _totalBookings = paidBookings.length;
      _paymentMethodBreakdown = methodBreakdown;
      _paymentMethodCount = methodCount;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Payments Report'),
        backgroundColor: AppColors.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPayments,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: AppColors.primary,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                              size: 48,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Total Revenue',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              Helpers.formatCurrency(_totalRevenue),
                              style: AppTextStyles.heading1.copyWith(
                                color: Colors.white,
                                fontSize: 36,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'From $_totalBookings bookings',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Payment Method Breakdown',
                      style: AppTextStyles.heading2,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (_paymentMethodBreakdown.isEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Center(
                            child: Text(
                              'No payment data available',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      ..._paymentMethodBreakdown.entries.map((entry) {
                        final method = entry.key;
                        final amount = entry.value;
                        final count = _paymentMethodCount[method] ?? 0;
                        final percentage = (_totalRevenue > 0)
                            ? (amount / _totalRevenue * 100)
                            : 0;

                        IconData icon;
                        Color color;

                        switch (method.toLowerCase()) {
                          case 'upi':
                            icon = Icons.phone_android;
                            color = Colors.purple;
                            break;
                          case 'card':
                            icon = Icons.credit_card;
                            color = Colors.blue;
                            break;
                          case 'cash':
                            icon = Icons.money;
                            color = Colors.green;
                            break;
                          default:
                            icon = Icons.payment;
                            color = AppColors.primary;
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(AppSpacing.sm),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                        AppBorderRadius.md),
                                  ),
                                  child: Icon(icon, color: color),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        method,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        '$count transactions',
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      Helpers.formatCurrency(amount),
                                      style: AppTextStyles.heading3.copyWith(
                                        color: color,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      '${percentage.toStringAsFixed(1)}%',
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Recent Transactions',
                      style: AppTextStyles.heading2,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ..._bookings.take(10).map((booking) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(AppBorderRadius.md),
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                            ),
                          ),
                          title: Text(
                            booking.serviceName,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '${Helpers.formatDate(booking.createdAt)} • ${booking.paymentMethod}',
                            style: AppTextStyles.bodySmall,
                          ),
                          trailing: Text(
                            booking.priceDisplay,
                            style: AppTextStyles.heading3.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
    );
  }
}
