

import 'package:json_annotation/json_annotation.dart';
part 'category_model.g.dart';
@JsonSerializable()
class Category{
  String href;
  List<LogoCategory> icons;
  String id;
  String name;

  Category(this.href, this.icons, this.id, this.name);

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class LogoCategory{
  int? height;
  int? width;
  String url;

  LogoCategory(this.height, this.width, this.url);
  factory LogoCategory.fromJson(Map<String, dynamic> json) => _$LogoCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$LogoCategoryToJson(this);

}