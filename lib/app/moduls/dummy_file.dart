import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DummyController extends GetxController {
  var count = 0.obs;

  void increment() {
    count++;
  }
}

class DummyScreen extends StatelessWidget {
  DummyScreen({super.key});

  final DummyController controller = Get.put(DummyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dummy Screen with GetX"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  'Count value: ${controller.count}',
                  style: TextStyle(fontSize: 20),
                )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.increment,
              child: Text("Increment"),
            ),
          ],
        ),
      ),
    );
  }
}
