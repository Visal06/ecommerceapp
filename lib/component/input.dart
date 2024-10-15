import 'package:flutter/material.dart';

class InputEditor extends StatelessWidget {
  final String label;
  final bool obs;
  const InputEditor({required this.label, this.obs = false, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obs,
      decoration: InputDecoration(
        hintText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
