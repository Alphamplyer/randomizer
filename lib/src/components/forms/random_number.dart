
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RandomNumberForm extends StatefulWidget {
  const RandomNumberForm({
    required this.onSubmit,
    Key? key
  }) : super(key: key);

  final Function(int min, int max) onSubmit;

  @override
  State<RandomNumberForm> createState() => _RandomNumberFormState();
}

class _RandomNumberFormState extends State<RandomNumberForm> {
  final _formKey = GlobalKey<FormState>();
  final _minController = TextEditingController();
  final _maxController = TextEditingController();

  final TextInputFormatter _signedIntegerFormatter = TextInputFormatter.withFunction((oldValue, newValue) {
    RegExp exp = RegExp(r'[0-9]');

    for (int i = 0; i < newValue.text.length; i++) {
      if (i == 0 && newValue.text[i] == '-') {
        continue;
      }
      if (!exp.hasMatch(newValue.text[i])) {
        return oldValue;
      }
    }

    return newValue;
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _minController,
              decoration: const InputDecoration(
                labelText: 'Minimum',
              ),
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [
                _signedIntegerFormatter
              ],
              validator: (value) {
                if (value == null || value.isEmpty || int.tryParse(value) == null) {
                  return 'Please enter a number';
                }
                if (_maxController.text.isNotEmpty && int.parse(value) > int.parse(_maxController.text)) {
                  return 'Minimum must be less than maximum';
                }
                return null;
              }
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _maxController,
              decoration: const InputDecoration(
                labelText: 'Maximum',
              ),
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              inputFormatters: [
                _signedIntegerFormatter
              ],
              validator: (value) {
                if (value == null || value.isEmpty || int.tryParse(value) == null) {
                  return 'Please enter a number';
                }
                if (_minController.text.isNotEmpty && int.parse(value) < int.parse(_minController.text)) {
                  return 'Maximum must be greater than minimum';
                }
                return null;
              }
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 55,
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('Generate'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final min = int.parse(_minController.text);
                    final max = int.parse(_maxController.text);
                    widget.onSubmit.call(min, max);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}