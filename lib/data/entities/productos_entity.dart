import 'package:flutter/material.dart';

import 'package:agroquimica/data/models/productos_model.dart';

class ProductosEntity {
  ProductosEntity({
    @required this.codproducto,
    @required this.descripcion,
    @required this.codunidad,
    @required this.unidad,
    @required this.tipoprod,
    @required this.destipoprod,
    @required this.url,
    @required this.cantven,
    @required this.precio,
  });

  String codproducto;
  String descripcion;
  String codunidad;
  List<UnidadModel> unidad;
  String tipoprod;
  String destipoprod;
  String url;
  String cantven;
  String precio;
  setCantidadven(String cantidad) {
    this.cantven = cantidad;
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ProductosEntity &&
        o.codproducto == codproducto &&
        o.descripcion == descripcion &&
        o.tipoprod == tipoprod &&
        o.destipoprod == destipoprod &&
        o.url == url;
  }

  @override
  int get hashCode {
    return codproducto.hashCode ^
        descripcion.hashCode ^
        tipoprod.hashCode ^
        destipoprod.hashCode ^
        url.hashCode;
  }

  @override
  String toString() {
    return 'ProductosEntity(precio:$precio,codproducto: $codproducto,codunidad: $codunidad, descripcion: $descripcion, tipoprod: $tipoprod, destipoprod: $destipoprod, url: $url)';
  }
}
