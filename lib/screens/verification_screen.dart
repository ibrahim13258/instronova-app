// File: screens/verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  int timer = 30;
  bool canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    canResend = false;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        if (timer > 0) timer--;
        if (timer == 0) canResend = true;
      });
      return timer > 0;
    });
  }

  void resendOTP() {
    if (canResend) {
      setState(() {
        timer = 30;
      });
      startTimer();
      // Call API to resend OTP
    }
  }

  void verifyOTP() {
    String otp = otpControllers.map((e) => e.text).join();
    if (otp.length == 6) {
      // Call verification API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Verified Successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter complete OTP')),
      );
    }
  }

  Widget otpField(int index) {
    return SizedBox(
      width: 45,
      child: TextField(
        controller: otpControllers[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(counterText: ''),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verification')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Enter the 6-digit code sent to your number/email',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) => otpField(index)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: verifyOTP,
              child: const Text('Verify'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: canResend ? resendOTP : null,
              child: Text(
                canResend
                    ? 'Resend OTP'
                    : 'Resend OTP in $timer seconds',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
