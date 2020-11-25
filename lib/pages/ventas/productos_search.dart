import 'package:agroquimica/cubit/adminstates_cubit.dart';
import 'package:agroquimica/data/entities/productos_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductosSearch extends SearchDelegate<ProductosEntities> {
  final List<ProductosEntities> productos;

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
    int cantidad = 1;
    List<ProductosEntities> lista = query.isEmpty
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
                                                NetworkImage(lista[index].url)),
                                        Text(lista[index].descripcion),
                                        Text("Precio: " + lista[index].precio),
                                        Counter(
                                            initialValue: cantidad,
                                            minValue: 1,
                                            step: 1,
                                            maxValue: int.parse(
                                                lista[index].cantidad),
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
                                          Navigator.of(context).pop();
                                          bool flag = true;

                                          lista[index].cantidadven =
                                              cantidad.toString();
                                          context
                                              .read<AdminstatesCubit>()
                                              .carrito
                                              .forEach((element) {
                                            if (element.codproducto ==
                                                lista[index].codproducto) {
                                              showDialog(
                                                context: context,
                                                builder: (dialogcontext) {
                                                  return AlertDialog(
                                                    content: Text(
                                                        "Producto ya agredado al carrito"),
                                                    actions: [
                                                      FlatButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    dialogcontext)
                                                                .pop();
                                                          },
                                                          child: Text("OK"))
                                                    ],
                                                  );
                                                },
                                              );
                                              flag = false;
                                            }
                                          });
                                          if (flag) {
                                            context
                                                .read<AdminstatesCubit>()
                                                .addcarrito(lista[index]);
                                          }
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
