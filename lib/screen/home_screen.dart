import 'package:emp_app/custom_widget/custom_tabbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {  
    return const Scaffold(
      body: CustomTabbar(),
    );
  }
}
