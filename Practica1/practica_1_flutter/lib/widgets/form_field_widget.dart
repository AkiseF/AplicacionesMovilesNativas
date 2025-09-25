import 'package:flutter/material.dart';

enum FormFieldType {
  text,
  password,
  multiline,
  number,
  email,
}

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldType type;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? hintText;
  final ValueChanged<String>? onChanged;

  const CustomFormField({
    super.key,
    required this.controller,
    required this.label,
    this.type = FormFieldType.text,
    this.maxLines = 1,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    TextInputType? inputType = keyboardType;
    bool isObscured = obscureText;
    int lines = maxLines;
    Widget? suffix = suffixIcon;

    // Configurar según el tipo
    switch (type) {
      case FormFieldType.password:
        isObscured = true;
        suffix = const Icon(Icons.visibility_off);
        break;
      case FormFieldType.multiline:
        lines = 3;
        break;
      case FormFieldType.number:
        inputType = TextInputType.number;
        break;
      case FormFieldType.email:
        inputType = TextInputType.emailAddress;
        break;
      case FormFieldType.text:
        break;
    }

    return TextField(
      controller: controller,
      obscureText: isObscured,
      maxLines: lines,
      keyboardType: inputType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
        suffixIcon: suffix,
        alignLabelWithHint: lines > 1,
      ),
    );
  }
}

class FormFieldGroup extends StatelessWidget {
  final List<Widget> fields;
  final String? title;
  final String? description;

  const FormFieldGroup({
    super.key,
    required this.fields,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        if (title != null && description != null)
          const SizedBox(height: 16),
        if (description != null)
          Text(
            description!,
            style: const TextStyle(fontSize: 16),
          ),
        if (title != null || description != null)
          const SizedBox(height: 24),
        ...fields.map((field) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: field,
        )),
      ],
    );
  }
}