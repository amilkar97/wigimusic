
import 'package:json_annotation/json_annotation.dart';
import 'package:wigi/models/album_model.dart';
part 'playlist_model.g.dart';

@JsonSerializable()
class Playlist{
  String id;
  String name;
  String description;
  List<Cover> images;

  Playlist(this.id, this.name, this.description, this.images);

  factory Playlist.fromJson(Map<String, dynamic> json) => _$PlaylistFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistToJson(this);
}