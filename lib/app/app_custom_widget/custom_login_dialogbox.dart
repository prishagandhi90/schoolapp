import 'package:schoolapp/app/core/util/app_style.dart';
import 'package:schoolapp/app/core/util/sizer_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomLoginDialogBox extends StatelessWidget {
  final bool obscurePassword;
  final VoidCallback? togglePasswordVisibility;
  final VoidCallback? onLoginPressed;
  final String? text;
  final String? hintText;
  final String? passwordHintText;
  final TextEditingController? controller;
  final TextEditingController? passcontroller;
  final List<TextInputFormatter>? inputFormatters;
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
    this.passwordHintText,
    this.onTap,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
        getDynamicHeight(size: 0.007),
      )),
      contentPadding: EdgeInsets.all(
        getDynamicHeight(size: 0.015),
      ),
      content: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: getDynamicHeight(size: 0.032),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text!,
                  style: TextStyle(
                    fontSize: getDynamicHeight(size: 0.015),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: getDynamicHeight(size: 0.018),
                ),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: inputFormatters,
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
                SizedBox(
                  height: getDynamicHeight(size: 0.0145),
                ),
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
                SizedBox(
                  height: getDynamicHeight(size: 0.018),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        getDynamicHeight(
                          size: 0.008,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: getDynamicHeight(size: 0.030),
                      vertical: getDynamicHeight(size: 0.010),
                    ),
                  ),
                  onPressed: onLoginPressed,
                  child: Text(
                    "LOG IN",
                    style: AppStyle.white,
                  ),
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
