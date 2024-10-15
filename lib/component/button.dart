import 'package:flutter/material.dart';

class ButtonComponent extends StatelessWidget {
  final String label;
  final VoidCallback onclick;
  const ButtonComponent(
      {required this.label, required this.onclick, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onclick,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(9),
        ),
        alignment: Alignment.center,
        height: 40,
        width: double.infinity,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
