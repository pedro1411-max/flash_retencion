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
  bool excentoIVA;
  bool excentoISLR;

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
    this.excentoIVA,
    this.excentoISLR,
  );

  double montoConIva() {
    double total = montoBase * 0.16 + montoBase;
    return excentoIVA == true ? 0.00 : total;
  }

  double retencionIva() {
    double iva = montoBase * 0.16;
    return excentoIVA == true ? 0.00 : iva * (retenIva / 100);
  }

  double retencionIslr() {
    return excentoISLR == true ? 0 : montoBase * (retenIslr / 100);
  }

  double retencionIae() {
    return montoBase * (retenIae / 100) * (porcentajeIAE / 100);
  }

  double montoTotal() {
    double conIva =
        montoConIva() - retencionIva() - retencionIslr() - retencionIae();
    double sinIva = montoBase - retencionIslr() - retencionIae();
    return excentoIVA == true ? sinIva : conIva;
  }
}
