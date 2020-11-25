import 'package:agroquimica/cubit/adminstates_cubit.dart';

import 'package:agroquimica/data/entities/productos_entities.dart';
import 'package:agroquimica/pages/ventas/productos_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:agroquimica/pages/menu_page.dart';

import 'lista_widget.dart';

class VentasPage extends StatefulWidget {
  @override
  VentasPageState createState() => VentasPageState();
}

class VentasPageState extends State<VentasPage> {
  List<ProductosEntities> productos = [];

  @override
  void initState() {
    context.read<AdminstatesCubit>().getProductos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ventas"),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: ProductosSearch(productos: productos));
              },
            ),
          ],
        ),
        endDrawer: UserDrawer(),
        body: BlocConsumer<AdminstatesCubit, AdminstatesState>(
            listener: (context, state) {
          if (state is AdminstatesError) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        }, builder: (context, state) {
          if (state is AdminstatesloadingProd) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AdminstatesloadedProd) {
            this.productos = state.productosEntities;
            return Lista();
          } else if (state is Adminstatesloadedcarrito) {
            return Lista();
          } else {
            return Center(
              child: Text("error"),
            );
          }
        }));
  }
}
