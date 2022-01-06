// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_google_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserGoogle _$UserGoogleFromJson(Map<String, dynamic> json) => UserGoogle(
      json['email'] as String?,
      json['name'] as String?,
      json['lastname'] as String?,
      json['photoURL'] as String?,
      json['documentNumber'] as String?,
    );

Map<String, dynamic> _$UserGoogleToJson(UserGoogle instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'lastname': instance.lastname,
      'documentNumber': instance.documentNumber,
      'photoURL': instance.photoURL,
    };
