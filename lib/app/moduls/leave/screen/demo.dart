import 'package:emp_app/app/moduls/leave/screen/custom_textformfield.dart';
import 'package:flutter/material.dart';

class DemoScreen extends StatelessWidget {
  // final _formKey = GlobalKey<FormState>();

  String? _inputValue;

  void _submitForm() {
    // if (_formKey.currentState!.validate()) {
    //   _formKey.currentState!.save();
    //   // Process the input value
    //   print("Input value: $_inputValue");
    //   // Show a snackbar or navigate to another screen as needed
    //   // ScaffoldMessenger.of(context).showSnackBar(
    //   //   SnackBar(content: Text('Form submitted with value: $_inputValue')),
    //   // );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          // key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your value:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              CustomTextFormField(
                decoration: InputDecoration(
                  labelText: 'Value',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
                // onSaved: (value) {
                //   _inputValue = value;
                // },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DemoScreen(),
  ));
}
