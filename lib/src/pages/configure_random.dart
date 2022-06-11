
import 'package:flutter/material.dart';
import 'package:randomizer/src/components/forms/random_number.dart';

class ConfigureRandomPage extends StatelessWidget {
  const ConfigureRandomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configure Random"),
      ),
      body: RandomNumberForm(
        key: const Key("random_number_form"),
        onSubmit: (min, max) {
          Navigator.pop(context, [min, max]);
        },
      ),
    );
  }
}