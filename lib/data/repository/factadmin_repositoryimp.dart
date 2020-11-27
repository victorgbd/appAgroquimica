part of 'factadmin_repository.dart';

class FacturaAdminRepositoryimp implements IFacturaAdminRepository {
  final http.Client httpClient;
  FacturaAdminRepositoryimp({
    @required this.httpClient,
  });
  final _url = "https://3542a0551334.ngrok.io";

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
  Future<Either<Failure, bool>> validateUser(
      String user, String password) async {
    try {
      final response = await this.httpClient.get(
            _url + "/user?nickname=" + user + "&contrasena=" + password,
          );
      if (response.statusCode != 200) {
        return Left(
            const FactAdminFailure(message: "something was wrong in getdata"));
      }
      final flag = userflagmodelFromJson(response.body);
      return Right(flag.flag);
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
          codcli: usuario.codcli);
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
      final response =
          await this.httpClient.get(_url + "/user?nickname=" + user);

      if (response.statusCode != 200) {
        return Left(
            const FactAdminFailure(message: "something was wrong in getdata"));
      }
      final flag = userflagmodelFromJson(response.body);
      return Right(flag.flag);
    } catch (e) {
      return Left(
          const FactAdminFailure(message: "something was wrong in getdata"));
    }
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

      var request = http.MultipartRequest("POST", uri);

      final multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: basename(fileImage.path),
      );

      request.files.add(multipartFile);

      http.StreamedResponse response = await request.send();
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
      return Right(listrecom);
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
