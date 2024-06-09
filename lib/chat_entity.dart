import 'package:json_annotation/json_annotation.dart';

part 'chat_entity.g.dart';

@JsonSerializable()
class TestChatEntity {
  final String userName;
  final List<String> messages;

  const TestChatEntity({
    required this.userName,
    required this.messages,
  });

  factory TestChatEntity.fromJson(Map<String, dynamic> json) => _$TestChatEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TestChatEntityToJson(this);
}
