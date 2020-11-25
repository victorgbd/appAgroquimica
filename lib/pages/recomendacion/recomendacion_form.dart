import 'package:agroquimica/cubit/adminstates_cubit.dart';
import 'package:agroquimica/data/entities/productos_entities.dart';
import 'package:agroquimica/data/entities/recomendacion/recomendacion_entities.dart';
import 'package:agroquimica/pages/ventas/ventas_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_counter/flutter_counter.dart';

class RecomendacionForm extends StatefulWidget {
  final List<RecomendacionesEntities> plantas;

  const RecomendacionForm({Key key, this.plantas}) : super(key: key);
  @override
  RecomendacionFormState createState() => RecomendacionFormState();
}

class RecomendacionFormState extends State<RecomendacionForm> {
  String codplanta;
  String codespecie;
  String codenfermedad;

  List<RecomendacionesEntities> especies = [];
  List<RecomendacionesEntities> enfermedades = [];
  String planta = 'Planta';
  String especie = 'Especie';
  String enfermedad = 'Enfermedad';
  List<ProductosEntities> recomendacion = [];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            DropdownButton<RecomendacionesEntities>(
              hint: Text(planta),
              items: widget.plantas.map((dropdownstringitem) {
                return DropdownMenuItem<RecomendacionesEntities>(
                  child: Text(dropdownstringitem.descripcion),
                  value: dropdownstringitem,
                );
              }).toList(),
              onChanged: (value) async {
                final aux = await context
                    .read<AdminstatesCubit>()
                    .getRecomendacion('?codplanta=' + value.cod.toString());
                setState(() {
                  this.codplanta = value.cod.toString();
                  planta = value.descripcion;
                  this.especies = aux;
                });
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            DropdownButton<RecomendacionesEntities>(
              hint: Text(especie),
              items: especies.map((dropdownstringitem) {
                return DropdownMenuItem<RecomendacionesEntities>(
                  child: Text(dropdownstringitem.descripcion),
                  value: dropdownstringitem,
                );
              }).toList(),
              onChanged: (value) async {
                final aux = await context
                    .read<AdminstatesCubit>()
                    .getRecomendacion('?codespecie=' + value.cod.toString());
                setState(() {
                  this.codespecie = value.cod.toString();
                  this.enfermedades = aux;
                  especie = value.descripcion;
                });
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            DropdownButton<RecomendacionesEntities>(
              hint: Text(enfermedad),
              items: enfermedades.map((dropdownstringitem) {
                return DropdownMenuItem<RecomendacionesEntities>(
                  child: Text(dropdownstringitem.descripcion),
                  value: dropdownstringitem,
                );
              }).toList(),
              onChanged: (value) async {
                setState(() {
                  this.codenfermedad = value.cod.toString();
                  enfermedad = value.descripcion;
                });
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              onPressed: () async {
                setState(() {
                  recomendacion.clear();
                });

                final aux = await context.read<AdminstatesCubit>().getRecomendacion(
                    '?codplanta=$codplanta&codespecie=$codespecie&codenfermedad=$codenfermedad');
                if (aux.isNotEmpty) {
                  setState(() {
                    recomendacion = aux;
                  });
                } else {
                  showDialog(
                      context: context,
                      builder: (dialogcontext) {
                        return AlertDialog(
                          content:
                              Text("Recomendación de productos no se encontró"),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(dialogcontext).pop();
                                },
                                child: Text("OK"))
                          ],
                        );
                      });
                }
              },
              child: Text('Buscar recomendación'),
              padding: EdgeInsets.symmetric(horizontal: 54.0, vertical: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ]),
                height: 300.0,
                width: 300,
                //agregar los datos
                child: ListView.builder(
                  itemCount: this.recomendacion.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            if (direction == DismissDirection.endToStart) {
                              setState(() {
                                recomendacion.removeAt(index);
                              });
                            }
                          },
                          child: ListTile(
                            title: Text(recomendacion[index].descripcion),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(recomendacion[index].cantidadven == null
                                    ? recomendacion[index].cantidadven = "1"
                                    : recomendacion[index].cantidadven),
                                Text("Precio: " + recomendacion[index].precio),
                              ],
                            ),
                            onTap: () {
                              int cantidad =
                                  int.parse(recomendacion[index].cantidadven);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            FadeInImage(
                                                height: 256.0,
                                                width: 256.0,
                                                placeholder: AssetImage(
                                                    'assets/plant_icon.png'),
                                                image: NetworkImage(
                                                    recomendacion[index].url)),
                                            Text(recomendacion[index]
                                                .descripcion),
                                            Text("Precio: " +
                                                recomendacion[index].precio),
                                            StatefulBuilder(
                                              builder: (context, setState) {
                                                return Counter(
                                                    initialValue: cantidad,
                                                    minValue: 1,
                                                    step: 1,
                                                    maxValue: int.parse(
                                                        recomendacion[index]
                                                            .cantidad),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        cantidad = value;
                                                      });
                                                    },
                                                    decimalPlaces: 0);
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        FlatButton(
                                            onPressed: () {
                                              setState(() {
                                                recomendacion[index]
                                                        .cantidadven =
                                                    cantidad.toString();
                                                context
                                                    .read<AdminstatesCubit>()
                                                    .setcantvenrec(
                                                        widget.plantas);
                                              });

                                              Navigator.of(context).pop();
                                            },
                                            child: Text("OK")),
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("CANCELAR"))
                                      ]);
                                },
                              );
                            },
                          ),
                        ),
                        Divider()
                      ],
                    );
                  },
                )),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              onPressed: () async {
                if (recomendacion.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (dialogcontext) {
                        return AlertDialog(
                          content: Text("Lista de productos vacia"),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(dialogcontext).pop();
                                },
                                child: Text("OK"))
                          ],
                        );
                      });
                } else {
                  context
                      .read<AdminstatesCubit>()
                      .addcarritorec(widget.plantas, recomendacion);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => VentasPage()));
                }
              },
              child: Text('Agregar al carrito'),
              padding: EdgeInsets.symmetric(horizontal: 54.0, vertical: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
