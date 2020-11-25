import 'dart:convert';
import 'dart:io';

import 'package:agroquimica/data/models/recomendacion/recomendacion_model.dart';
import 'package:path/path.dart';
import 'package:agroquimica/data/entities/detallefact_entities.dart';
import 'package:agroquimica/data/entities/direccion/direccion_entities.dart';
import 'package:agroquimica/data/entities/image_entities.dart';
import 'package:agroquimica/data/entities/productos_entities.dart';
import 'package:agroquimica/data/entities/user_entities.dart';
import 'package:agroquimica/data/entities/usere_entities.dart';
import 'package:agroquimica/data/models/detallefact_model.dart';
import 'package:agroquimica/data/models/direccion/direccion_model.dart';
import 'package:agroquimica/data/models/imagesres_model.dart';
import 'package:agroquimica/data/models/produtos_model.dart';
import 'package:agroquimica/data/models/user_model.dart';
import 'package:agroquimica/data/models/usere_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:agroquimica/data/entities/factura_entities.dart';
import 'package:agroquimica/data/models/factura_model.dart';
import 'package:agroquimica/data/repository/factadmin_repository.dart';
import 'package:http/http.dart';

class FacturaAdminRepositoryimp implements IFacturaAdminRepository {
  final http.Client httpClient;
  FacturaAdminRepositoryimp({
    @required this.httpClient,
  });
  final _url = "https://50785635ece4.ngrok.io";

  // @override
  // Future<Either<Failure, FacturaEntities>> getFactura() {
  //
  // }

  @override
  Future<Either<Failure, int>> createFactura(FacturaEntities factura) async {
    try {
      final factModel = FacturaModel(
          numfact: factura.numfact,
          codcli: factura.codcli,
          estado: factura.estado,
          tipfac: factura.tipfac,
          fecha: new DateTime.now(),
          codemp: 13,
          balance: factura.balance,
          total: factura.total);
      final response = await this
          .httpClient
          .post(_url + "/factura", body: facturaModelToJson([factModel]));
      print(response.body);
      print(response.statusCode);
      if (response.statusCode != 200)
        return Left(
            const FactAdminFailure(message: "something was wrong on create"));
      return Right(int.parse(response.body));
    } catch (e) {
      return Left(
          const FactAdminFailure(message: "something was wrong on create e"));
    }
  }

  @override
  Future<Either<Failure, UserEntities>> getUser(
      String user, String password) async {
    try {
      final body = UserModel(
          codusuario: '1',
          contrasena: password,
          nickname: user,
          tipoacceso: '0');
      final response = await this.httpClient.post(
            _url + "/user",
            body: userModelToJson([body]),
          );

      if (response.statusCode != 200) {
        return Left(
            const FactAdminFailure(message: "something was wrong in getdata"));
      }

      final listUser = userModelFromJson(response.body);
      if (listUser.isNotEmpty) {
        return Right(listUser[0]);
      } else {
        return Left(const FactAdminFailure(message: "usuario vacio"));
      }
    } catch (e) {
      return Left(
          const FactAdminFailure(message: "something was wrong in getdata"));
    }
  }

  @override
  Future<Either<Failure, bool>> validateUser(
      String user, String password) async {
    try {
      final body = UserModel(
          codusuario: '1',
          contrasena: password,
          nickname: user,
          tipoacceso: '0');
      final response = await this.httpClient.put(
            _url + "/user",
            body: userModelToJson([body]),
          );

      if (response.statusCode != 200) {
        return Left(
            const FactAdminFailure(message: "something was wrong in getdata"));
      }

      final listUser = userModelFromJson(response.body);

      return Right(listUser.isNotEmpty);
    } catch (e) {
      return Left(
          const FactAdminFailure(message: "something was wrong in getdata"));
    }
  }

  @override
  Future<Either<Failure, Unit>> createUser(UserEEntities usuario) async {
    try {
      final userModel = UserEModel(
          nombre: usuario.nombre,
          apellido: usuario.apellido,
          correo: usuario.correo,
          contrasena: usuario.contrasena,
          pais: usuario.pais,
          ciudad: usuario.ciudad,
          coddir: usuario.coddir,
          direccion: usuario.direccion,
          tipo: usuario.tipo,
          numeracion: usuario.numeracion,
          numerotelf: usuario.numerotelf,
          codciudad: usuario.codciudad,
          codpais: usuario.codpais,
          codcli: null);
      final response = await this
          .httpClient
          .post(_url + "/user", body: userEModelToJson([userModel]));
      print(response.body);
      print(response.statusCode);
      if (response.statusCode != 200)
        return Left(const FactAdminFailure(
            message: "something was wrong in create user"));
      return right(unit);
    } catch (e) {
      return Left(const FactAdminFailure(
          message: "something was wrong in create user"));
    }
  }

