import 'dart:async';
import 'dart:io';

import 'package:agroquimica/data/entities/direccion/direccion_entities.dart';
import 'package:agroquimica/data/entities/image_entities.dart';

import 'package:agroquimica/data/entities/recomendacion/recomendacion_entities.dart';
import 'package:agroquimica/data/entities/usere_entities.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:agroquimica/data/entities/detallefact_entities.dart';
import 'package:agroquimica/data/entities/factura_entities.dart';
import 'package:agroquimica/data/repository/factadmin_repository.dart';
import 'package:agroquimica/data/entities/productos_entity.dart';
part 'adminstates_state.dart';

class AdminstatesCubit extends Cubit<AdminstatesState> {
  final List<ProductosEntity> carrito = [];
  double totalfacturar = 0.0;
  UserEEntities userEEntities;
  final IFacturaAdminRepository facturaAdminRepository;

  AdminstatesCubit({
    this.facturaAdminRepository,
    this.userEEntities,
  }) : super(AdminstatesInitial());

  Future<void> setUser(String user, String password) async {
    final failureOrUnit =
        await this.facturaAdminRepository.getUserE(user, password);

    failureOrUnit.fold(
      (failure) => emit(AdminstatesError(message: failure.message)),
      (user) => userEEntities = user,
    );
  }

  Future<bool> validateUser(String user, String password) async {
    final failOrsucess =
        await this.facturaAdminRepository.validateUser(user, password);
    bool f = false;
    f = failOrsucess.fold(
      (failure) {
        emit(AdminstatesError(message: failure.message));
        return false;
      },
      (flag) {
        f = flag;
        return f;
      },
    );
    print(f);
    return f;
  }

  Future<bool> validateUsername(String user) async {
    final failOrsucess =
        await this.facturaAdminRepository.validateUsername(user);
    bool f = false;
    f = failOrsucess.fold(
      (failure) {
        emit(AdminstatesError(message: failure.message));
        return false;
      },
      (flag) {
        f = flag;
        return f;
      },
    );
    return f;
  }

  Future<void> createUser(UserEEntities userEntity) async {
    final failureOrUnit =
        await this.facturaAdminRepository.createUser(userEntity);

    failureOrUnit.fold(
      (failure) => emit(AdminstatesError(message: failure.message)),
      (unit) => AdminstatesCreated(),
    );
  }

  Future<void> getDireccionInit(String query) async {
    emit(AdminstatesLoadingdir());
    final failureOrUnit = await this.facturaAdminRepository.getDireccion(query);
    failureOrUnit.fold(
      (failure) {
        emit(AdminstatesError(message: failure.message));
      },
      (direccion) {
        emit(AdminstatesLoadeddir(direccionEntities: direccion));
      },
    );
  }

  Future<List<DireccionEntities>> getDireccion(String query) async {
    final failureOrUnit = await this.facturaAdminRepository.getDireccion(query);
    List<DireccionEntities> list = [];
    list = failureOrUnit.fold(
      (failure) {
        emit(AdminstatesError(message: failure.message));
        return [];
      },
      (direccion) {
        list = direccion;
        return list;
      },
    );
    return list;
  }

  Future<void> getProductos() async {
    emit(AdminstatesloadingProd());
    final failureOrUnit = await this.facturaAdminRepository.getProductos();
    failureOrUnit.fold(
      (failure) {
        emit(AdminstatesError(message: failure.message));
      },
      (productos) {
        emit(AdminstatesloadedProd(productosEntities: productos));
      },
    );
  }

  void setcantven(int index, int cantidad) {
    carrito[index].setCantidadven(cantidad.toString());
    emit(Adminstatesloadedcarrito());
  }

//si retorna 0 hay un error
  Future<int> createFactura(FacturaEntities factura) async {
    final failOrsucess =
        await this.facturaAdminRepository.createFactura(factura);
    int numerofactura = 0;
    numerofactura = failOrsucess.fold(
      (failure) {
        emit(AdminstatesError(message: failure.message));
        return numerofactura;
      },
      (numfactura) {
        numerofactura = numfactura;
        return numerofactura;
      },
    );
    return numerofactura;
  }

