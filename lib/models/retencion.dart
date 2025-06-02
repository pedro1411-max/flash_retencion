class Retencion {
  int id;
  String documento;
  String nombre;
  String descripcion;
  double montoBase;
  double retenIslr;
  double retenIva;
  double retenIae;
  double porcentajeIAE;

  Retencion(
    this.id,
    this.documento,
    this.nombre,
    this.descripcion,
    this.montoBase,
    this.retenIslr,
    this.retenIva,
    this.retenIae,
    this.porcentajeIAE,
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
    return montoBase * (retenIae / 100) * (porcentajeIAE / 100);
  }

  double montoTotal() {
    return montoConIva() - retencionIva() - retencionIslr() - retencionIae();
  }
}
