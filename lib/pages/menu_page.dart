import 'package:agroquimica/cubit/adminstates_cubit.dart';
import 'package:agroquimica/data/entities/usere_entities.dart';
import 'package:agroquimica/pages/deteccion/deteccion_page.dart';
import 'package:agroquimica/pages/recomendacion/recomendacion_page.dart';
import 'package:agroquimica/pages/ventas/ventas_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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
              GestureDetector(
                child: Container(
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
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => VentasPage()));
                },
              ),
              GestureDetector(
                child: Container(
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
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DeteccionPage()));
                },
              ),
              GestureDetector(
                child: Container(
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
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RecomendacionPage()));
                },
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
              //accountEmail: Text("ua"), accountName: Text("ua"),
              accountName: Text(
                  context.watch<AdminstatesCubit>().userEEntities.nombre +
                      " " +
                      context.watch<AdminstatesCubit>().userEEntities.apellido),
              accountEmail:
                  Text(context.watch<AdminstatesCubit>().userEEntities.correo)),
          ListTile(
            title: Text("MENÚ"),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/menu', (_) => false);
            },
          ),
          ListTile(
              title: Text("VENTAS"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => VentasPage()));
              }),
          ListTile(
              title: Text("RECOMENDACIÓN DE PRODUCTOS"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RecomendacionPage()));
              }),
          ListTile(
              title: Text("DETECCIÓN DE ENFERMEDAD"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DeteccionPage()));
              }),
          ListTile(
              title: Text("SIGN OUT"),
              onTap: () async {
                final User user = _auth.currentUser;
                if (user == null) {
                  Scaffold.of(context).showSnackBar(const SnackBar(
                    content: Text('No one has signed in.'),
                  ));
                  return;
                }
                await _auth.signOut();
                context.read<AdminstatesCubit>().carrito.clear();
                context.read<AdminstatesCubit>().totalfacturar = 0.0;
                context.read<AdminstatesCubit>().userEEntities = UserEEntities(
                    nombre: null,
                    apellido: null,
                    codcli: null,
                    correo: null,
                    contrasena: null,
                    codpais: null,
                    pais: null,
                    codciudad: null,
                    ciudad: null,
                    coddir: null,
                    direccion: null,
                    tipo: null,
                    numeracion: null,
                    numerotelf: null);
                Navigator.pushNamedAndRemoveUntil(
                    context, "/welcome", (_) => false);
              }),
        ],
      ),
    );
  }
}
