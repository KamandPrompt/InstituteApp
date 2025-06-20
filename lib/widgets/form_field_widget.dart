// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class FormFieldWidget extends StatefulWidget {
  final GlobalKey<FormState> fieldKey;
  final TextEditingController controller;
  final FocusNode focusNode;
  bool obscureText;
  final String? Function(String? value)? validator;
  final void Function(String value)? onChanged;
  final TextInputType keyboardType;
  final String? errorText;
  final IconData? prefixIcon;
  final bool showSuffixIcon;
  final String hintText;
  final TextInputAction textInputAction;
  final void Function()? onTap;
  bool? readOnly;
  int? maxLines;

  FormFieldWidget(
      {super.key,
      required this.fieldKey,
      required this.controller,
      required this.obscureText,
      required this.validator,
      this.onChanged,
      required this.keyboardType,
      required this.errorText,
      required this.prefixIcon,
      required this.showSuffixIcon,
      required this.hintText,
      this.onTap,
      this.readOnly,
      required this.focusNode,
      required this.textInputAction,
      this.maxLines = 1});

  @override
  State<FormFieldWidget> createState() => _FormFieldWidgetState();
}

class _FormFieldWidgetState extends State<FormFieldWidget> {
  void _togglevisibility() {
    setState(() {
      widget.obscureText = !widget.obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() {
        // if (widget.focusNode.hasFocus) {
        //   widget.controller.selection = TextSelection(
        //     baseOffset: 0,
        //     extentOffset: widget.controller.text.length,
        //   );
        // }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.fieldKey,
        child: TextFormField(
          // autofocus: false,
          focusNode: widget.focusNode,
          onTapOutside: (event) {
            widget.focusNode.unfocus();
          },
          maxLines: widget.maxLines == 0 ? null : widget.maxLines,
          readOnly: widget.readOnly ?? false,
          onTap: widget.onTap,
          controller: widget.controller,
          obscureText: widget.obscureText,
          cursorColor: Theme.of(context).primaryColor,
          validator: widget.validator,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          style: Theme.of(context).textTheme.labelSmall,
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
              errorText: widget.errorText,
              errorStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onError, fontSize: 12),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 15, horizontal: widget.prefixIcon != null ? 0 : 15),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.scrim, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  gapPadding: 24),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: widget.focusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.scrim,
                      size: 18,
                    )
                  : null,
              suffixIcon: widget.showSuffixIcon
                  ? GestureDetector(
                      onTap: () {
                        _togglevisibility();
                      },
                      child: Icon(
                        widget.obscureText
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: widget.focusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.scrim,
                        size: 18,
                      ),
                    )
                  : null,
              hintText: widget.hintText,
              hintStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.scrim,
                  overflow: TextOverflow.ellipsis),
              // hintMaxLines: 2,
              fillColor: Theme.of(context).cardColor,
              filled: true,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  gapPadding: 24),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onError, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  gapPadding: 24),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onError, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  gapPadding: 24)),
        ));
  }
}
