// To parse this JSON data, do
//
//     final productosModel = productosModelFromJson(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';

List<ProductosModel> productosModelFromJson(String str) =>
    List<ProductosModel>.from(
        json.decode(str).map((x) => ProductosModel.fromJson(x)));

String productosModelToJson(List<ProductosModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductosModel {
  ProductosModel({
    @required this.codproducto,
    @required this.descripcion,
    @required this.codunidad,
    @required this.unidad,
    @required this.tipoprod,
    @required this.destipoprod,
    @required this.url,
  });

  final String codproducto;
  final String descripcion;
  final String codunidad;
  final List<UnidadModel> unidad;
  final String tipoprod;
  final String destipoprod;
  final String url;

  factory ProductosModel.fromJson(Map<String, dynamic> json) => ProductosModel(
        codproducto: json["codproducto"],
        descripcion: json["descripcion"],
        codunidad: json["codunidad"],
        unidad: List<UnidadModel>.from(
            json["unidad"].map((x) => UnidadModel.fromJson(x))),
        tipoprod: json["tipoprod"],
        destipoprod: json["destipoprod"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "codproducto": codproducto,
        "descripcion": descripcion,
        "codunidad": codunidad,
        "unidad": List<dynamic>.from(unidad.map((x) => x.toJson())),
        "tipoprod": tipoprod,
        "destipoprod": destipoprod,
        "url": url,
      };

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ProductosModel &&
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
    return 'ProductosModel(codproducto: $codproducto, descripcion: $descripcion, tipoprod: $tipoprod, destipoprod: $destipoprod, url: $url, codunidad:$codunidad)';
  }
}

class UnidadModel {
  UnidadModel({
    @required this.desunidad,
    @required this.coduni,
    @required this.cantidad,
    @required this.precio,
  });

  final String desunidad;
  final String coduni;
  final String cantidad;
  final String precio;

  factory UnidadModel.fromJson(Map<String, dynamic> json) => UnidadModel(
        desunidad: json["desunidad"],
        coduni: json["coduni"],
        cantidad: json["cantidad"],
        precio: json["precio"],
      );

  Map<String, dynamic> toJson() => {
        "desunidad": desunidad,
        "coduni": coduni,
        "cantidad": cantidad,
        "precio": precio,
      };
}
