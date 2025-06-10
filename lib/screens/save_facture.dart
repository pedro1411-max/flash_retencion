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
  List<Retencion> _allRetenciones = [];
  List<Retencion> _filteredRetenciones = [];
  String _searchType = 'fecha'; // 'fecha', 'numfactura', 'numcontrol'
  DateTime? _selectedDate;
  final TextEditingController _searchController = TextEditingController();

  // Función para formatear fechas sin usar intl
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void initState() {
    super.initState();
    _refreshList();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshList() async {
    setState(() {
      _retencionesFuture = Basedatos.viewData().then((retenciones) {
        _allRetenciones = retenciones;
        _filteredRetenciones = retenciones;
        return retenciones;
      });
    });
  }

  void _deleteRetencion(int id) async {
    await Basedatos.delete(id);
    _refreshList();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Retención eliminada')),
    );
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty && _selectedDate == null) {
        _filteredRetenciones = _allRetenciones;
      } else {
        _filteredRetenciones = _allRetenciones.where((retencion) {
          if (_searchType == 'fecha' && _selectedDate != null) {
            return retencion.fecha.year == _selectedDate!.year &&
                   retencion.fecha.month == _selectedDate!.month &&
                   retencion.fecha.day == _selectedDate!.day;
          } else if (_searchType == 'numfactura') {
            return retencion.numFactura.toLowerCase().contains(query);
          } else if (_searchType == 'numcontrol') {
            return retencion.numControl.toLowerCase().contains(query);
          }
          return false;
        }).toList();
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _onSearchChanged();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChoiceChip(
                      label: const Text('Fecha'),
                      selected: _searchType == 'fecha',
                      onSelected: (selected) {
                        setState(() {
                          _searchType = 'fecha';
                          _searchController.clear();
                          _onSearchChanged();
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('N° Factura'),
                      selected: _searchType == 'numfactura',
                      onSelected: (selected) {
                        setState(() {
                          _searchType = 'numfactura';
                          _selectedDate = null;
                          _onSearchChanged();
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('N° Control'),
                      selected: _searchType == 'numcontrol',
                      onSelected: (selected) {
                        setState(() {
                          _searchType = 'numcontrol';
                          _selectedDate = null;
                          _onSearchChanged();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_searchType == 'fecha')
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Seleccione fecha',
                              border: OutlineInputBorder(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedDate == null
                                      ? 'Seleccione una fecha'
                                      : _formatDate(_selectedDate!),
                                ),
                                const Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (_selectedDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _selectedDate = null;
                              _onSearchChanged();
                            });
                          },
                        ),
                    ],
                  )
                else
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: _searchType == 'numfactura'
                          ? 'Buscar por N° Factura'
                          : 'Buscar por N° Control',
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Retencion>>(
              future: _retencionesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || _filteredRetenciones.isEmpty) {
                  return const Center(child: Text('No hay retenciones registradas'));
                }

                return ListView.builder(
                  itemCount: _filteredRetenciones.length,
                  itemBuilder: (context, index) {
                    final retencion = _filteredRetenciones[index];
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fecha: ${_formatDate(retencion.fecha)}'),
                            Text('N° Factura: ${retencion.numFactura}'),
                            Text('N° Control: ${retencion.numControl}'),
                            Text('Monto Base: ${retencion.montoBase.toStringAsFixed(2)}bs'),
                          ],
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
          ),
        ],
      ),
    );
  }
}
