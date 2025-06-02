import 'package:flash_retencion/models/retencion.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Basedatos {
  static Future<Database> open() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'retenciones.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE Retenciones (id INTEGER PRIMARY KEY, documento TEXT, nombre TEXT, descripcion TEXT, montobase REAL, retenIVA REAL, retenISLR REAL, retenIAE REAL, porcentIAE REAL)',
        );
      },
    );
  }

  static Future<void> insertar(Retencion datos) async {
    Database db = await open();
    try {
      await db.insert('Retenciones', {
        'documento': datos.documento,
        'nombre': datos.nombre,
        'descripcion': datos.descripcion,
        'montobase': datos.montoBase,
        'retenIVA': datos.retenIva,
        'retenISLR': datos.retenIslr,
        'retenIAE': datos.retenIae,
        'porcentIAE': datos.porcentajeIAE,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } finally {
      await db.close();
    }
  }

  static Future<void> delete(int id) async {
    Database db = await open();
    try {
      await db.delete('Retenciones', where: 'id = ?', whereArgs: [id]);
    } finally {
      await db.close();
    }
  }

  static Future<List<Retencion>> viewData() async {
    Database db = await open();
    try {
      final List<Map<String, dynamic>> mapRetenciones = await db.query(
        'Retenciones',
      );

      return List.generate(
        mapRetenciones.length,
        (i) => Retencion(
          mapRetenciones[i]['id'],
          mapRetenciones[i]['documento'],
          mapRetenciones[i]['nombre'],
          mapRetenciones[i]['descripcion'],
          mapRetenciones[i]['montobase'],
          mapRetenciones[i]['retenISLR'],
          mapRetenciones[i]['retenIVA'],
          mapRetenciones[i]['retenIAE'],
          mapRetenciones[i]['porcentIAE'],
        ),
      );
    } finally {
      await db.close();
    }
  }
}
