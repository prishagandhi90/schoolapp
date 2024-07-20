import 'package:emp_app/app/moduls/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginNumber extends StatelessWidget {
  LoginNumber({super.key});

  final loginController = Get.put(LoginController());
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF74c3c7),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
              child: Form(
                key: loginController.formKey,
                child: Column(
                  children: [
                    Align(
                        alignment: AlignmentDirectional.center,
                        child: Image.asset('assets/output-onlinepngtools.png', width: MediaQuery.of(context).size.width * 0.8)),
                    const SizedBox(height: 60),
                    Text(
                      'Log In',
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                        controller: loginController.numberController,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a mobile number';
                          }
                          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            return 'Please enter a valid 10-digit mobile number';
                          }
                          return null;
                        },
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter Mobile Number',
                          fillColor: Color.fromARGB(255, 228, 227, 227),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 228, 227, 227)),
                          ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(color: Color.fromARGB(255, 228, 227, 227)),
                          // ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromARGB(255, 228, 227, 227)),
                          ),
                        )),
                    const SizedBox(height: 50),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.11,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ElevatedButton(
                        onPressed: () async {
                          loginController.isLoadingLogin ? null : loginController.requestOTP(context);
                          // if (formKey.currentState!.validate()) {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => const OtpScreen()),
                          //   );
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 23, 53, 109),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        child: loginController.isLoadingLogin ? const CircularProgressIndicator() : const Text('Login', style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
