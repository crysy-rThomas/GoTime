import 'package:flutter/material.dart';

class UserSmallInfo extends StatelessWidget {
  const UserSmallInfo({
    super.key,
    required this.title,
    required this.data,
  });

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(145, 150, 154, 1),
          ),
        ),
        const SizedBox(height: 8),
        SelectableText(
          data == '' || data == null || data == "null" ? 'Non renseigné' : data,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: data != null && data != '' && data != "null"
                ? const Color.fromRGBO(72, 80, 86, 1)
                : const Color.fromRGBO(145, 150, 154, 1),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
