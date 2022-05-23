import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon, //Opcional
  }) {
    return InputDecoration(
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
          color: Colors.deepPurple,
        )),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.deepPurple,
            width: 2,
          ),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.grey,
        ),
        hintText: hintText,
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: Colors.indigo) : null);
  }
}
