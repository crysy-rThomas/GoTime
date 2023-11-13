import 'package:flutter/material.dart';

AlertDialog alertDelete(BuildContext context) {
  return AlertDialog(
    title: const SelectableText(
      "Delete account",
      style: TextStyle(
        color: Color.fromRGBO(145, 150, 154, 1),
        fontWeight: FontWeight.w500,
        fontSize: 24,
      ),
    ),
    content: const SelectableText(
      "Are you sure you want to delete this account ?",
      style: TextStyle(
        color: Color.fromRGBO(72, 80, 86, 1),
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
    ),
    actionsOverflowDirection: VerticalDirection.up,
    actions: [
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Color.fromRGBO(101, 126, 233, 1),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(101, 126, 233, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Log out",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
