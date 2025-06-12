import 'package:flash_retencion/models/retencion.dart';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

// Importamos ambos paquetes (el correcto se usará en tiempo de ejecución)
import 'package:sqflite/sqflite.dart' as mobile;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as desktop;

class Basedatos {
  static bool _isDesktop = false;
  static bool _initialized = false;

  static Future<void> _init() async {
    if (_initialized) return;

    // Detectamos si estamos en escritorio (Windows/Linux/macOS)
    _isDesktop = !kIsWeb && (await _isPlatformDesktop());

    if (_isDesktop) {
      desktop.sqfliteFfiInit();
      desktop.databaseFactory = desktop.databaseFactoryFfi;
    }

    _initialized = true;
  }

  static Future<bool> _isPlatformDesktop() async {
    try {
      // Intenta acceder a una API solo disponible en desktop
      final result = await desktop.databaseFactoryFfi.openDatabase('test');
      await result.close();
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<dynamic> open() async {
    await _init();

    final databasePath = await (_isDesktop
        ? desktop.getDatabasesPath()
        : mobile.getDatabasesPath());

    final path = join(databasePath, 'retenciones.db');
    print(path);
    return _isDesktop
        ? desktop.openDatabase(path, version: 1, onCreate: _onCreate)
        : mobile.openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(dynamic db, int version) async {
    await db.execute(
      'CREATE TABLE Retenciones (id INTEGER PRIMARY KEY, documento TEXT, nombre TEXT, numfactura TEXT,numcontrol TEXT, '
      'descripcion TEXT, montobase REAL, retenIVA REAL, retenISLR REAL, '
      'retenIAE REAL, porcentIAE REAL, excentoIVA REAL, excentoISLR REAL, fecha TEXT)',
    );
  }

  static Future<void> insertar(Retencion datos) async {
    final db = await open();
    try {
      await db.insert('Retenciones', {
        'documento': datos.documento,
        'nombre': datos.nombre,
        'descripcion': datos.descripcion,
        'numfactura': datos.numFactura,
        'numcontrol': datos.numControl,
        'montobase': datos.montoBase,
        'retenIVA': datos.retenIva,
        'retenISLR': datos.retenIslr,
        'retenIAE': datos.retenIae,
        'porcentIAE': datos.porcentajeIAE,
        'excentoIVA': datos.excentoIVA ? 1.00 : 0.00,
        'excentoISLR': datos.excentoISLR ? 1.00 : 0.00,
        'fecha': datos.fecha.toIso8601String(),
      });
    } finally {
      await db.close();
    }
  }

  static Future<void> delete(int id) async {
    final db = await open();
    try {
      await db.delete('Retenciones', where: 'id = ?', whereArgs: [id]);
    } finally {
      await db.close();
    }
  }

  static Future<List<Retencion>> viewData() async {
    final db = await open();
    try {
      final List<Map<String, dynamic>> mapRetenciones = await db.query(
        'Retenciones',
        orderBy: 'id DESC',
      );
      print(mapRetenciones);
      return List.generate(
        mapRetenciones.length,
        (i) => Retencion(
          mapRetenciones[i]['id'],
          mapRetenciones[i]['documento'],
          mapRetenciones[i]['nombre'],
          mapRetenciones[i]['numfactura'],
          mapRetenciones[i]['numcontrol'],
          mapRetenciones[i]['descripcion'],
          mapRetenciones[i]['montobase'],
          mapRetenciones[i]['retenISLR'],
          mapRetenciones[i]['retenIVA'],
          mapRetenciones[i]['retenIAE'],
          mapRetenciones[i]['porcentIAE'],
          mapRetenciones[i]['excentoIVA'] == 1.00 ? true : false,
          mapRetenciones[i]['excentoISLR'] == 1.00 ? true : false,
          DateTime.parse(mapRetenciones[i]['fecha']),
        ),
      );
    } finally {
      await db.close();
    }
  }
}
