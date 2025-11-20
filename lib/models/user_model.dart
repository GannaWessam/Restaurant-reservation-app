/// UserModel - Model in MVVM pattern
/// Represents user data structure
class UserModel {
  final String uid; 
  final String? fullName;
  final String? email;
  final String? password;
  final double? currentLat;
  final double? currentLng;
  final List<String>? favoritePlaces;

  UserModel({
    required this.uid,
    this.fullName,
    this.email,
    this.password,
    this.currentLat,
    this.currentLng,
    this.favoritePlaces,
  });

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'currentLat': currentLat,
      'currentLng': currentLng,
      'favoritePlaces': favoritePlaces,
    };
  }

  // Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      fullName: json['fullName'],
      email: json['email'],
      currentLat: json['currentLat'],
      currentLng: json['currentLng'],
      favoritePlaces: json['favoritePlaces'] != null
          ? List<String>.from(json['favoritePlaces'])
          : null,
    );
  }
}

