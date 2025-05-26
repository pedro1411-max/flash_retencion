import 'package:flutter/material.dart';

class Facture extends StatefulWidget {
  const Facture({super.key});
  @override
  State<Facture> createState() => _FatureState();
}

class _FatureState extends State<Facture> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_rounded)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        decoration: BoxDecoration(
            border: Border.all(width: 2),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: ListView(children: [
          Text("Factura"),
        ]),
      ),
    );
  }
}
