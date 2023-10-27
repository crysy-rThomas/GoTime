import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class ModifyTextAutocomplete extends StatefulWidget {
  const ModifyTextAutocomplete({
    super.key,
    required this.controller,
    required this.title,
    required this.isRequired,
    required this.suggestionsCallback,
    required this.onSuggestionSelected,
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
  final FutureOr<Iterable<String>> Function(String) suggestionsCallback;
  final void Function(String) onSuggestionSelected;

  @override
  State<ModifyTextAutocomplete> createState() => _ModifyTextAutocompleteState();
}

class _ModifyTextAutocompleteState extends State<ModifyTextAutocomplete> {
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
        TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: widget.controller,
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
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(248, 249, 250, 1),
                  width: 2,
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
            ),
          ),
          loadingBuilder: (context) {
            return const SizedBox(
              height: 60,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          noItemsFoundBuilder: (context) {
            return ListTile(
              title: Text(
                "Aucun résultat",
                style: TextStyle(
                  color: Colors.grey.withOpacity(0.6),
                ),
              ),
            );
          },
          suggestionsCallback: widget.suggestionsCallback,
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion.replaceAll('/', ' ')),
            );
          },
          onSuggestionSelected: widget.onSuggestionSelected,
          validator: (value) {
            if (value!.isEmpty && widget.isRequired) {
              return 'Veuillez remplir ce champ';
            }
            if (widget.validator != null) {
              return widget.validator!(value);
            }
            return null;
          },
        ),
      ],
    );
  }
}
