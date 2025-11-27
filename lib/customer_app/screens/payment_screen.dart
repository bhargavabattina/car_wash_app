import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/models/service_model.dart';
import '../../shared/models/car_model.dart';
import '../../shared/models/booking_model.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/helpers.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/booking_provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'UPI';
  bool _isProcessing = false;

  void _processPayment(Map<String, dynamic> args) async {
    setState(() {
      _isProcessing = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

    final service = args['service'] as ServiceModel;
    final car = args['car'] as CarModel;
    final date = args['date'] as DateTime;
    final time = args['time'] as String;
    final location = args['location'] as String;
    final latitude = args['latitude'] as double;
    final longitude = args['longitude'] as double;

    final booking = BookingModel(
      id: '',
      customerId: authProvider.currentUser!.id,
      customerName: authProvider.currentUser!.name,
      customerPhone: authProvider.currentUser!.phone,
      serviceId: service.id,
      serviceName: service.name,
      carId: car.id,
      carDetails: car.displayName,
      scheduledDate: date,
      scheduledTime: time,
      location: location,
      latitude: latitude,
      longitude: longitude,
      totalPrice: service.basePrice,
      paymentMethod: _selectedPaymentMethod,
      paymentStatus: _selectedPaymentMethod == 'Cash' ? 'pending' : 'paid',
      bookingStatus: 'pending',
      createdAt: DateTime.now(),
    );

    try {
      final bookingId = await bookingProvider.createBooking(booking);

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.bookingConfirmation,
          (route) => false,
          arguments: bookingId,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        Helpers.showSnackBar(context, 'Booking failed. Please try again.', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final service = args['service'] as ServiceModel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: AppTextStyles.heading3,
                          ),
                          Text(
                            service.priceDisplay,
                            style: AppTextStyles.heading2.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Payment Options',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildPaymentOption(
                    title: 'UPI',
                    subtitle: 'Pay via Google Pay, PhonePe, Paytm',
                    icon: Icons.phone_android,
                    value: 'UPI',
                  ),
                  _buildPaymentOption(
                    title: 'Credit/Debit Card',
                    subtitle: 'Visa, Mastercard, Rupay',
                    icon: Icons.credit_card,
                    value: 'Card',
                  ),
                  _buildPaymentOption(
                    title: 'Cash on Service',
                    subtitle: 'Pay after service completion',
                    icon: Icons.money,
                    value: 'Cash',
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
                text: 'Pay Now',
                onPressed: _isProcessing ? () {} : () => _processPayment(args),
                isLoading: _isProcessing,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
  }) {
    final isSelected = _selectedPaymentMethod == value;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.heading3,
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySmall,
        ),
        trailing: Radio<String>(
          value: value,
          groupValue: _selectedPaymentMethod,
          onChanged: (String? newValue) {
            setState(() {
              _selectedPaymentMethod = newValue!;
            });
          },
          activeColor: AppColors.primary,
        ),
        onTap: () {
          setState(() {
            _selectedPaymentMethod = value;
          });
        },
      ),
    );
  }
}
