import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:laptop_price_predicition/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for jsonEncode

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _formKey = GlobalKey<FormState>();
  int key = 0;
  String prediction = '';
  TextEditingController ramCtrl = TextEditingController();
  TextEditingController screenSizeCtrl = TextEditingController();
  TextEditingController weightCtrl = TextEditingController();
  final brandCtrl = SingleSelectController<String>(Models.laptopBrands[0]);
  final typeCtrl = SingleSelectController<String>(Models.Type[0]);
  final screenSpecsCtrl =
      SingleSelectController<String>(Models.displayResolutions[0]);
  final cpuCtrl = SingleSelectController<String>(Models.cpus[0]);
  final hardDiskCtrl = SingleSelectController<String>(Models.storageOptions[0]);
  final gpuCtrl = SingleSelectController<String>(Models.gpus[0]);
  final osCtrl = SingleSelectController<String>(Models.os[0]);

  Future<void> sendPostRequest(payload) async {
    const url = 'http://localhost:5000/Predict';

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      prediction = response.body;
      print("Response: ${response.body}");
    } else {
      prediction = response.statusCode.toString();
      print("Failed with status: ${response.statusCode}");
    }
  }

  void refreshPredict() {
    setState(() {
      key++;
    });
  }

  Widget buildDropdownField({
    required String label,
    required Widget dropdown,
  }) {
    return Container(
      margin: EdgeInsets.all(10),
      width: 250,
      height: 70,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          dropdown,
        ],
      ),
    );
  }

  Widget buildTextInputField({
    required TextEditingController controller,
    required String label,
    required String fieldKey,
    required Map<String, dynamic> payload,
  }) {
    return Container(
      margin: EdgeInsets.all(10),
      width: 250,
      height: 70,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$fieldKey is required';
          }
          return null;
        },
        onChanged: (value) {
          payload[fieldKey] = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> payload = {
      'Brand': brandCtrl.value!.trim(),
      'Type': typeCtrl.value!.trim(),
      'Screen Size': screenSizeCtrl.text.trim(),
      'Screen Specs': screenSpecsCtrl.value!.trim(),
      'CPU': cpuCtrl.value!.trim(),
      'RAM': ramCtrl.text.trim(),
      'Hard Disk': hardDiskCtrl.value!.trim(),
      'GPU': gpuCtrl.value!.trim(),
      'Operating System': osCtrl.value!.trim(),
      'Weight': weightCtrl.text.trim(),
    };
    return Expanded(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Wrap(
            spacing: 10, // horizontal spacing
            runSpacing: 10, // vertical spacing between lines
            children: [
              buildDropdownField(
                label: 'Operating System',
                dropdown: SimpleDropdown(
                  controller: osCtrl,
                  list_: Models.os,
                  onChanged: (p0) => payload['Operating System'] = p0!,
                ),
              ),
              buildDropdownField(
                label: 'GPU',
                dropdown: SimpleSearchDropdown(
                  controller: gpuCtrl,
                  list_: Models.gpus,
                  onChanged: (p0) => payload['GPU'] = p0!,
                ),
              ),
              buildDropdownField(
                label: 'CPU',
                dropdown: SimpleSearchDropdown(
                  controller: cpuCtrl,
                  list_: Models.cpus,
                  onChanged: (p0) => payload['CPU'] = p0!,
                ),
              ),
              buildDropdownField(
                label: 'Hard Disk',
                dropdown: SimpleSearchDropdown(
                  controller: hardDiskCtrl,
                  list_: Models.storageOptions,
                  onChanged: (p0) => payload['Hard Disk'] = p0!,
                ),
              ),
              buildDropdownField(
                label: 'Brand',
                dropdown: SimpleDropdown(
                  controller: brandCtrl,
                  list_: Models.laptopBrands,
                  onChanged: (p0) => payload['Brand'] = p0!,
                ),
              ),
              buildDropdownField(
                label: 'Type',
                dropdown: SimpleDropdown(
                  controller: typeCtrl,
                  list_: Models.Type,
                  onChanged: (p0) => payload['Type'] = p0!,
                ),
              ),
              buildDropdownField(
              label: 'Screen Specs',
              dropdown: SimpleSearchDropdown(
                controller: screenSpecsCtrl,
                list_: Models.displayResolutions,
                onChanged: (p0) => payload['Screen Specs'] = p0!,
              ),
            ),
              buildTextInputField(
                controller: ramCtrl,
                label: 'RAM Ex: 1',
                fieldKey: 'RAM',
                payload: payload,
              ),
              buildTextInputField(
                controller: screenSizeCtrl,
                label: 'Screen Size Ex: 1.1',
                fieldKey: 'Screen Size',
                payload: payload,
              ),
              buildTextInputField(
                controller: weightCtrl,
                label: 'Weight Ex: 1.1',
                fieldKey: 'Weight',
                payload: payload,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.lightBlueAccent,
                        Colors.blue[800]!
                      ], // light blue → darker blue
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(2, 4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Make background transparent to see gradient
                      shadowColor: Colors.transparent, // Disable default shadow
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await sendPostRequest(payload);
                        refreshPredict();
                      }
                    },
                    child: Text(
                      'Predict!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  key: ValueKey(key),
                  'The Predicted Price is $prediction',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleDropdown extends StatelessWidget {
  final List<String> list_;
  final dynamic Function(String?)? onChanged;
  final SingleSelectController<String> controller;
  const SimpleDropdown(
      {super.key,
      required this.list_,
      required this.onChanged,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
        controller: controller, items: list_, onChanged: onChanged);
  }
}

class SimpleSearchDropdown extends StatelessWidget {
  final List<String> list_;
  final dynamic Function(String?)? onChanged;
  final SingleSelectController<String> controller;
  const SimpleSearchDropdown(
      {super.key,
      required this.list_,
      required this.onChanged,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>.search(
      controller: controller,
      items: list_,
      onChanged: onChanged,
    );
  }
}
