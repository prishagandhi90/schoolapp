import 'package:flutter/material.dart';

class EmpAttDtlExtraData extends StatelessWidget {
  const EmpAttDtlExtraData({
    super.key,
    required this.punch,
    required this.shift,
    required this.lv,
    required this.st,
    required this.oTENTMIN,
    required this.oTMIN,
    required this.lc,
    required this.eg,
  });

  final String punch, shift, lv, st, oTENTMIN, oTMIN, lc, eg;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(punch),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(shift),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(lv),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(st),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(oTENTMIN),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(oTMIN),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(lc),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(eg),
            ),
          ],
        )
      ],
    );
  }
}
