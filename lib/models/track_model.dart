

import 'package:json_annotation/json_annotation.dart';
import 'package:wigi/models/album_model.dart';
part 'track_model.g.dart';
@JsonSerializable()
class Track{
  String id;
  String name;
  List<Artist> artists;
  int duration_ms;
  Album album;
  String? preview_url;
  String uri;

  Track(this.id, this.name, this.artists, this.duration_ms, this.album,this.preview_url,this.uri);

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
  Map<String, dynamic> toJson() => _$TrackToJson(this);
}