  @override
  Future<Either<Failure, bool>> validateUsername(String user) async {
    try {
      final body = UserModel(
          codusuario: '2', contrasena: '1', nickname: user, tipoacceso: '0');
      final response = await this.httpClient.put(
            _url + "/user",
            body: userModelToJson([body]),
          );

      if (response.statusCode != 200) {
        return Left(
            const FactAdminFailure(message: "something was wrong in getdata"));
      }

      final listUser = userModelFromJson(response.body);

      return Right(listUser.isNotEmpty);
    } catch (e) {
      return Left(
          const FactAdminFailure(message: "something was wrong in getdata"));
    }
  }

  @override
  Future<Either<Failure, List<UserEntities>>> getUsers(
      String user, String password) {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEEntities>> getUserE(
      String user, String password) async {
    try {
      final response = await this
          .httpClient
          .get(_url + "/user?email=" + user + "&password=" + password);

      if (response.statusCode != 200) {
        return Left(
            const FactAdminFailure(message: "something was wrong in getdata"));
      }

      final listUser = userEModelFromJson(response.body);
      if (listUser.isNotEmpty) {
        return Right(listUser[0]);
      } else {
        return Left(const FactAdminFailure(message: "usuario vacio"));
      }
    } catch (e) {
      return Left(
          const FactAdminFailure(message: "something was wrong in getdata"));
    }
  }

  @override
  Future<Either<Failure, List<DireccionEntities>>> getDireccion(
      String query) async {
    try {
      final response = await this.httpClient.get(_url + "/direccion" + query);

      if (response.statusCode != 200) {
        return Left(
            const FactAdminFailure(message: "something was wrong in getdata"));
      }

      final listdirection = direccionModelFromJson(response.body);
      if (listdirection.isNotEmpty) {
        return Right(listdirection);
      } else {
        return Left(const FactAdminFailure(message: "direccion vacio"));
      }
    } catch (e) {
      return Left(
          const FactAdminFailure(message: "something was wrong in getdata"));
    }
  }

  @override
  Future<Either<Failure, List<ProductosEntities>>> getProductos() async {
    try {
      final response = await this.httpClient.get(_url + "/productos");

      if (response.statusCode != 200) {
        return Left(
            const FactAdminFailure(message: "something was wrong in getdata"));
      }

      final listUser = productosModelFromJson(response.body);
      if (listUser.isNotEmpty) {
        return Right(listUser);
      } else {
        return Left(const FactAdminFailure(message: "productos vacio"));
      }
    } catch (e) {
      return Left(const FactAdminFailure(
          message: "something was wrong in getdata exeption"));
    }
  }

  @override
  Future<Either<Failure, Unit>> createdetalleFactura(
      List<DetallefactEntities> factura) async {
    try {
      List<DetallefactModel> detalle = List<DetallefactModel>();
      factura.forEach((element) {
        detalle.add(DetallefactModel(
            numfac: element.numfac,
            codproducto: element.codproducto,
            cantvent: element.cantvent,
            precvent: element.precvent,
            coduni: element.coduni));
      });
      final response = await this
          .httpClient
          .post(_url + "/dfactura", body: detallefactModelToJson(detalle));
      print(response.body);
      print(response.statusCode);
      if (response.statusCode != 200)
        return Left(
            const FactAdminFailure(message: "something was wrong on create"));
      return right(unit);
    } catch (e) {
      return Left(
          const FactAdminFailure(message: "something was wrong on create"));
    }
  }

  @override
  Future<Either<Failure, List<ImageEntities>>> getImageResult(
      File fileImage) async {
    try {
      final stream = http.ByteStream(fileImage.openRead());
      stream.cast();
      final length = await fileImage.length();

      final uri = Uri.parse(_url + "/upload");

      var request = MultipartRequest("POST", uri);

      final multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: basename(fileImage.path),
      );

      request.files.add(multipartFile);

      StreamedResponse response = await request.send();
      if (response.statusCode != 200)
        return Left(const FactAdminFailure(message: "Conexion Fallida"));

      var resp = await response.stream.transform(utf8.decoder).first;
      return Right(imageModelFromJson(resp));
    } catch (e) {
      return Left(const FactAdminFailure(message: "Conexion Fallida"));
    }
  }

  @override
  Future<Either<Failure, List>> getRecomendacion(String query) async {
    try {
      final response =
          await this.httpClient.get(_url + "/recomendacion" + query);

      if (response.statusCode != 200) {
        return Left(
            const FactAdminFailure(message: "something was wrong in getdata"));
      }
      List listrecom;
      if (query.contains("&codenfermedad=")) {
        listrecom = productosModelFromJson(response.body);
      } else {
        listrecom = recomendacionesModelFromJson(response.body);
      }
      if (listrecom.isNotEmpty) {
        return Right(listrecom);
      } else {
        return Left(const FactAdminFailure(message: "recomendacion vacia"));
      }
    } catch (e) {
      return Left(
          const FactAdminFailure(message: "something was wrong in getdata"));
    }
  }
}

class FactAdminFailure extends Failure {
  final String message;
  const FactAdminFailure({this.message}) : super(message);
}
