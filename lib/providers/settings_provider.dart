// GetX removed for Provider consistency

class SettingsProvider extends GetxController {
  // Account settings
  var username = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;

  // Privacy settings
  var isPrivateAccount = false.obs;
  var allowTagging = true.obs;
  var allowComments = true.obs;

  // Security settings
  var twoFactorAuth = false.obs;
  var loginAlerts = true.obs;
  var savedLoginInfo = true.obs;

  // ----------------- Account Methods -----------------
  void updateUsername(String newUsername) {
    username.value = newUsername;
  }

  void updateEmail(String newEmail) {
    email.value = newEmail;
  }

  void updatePhoneNumber(String newPhone) {
    phoneNumber.value = newPhone;
  }

  // ----------------- Privacy Methods -----------------
  void togglePrivateAccount(bool value) {
    isPrivateAccount.value = value;
  }

  void toggleAllowTagging(bool value) {
    allowTagging.value = value;
  }

  void toggleAllowComments(bool value) {
    allowComments.value = value;
  }

  // ----------------- Security Methods -----------------
  void toggleTwoFactorAuth(bool value) {
    twoFactorAuth.value = value;
  }

  void toggleLoginAlerts(bool value) {
    loginAlerts.value = value;
  }

  void toggleSavedLoginInfo(bool value) {
    savedLoginInfo.value = value;
  }

  // ----------------- Reset All Settings -----------------
  void resetSettings() {
    isPrivateAccount.value = false;
    allowTagging.value = true;
    allowComments.value = true;
    twoFactorAuth.value = false;
    loginAlerts.value = true;
    savedLoginInfo.value = true;
  }
}
