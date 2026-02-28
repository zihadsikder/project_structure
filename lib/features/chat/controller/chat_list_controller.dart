import 'dart:async';
import 'package:get/get.dart';
import '../../../../../core/services/Auth_service.dart';
import '../../../../../core/services/network_caller.dart';
import '../../../../../core/utils/constants/app_urls.dart';
import '../../../core/utils/logging/logger.dart';
import '../model/chat_list_model.dart';

class ChatListController extends GetxController {
  var isLoading = false.obs;
  Rx<GetChatListModel?> chatListDetails = Rx(null);
  var searchQuery = ''.obs;
  Timer? _refreshTimer;
  final isCreatingRoom = false.obs;
  String? get token => AuthService.token;

  @override
  void onInit() {
    super.onInit();
    AppLoggerHelper.info("ChatListController initialized");
    fetchChatListDetails();
    //_startAutoRefresh();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  /// Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  /// Periodic refresher
  // void _startAutoRefresh() {
  //   //_refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
  //     refreshChatList();
  //   });
  // }

  /// Fetch chat list data
  Future<void> fetchChatListDetails() async {
    isLoading.value = true;
    try {
      final response = await NetworkCaller().getRequest(
        AppUrls.getMyChatLists,
        token: 'Bearer $token',
      );

      if (response.isSuccess) {
        if (response.responseData is Map<String, dynamic>) {
          chatListDetails.value = GetChatListModel.fromJson(
            response.responseData,
          );
          AppLoggerHelper.info("Chat list fetched successfully");
        } else {
          throw Exception('Unexpected response data format');
        }
      } else {
        AppLoggerHelper.error(
          "Failed to load chat list: ${response.errorMessage}",
        );
        throw Exception('Failed to load chat list: ${response.errorMessage}');
      }
    } catch (e) {
      //Get.snackbar('Error', 'An error occurred: $e');
      AppLoggerHelper.error("Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh chat list (without loader)
  Future<void> refreshChatList() async {
    try {
      final response = await NetworkCaller().getRequest(
        AppUrls.getMyChatLists,
        token: 'Bearer $token',
      );

      if (response.isSuccess && response.responseData is Map<String, dynamic>) {
        chatListDetails.value = GetChatListModel.fromJson(
          response.responseData,
        );
      } else {
        //Get.snackbar('Error', 'Failed to refresh chat list');
      }
    } catch (e) {
      AppLoggerHelper.error("Refresh error: $e");
      //Get.snackbar('Error', 'Failed to refresh chat list: $e');
    }
  }

  /// Filter chat list based on search query
  List<ChatData> get filteredChatList {
    final chats = chatListDetails.value?.data ?? [];
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) return chats;
    return chats
        .where(
          (chat) =>
      (chat.user?.name?.toLowerCase().contains(query) ?? false) ||
          (chat.user?.email?.toLowerCase().contains(query) ?? false),
    )
        .toList();
  }
}
