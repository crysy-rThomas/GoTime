import 'package:flutter/material.dart';

class ModifyText extends StatefulWidget {
  const ModifyText({
    super.key,
    required this.controller,
    required this.title,
    required this.isRequired,
    this.keyboardType,
    this.validator,
    this.isLongText,
    this.removePlaceholder,
    this.isNotEditable,
    this.isLength,
  });

  final TextEditingController controller;
  final String title;
  final bool isRequired;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final bool? isLongText;
  final bool? removePlaceholder;
  final bool? isNotEditable;
  final bool? isLength;

  @override
  State<ModifyText> createState() => _ModifyTextState();
}

class _ModifyTextState extends State<ModifyText> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SelectableText(
              widget.title,
              style: const TextStyle(
                color: Color.fromRGBO(72, 80, 86, 1),
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 4),
            if (widget.isRequired)
              const SelectableText(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        if (widget.title != "") const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          validator: (value) {
            if (value!.isEmpty && widget.isRequired) {
              return 'Veuillez remplir ce champ';
            }
            if (widget.validator != null) {
              return widget.validator!(value);
            }
            return null;
          },
          keyboardType: widget.keyboardType,
          maxLines: widget.isLongText == true ? 5 : 1,
          enabled: widget.isNotEditable == true ? false : true,
          decoration: InputDecoration(
            hintText: widget.removePlaceholder == true ? null : widget.title,
            hintStyle: const TextStyle(
              color: Color.fromRGBO(72, 80, 86, 1),
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
            suffixIcon: (widget.isLength == true)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [Text('m2')],
                  )
                : null,
            fillColor: const Color.fromRGBO(248, 249, 250, 1),
            filled: true,
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color.fromRGBO(248, 249, 250, 1),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
