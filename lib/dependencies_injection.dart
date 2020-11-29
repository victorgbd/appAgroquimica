import 'package:agroquimica/data/entities/usere_entities.dart';
import 'package:agroquimica/data/repository/factadmin_repository.dart';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'cubit/adminstates_cubit.dart';

/// service locator
final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => AdminstatesCubit(
        facturaAdminRepository: sl(),
        userEEntities: UserEEntities(
            nombre: null,
            apellido: null,
            codcli: null,
            correo: null,
            contrasena: null,
            codpais: null,
            pais: null,
            codciudad: null,
            ciudad: null,
            coddir: null,
            direccion: null,
            tipo: null,
            numeracion: null,
            numerotelf: null),
      ));

  sl.registerLazySingleton<IFacturaAdminRepository>(
      () => FacturaAdminRepositoryimp(httpClient: sl()));
  sl.registerLazySingleton(() => http.Client());
}
