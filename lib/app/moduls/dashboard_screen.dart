import 'package:emp_app/app/app_custom_widget/custom_tabbar.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {  
    return const Scaffold(
      body: CustomTabbar(),
    );
  }
}
