import 'package:emp_app/screen/attendance_screen.dart';
import 'package:emp_app/screen/mispunch_screen.dart';
import 'package:flutter/material.dart';

class CustomTabbar extends StatefulWidget {
  const CustomTabbar({super.key});

  @override
  State<CustomTabbar> createState() => _CustomTabbarState();
}

class _CustomTabbarState extends State<CustomTabbar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              const SliverAppBar(
                title: Text('Employee Info'),
                centerTitle: true,
                pinned: true,
                // stretch: true,
                bottom: TabBar(
                  labelStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(child: Text('Attendance Detail')),
                    Tab(child: Text('Mispunch Detail')),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [AttendancdScreen(), MispunchScreen()],
          ),
        )));
  }
}
