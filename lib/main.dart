//comentario prueba

import 'package:flash_retencion/screens/create_facture.dart';
import 'package:flash_retencion/screens/save_facture.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  final formKey = GlobalKey<FormState>();
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flash Retencion'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Text(
              "Empresa",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: 150),

            Image.asset('assets/1.png'),
            Expanded(child: SizedBox()),
            Row(
              children: [
                Text(
                  "Correo: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text("info@intento.com.ve", style: TextStyle(fontSize: 20)),
              ],
            ),
            Row(
              children: [
                Text(
                  "Telefono: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text("+58255-622-20-30", style: TextStyle(fontSize: 20)),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
      appBar: AppBar(
        // This trailing comma makes auto-formatting nicer for build methods.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: controller,
          tabs: [
            Text('Creacion', style: TextStyle(height: 2.5)),
            Text('Guardado', style: TextStyle(height: 2.5)),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [Busqueda(), SaveFacture()],
      ),
    );
  }
}
