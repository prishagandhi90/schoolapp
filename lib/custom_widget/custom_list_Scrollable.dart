// ignore_for_file: file_names

import 'package:flutter/material.dart';

class FixedColumnWidget extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> Function() rowBuilder;
  final WidgetStateProperty<Color?>? headingRowColor;

  const FixedColumnWidget({super.key, required this.columns, required this.rowBuilder, this.headingRowColor});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)),
              bottom: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)),
              left: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)),
            ),
          ),
          child: DataTable(
            border: const TableBorder(
                top: BorderSide(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)),
                left: BorderSide(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)),
                bottom: BorderSide(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)),
                horizontalInside: BorderSide(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)),
                verticalInside: BorderSide(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26))),
            columnSpacing: 20,
            headingRowColor: headingRowColor,
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey, width: 2)),
            ),
            columns: columns,
            rows: rowBuilder(),
          ),
        ),
      ),
    );
  }
}

class ScrollableColumnWidget extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> Function() rowBuilder;
  final WidgetStateProperty<Color?>? headingRowColor;

  const ScrollableColumnWidget({super.key, required this.columns, required this.rowBuilder, this.headingRowColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)),
              top: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)),
              bottom: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)),
            ),
          ),
          child: DataTable(
            border: const TableBorder(
              top: BorderSide(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)),
              right: BorderSide(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)),
              bottom: BorderSide(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)),
              horizontalInside: BorderSide(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)),
              verticalInside: BorderSide(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)),
            ),
            headingRowColor: headingRowColor,
            columnSpacing: 20,
            decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 0.5))),
            columns: columns,
            rows: rowBuilder(),
          ),
        ),
      ),
    );
  }
}









































// import 'package:flutter/material.dart';

// class FixedColumnWidget extends StatelessWidget {
//   final List<DataColumn> columns;
//   final List<DataRow> rows;
//   final WidgetStateProperty<Color?>? headingRowColor;
//   const FixedColumnWidget({super.key, required this.columns, required this.rows, this.headingRowColor});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Container(
//         decoration: const BoxDecoration(
//             border: Border(
//                 top: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)),
//                 bottom: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)),
//                 left: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)))),
//         child: DataTable(
//             columnSpacing: 20,
//             headingRowColor: headingRowColor,
//             decoration: const BoxDecoration(
//               border: Border(
//                 right: BorderSide(color: Colors.grey, width: 2),
//               ),
//             ),
//             columns: columns,
//             //  const [
//             //   DataColumn(label: Text('TTL \nPRSNT')),
//             //   DataColumn(label: Text('TTL \nAB')),
//             //   DataColumn(label: Text('TTL \nDAYS')),
//             // ],
//             rows: rows
//             //  [
//             //   ...teamsData.map((team) => DataRow(
//             //         cells: [
//             //           DataCell(Text('${team.position.toString()} ', style: const TextStyle(fontWeight: FontWeight.bold))),
//             //           DataCell(Text('${team.points}', style: const TextStyle(fontWeight: FontWeight.bold))),
//             //           DataCell(Text('${team.points}', style: const TextStyle(fontWeight: FontWeight.bold))),
//             //         ],
//             //       ))
//             // ],
//             ),
//       ),
//     );
//   }
// }

// class ScrollableColumnWidget extends StatelessWidget {
//   final List<DataColumn> columns;
//   final List<DataRow> rows;
//   final WidgetStateProperty<Color?>? headingRowColor;
//   const ScrollableColumnWidget({super.key, required this.columns, required this.rows, this.headingRowColor});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Container(
//           decoration: const BoxDecoration(
//             border: Border(
//                 right: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)),
//                 top: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26)),
//                 bottom: BorderSide(width: 1, color: Color.fromRGBO(0, 0, 0, 0.26))),
//           ),
//           child: DataTable(
//             headingRowColor: headingRowColor, //WidgetStateProperty.all(Colors.green[100]),
//             columnSpacing: 20,
//             decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 0.5))),
//             columns: columns,
//             //  const [
//             //   DataColumn(label: Text('PRSNT')),
//             //   DataColumn(label: Text('AB')),
//             //   DataColumn(label: Text('WO')),
//             //   DataColumn(label: Text('CO')),
//             //   DataColumn(label: Text('PL')),
//             //   DataColumn(label: Text('SL')),
//             //   DataColumn(label: Text('CL')),
//             //   DataColumn(label: Text('HO')),
//             //   DataColumn(label: Text('ML')),
//             // ],
//             rows: rows,
//             // [
//             //   ...teamsData.map((team) => DataRow(
//             //         cells: [
//             //           // DataCell(Container(
//             //           //   alignment: Alignment.center,
//             //           //   padding: const EdgeInsets.symmetric(horizontal: 10),
//             //           //   decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2))),
//             //           //   child: Text(team.won.toString()),
//             //           // )),
//             //           // DataCell(Container(
//             //           //   alignment: Alignment.center,
//             //           //   padding: const EdgeInsets.symmetric(horizontal: 10),
//             //           //   decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2))),
//             //           //   child: Text(team.lost.toString()),
//             //           // )),
//             //           // DataCell(Container(
//             //           //   alignment: Alignment.center,
//             //           //   padding: const EdgeInsets.symmetric(horizontal: 8),
//             //           //   decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2))),
//             //           //   child: Text(team.drawn.toString()),
//             //           // )),
//             //           // DataCell(Container(
//             //           //   alignment: Alignment.center,
//             //           //   padding: const EdgeInsets.symmetric(horizontal: 8),
//             //           //   decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2))),
//             //           //   child: Text(team.against.toString()),
//             //           // )),
//             //           // DataCell(Container(
//             //           //   alignment: Alignment.center,
//             //           //   padding: const EdgeInsets.symmetric(horizontal: 8),
//             //           //   decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.grey, width: 2))),
//             //           //   child: Text(team.gd.toString()),
//             //           // )),
//             //           DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.won.toString()))),
//             //           DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.lost.toString()))),
//             //           DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.drawn.toString()))),
//             //           DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.against.toString()))),
//             //           DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.gd.toString()))),
//             //           DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.gd.toString()))),
//             //           DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.gd.toString()))),
//             //           DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.gd.toString()))),
//             //           DataCell(Container(alignment: AlignmentDirectional.center, child: Text(team.gd.toString()))),
//             //         ],
//             //       ))
//             // ]
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget buildHeaderCell(String text) {
//   //   return Container(
//   //     alignment: Alignment.center,
//   //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//   //     decoration: BoxDecoration(
//   //       color: Colors.grey[300], // Optional: Add background color for header
//   //       border: const Border(
//   //         bottom: BorderSide(color: Colors.grey, width: 1),
//   //         right: BorderSide(color: Colors.grey, width: 0.5),
//   //       ),
//   //     ),
//   //     child: Text(
//   //       text,
//   //       style: const TextStyle(fontWeight: FontWeight.bold),
//   //     ),
//   //   );
//   // }
// }
