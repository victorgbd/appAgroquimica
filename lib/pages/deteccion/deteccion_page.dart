import 'package:agroquimica/cubit/adminstates_cubit.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../menu_page.dart';

class DeteccionPage extends StatefulWidget {
  @override
  DeteccionPageState createState() => DeteccionPageState();
}

class DeteccionPageState extends State<DeteccionPage> {
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

  int _indexstep = 0;
  bool complete = false;
  void goTo(int step) {
    setState(() {
      _indexstep = step;
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
                            height: 400.0,
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
              ],
            )),
      ),
      Step(
          title: Text(""),
          content: Container(
            child: Column(
              children: [
                RaisedButton(
                  onPressed: () {
                    context.read<AdminstatesCubit>().getResult(_file);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: Text("Analizar"),
                  padding:
                      EdgeInsets.symmetric(horizontal: 54.0, vertical: 24.0),
                ),
              ],
            ),
          )),
    ];
    return Scaffold(
      endDrawer: UserDrawer(),
      appBar: AppBar(
        title: Text("Detección de enfermedad de plantas"),
      ),
      body: BlocConsumer<AdminstatesCubit, AdminstatesState>(
        listener: (context, state) {
          if (state is AdminstatesError) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ImageStateLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ImageStateLoaded) {
            return Text(state.imageEntities[0].planta +
                " " +
                state.imageEntities[0].especie +
                " " +
                state.imageEntities[0].enfermedad +
                " " +
                state.imageEntities[0].porc);
          } else {
            return Stepper(
              type: StepperType.horizontal,
              currentStep: _indexstep,
              steps: steps,
              onStepTapped: (value) => goTo(value),
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          _indexstep + 1 != steps.length
                              ? goTo(_indexstep + 1)
                              : setState(() => complete = true);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Text("Siguiente"),
                        padding: EdgeInsets.symmetric(
                            horizontal: 44.0, vertical: 14.0),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          _indexstep - 1 >= 0
                              ? goTo(_indexstep - 1)
                              : setState(() => complete = false);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Text("Atrás"),
                        padding: EdgeInsets.symmetric(
                            horizontal: 44.0, vertical: 14.0),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
