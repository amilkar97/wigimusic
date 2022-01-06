// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      json['href'] as String,
      (json['icons'] as List<dynamic>)
          .map((e) => LogoCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['id'] as String,
      json['name'] as String,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'href': instance.href,
      'icons': instance.icons,
      'id': instance.id,
      'name': instance.name,
    };

LogoCategory _$LogoCategoryFromJson(Map<String, dynamic> json) => LogoCategory(
      json['height'] as int?,
      json['width'] as int?,
      json['url'] as String,
    );

Map<String, dynamic> _$LogoCategoryToJson(LogoCategory instance) =>
    <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
      'url': instance.url,
    };
