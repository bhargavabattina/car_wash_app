class ServiceModel {
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final int estimatedMinutes;
  final String category; // 'basic', 'premium', 'detailing', 'interior'
  final List<String> includes;
  final bool isActive;
  final String? imageUrl;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.estimatedMinutes,
    required this.category,
    required this.includes,
    this.isActive = true,
    this.imageUrl,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      basePrice: (json['basePrice'] ?? 0).toDouble(),
      estimatedMinutes: json['estimatedMinutes'] ?? 30,
      category: json['category'] ?? 'basic',
      includes: List<String>.from(json['includes'] ?? []),
      isActive: json['isActive'] ?? true,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'basePrice': basePrice,
      'estimatedMinutes': estimatedMinutes,
      'category': category,
      'includes': includes,
      'isActive': isActive,
      'imageUrl': imageUrl,
    };
  }

  String get priceDisplay => '₹${basePrice.toStringAsFixed(0)}';
  String get durationDisplay => '${estimatedMinutes} mins';

  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    double? basePrice,
    int? estimatedMinutes,
    String? category,
    List<String>? includes,
    bool? isActive,
    String? imageUrl,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      category: category ?? this.category,
      includes: includes ?? this.includes,
      isActive: isActive ?? this.isActive,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
