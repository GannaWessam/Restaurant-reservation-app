class CategoryModel {
  final String id;
  final String name;
  final String? imageBase64;
  final String? description;
  final String? peakTime;
  final int restaurantCount;

  CategoryModel({
    required this.id,
    required this.name,
    this.imageBase64,
    this.description,
    this.peakTime,
    this.restaurantCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageBase64': imageBase64,
      'description': description,
      'peakTime': peakTime,
      'restaurantCount': restaurantCount,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageBase64: json['imageBase64'] as String?,
      description: json['description'] as String?,
      peakTime: json['peakTime'] as String?,
      restaurantCount: (json['restaurantCount'] as num?)?.toInt() ?? 0,
    );
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? imageBase64,
    String? description,
    String? peakTime,
    int? restaurantCount,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageBase64: imageBase64 ?? this.imageBase64,
      description: description ?? this.description,
      peakTime: peakTime ?? this.peakTime,
      restaurantCount: restaurantCount ?? this.restaurantCount,
    );
  }
}


