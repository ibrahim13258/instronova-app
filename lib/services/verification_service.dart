import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class VerificationService extends GetxService {
  // User verification status
  RxBool isVerified = false.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  final String baseUrl = 'https://yourapi.com/api';

  // Fetch verification status for logged-in user
  Future<void> fetchVerificationStatus(String userId) async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse('$baseUrl/verify/$userId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        isVerified.value = data['verified'] ?? false;
      } else {
        errorMessage.value = 'Failed to fetch verification status';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Request new verification (like blue tick request)
  Future<bool> requestVerification(String userId, String documentUrl) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse('$baseUrl/verify/request'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'document_url': documentUrl, // Government ID, Passport, etc.
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'pending') {
// TODO: Replace GetX navigation: Get.snackbar('Verification', 'Your verification request is pending');
          return true;
        }
      } else {
        errorMessage.value = 'Verification request failed';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Approve verification (admin function, optional)
  Future<bool> approveVerification(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify/approve'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        isVerified.value = true;
        return true;
      } else {
        errorMessage.value = 'Failed to approve verification';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
  }
}