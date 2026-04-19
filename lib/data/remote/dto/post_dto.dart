import 'package:json_annotation/json_annotation.dart';
import 'package:dio_lab/domain/model/post.dart';

part 'post_dto.g.dart';

@JsonSerializable()
class PostDto {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'userId')
  final int userId;

  final String title;
  final String body;

  const PostDto({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory PostDto.fromJson(Map<String, dynamic> json) =>
      _$PostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PostDtoToJson(this);
}

extension PostDtoMapper on PostDto {
  Post toDomain() => Post(
    id: id,
    userId: userId,
    title: title,
    excerpt: body.length > 100 ? '${body.substring(0, 100)}…' : body,
  );
}