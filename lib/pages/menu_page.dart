import 'package:agroquimica/cubit/adminstates_cubit.dart';
import 'package:agroquimica/pages/deteccion/deteccion_page.dart';
import 'package:agroquimica/pages/ventas/ventas_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menú"),
      ),
      endDrawer: UserDrawer(),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 15.0,
            crossAxisSpacing: 15.0,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                height: double.infinity,
                width: double.infinity,
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
                child: GestureDetector(
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage('assets/plant_icon.png'),
                        height: 128.0,
                        width: 128.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('VENTAS'),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => VentasPage()));
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                height: double.infinity,
                width: double.infinity,
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
                child: GestureDetector(
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage('assets/plant_icon.png'),
                        height: 128.0,
                        width: 128.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('     DETECCIÓN \nDE ENFERMEDAD'),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DeteccionPage()));
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                height: double.infinity,
                width: double.infinity,
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
                child: GestureDetector(
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage('assets/plant_icon.png'),
                        height: 128.0,
                        width: 128.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('RECOMENDACIÓN DE\n        PRODUCTOS'),
                      ),
                    ],
                  ),
                  onTap: () {
                    print("uy");
                  },
                ),
              ),
            ]),
      )),
    );
  }
}

class UserDrawer extends StatelessWidget {
  const UserDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text("ua"), accountName: Text("ua"),
            // accountName: Text(
            //     context.watch<AdminstatesCubit>().userEEntities.nombre +
            //         " " +
            //         context.watch<AdminstatesCubit>().userEEntities.apellido),
            // accountEmail:
            //     Text(context.watch<AdminstatesCubit>().userEEntities.correo))
          )
        ],
      ),
    );
  }
}
