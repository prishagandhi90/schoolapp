import 'package:emp_app/app/moduls/internetconnection/controller/nointernet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectivityCheckPage extends StatelessWidget {
  const ConnectivityCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConnectivityController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internet Connection'),
      ),
      body: Center(
        child: Obx(() => Text(
              controller.connectionType == MConnectivityResult.wifi
                  ? "Wifi Connected"
                  : controller.connectionType == MConnectivityResult.mobile
                      ? 'Mobile Data Connected'
                      : 'No Internet Available',
              style: const TextStyle(fontSize: 20),
            )),
      ),
    );
  }
}