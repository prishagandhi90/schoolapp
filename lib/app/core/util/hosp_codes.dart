import 'package:schoolapp/app/core/util/app_string.dart';
import 'package:schoolapp/app/moduls/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CodeAlertScreen extends StatelessWidget {
  final String codeType;
  final String patientId;

  const CodeAlertScreen({super.key, required this.codeType, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("🚨 $codeType", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("Patient ID: $patientId", style: TextStyle(fontSize: 18)),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                // Stop alarm here if needed
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                bool isSuperAdmin = prefs.getString(AppString.keySuperAdmin) != null &&
                        prefs.getString(AppString.keySuperAdmin) != '' &&
                        prefs.getString(AppString.keySuperAdmin) == 'True'
                    ? true
                    : false;
                if (isSuperAdmin) {
                  await prefs.setString(AppString.keySuperAdmin, '');
                }
                bool isLoggedIn =
                    prefs.getString(AppString.keyToken) != null && prefs.getString(AppString.keyToken) != '' && !isSuperAdmin ? true : false;
                if (isLoggedIn) {
                  Get.offAllNamed(Routes.BOTTOM_BAR);
                } else {
                  Get.offAllNamed(Routes.LOGIN);
                }
              },
              child: Text("Acknowledge"),
            ),
          ],
        ),
      ),
    );
  }
}
