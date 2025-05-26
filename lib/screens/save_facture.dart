import 'package:flutter/material.dart';

class SaveFacture extends StatefulWidget {
  const SaveFacture({super.key});
  @override
  State<SaveFacture> createState() => _SaveFactureState();
}

class _SaveFactureState extends State<SaveFacture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Text(
              'NO DATA',
            ),
          )
        ],
      ),
    );
  }
}
