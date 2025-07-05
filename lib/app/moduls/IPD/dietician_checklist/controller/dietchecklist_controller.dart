import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DietchecklistController extends GetxController{
   final TextEditingController searchController = TextEditingController();
   final ScrollController adPatientScrollController = ScrollController();
   String selectedTabLabel = 'ALL';

   void updateSelectedTab(String label) {
    selectedTabLabel = label;
    update(); // UI refresh
  }
}