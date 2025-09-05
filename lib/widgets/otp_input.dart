import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPInput extends StatelessWidget {
  final int length;
  final Function(String) onCompleted;

  const OTPInput({
    super.key,
    this.length = 6,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(length, (index) {
        return SizedBox(
          width: 45,
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              counterText: "",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < length - 1) {
                FocusScope.of(context).nextFocus();
              }
              if (value.isEmpty && index > 0) {
                FocusScope.of(context).previousFocus();
              }
              String otp = "";
              FocusScope.of(context).focusedChild?.context?.visitAncestorElements((element) {
                if (element.widget is TextField) {
                  final tf = element.widget as TextField;
                  otp += tf.controller?.text ?? "";
                }
                return true;
              });
              if (otp.length == length) {
                onCompleted(otp);
              }
            },
          ),
        );
      }),
    );
  }
}
