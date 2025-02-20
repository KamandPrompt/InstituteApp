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
  final bool isLargeField;
  final void Function()? onTap;
  bool? readOnly;

  FormFieldWidget({
    super.key,
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
    this.isLargeField = false, // Default to false
  });

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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.isLargeField ? Container(
        width: 400, // Set constant width
        height: 200, // Set constant height
        child: Form(
          key: widget.fieldKey,
          child: Stack(
            children: [
              TextFormField(
                focusNode: widget.focusNode,
                onTapOutside: (event) {
                  widget.focusNode.unfocus();
                },
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
                maxLines: null, // Allows unlimited lines but within fixed height
                expands: true, // Makes text expand inside fixed container
                textAlignVertical: TextAlignVertical.top, // Aligns input text to the top
                decoration: InputDecoration(
                  errorText: widget.errorText,
                  errorStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onError, fontSize: 12),
                  contentPadding: const EdgeInsets.only(
                      top: 10, left: 40, right: 10, bottom: 10), // Space for the icon
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.scrim, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      gapPadding: 24),
                  hintText: widget.hintText,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Theme.of(context).colorScheme.scrim),
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
                      gapPadding: 24),
                ),
              ),
              Positioned(
                left: 10,
                top: 13,
                child: Icon(
                  widget.prefixIcon,
                  color: widget.focusNode.hasFocus
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.scrim,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ) : Form(
          key: widget.fieldKey,
          child: TextFormField(
            // autofocus: false,
            focusNode: widget.focusNode,
            onTapOutside: (event) {
              widget.focusNode.unfocus();
            },
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
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.scrim, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    gapPadding: 24),
                prefixIcon: Icon(
                  widget.prefixIcon,
                  color: widget.focusNode.hasFocus
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.scrim,
                  size: 18,
                ),
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
                    : const Icon(null),
                hintText: widget.hintText,
                hintStyle: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Theme.of(context).colorScheme.scrim),
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
          )) // Conditional rendering
    );
  }
}