import 'package:flutter/material.dart';

class FormWidget extends StatelessWidget {
  const FormWidget(
      {Key? key,
      required this.controller,
      required this.focusNode,
      required this.keyboardType,
      required this.label,
      required this.onSaved,
      required this.textInputAction})
      : super(key: key);
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String label;
  final void Function(String?)? onSaved;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.black),
            fillColor: Colors.transparent,
            focusColor: Colors.black,
            filled: true),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: focusNode != null
            ? (value) => FocusScope.of(context).requestFocus(focusNode)
            : (_) => {},
        onSaved: onSaved,
      ),
    );
  }
}
