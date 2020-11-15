// To parse this JSON data, do
//
//     final recomendacionModel = recomendacionModelFromJson(jsonString);

import 'package:agroquimica/data/entities/recomendacion/recomendacion_entities.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

List<RecomendacionModel> recomendacionModelFromJson(String str) =>
    List<RecomendacionModel>.from(
        json.decode(str).map((x) => RecomendacionModel.fromJson(x)));

String recomendacionModelToJson(List<RecomendacionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecomendacionModel extends RecomendacionEntities {
  RecomendacionModel({
    @required this.codprod,
    @required this.coduni,
    @required this.cantidad,
  });

  final String codprod;
  final String coduni;
  final String cantidad;

  factory RecomendacionModel.fromJson(Map<String, dynamic> json) =>
      RecomendacionModel(
        codprod: json["codprod"],
        coduni: json["coduni"],
        cantidad: json["cantidad"],
      );

  Map<String, dynamic> toJson() => {
        "codprod": codprod,
        "coduni": coduni,
        "cantidad": cantidad,
      };
}

List<RecomendacionesModel> direccionModelFromJson(String str) =>
    List<RecomendacionesModel>.from(
        json.decode(str).map((x) => RecomendacionesModel.fromJson(x)));

String direccionModelToJson(List<RecomendacionesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecomendacionesModel extends RecomendacionesEntities {
  RecomendacionesModel({
    @required this.cod,
    @required this.descripcion,
  });

  final int cod;
  final String descripcion;

  factory RecomendacionesModel.fromJson(Map<String, dynamic> json) =>
      RecomendacionesModel(
        cod: json["cod"],
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toJson() => {
        "cod": cod,
        "descripcion": descripcion,
      };
}
