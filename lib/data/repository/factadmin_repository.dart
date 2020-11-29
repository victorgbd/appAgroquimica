import 'dart:convert';
import 'dart:io';
import 'package:agroquimica/data/models/detallefact_model.dart';
import 'package:agroquimica/data/models/direccion/direccion_model.dart';
import 'package:agroquimica/data/models/factura_model.dart';
import 'package:agroquimica/data/models/imagesres_model.dart';
import 'package:agroquimica/data/entities/productos_entity.dart';
import 'package:agroquimica/data/models/productos_model.dart';
import 'package:agroquimica/data/models/recomendacion/recomendacion_model.dart';
import 'package:agroquimica/data/models/usere_model.dart';
import 'package:agroquimica/data/models/userflag_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:agroquimica/data/entities/detallefact_entities.dart';
import 'package:agroquimica/data/entities/direccion/direccion_entities.dart';
import 'package:agroquimica/data/entities/image_entities.dart';
import 'package:agroquimica/data/entities/usere_entities.dart';
import 'package:dartz/dartz.dart';
import 'package:agroquimica/data/entities/factura_entities.dart';
import 'package:path/path.dart';
part 'factadmin_repositoryimp.dart';

abstract class IFacturaAdminRepository {
  Future<Either<Failure, List<ImageEntities>>> getImageResult(File fileImage);
  Future<Either<Failure, int>> createFactura(FacturaEntities factura);
  Future<Either<Failure, Unit>> createdetalleFactura(
      List<DetallefactEntities> factura);

  Future<Either<Failure, UserEEntities>> getUserE(String user, String password);
  Future<Either<Failure, bool>> validateUser(String user, String password);
  Future<Either<Failure, bool>> validateUsername(String user);
  Future<Either<Failure, Unit>> createUser(UserEEntities usuario);
  Future<Either<Failure, List<DireccionEntities>>> getDireccion(String query);
  Future<Either<Failure, List<ProductosEntity>>> getProductos();
  Future<Either<Failure, List<dynamic>>> getRecomendacion(String query);
}

abstract class Failure {
  final String message;
  const Failure(
    this.message,
  );
}
