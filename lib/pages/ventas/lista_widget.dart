import 'package:agroquimica/cubit/adminstates_cubit.dart';
import 'package:agroquimica/data/entities/detallefact_entities.dart';
import 'package:agroquimica/data/entities/factura_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_counter/flutter_counter.dart';

class Lista extends StatefulWidget {
  const Lista({
    Key key,
  }) : super(key: key);

  @override
  ListaState createState() => ListaState();
}

class ListaState extends State<Lista> {
  @override
  Widget build(BuildContext context) {
    double totalfact;
    setState(() {
      totalfact = getTotal(context);
    });

    context.watch<AdminstatesCubit>().totalfacturar = totalfact;

    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: Container(
              width: 470.0,
              height: 620.0,
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
              child: ListView.builder(
                itemCount: context.watch<AdminstatesCubit>().carrito.length,
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
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            //llamar un metodo para eliminarlo de la tabla wishlist
                            setState(() {
                              totalfact -= int.parse(context
                                      .read<AdminstatesCubit>()
                                      .carrito[index]
                                      .cantidadven) *
                                  double.parse(context
                                      .read<AdminstatesCubit>()
                                      .carrito[index]
                                      .precio);
                              context.read<AdminstatesCubit>().totalfacturar =
                                  totalfact;
                              context
                                  .read<AdminstatesCubit>()
                                  .carrito
                                  .removeAt(index);
                            });
                          }
                        },
                        key: UniqueKey(),
                        child: ListTile(
                          title: Text(context
                              .watch<AdminstatesCubit>()
                              .carrito[index]
                              .descripcion),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(context
                                  .watch<AdminstatesCubit>()
                                  .carrito[index]
                                  .cantidadven),
                              Text("Precio: " +
                                  context
                                      .watch<AdminstatesCubit>()
                                      .carrito[index]
                                      .precio),
                            ],
                          ),
                          onTap: () {
                            int cantidad = int.parse(context
                                .read<AdminstatesCubit>()
                                .carrito[index]
                                .cantidadven);
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
                                                  image: NetworkImage(context
                                                      .watch<AdminstatesCubit>()
                                                      .carrito[index]
                                                      .url)),
                                              Text(context
                                                  .watch<AdminstatesCubit>()
                                                  .carrito[index]
                                                  .descripcion),
                                              Text("Precio: " +
                                                  context
                                                      .watch<AdminstatesCubit>()
                                                      .carrito[index]
                                                      .precio),
                                              Counter(
                                                  initialValue: cantidad,
                                                  minValue: 1,
                                                  step: 1,
                                                  maxValue: int.parse(context
                                                      .watch<AdminstatesCubit>()
                                                      .carrito[index]
                                                      .cantidad),
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
                                                context
                                                    .read<AdminstatesCubit>()
                                                    .setcantven(
                                                        index, cantidad);
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
                            );
                          },
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
              Container(
                height: 40.0,
                width: 156.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ]),
                child: Row(
                  children: [
                    Icon(Icons.attach_money),
                    Text(
                      '$totalfact',
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        content: Text("¿Estas seguro que quieres continuar?"),
                        actions: [
                          FlatButton(
                              onPressed: () async {
                                final factura = FacturaEntities(
                                    numfact: 1,
                                    codcli: int.parse(context
                                        .read<AdminstatesCubit>()
                                        .userEEntities
                                        .codcli),
                                    estado: 0,
                                    tipfac: "true",
                                    fecha: null,
                                    codemp: 13,
                                    balance: 0.0,
                                    total: context
                                        .read<AdminstatesCubit>()
                                        .totalfacturar);
                                int numfac = await context
                                    .read<AdminstatesCubit>()
                                    .createFactura(factura);

                                List<DetallefactEntities> detalle =
                                    List<DetallefactEntities>();
                                context
                                    .read<AdminstatesCubit>()
                                    .carrito
                                    .forEach((element) {
                                  detalle.add(DetallefactEntities(
                                      numfac: numfac,
                                      codproducto:
                                          int.parse(element.codproducto),
                                      cantvent: int.parse(element.cantidadven),
                                      precvent: double.parse(element.precio),
                                      coduni: int.parse(element.codunidad)));
                                });

                                await context
                                    .read<AdminstatesCubit>()
                                    .createDetalleFactura(detalle);

                                Navigator.of(context).pop();
                                compraExitosa();
                              },
                              child: Text('OK')),
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('CANCELAR'))
                        ],
                      ));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Text("Facturar"),
                padding: EdgeInsets.symmetric(horizontal: 44.0, vertical: 14.0),
              ),
              SizedBox(),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  double getTotal(BuildContext context) {
    double total = 0;
    context.watch<AdminstatesCubit>().carrito.forEach((element) {
      total += int.parse(element.cantidadven) * double.parse(element.precio);
    });
    return total;
  }

  void compraExitosa() {
    setState(() {
      context.read<AdminstatesCubit>().carrito.clear();
    });
    showDialog(
        context: context,
        child: AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: [
                Image(
                  height: 256.0,
                  width: 256.0,
                  image: AssetImage('assets/check_animation.gif'),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('Compra realizada existosamente'),
              ],
            ),
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('ATRÁS'))
          ],
        ));
  }
}
