class CarModel {
  final String id;
  final String userId;
  final String brand;
  final String model;
  final String numberPlate;
  final String carType; // 'Hatchback', 'Sedan', 'SUV'
  final DateTime createdAt;

  CarModel({
    required this.id,
    required this.userId,
    required this.brand,
    required this.model,
    required this.numberPlate,
    required this.carType,
    required this.createdAt,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      numberPlate: json['numberPlate'] ?? '',
      carType: json['carType'] ?? 'Sedan',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'brand': brand,
      'model': model,
      'numberPlate': numberPlate,
      'carType': carType,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get displayName => '$brand $model';

  CarModel copyWith({
    String? id,
    String? userId,
    String? brand,
    String? model,
    String? numberPlate,
    String? carType,
    DateTime? createdAt,
  }) {
    return CarModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      numberPlate: numberPlate ?? this.numberPlate,
      carType: carType ?? this.carType,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
