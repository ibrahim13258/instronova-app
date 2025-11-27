// GetX removed for Provider consistency
import 'package:dio/dio.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatService extends GetxService {
  final Dio _dio = Dio();

  final RxList<ChatModel> _chatList = <ChatModel>[].obs;
  final RxMap<String, List<MessageModel>> _messages = <String, List<MessageModel>>{}.obs;

  // Getters
  List<ChatModel> get chatList => _chatList;
  List<MessageModel> messages(String chatId) => _messages[chatId] ?? [];

  // Fetch chat list
  Future<void> fetchChatList(String userId) async {
    try {
      Response response = await _dio.get('https://api.example.com/users/$userId/chats');
      _chatList.value = (response.data as List)
          .map((json) => ChatModel.fromJson(json))
          .toList();
    } catch (e) {
      print("Error fetching chat list: $e");
    }
  }

  // Fetch messages for a chat
  Future<void> fetchMessages(String chatId) async {
    try {
      Response response = await _dio.get('https://api.example.com/chats/$chatId/messages');
      _messages[chatId] = (response.data as List)
          .map((json) => MessageModel.fromJson(json))
          .toList();
    } catch (e) {
      print("Error fetching messages: $e");
    }
  }

  // Send a new message
  Future<void> sendMessage(String chatId, MessageModel message) async {
    try {
      Response response = await _dio.post(
        'https://api.example.com/chats/$chatId/messages',
        data: message.toJson(),
      );
      // Add sent message to local list
      _messages.putIfAbsent(chatId, () => <MessageModel>[]).add(MessageModel.fromJson(response.data));
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  // Real-time update simulation (polling or websocket can be integrated)
  void addIncomingMessage(String chatId, MessageModel message) {
    _messages.putIfAbsent(chatId, () => <MessageModel>[]).add(message);
  }

  // Clear chat messages (optional)
  void clearMessages(String chatId) {
    _messages[chatId]?.clear();
  }
}
