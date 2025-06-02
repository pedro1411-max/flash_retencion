import 'package:flash_retencion/database.dart';
import 'package:flash_retencion/models/retencion.dart';
import 'package:flash_retencion/screens/facture.dart';
import 'package:flutter/material.dart';

class SaveFacture extends StatefulWidget {
  const SaveFacture({super.key});
  @override
  State<SaveFacture> createState() => _SaveFactureState();
}

class _SaveFactureState extends State<SaveFacture> {
  late Future<List<Retencion>> _retencionesFuture;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _retencionesFuture = Basedatos.viewData();
    });
  }

  void _deleteRetencion(int id) async {
    await Basedatos.delete(id);
    _refreshList();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Retención eliminada')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Retencion>>(
        future: _retencionesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay retenciones registradas'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final retencion = snapshot.data![index];
              return Dismissible(
                key: Key(retencion.id.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirmar'),
                      content: const Text('¿Eliminar esta retención?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) {
                  _deleteRetencion(retencion.id);
                },
                child: ListTile(
                  title: Text(retencion.descripcion),
                  subtitle: Text(
                    'Monto Base: ${retencion.montoBase.toStringAsFixed(2)}bs',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Facture(false, retencion),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshList,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
