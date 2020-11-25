import 'package:agroquimica/cubit/adminstates_cubit.dart';
import 'package:agroquimica/data/entities/recomendacion/recomendacion_entities.dart';
import 'package:agroquimica/pages/recomendacion/recomendacion_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../menu_page.dart';

class RecomendacionPage extends StatefulWidget {
  @override
  RecomendacionPageState createState() => RecomendacionPageState();
}

class RecomendacionPageState extends State<RecomendacionPage> {
  List<RecomendacionesEntities> plantas;
  @override
  void initState() {
    context.read<AdminstatesCubit>().getRecomendacionInit('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: UserDrawer(),
        appBar: AppBar(
          title: Text("Recomendación de productos"),
        ),
        body: BlocConsumer<AdminstatesCubit, AdminstatesState>(
          listener: (context, state) {
            if (state is AdminstatesError) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is AdminstateloadingRecomendacion) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AdminstateloadedRecomendacion) {
              plantas = state.recomendacionesEntites ?? [];
              return RecomendacionForm(
                plantas: plantas,
              );
            } else if (state is AdminstatesError) {
              plantas = [];
              return RecomendacionForm(
                plantas: plantas,
              );
            } else {
              return RecomendacionForm(
                plantas: plantas,
              );
            }
          },
        ));
  }
}
