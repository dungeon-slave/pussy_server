// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestChatEntity _$TestChatEntityFromJson(Map<String, dynamic> json) =>
    TestChatEntity(
      userName: json['userName'] as String,
      messages:
          (json['messages'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$TestChatEntityToJson(TestChatEntity instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'messages': instance.messages,
    };
