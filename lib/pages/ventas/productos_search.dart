import 'package:agroquimica/cubit/adminstates_cubit.dart';
import 'package:agroquimica/data/entities/productos_entity.dart';
import 'package:agroquimica/data/models/productos_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductosSearch extends SearchDelegate<ProductosEntity> {
  final List<ProductosEntity> productos;

  ProductosSearch({@required this.productos});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    String unidadsel = "UNIDAD";
    String coduni = '';
    int cantidad = 1;
    double precio = 0.0;
    int cantmax = 2;

    List<ProductosEntity> lista = query.isEmpty
        ? productos
        : productos
            .where((element) => element.descripcion
                .toLowerCase()
                .startsWith(query.toLowerCase()))
            .toList();
    return lista.isEmpty
        ? Text('Producto no encontrado...')
        : ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(lista[index].descripcion),
                    subtitle: Column(
                      children: [],
                    ),
                    onTap: () {
                      ProductosEntity productossel = lista[index];
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        FadeInImage(
                                            height: 256.0,
                                            width: 256.0,
                                            placeholder: AssetImage(
                                                'assets/plant_icon.png'),
                                            image:
                                                NetworkImage(productossel.url)),
                                        DropdownButton<UnidadModel>(
                                          hint: Text(unidadsel),
                                          items: productossel.unidad
                                              .map((dropdownstringitem) {
                                            return DropdownMenuItem<
                                                UnidadModel>(
                                              child: Text(
                                                  dropdownstringitem.desunidad),
                                              value: dropdownstringitem,
                                            );
                                          }).toList(),
                                          onChanged: (value) async {
                                            setState(() {
                                              unidadsel = value.desunidad;

                                              cantmax =
                                                  int.parse(value.cantidad);
                                              precio =
                                                  double.parse(value.precio);

                                              coduni = value.coduni;
                                            });
                                          },
                                        ),
                                        Text(productossel.descripcion),
                                        Text("Precio: $precio"),
                                        Counter(
                                            initialValue: cantidad,
                                            minValue: 1,
                                            step: 1,
                                            maxValue: cantmax,
                                            onChanged: (value) {
                                              setState(() {
                                                cantidad = value;
                                              });
                                            },
                                            decimalPlaces: 0)
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          productossel.precio =
                                              precio.toString();
                                          productossel.codunidad = coduni;
                                          productossel.cantven =
                                              cantidad.toString();
                                          // bool flag = true;

                                          // showDialog(
                                          //   context: context,
                                          //   builder: (dialogcontext) {
                                          //     return AlertDialog(
                                          //       content: Text(
                                          //           "Producto ya agredado al carrito"),
                                          //       actions: [
                                          //         FlatButton(
                                          //             onPressed: () {
                                          //               Navigator.of(
                                          //                       dialogcontext)
                                          //                   .pop();
                                          //             },
                                          //             child: Text("OK"))
                                          //       ],
                                          //     );
                                          //   },
                                          // );
                                          context
                                              .read<AdminstatesCubit>()
                                              .addcarrito(productossel);
                                          print("prodselec");
                                          print(productossel);
                                          print("carrito");

                                          Navigator.of(context).pop();
                                        },
                                        child: Text("AGREGAR")),
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("CANCELAR"))
                                  ]);
                            },
                          );
                        },
                      );
                    },
                  ),
                  Divider(),
                ],
              );
            });
  }
}
