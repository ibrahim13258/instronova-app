// TODO: Removed GetX import
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class MultiAccountService extends GetxService {
  // Secure storage for accounts
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // List of saved accounts
  final RxList<UserModel> _accounts = <UserModel>[].obs;
  List<UserModel> get accounts => _accounts;

  // Currently active account
  final Rx<UserModel?> _activeAccount = Rx<UserModel?>(null);
  UserModel? get activeAccount => _activeAccount.value;

  /// Initialize service and load accounts from storage
  Future<MultiAccountService> init() async {
    await _loadAccounts();
    return this;
  }

  /// Load saved accounts from secure storage
  Future<void> _loadAccounts() async {
    final allKeys = await _storage.readAll();
    _accounts.clear();
    allKeys.forEach((key, value) {
      _accounts.add(UserModel.fromJson(value));
    });

    if (_accounts.isNotEmpty) {
      _activeAccount.value = _accounts.first;
    }
  }

  /// Add a new account
  Future<void> addAccount(UserModel user) async {
    await _storage.write(key: user.id, value: user.toJson());
    _accounts.add(user);
    _activeAccount.value = user;
  }

  /// Switch to a different account
  void switchAccount(String userId) {
    final user = _accounts.firstWhereOrNull((u) => u.id == userId);
    if (user != null) {
      _activeAccount.value = user;
// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// TODO: GetX usage commented out
// // OLD: // TODO: Replace GetX navigation: Get.snackbar('Switched', 'Account switched to ${user.username}');    }
  }

  /// Remove an account
  Future<void> removeAccount(String userId) async {
    await _storage.delete(key: userId);
    _accounts.removeWhere((u) => u.id == userId);

    if (_activeAccount.value?.id == userId) {
      _activeAccount.value = _accounts.isNotEmpty ? _accounts.first : null;
    }
  }

  /// Logout current account
  Future<void> logout() async {
    if (_activeAccount.value != null) {
      await removeAccount(_activeAccount.value!.id);
    }
  }
}