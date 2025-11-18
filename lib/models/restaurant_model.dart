/// RestaurantModel - Model in MVVM pattern
/// Represents restaurant data structure
class RestaurantModel {
  final String id;
  final String name;
  final String category;
  final String distance;
  final double rating;
  final String tables;
  final String? imagePath;
  bool isFavorite;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.category,
    required this.distance,
    required this.rating,
    required this.tables,
    this.imagePath,
    this.isFavorite = false,
  });

  // Convert RestaurantModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'distance': distance,
      'rating': rating,
      'tables': tables,
      'imagePath': imagePath,
      'isFavorite': isFavorite,
    };
  }

  // Create RestaurantModel from JSON
  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      distance: json['distance'] as String,
      rating: (json['rating'] as num).toDouble(),
      tables: json['tables'] as String,
      imagePath: json['imagePath'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  // Create a copy of the restaurant with some fields updated
  RestaurantModel copyWith({
    String? id,
    String? name,
    String? category,
    String? distance,
    double? rating,
    String? tables,
    String? imagePath,
    bool? isFavorite,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      distance: distance ?? this.distance,
      rating: rating ?? this.rating,
      tables: tables ?? this.tables,
      imagePath: imagePath ?? this.imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

