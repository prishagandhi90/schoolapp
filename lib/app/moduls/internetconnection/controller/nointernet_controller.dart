import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:emp_app/app/moduls/internetconnection/view/nointernet_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NoInternetController extends GetxController {
  var connectionType = 0.obs;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription _streamSubscription;
  bool isOpenInternetConnectionDialog = false;

  @override
  void onInit() async {
    super.onInit();
    await getConnectivityType();
    _streamSubscription = connectivity.onConnectivityChanged.listen(_updateState);
  }

  Future<void> getConnectivityType() async {
    late ConnectivityResult connectivityResult;
    try {
      connectivityResult = (await (connectivity.checkConnectivity()));
      update();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return _updateState(connectivityResult);
  }

  // Update State Function
  _updateState(ConnectivityResult connectivityResult) {
    switch (connectivityResult) {
      // WIFI
      case ConnectivityResult.wifi:
        connectionType.value = ConnectivityResult.wifi.index;
        checkAndCloseDialog();

        print("ConnectivityResult.wifi : ${connectionType.value}");

        break;
      case ConnectivityResult.mobile:
        connectionType.value = ConnectivityResult.mobile.index;
        checkAndCloseDialog();
        print("ConnectivityResult.mobile : ${connectionType.value}");
        break;
      // Ethernet
      case ConnectivityResult.ethernet:
        connectionType.value = ConnectivityResult.ethernet.index;
        checkAndCloseDialog();
        print("ConnectivityResult.ethernet : ${connectionType.value}");

        break;
      case ConnectivityResult.none:
        connectionType.value = ConnectivityResult.none.index;
        print("ConnectivityResult.none : ${connectionType.value}");
        if (isOpenInternetConnectionDialog == false) {
          isOpenInternetConnectionDialog = true;
          update();
          // Get.toNamed(Routes.);
          Get.to(const NoInternetView());
        }
        break;
      case ConnectivityResult.bluetooth:
        connectionType.value = ConnectivityResult.bluetooth.index;
        print("ConnectivityResult.bluetooth : ${connectionType.value}");
        break;
      case ConnectivityResult.vpn:
        connectionType.value = ConnectivityResult.vpn.index;
        print("ConnectivityResult.vpn : ${connectionType.value}");
        break;

      case ConnectivityResult.other:
        connectionType.value = ConnectivityResult.other.index;
        print("ConnectivityResult.other : ${connectionType.value}");
        break;
      // default:
      //   Get.rawSnackbar(message: "Failed to get connection type");
        // Get.showSnackbar(const GetSnackBar(
        //     title: 'Error', message: 'Failed to get connection type'));
        // break;
    }
    update();
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
  }

  void checkAndCloseDialog() {
    if (isOpenInternetConnectionDialog) {
      isOpenInternetConnectionDialog = false;
      // Get.offAllNamed(Routes.SPLASH);
      // Get.offAll(const SplashView());
      update();
      Get.back();
    }
  }
}
