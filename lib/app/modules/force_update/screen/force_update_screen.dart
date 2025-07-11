import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateScreen extends StatelessWidget {
  // Method to launch the app's page on the Play Store
  void _launchStore() async {
    final Uri storeUrl = Uri.parse("https://play.google.com/store/apps/details?id=com.venus_hospital.schoolapp");
    // Check if the device can open this URL
    if (await canLaunchUrl(storeUrl)) {
      // Launch the URL externally (outside the app)
      await launchUrl(storeUrl, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch Store URL";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AlertDialog(
          title: Text('Update Required'),
          content: Text('A new version of the app is available. Please update to continue.'),
          actions: [
            ElevatedButton(
              onPressed: _launchStore,
              child: Text('Update Now'),
            ),
          ],
        ),
      ),
    );
  }
}
