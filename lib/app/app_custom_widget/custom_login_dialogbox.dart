import 'package:flutter/material.dart';

class CustomLoginDialogBox extends StatelessWidget {
  final bool obscurePassword;
  final VoidCallback? togglePasswordVisibility;
  final VoidCallback? onLoginPressed;
  final String? text;
  final String? hintText;
  final String? passwordHintText;
  final TextEditingController? controller;
  final TextEditingController? passcontroller;
  final Function()? onTap;
  const CustomLoginDialogBox({
    Key? key,
    this.obscurePassword = false,
    this.togglePasswordVisibility,
    this.onLoginPressed,
    this.text,
    this.hintText,
    this.controller,
    this.passcontroller,
    this.passwordHintText, this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.all(16),
      content: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text!,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: hintText,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passcontroller,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    hintText: passwordHintText,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: togglePasswordVisibility,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: onLoginPressed,
                  child: const Text("LOG IN"),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onTap,
              child: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
