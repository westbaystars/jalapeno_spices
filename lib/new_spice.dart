/*
    Based on the Flutter Text Field + Date Picker at
    https://www.refactord.com/guides/flutter-text-field-date-picker
 */
import 'package:flutter/material.dart';

import 'spice.dart';

class NewSpiceForm extends StatefulWidget {
  NewSpiceForm({required Key key}) : super(key: key);

  @override
  _NewSpiceFormState createState() => _NewSpiceFormState();
}

class _NewSpiceFormState extends State<NewSpiceForm> {
  Map<String, dynamic> spice = new Spice(id: 0, name: "Onion Powder", expiration_date: DateTime(2022, 9, 22)).toMap();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            onSaved: (val) => spice["name"] = val!,
            decoration: InputDecoration(
              labelText: "Spice Name",
              icon: Icon(Icons.grass)
            ),
            validator: (value) {
              if (value == null || value.isEmpty)
                return "Please enter the name of the spice";
              return null;
            }
          ),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: TextFormField(
                onSaved: (val) {
                  spice["expiration_date"] = selectedDate;
                },
                controller: _dateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: "Expiration Date",
                  icon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Please enter an expiration date";
                  return null;
                },
              ),
            ),
          ),
          TextButton(
            child: Text("Commit"),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
              }
            },
          )
        ],
      )
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        var date =
            "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
        _dateController.text = date;
      });
  }
}