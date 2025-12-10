import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final FormFieldValidator<String>? validator;

  const PasswordInput({
    super.key,
    this.controller,
    this.label = 'Senha',
    this.validator,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText; // alterna visibilidade
            });
          },
        ),
      ),
      obscureText: _obscureText,
    );
  }
}
