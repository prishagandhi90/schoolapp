import 'package:flutter/material.dart';

class LabSummaryScreen_test extends StatelessWidget {
  LabSummaryScreen_test({Key? key}) : super(key: key);

  final double rowHeight = 50.0;
  double maxHeight = 80.0;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ✅ Fixed Header (SliverAppBar)
          SliverAppBar(
            title: Text("Lab Summary"),
            floating: true,
            pinned: true,
            expandedHeight: 100,
          ),

          // ✅ Table Content (Fixed First 3 Columns + Scrollable Other Columns)
          SliverFillRemaining(
            hasScrollBody: true,
            child: Row(
              children: [
                // ✅ Fixed Columns (Report, Test, Range)
                Container(
                  width: 300, // Fixing the width of first 3 columns
                  color: Colors.white,
                  child: DataTable(
                    columnSpacing: 20,
                    columns: [
                      DataColumn(label: Text("Report")),
                      DataColumn(label: Text("Test")),
                      DataColumn(label: Text("Range")),
                    ],
                    rows: List.generate(10, (index) {
                      return DataRow(cells: [
                        DataCell(Text("Report $index")),
                        DataCell(Text("Test $index")),
                        DataCell(Text("Range $index")),
                      ]);
                    }),
                  ),
                ),

                // ✅ Scrollable Columns (Remaining Data)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      columns: List.generate(5, (i) => DataColumn(label: Text("Date ${i + 1}"))),
                      rows: List.generate(10, (index) {
                        return DataRow(cells: List.generate(5, (i) => DataCell(Text("Data $index-$i"))));
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
