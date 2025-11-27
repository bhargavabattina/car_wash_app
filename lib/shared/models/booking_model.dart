class BookingModel {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String serviceId;
  final String serviceName;
  final String carId;
  final String carDetails;
  final DateTime scheduledDate;
  final String scheduledTime;
  final String location;
  final double latitude;
  final double longitude;
  final double totalPrice;
  final String paymentMethod; // 'UPI', 'Card', 'Cash'
  final String paymentStatus; // 'pending', 'paid', 'failed'
  final String bookingStatus; // 'pending', 'assigned', 'on_the_way', 'in_progress', 'completed', 'cancelled'
  final String? technicianId;
  final String? technicianName;
  final String? technicianPhone;
  final List<String> beforePhotos;
  final List<String> afterPhotos;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? remarks;

  BookingModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.serviceId,
    required this.serviceName,
    required this.carId,
    required this.carDetails,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.totalPrice,
    required this.paymentMethod,
    this.paymentStatus = 'pending',
    this.bookingStatus = 'pending',
    this.technicianId,
    this.technicianName,
    this.technicianPhone,
    this.beforePhotos = const [],
    this.afterPhotos = const [],
    required this.createdAt,
    this.completedAt,
    this.remarks,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      serviceId: json['serviceId'] ?? '',
      serviceName: json['serviceName'] ?? '',
      carId: json['carId'] ?? '',
      carDetails: json['carDetails'] ?? '',
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'])
          : DateTime.now(),
      scheduledTime: json['scheduledTime'] ?? '',
      location: json['location'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? 'Cash',
      paymentStatus: json['paymentStatus'] ?? 'pending',
      bookingStatus: json['bookingStatus'] ?? 'pending',
      technicianId: json['technicianId'],
      technicianName: json['technicianName'],
      technicianPhone: json['technicianPhone'],
      beforePhotos: List<String>.from(json['beforePhotos'] ?? []),
      afterPhotos: List<String>.from(json['afterPhotos'] ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'carId': carId,
      'carDetails': carDetails,
      'scheduledDate': scheduledDate.toIso8601String(),
      'scheduledTime': scheduledTime,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'totalPrice': totalPrice,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'bookingStatus': bookingStatus,
      'technicianId': technicianId,
      'technicianName': technicianName,
      'technicianPhone': technicianPhone,
      'beforePhotos': beforePhotos,
      'afterPhotos': afterPhotos,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'remarks': remarks,
    };
  }

  String get priceDisplay => '₹${totalPrice.toStringAsFixed(0)}';

  String get statusDisplay {
    switch (bookingStatus) {
      case 'pending':
        return 'Pending';
      case 'assigned':
        return 'Technician Assigned';
      case 'on_the_way':
        return 'On the Way';
      case 'in_progress':
        return 'Washing Started';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  BookingModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? serviceId,
    String? serviceName,
    String? carId,
    String? carDetails,
    DateTime? scheduledDate,
    String? scheduledTime,
    String? location,
    double? latitude,
    double? longitude,
    double? totalPrice,
    String? paymentMethod,
    String? paymentStatus,
    String? bookingStatus,
    String? technicianId,
    String? technicianName,
    String? technicianPhone,
    List<String>? beforePhotos,
    List<String>? afterPhotos,
    DateTime? createdAt,
    DateTime? completedAt,
    String? remarks,
  }) {
    return BookingModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      carId: carId ?? this.carId,
      carDetails: carDetails ?? this.carDetails,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      technicianId: technicianId ?? this.technicianId,
      technicianName: technicianName ?? this.technicianName,
      technicianPhone: technicianPhone ?? this.technicianPhone,
      beforePhotos: beforePhotos ?? this.beforePhotos,
      afterPhotos: afterPhotos ?? this.afterPhotos,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      remarks: remarks ?? this.remarks,
    );
  }
}