  Future<void> createDetalleFactura(List<DetallefactEntities> factura) async {
    final failOrsucess =
        await this.facturaAdminRepository.createdetalleFactura(factura);
    failOrsucess.fold(
      (failure) {
        emit(AdminstatesError(message: failure.message));
      },
      (numfactura) {
        emit(Adminstatesloadedcarrito());
      },
    );
  }

  Future<List<ImageEntities>> getResult(File image) async {
    // emit(ImageStateLoading());
    final failOrsucess =
        await this.facturaAdminRepository.getImageResult(image);
    List<ImageEntities> list = [];
    list = failOrsucess.fold(
      (failure) {
        emit(AdminstatesError(message: failure.message));
        return list;
      },
      (direccion) {
        list = direccion;
        return list;
      },
    );
    return list;
  }

  Future<void> getRecomendacionInit(String query) async {
    emit(AdminstateloadingRecomendacion());
    final failureOrUnit =
        await this.facturaAdminRepository.getRecomendacion(query);
    failureOrUnit.fold(
      (failure) {
        emit(AdminstatesError(message: failure.message));
      },
      (recomendacion) {
        emit(AdminstateloadedRecomendacion(
            recomendacionesEntites: recomendacion));
      },
    );
  }

  Future<List> getRecomendacion(String query) async {
    final failureOrUnit =
        await this.facturaAdminRepository.getRecomendacion(query);
    List list = [];
    list = failureOrUnit.fold(
      (failure) {
        emit(AdminstatesError(message: failure.message));
        return list;
      },
      (recomendacion) {
        list = recomendacion;
        return list;
      },
    );
    return list;
  }

  void setcantvenrec(List<RecomendacionesEntities> recomendacion) {
    emit(AdminstateloadedRecomendacion(recomendacionesEntites: recomendacion));
  }

  void setcantvendetc() {
    emit(AdminstateloadedRecomendacion());
  }

  void addcarritorec(List<RecomendacionesEntities> recomendacion,
      List<ProductosEntity> producto) {
    var flag = true;
    producto.forEach((elementi) {
      flag = true;
      carrito.forEach((elementj) {
        if (elementj.codproducto == elementi.codproducto &&
            elementj.codunidad == elementi.codunidad) {
          flag = false;
        }
      });
      if (flag) {
        carrito.add(ProductosEntity(
            codproducto: elementi.codproducto,
            descripcion: elementi.descripcion,
            codunidad: elementi.codunidad,
            unidad: elementi.unidad,
            tipoprod: elementi.tipoprod,
            destipoprod: elementi.destipoprod,
            url: elementi.url,
            cantven: elementi.cantven,
            precio: elementi.precio));
      }
    });
    emit(AdminstateloadedRecomendacion(recomendacionesEntites: recomendacion));
  }

  void addcarritodet(List<ProductosEntity> producto) {
    var flag = true;
    producto.forEach((elementi) {
      flag = true;
      carrito.forEach((elementj) {
        if (elementj.codproducto == elementi.codproducto &&
            elementj.codunidad == elementi.codunidad) {
          flag = false;
        }
      });
      if (flag) {
        carrito.add(ProductosEntity(
            codproducto: elementi.codproducto,
            descripcion: elementi.descripcion,
            codunidad: elementi.codunidad,
            unidad: elementi.unidad,
            tipoprod: elementi.tipoprod,
            destipoprod: elementi.destipoprod,
            url: elementi.url,
            cantven: elementi.cantven,
            precio: elementi.precio));
      }
    });
  }

  void addcarrito(ProductosEntity producto) {
    var flag = true;
    carrito.forEach((element) {
      if (element.codproducto == producto.codproducto &&
          element.codunidad == producto.codunidad) {
        flag = false;
      }
    });
    if (flag) {
      carrito.add(ProductosEntity(
          codproducto: producto.codproducto,
          descripcion: producto.descripcion,
          codunidad: producto.codunidad,
          unidad: producto.unidad,
          tipoprod: producto.tipoprod,
          destipoprod: producto.destipoprod,
          url: producto.url,
          cantven: producto.cantven,
          precio: producto.precio));
    }
    emit(Adminstatesloadedcarrito());
  }
}
