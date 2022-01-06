

import 'package:json_annotation/json_annotation.dart';
part 'user_google_model.g.dart';

@JsonSerializable()
class UserGoogle{
  String? email;
  String? name;
  String? lastname;
  String? documentNumber;
  String? photoURL;

  UserGoogle(this.email, this.name,this.lastname, this.photoURL, this.documentNumber);
  factory UserGoogle.fromJson(Map<String, dynamic> json) => _$UserGoogleFromJson(json);

  Map<String, dynamic> toJson() => _$UserGoogleToJson(this);

}