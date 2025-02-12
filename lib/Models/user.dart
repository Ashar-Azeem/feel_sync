import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String userId;
  final String name;
  final String userName;
  final String bio;
  final String? profileLocation;
  final String? token;
  final int age;
  final String gender;
  final int compatibility;

  const User(
      {required this.userId,
      required this.name,
      required this.compatibility,
      required this.userName,
      required this.bio,
      this.profileLocation,
      required this.token,
      required this.age,
      required this.gender});

  User copyWith(
      {String? name,
      String? userName,
      String? bio,
      String? profileLocation,
      String? token,
      int? age,
      String? gender,
      String? userId,
      int? compatibility}) {
    return User(
        name: name ?? this.name,
        userName: userName ?? this.userName,
        token: token ?? this.token,
        bio: bio ?? this.bio,
        profileLocation: profileLocation ?? this.profileLocation,
        age: age ?? this.age,
        gender: gender ?? this.gender,
        compatibility: compatibility ?? this.compatibility,
        userId: userId ?? this.userId);
  }

  factory User.fromDocumentSnapshot(DocumentSnapshot result) {
    Map<String, dynamic> data = result.data() as Map<String, dynamic>;

    return User(
        name: data['name'] as String,
        userName: data['userName'] as String,
        bio: data['bio'] as String,
        profileLocation: data['profileLocation'] as String?,
        token: data['token'] as String?,
        age: data['age'] as int,
        gender: data['gender'] as String,
        compatibility: data['compatibility'] as int,
        userId: result.id);
  }

  @override
  List<Object?> get props =>
      [name, userName, bio, profileLocation, token, age, gender, compatibility];
}
