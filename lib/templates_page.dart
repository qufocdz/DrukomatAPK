import 'package:flutter/material.dart';
import 'globals.dart';

class TemplatesPage extends StatelessWidget {
  const TemplatesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(verdigris),
      appBar: AppBar(
        title: const Text("Szablony druku"),
        backgroundColor: const Color(midnightGreen),
        foregroundColor: const Color(electricBlue),
      ),
      body: const Center(
        child: Text(
          "Tutaj możesz wybrać szablon druku.",
          style: TextStyle(
            fontSize: 16,
            color: Color(richBlack),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
