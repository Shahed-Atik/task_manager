import 'package:dio_refresh_bot/dio_refresh_bot.dart';

class User extends AuthToken {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String image;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.image,
    required String token,
    required super.refreshToken,
  }) : super(accessToken: token);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'image': image,
      'token': accessToken,
      'refreshToken': refreshToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      username: map['username'] as String,
      email: map['email'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      gender: map['gender'] as String,
      image: map['image'] as String,
      token: map['token'] as String,
      refreshToken: map['refreshToken'] as String,
    );
  }

  @override
  User copyWith(
      {int? id,
      String? username,
      String? email,
      String? firstName,
      String? lastName,
      String? gender,
      String? image,
      String? accessToken,
      int? expiresIn,
      String? refreshToken,
      String? tokenType}) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      image: image ?? this.image,
      token: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
