import 'package:agroquimica/cubit/adminstates_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../menu_page.dart';
import 'deteccion_stepper.dart';

class DeteccionPage extends StatefulWidget {
  @override
  DeteccionPageState createState() => DeteccionPageState();
}

class DeteccionPageState extends State<DeteccionPage> {
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

  @override
  Widget build(BuildContext context) {
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
            return DeteccionStepper();
          } else {
            return DeteccionStepper();
          }
        },
      ),
    );
  }
}
