import 'package:flutter/material.dart';

// Widget _buildDataRow(List<String> data) {
//   return Padding(
//     padding: EdgeInsets.symmetric(vertical: 4.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: data
//           .map(
//             (item) => Expanded(
//               child: Text(
//                 item,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           )
//           .toList(),
//     ),
//   );
// }

class CustomBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // PUNCH section
          _buildSectionHeader('PUNCH', [Colors.green, Colors.blue]),
          _buildFlexibleDataRow_50_50(context, ['24-06-2024 11:17:10', '24-06-2024 14:55:04']),
          _buildFlexibleDataRow_50_50(context, ['24-06-2024 16:04:58', '24-06-2024 21:01:33']),
          SizedBox(
            height: 8,
          ),

          // SHIFT, ST, LV section
          _buildSectionHeaderWithFlexibleColumns(context, 'SHIFT', 'ST', 'LV', [Colors.green, Colors.blue]),
          _buildFlexibleDataRow(context, ['M23 [11:00- 20:00]', 'PR', 'HD']),
          SizedBox(height: 8),

          // LC, EG section
          _buildSectionHeaderWithFlexibleCols_50_50(context, 'LC', 'EG', '', [Colors.blue, Colors.green]),
          _buildFlexibleDataRow_50_50(context, ['', '']),
          SizedBox(height: 8),

          // OT ENT MIN, OT MIN section
          _buildSectionHeaderWithFlexibleCols_50_50(context, 'OT ENT MIN', 'OT MIN', '', [Colors.green, Colors.blue]),
          _buildFlexibleDataRow_50_50(context, ['', '0']),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, List<Color> colors) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSectionHeaderWithFlexibleColumns(BuildContext context, String col1, String col2, String col3, List<Color> colors) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 2,
            child: Container(
              // height: 100,
              width: MediaQuery.of(context).size.height * 0.5,
              alignment: Alignment.center,
              child: Text(
                col1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Spacer(flex: 1),
          Flexible(
            flex: 1,
            child: Container(
              // height: 100,
              width: MediaQuery.of(context).size.height * 0.25,
              alignment: Alignment.center,
              child: Text(
                col2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Spacer(flex: 1),
          Flexible(
            flex: 1,
            child: Container(
              // height: 100,
              width: MediaQuery.of(context).size.height * 0.25,
              alignment: Alignment.center,
              child: Text(
                col3,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeaderWithFlexibleCols_50_50(BuildContext context, String col1, String col2, String col3, List<Color> colors) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              // height: 100,
              width: MediaQuery.of(context).size.height * 0.5,
              alignment: Alignment.center,
              child: Text(
                col1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Spacer(flex: 1),
          Flexible(
            flex: 1,
            child: Container(
              // height: 100,
              width: MediaQuery.of(context).size.height * 0.5,
              alignment: Alignment.center,
              child: Text(
                col2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget _buildFlexibleDataRow(BuildContext context, List<String> data) {
    while (data.length < 3) {
      data.add(''); // Ensure the list has exactly 3 elements
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              width: MediaQuery.of(context).size.height * 0.5,
              child: Text(
                data[0],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Spacer(flex: 1),
          Flexible(
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.height * 0.25,
              child: Text(
                data[1],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Spacer(flex: 1),
          Flexible(
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.height * 0.25,
              child: Text(
                data[2],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlexibleDataRow_50_50(BuildContext context, List<String> data) {
    while (data.length < 3) {
      data.add(''); // Ensure the list has exactly 3 elements
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.height * 0.5,
              child: Text(
                data[0],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Spacer(flex: 1),
          Flexible(
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.height * 0.5,
              child: Text(
                data[1],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Spacer(flex: 1),
        ],
      ),
    );
  }
}
