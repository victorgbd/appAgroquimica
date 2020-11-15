import 'dart:io';

import 'package:agroquimica/data/entities/detallefact_entities.dart';
import 'package:agroquimica/data/entities/direccion/direccion_entities.dart';
import 'package:agroquimica/data/entities/image_entities.dart';
import 'package:agroquimica/data/entities/productos_entities.dart';
import 'package:agroquimica/data/entities/user_entities.dart';
import 'package:agroquimica/data/entities/usere_entities.dart';
import 'package:dartz/dartz.dart';
import 'package:agroquimica/data/entities/factura_entities.dart';

abstract class IFacturaAdminRepository {
  Future<Either<Failure, List<ImageEntities>>> getImageResult(File fileImage);
  Future<Either<Failure, int>> createFactura(FacturaEntities factura);
  Future<Either<Failure, Unit>> createdetalleFactura(
      List<DetallefactEntities> factura);
  Future<Either<Failure, List<UserEntities>>> getUsers(
      String user, String password);
  Future<Either<Failure, UserEntities>> getUser(String user, String password);
  Future<Either<Failure, UserEEntities>> getUserE(String user, String password);
  Future<Either<Failure, bool>> validateUser(String user, String password);
  Future<Either<Failure, bool>> validateUsername(String user);
  Future<Either<Failure, Unit>> createUser(UserEEntities usuario);
  Future<Either<Failure, List<DireccionEntities>>> getDireccion(String query);
  Future<Either<Failure, List<ProductosEntities>>> getProductos();
}

abstract class Failure {
  final String message;
  const Failure(
    this.message,
  );
}
