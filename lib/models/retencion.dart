class Retencion {
  String documento;
  String nombre;
  String descripcion;
  double montoBase;
  double retenIslr;
  double retenIva;
  double retenIae;

  Retencion(
    this.documento,
    this.nombre,
    this.descripcion,
    this.montoBase,
    this.retenIslr,
    this.retenIva,
    this.retenIae,
  );

  double montoConIva() {
    double total = montoBase * 0.16 + montoBase;
    return total;
  }

  double retencionIva() {
    double iva = montoBase * 0.16;
    return iva * (retenIva / 100);
  }

  double retencionIslr() {
    return montoBase * (retenIslr / 100);
  }

  double retencionIae() {
    return montoBase * (retenIae / 100) * 0.5;
  }

  double montoTotal() {
    return montoConIva() - retencionIva() - retencionIslr() - retencionIae();
  }
}
