// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
      json['id'] as String,
      json['album_type'] as String,
      (json['artists'] as List<dynamic>)
          .map((e) => Artist.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['images'] as List<dynamic>)
          .map((e) => Cover.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['name'] as String,
    );

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
      'id': instance.id,
      'album_type': instance.album_type,
      'artists': instance.artists,
      'images': instance.images,
      'name': instance.name,
    };

Artist _$ArtistFromJson(Map<String, dynamic> json) => Artist(
      json['id'] as String,
      json['name'] as String,
    )
      ..followers = json['followers'] as int?
      ..generes =
          (json['generes'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..images = (json['images'] as List<dynamic>?)
          ?.map((e) => Cover.fromJson(e as Map<String, dynamic>))
          .toList()
      ..popularity = json['popularity'] as int?;

Map<String, dynamic> _$ArtistToJson(Artist instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'followers': instance.followers,
      'generes': instance.generes,
      'images': instance.images,
      'popularity': instance.popularity,
    };

Cover _$CoverFromJson(Map<String, dynamic> json) => Cover(
      json['height'] as int?,
      json['width'] as int?,
      json['url'] as String,
    );

Map<String, dynamic> _$CoverToJson(Cover instance) => <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
      'url': instance.url,
    };
