import 'package:flutter/material.dart';

import 'show_snack_bar.dart';

class ChangerNom extends StatefulWidget {
  const ChangerNom({super.key, required this.name});

  final String name;

  @override
  State<ChangerNom> createState() => _ChangerNomState();
}

class _ChangerNomState extends State<ChangerNom> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const SelectableText(
        "Nom du fichier",
        style: TextStyle(
          fontSize: 24,
          color: Color.fromRGBO(72, 80, 86, 1),
          fontWeight: FontWeight.w500,
        ),
      ),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: "Nom du fichier",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(101, 126, 233, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () {
              if (controller.text.isEmpty) {
                showSnackBar("Veuillez entrer un nom de fichier",
                    isError: true);
                return;
              }
              if (!controller.text.contains(".pdf")) {
                showSnackBar(
                    "Veuillez entrer un nom de fichier finissant par .pdf",
                    isError: true);
                return;
              }
              Navigator.pop(context, controller.text);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Valider'),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Annuler',
              style: TextStyle(
                color: Color.fromRGBO(101, 126, 233, 1),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
