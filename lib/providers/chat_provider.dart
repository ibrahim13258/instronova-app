import 'package:get/get.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';

class ChatProvider extends GetxController {
  // Chat list state
  var chatList = <ChatModel>[].obs;

  // Selected chat messages state
  var messages = <MessageModel>[].obs;

  // Loading states
  var isChatListLoading = false.obs;
  var isMessagesLoading = false.obs;

  // Error messages
  var errorMessage = ''.obs;

  // Service instance
  final ChatService _chatService = ChatService();

  // Fetch chat list
  Future<void> fetchChatList() async {
    try {
      isChatListLoading.value = true;
      final list = await _chatService.getChatList();
      chatList.assignAll(list);
    } catch (e) {
      errorMessage.value = 'Failed to load chat list: $e';
    } finally {
      isChatListLoading.value = false;
    }
  }

  // Fetch messages for a chat
  Future<void> fetchMessages(String chatId) async {
    try {
      isMessagesLoading.value = true;
      final chatMessages = await _chatService.getMessages(chatId);
      messages.assignAll(chatMessages);
    } catch (e) {
      errorMessage.value = 'Failed to load messages: $e';
    } finally {
      isMessagesLoading.value = false;
    }
  }

  // Send a message
  Future<void> sendMessage(String chatId, String content) async {
    try {
      final newMessage = await _chatService.sendMessage(chatId, content);
      messages.add(newMessage);
    } catch (e) {
      errorMessage.value = 'Failed to send message: $e';
    }
  }

  // Clear messages (when leaving chat)
  void clearMessages() {
    messages.clear();
  }
}
