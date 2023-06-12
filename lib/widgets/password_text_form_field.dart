import 'package:flutter/material.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    super.key,
    this.readOnly = false,
    this.initialValue,
    this.passwordController,
    this.labelText,
    this.visiblePasswordIcon,
    this.obscurePasswordIcon,
    this.onChanged,
    this.errorMessage,
    this.onEditingComplete,
    this.textInputAction,
    this.hintText,
  });

  final bool readOnly;
  final String? initialValue;
  final String? labelText;
  final String? hintText;
  final Widget? visiblePasswordIcon;
  final Widget? obscurePasswordIcon;
  final TextEditingController? passwordController;
  final ValueChanged<String>? onChanged;
  final String? errorMessage;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final suffixIcon = obscurePassword
        ? widget.obscurePasswordIcon ??
            const Icon(Icons.remove_red_eye_outlined)
        : widget.visiblePasswordIcon ??
            const Icon(Icons.remove_red_eye_rounded);

    return TextFormField(
      readOnly: widget.readOnly,
      initialValue: widget.initialValue,
      controller: widget.passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obscurePassword,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      onEditingComplete: widget.onEditingComplete,
      decoration: InputDecoration(
        errorText: widget.errorMessage,
        labelText: widget.labelText,
        hintText: widget.hintText,
        suffixIcon: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _togglePasswordVisibility,
          child: UnconstrainedBox(child: suffixIcon),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }
}
