import 'dart:async';
import 'package:emp_app/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.mobileNumber, re, required this.otpNo});
  final String mobileNumber;
  final String otpNo;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final LoginController loginController = Get.put(LoginController());
  int _counter = 10;
  late Timer _timer;
  // String otp = "";

  void startTimer() {
    _counter = 20;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  Widget textWidgetInfo() {
    if (_counter > 0) {
      return Text(
        "Request otp in $_counter",
        style: const TextStyle(
          fontSize: 15.0,
          color: Colors.white,
        ),
      );
    } else {
      return InkWell(
        child: const Text(
          'Resend',
          style: TextStyle(fontSize: 15.0, color: Colors.white),
        ),
        onTap: () {
          startTimer();
          // resendM();
        },
      );
    }
  }

  @override
  void initState() {
    startTimer();
    super.initState();
    print('RespOTP: ${widget.otpNo}');
  }

  @override
  Widget build(BuildContext context) {
    // const focusedBorderColor = Color.fromRGBO(239, 240, 240, 1);
    // const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(239, 240, 240, 1);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
      ),
    );
    return Scaffold(
      backgroundColor: const Color(0xFF74c3c7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                    alignment: AlignmentDirectional.center,
                    child: Image.asset('assets/output-onlinepngtools.png', width: MediaQuery.of(context).size.width * 0.8)),
                const SizedBox(height: 60),
                Text(
                  'Enter OTP',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  'We have sent you an OTP on +91 1234567890',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                const SizedBox(height: 30),
                Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  separatorBuilder: (index) => const SizedBox(width: 8),
                  // validator: (value) {
                  //   if (Get.find<LoginController>().apiController['isValid']) {
                  //     return null;
                  //   } else {
                  //     return 'Pin is incorrect';
                  //   }
                  // },
                  onCompleted: (pin) {},
                  onChanged: (value) {},
                  // submittedPinTheme: defaultPinTheme.copyWith(
                  //   decoration: defaultPinTheme.decoration!.copyWith(
                  //     color: fillColor,
                  //     borderRadius: BorderRadius.circular(19),
                  //     border: Border.all(color: focusedBorderColor),
                  //   ),
                  // ),
                ),

                // OtpTextField(
                //   numberOfFields: 6,
                //   keyboardType: TextInputType.number,
                //   borderColor: const Color.fromARGB(255, 209, 208, 209),
                //   focusedBorderColor: const Color.fromARGB(255, 209, 208, 209),
                //   showFieldAsBox: true,
                //   onCodeChanged: (String value) {},
                //   onSubmit: (String value) {},
                // ),
                const SizedBox(height: 30),
                Container(
                  alignment: AlignmentDirectional.centerStart,
                  margin: const EdgeInsets.all(15.0),
                  child: textWidgetInfo(),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.11,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ElevatedButton(
                    onPressed: () {
                      loginController.otpOnClk(context, widget.otpNo);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 23, 53, 109),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Verify', style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
