// File: screens/multi_account_switcher_screen.dart
import 'package:flutter/material.dart';
// TODO: Removed GetX import

class MultiAccountSwitcherScreen extends StatefulWidget {
  const MultiAccountSwitcherScreen({Key? key}) : super(key: key);

  @override
  State<MultiAccountSwitcherScreen> createState() =>
      _MultiAccountSwitcherScreenState();
}

class _MultiAccountSwitcherScreenState
    extends State<MultiAccountSwitcherScreen> {
  List<Map<String, String>> accounts = [
    {"username": "john_doe", "avatar": "assets/avatars/john.png"},
    {"username": "jane_smith", "avatar": "assets/avatars/jane.png"},
    {"username": "alex_king", "avatar": "assets/avatars/alex.png"},
  ];

  String currentUsername = "john_doe";

  void switchAccount(String username) {
    setState(() {
      currentUsername = username;
    });
// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// OLD: Get.back(); // Close the switcher after selection// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// OLD: Get.snackbar(      "Switched Account",
      "You are now logged in as $username",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Switch Account")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Select an account",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  final isCurrent = account["username"] == currentUsername;
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(account["avatar"]!),
                        radius: 25,
                      ),
                      title: Text(account["username"]!,
                          style: TextStyle(
                              fontWeight:
                                  isCurrent ? FontWeight.bold : FontWeight.normal)),
                      trailing: isCurrent
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () => switchAccount(account["username"]!),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add Account"),
              onPressed: () {
                // Navigate to login/signup flow for new account
// TODO: Replace GetX
Navigator.of(context).pushNamed('/'); // fallback
// OLD: Get.toNamed('/login');              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
