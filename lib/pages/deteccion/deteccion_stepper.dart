import 'dart:io';

import 'package:agroquimica/cubit/adminstates_cubit.dart';
import 'package:agroquimica/data/entities/image_entities.dart';
import 'package:agroquimica/data/entities/productos_entities.dart';
import 'package:agroquimica/pages/ventas/ventas_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:image_picker/image_picker.dart';

class DeteccionStepper extends StatefulWidget {
  DeteccionStepper({
    Key key,
  }) : super(key: key);

  @override
  DeteccionStepperState createState() => DeteccionStepperState();
}

class DeteccionStepperState extends State<DeteccionStepper> {
  List<ProductosEntities> recomendacion = [];
  String codplanta = "";
  String codespecie = "";
  String codenfermedad = "";

  int _indexstep = 0;
  bool complete = false;
  void goTo(int step) {
    setState(() {
      _indexstep = step;
    });
  }

  File _file;
  final picker = ImagePicker();
  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Theme.of(context).secondaryHeaderColor,
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(
                        Icons.photo_library,
                        color: Colors.white,
                      ),
                      title: Text('Galeria',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        getImageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(
                      Icons.photo_camera,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Camara',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      getImageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void dialog(String message) {
    showDialog(
        context: context,
        builder: (dialogcontext) {
          return AlertDialog(
            content: Text(message),
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

  void dialogAnalizar(List<ImageEntities> resultados) {
    showDialog(
        context: context,
        builder: (dialogcontext) {
          return AlertDialog(
            scrollable: true,
            content: Column(
              children: [
                Text("Seleccione una predicción"),
                SizedBox(
                  height: 10.0,
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
                  width: 300.0,
                  height: 250.0,
                  child: ListView.builder(
                    itemCount: resultados.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(resultados[index].planta),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(resultados[index].especie),
                            Text(resultados[index].enfermedad),
                            Text("Porciento:" + resultados[index].porc + "%"),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(dialogcontext).pop();
                          if (int.parse(resultados[index].codenfer) == -1) {
                            dialog("Esta planta esta saludable");
                          } else {
                            showDialog(
                                context: context,
                                builder: (dialogcontext2) {
                                  return AlertDialog(
                                    content: Text("Estás Seguro?"),
                                    actions: [
                                      FlatButton(
                                          onPressed: () async {
                                            codplanta =
                                                resultados[index].codplanta;
                                            codespecie =
                                                resultados[index].codespecie;
                                            codenfermedad =
                                                resultados[index].codenfer;
                                            Navigator.of(dialogcontext2).pop();
                                          },
                                          child: Text("OK")),
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(dialogcontext2).pop();
                                            dialogAnalizar(resultados);
                                          },
                                          child: Text("ATRÁS"))
                                    ],
                                  );
                                });
                          }
                        },
                      );
                    },
                  ),
                )
              ],
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(dialogcontext).pop();
                  },
                  child: Text("CANCELAR"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
        title: Text(""),
        content: Container(
            padding: EdgeInsets.all(40.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 5.0,
                          blurRadius: 7.0,
                          offset: Offset(0.0, 2.0),
                        ),
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: _file == null
                        ? SizedBox(
                            height: 300.0,
                            width: 400.0,
                            child: Text('No image selected.'))
                        : Image(
                            image: FileImage(_file),
                          ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  onPressed: () => _showPicker(context),
                  child: SizedBox(
                      height: 50,
                      child: Column(
                        children: [
                          Icon(Icons.add_a_photo, color: Colors.white),
                          Text('Selecciona una Imagen',
                              style: TextStyle(color: Colors.white))
                        ],
                      )),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                RaisedButton(
                  onPressed: () async {
                    if (_file == null) {
                      dialog("Imagen no seleccionada");
                    } else {
                      var resultados = await context
                          .read<AdminstatesCubit>()
                          .getResult(_file);
                      if (resultados.isNotEmpty) {
                        dialogAnalizar(resultados);
                        setState(() {
                          recomendacion.clear();
                        });
                      } else {
                        return null;
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: Text("Analizar"),
                  padding:
                      EdgeInsets.symmetric(horizontal: 54.0, vertical: 24.0),
                ),
              ],
            )),
      ),
      Step(
        title: Text(""),
        content: Column(
          children: [
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
                height: 400.0,
                width: 400,
                //agregar los datos
                child: ListView.builder(
                  itemCount: recomendacion.length,
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
              height: 10.0,
            ),
            RaisedButton(
              onPressed: () async {
                if (recomendacion.isEmpty) {
                  dialog("Lista de productos vacia");
                } else {
                  await context
                      .read<AdminstatesCubit>()
                      .addcarritodet(recomendacion);
                  recomendacion.clear();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => VentasPage()));
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Text("Agregar al carrito"),
              padding: EdgeInsets.symmetric(horizontal: 44.0, vertical: 14.0),
            ),
          ],
        ),
      ),
    ];
    return Stepper(
      type: StepperType.horizontal,
      currentStep: _indexstep,
      steps: steps,
      onStepTapped: (value) async {
        if (codplanta.isNotEmpty &&
            codespecie.isNotEmpty &&
            codenfermedad.isNotEmpty) {
          if (_indexstep == 0) {
            List<ProductosEntities> aux = await context
                .read<AdminstatesCubit>()
                .getRecomendacion('?codplanta=' +
                    codplanta +
                    '&codespecie=' +
                    codespecie +
                    '&codenfermedad=' +
                    codenfermedad);
            if (aux.isNotEmpty) {
              setState(() {
                recomendacion = aux;
              });
            } else {
              dialog("Recomendación de productos no se encontró");
            }
          }
          goTo(value);
        }
      },
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: _indexstep != 1
                  ? RaisedButton(
                      onPressed: () async {
                        if (_indexstep == 0) {
                          if (codplanta.isNotEmpty &&
                              codespecie.isNotEmpty &&
                              codenfermedad.isNotEmpty) {
                            _indexstep + 1 != steps.length
                                ? goTo(_indexstep + 1)
                                : setState(() => complete = true);
                            List<ProductosEntities> aux = await context
                                .read<AdminstatesCubit>()
                                .getRecomendacion('?codplanta=' +
                                    codplanta +
                                    '&codespecie=' +
                                    codespecie +
                                    '&codenfermedad=' +
                                    codenfermedad);
                            if (aux.isNotEmpty) {
                              setState(() {
                                recomendacion = aux;
                              });
                            } else {
                              dialog(
                                  "Recomendación de productos no se encontró");
                            }
                          }
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Text("Siguiente"),
                      padding: EdgeInsets.symmetric(
                          horizontal: 44.0, vertical: 14.0),
                    )
                  : null,
            ),
            Container(
              child: _indexstep == 1
                  ? RaisedButton(
                      onPressed: () {
                        goTo(_indexstep - 1);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Text("Atrás"),
                      padding: EdgeInsets.symmetric(
                          horizontal: 44.0, vertical: 14.0),
                    )
                  : null,
            ),
          ],
        );
      },
    );
  }
}
