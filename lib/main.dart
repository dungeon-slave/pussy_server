import 'dart:async';
import 'dart:io';
import 'chat_entity.dart';
import 'dart:convert';
import 'dart:math';

WebSocket? userSocket;
const String characters =
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

Future<void> main() async {
  final HttpServer server = await HttpServer.bind("10.201.33.224", 4040);
  print(
    'WebSocket server is running on ws://${server.address.address}:${server.port}/',
  );

  Timer.periodic(const Duration(seconds: 10), (_) => spamMessages());

  await for (final HttpRequest request in server) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      final WebSocket websocket = await WebSocketTransformer.upgrade(request);
      print('Client connected!');

      final Map<String, dynamic> mockedChatsInJson = {
        'MessageType': 0,
        'Chats': [
          for (final chat in mockedChats) chat.toJson(),
        ],
      };

      final String stringifyData = jsonEncode(mockedChatsInJson);

      websocket.add(stringifyData);

      websocket.listen(
        (message) {
          print('Received message: $message');
          websocket.add('Echo: $message');
        },
        onDone: () {
          print('Client disconnected!');
        },
        onError: (error) {
          print('Error: $error');
        },
      );

      userSocket = websocket;
    } else {
      request.response
        ..statusCode = HttpStatus.forbidden
        ..write('WebSocket connections only')
        ..close();
    }
  }
}

void spamMessages() {
  final int index = Random().nextInt(mockedChats.length - 1 + 1);
  final int messageSize = Random().nextInt(500);
  final int whosMessage = Random().nextInt(2);
  final TestChatEntity chat = mockedChats[index];

  final Map<String, dynamic> message = {
    'MessageType': 1,
    'ChatName': chat.userName,
    'Message': generateRandomText(messageSize),
    'IsUserMessage' : whosMessage == 0 ? true : false,
  };

  userSocket?.add(jsonEncode(message));
}

String generateRandomText(int length) {
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => characters.codeUnitAt(Random().nextInt(characters.length)),
    ),
  );
}

List<TestChatEntity> mockedChats = [
  TestChatEntity(userName: 'Angela', messages: []),
  TestChatEntity(userName: 'Daria', messages: []),
  TestChatEntity(userName: 'Varvara', messages: []),
  TestChatEntity(userName: 'Tolik', messages: []),
  TestChatEntity(userName: 'Yaroslav', messages: []),
  TestChatEntity(userName: 'Dana Moll', messages: []),
];
