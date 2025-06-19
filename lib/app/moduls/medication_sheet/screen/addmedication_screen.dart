import 'package:emp_app/app/app_custom_widget/custom_dropdown.dart';
import 'package:flutter/material.dart';

class AddMedicationScreen extends StatelessWidget {
  final ScrollController formScrollController = ScrollController();
  final ScrollController listScrollController = ScrollController();

  final TextEditingController medicationTypeController = TextEditingController();
  final TextEditingController instTypeController = TextEditingController();
  final TextEditingController routeController = TextEditingController();
  final TextEditingController afternoonController = TextEditingController();

  final List<Map<String, String>> dummyItems = [
    {"text": "Option 1"},
    {"text": "Option 2"},
    {"text": "Option 3"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add Medication", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              controller: formScrollController,
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  buildTextField("KISHOR PRABHUBHAI DARJI (A/1469/25)", enabled: false),
                  buildCustomDropdown("Medication Type", medicationTypeController),
                  buildTextField("Formulary Medicine"),
                  buildTextField("Non Formulary Medicine"),
                  Row(
                    children: [
                      Expanded(child: buildCustomDropdown("Inst Typ", instTypeController)),
                      SizedBox(width: 8),
                      Expanded(child: buildTextField("Dose")),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: buildTextField("Qty")),
                      SizedBox(width: 8),
                      Expanded(child: buildCustomDropdown("Route", routeController)),
                    ],
                  ),
                  buildTextField("Remarks", maxLines: 2),
                  Row(
                    children: [
                      Expanded(child: buildTimingButton("Morning")),
                      Expanded(child: buildCustomDropdown("Afternoon", afternoonController)),
                      Expanded(child: buildTimingButton("Evening")),
                      Expanded(child: buildTimingButton("Night")),
                    ],
                  ),
                  buildTextField("Days"),
                  Row(
                    children: [
                      Expanded(child: buildDateField("Stop Date")),
                      SizedBox(width: 8),
                      Expanded(child: buildTimeField("Stop Time")),
                    ],
                  ),
                  buildTextField("Flow Rate"),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text("SAVE", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              "Added Medication (0)",
              style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 1,
            child: Scrollbar(
              controller: listScrollController,
              child: ListView.builder(
                controller: listScrollController,
                itemCount: 0,
                itemBuilder: (context, index) => ListTile(title: Text("Medication $index")),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String hint, {int maxLines = 1, bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        maxLines: maxLines,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildCustomDropdown(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: CustomDropdown(
        text: hint,
        controller: controller,
        onChanged: (value) {},
        items: dummyItems
            .map((e) => DropdownMenuItem<Map<String, String>>(
                  value: e,
                  child: Text(e['text']!),
                ))
            .toList(),
      ),
    );
  }

  Widget buildTimingButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: OutlinedButton(
        onPressed: () {},
        child: Text(text),
      ),
    );
  }

  Widget buildDateField(String hint) {
    return buildTextField(hint);
  }

  Widget buildTimeField(String hint) {
    return buildTextField(hint);
  }
}
