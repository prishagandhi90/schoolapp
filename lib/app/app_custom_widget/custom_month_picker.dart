import 'package:emp_app/app/core/util/app_color.dart';
import 'package:flutter/material.dart';

class MonthSelectionScreen extends StatelessWidget {
  MonthSelectionScreen({
    super.key,
    required this.selectedMonthIndex,
    required this.onPressed,
    required this.scrollController,
  });

  final Function(int) onPressed;
  int selectedMonthIndex;
  final ScrollController scrollController;

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  // void dispose() {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        double itemWidth = 80; // Adjust this based on your item width
        double screenWidth = MediaQuery.of(context).size.width;
        double screenCenter = screenWidth / 2;
        double selectedMonthPosition = selectedMonthIndex * itemWidth;
        double targetScrollPosition = selectedMonthPosition - screenCenter + itemWidth / 2;

        // Ensure the calculated position is within valid scroll range
        double maxScrollExtent = scrollController.position.maxScrollExtent;
        double minScrollExtent = scrollController.position.minScrollExtent;
        if (targetScrollPosition < minScrollExtent) {
          targetScrollPosition = minScrollExtent;
        } else if (targetScrollPosition > maxScrollExtent) {
          targetScrollPosition = maxScrollExtent;
        }

        scrollController.animateTo(
          targetScrollPosition,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    return Center(
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(months.length, (index) {
            return GestureDetector(
              onTap: () {
                onPressed(index);
                // setState(() {
                //   widget.selectedMonthIndex = index;
                // });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: selectedMonthIndex == index
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor, // Adjust based on your color
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          months[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : Text(
                        months[index],
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
