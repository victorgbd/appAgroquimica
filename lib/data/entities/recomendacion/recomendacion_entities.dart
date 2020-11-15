import 'package:flutter/material.dart';

class RecomendacionEntities {
  RecomendacionEntities({
    @required this.codprod,
    @required this.coduni,
    @required this.cantidad,
  });

  final String codprod;
  final String coduni;
  final String cantidad;
}

class RecomendacionesEntities {
  RecomendacionesEntities({
    @required this.cod,
    @required this.descripcion,
  });

  final int cod;
  final String descripcion;
}
