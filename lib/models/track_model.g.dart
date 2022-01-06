// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Track _$TrackFromJson(Map<String, dynamic> json) => Track(
      json['id'] as String,
      json['name'] as String,
      (json['artists'] as List<dynamic>)
          .map((e) => Artist.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['duration_ms'] as int,
      Album.fromJson(json['album'] as Map<String, dynamic>),
      json['preview_url'] as String?,
      json['uri'] as String,
    );

Map<String, dynamic> _$TrackToJson(Track instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'artists': instance.artists,
      'duration_ms': instance.duration_ms,
      'album': instance.album,
      'preview_url': instance.preview_url,
      'uri': instance.uri,
    };
