part of 'adminstates_cubit.dart';

@immutable
abstract class AdminstatesState {}

class AdminstatesInitial extends AdminstatesState {}

class AdminstatesCreated extends AdminstatesState {}

class AdminstatesCreating extends AdminstatesState {}

class AdminstatesDeleted extends AdminstatesState {}

class AdminstatesErasing extends AdminstatesState {}

class AdminstatesLoadFact extends AdminstatesState {
  final FacturaEntities facturaEntities;
  AdminstatesLoadFact({
    this.facturaEntities,
  });
}

class AdminstatesCreatingUser extends AdminstatesState {}

class AdminstatesError extends AdminstatesState {
  final String message;
  AdminstatesError({
    this.message,
  });
}

class AdminstatesLoadingFact extends AdminstatesState {}

class AdminstatesLoadDFact extends AdminstatesState {
  final List<DetallefactEntities> detallefacturaEntities;
  AdminstatesLoadDFact({
    this.detallefacturaEntities,
  });
}

class AdminstatesLoadingdFact extends AdminstatesState {}

class AdminstatesLoadingdir extends AdminstatesState {}

class AdminstatesLoadeddir extends AdminstatesState {
  final List<DireccionEntities> direccionEntities;

  AdminstatesLoadeddir({this.direccionEntities});
}

class AdminstatesloadingProd extends AdminstatesState {}

class AdminstatesloadedProd extends AdminstatesState {
  final List<ProductosEntity> productosEntities;
  AdminstatesloadedProd({this.productosEntities});
}

class Adminstatesloadedcarrito extends AdminstatesState {}

class ImageStateLoaded extends AdminstatesState {
  final List<ImageEntities> imageEntities;

  ImageStateLoaded(this.imageEntities);
}

class ImageStateLoading extends AdminstatesState {}

class AdminstateloadingRecomendacion extends AdminstatesState {}

class AdminstateloadedRecomendacion extends AdminstatesState {
  final List<RecomendacionesEntities> recomendacionesEntites;

  AdminstateloadedRecomendacion({this.recomendacionesEntites});
}
