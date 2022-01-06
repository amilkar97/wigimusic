

import 'package:json_annotation/json_annotation.dart';
part 'album_model.g.dart';
@JsonSerializable()
class Album{
    String id;
    String album_type;
    List<Artist> artists;
    List<Cover> images;
    String name;

    Album(this.id, this.album_type, this.artists, this.images, this.name);

    factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);
    Map<String, dynamic> toJson() => _$AlbumToJson(this);
}

@JsonSerializable()
class Artist{
  String id;
  String name;
  int? followers;
  List<String>? generes;
  List<Cover>? images;
  int? popularity;
  Artist(this.id, this.name);

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);
  Map<String, dynamic> toJson() => _$ArtistToJson(this);
}


@JsonSerializable()
class Cover{
  int? height;
  int? width;
  String url;

  Cover(this.height, this.width, this.url);

  factory Cover.fromJson(Map<String, dynamic> json) => _$CoverFromJson(json);
  Map<String, dynamic> toJson() => _$CoverToJson(this);
}

