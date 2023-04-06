import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String? name;
  String? mail;
  String? id;
   String? profileImage ="" ;

  UserModel({
    this.name,
    this.mail,
    this.id,
    this.profileImage
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'mail': mail,
      'id': id,
      'profileImage': profileImage,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] != null ? json['name'] as String : null,
      mail: json['mail'] != null ? json['mail'] as String : null,
      id: json['id'] != null ? json['id'] as String : null,
      profileImage: json['profileImage'],
    );
  }
}
