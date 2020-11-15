import 'package:agroquimica/cubit/adminstates_cubit.dart';
import 'package:agroquimica/data/entities/direccion/direccion_entities.dart';
import 'package:agroquimica/data/entities/usere_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombretextController = TextEditingController();
  final _apellidotextController = TextEditingController();
  final _emailtextController = TextEditingController();
  final _passwordtextController = TextEditingController();
  final _referenciatextController = TextEditingController();
  final _numeraciontextController = TextEditingController();
  final _numeroteltextController = TextEditingController();
  List<String> tipo = ['CEDULA', 'PASAPORTE'];
  String codpais = "";
  String codprov = "";
  String tiposel = 'Tipo de documento';
  String paistit = 'Pais';
  String ciudadtit = 'Ciudad';

  List<DireccionEntities> prov = [];
  List<DireccionEntities> pais = [];
  @override
  void initState() {
    context.read<AdminstatesCubit>().getDireccionInit('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<AdminstatesCubit, AdminstatesState>(
      listener: (context, state) {
        if (state is AdminstatesError) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is AdminstatesLoadingdir) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AdminstatesLoadeddir) {
          return buildbody(context, state);
        } else {
          return Center(
            child: Text("Cargando..."),
          );
        }
      },
    ));
  }

  Widget buildbody(BuildContext context, AdminstatesLoadeddir state) {
    pais = state.direccionEntities;

    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 320.0),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: Colors.grey),
                  width: size.width * 0.8,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: TextFormField(
                    controller: _nombretextController,
                    decoration: InputDecoration(
                        labelText: "Nombre", icon: Icon(Icons.person)),
                    validator: (value) {
                      if (value.length > 0) {
                        return null;
                      } else {
                        return "Debe introducir un Nombre";
                      }
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: Colors.grey),
                  width: size.width * 0.8,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: TextFormField(
                    controller: _apellidotextController,
                    decoration: InputDecoration(
                        labelText: "Apellido", icon: Icon(Icons.person)),
                    validator: (value) {
                      if (value.length > 0) {
                        return null;
                      } else {
                        return "Debe introducir un Apellido";
                      }
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: Colors.grey),
                  width: size.width * 0.8,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: TextFormField(
                    controller: _emailtextController,
                    decoration: InputDecoration(
                        labelText: "Email", icon: Icon(Icons.person)),
                    validator: (value) {
                      if (value.length > 0) {
                        return null;
                      } else {
                        return "Debe introducir un username";
                      }
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: Colors.grey),
                  width: size.width * 0.8,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: TextFormField(
                    controller: _passwordtextController,
                    decoration: InputDecoration(
                        labelText: "Password", icon: Icon(Icons.person)),
                    validator: (value) {
                      if (value.length > 0) {
                        if (value.length < 6) {
                          return "Debe ser mayor a 6 digitos";
                        }
                        return null;
                      } else {
                        return "Debe introducir una contraseña";
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                //pais
                DropdownButton<DireccionEntities>(
                  hint: Text(paistit),
                  items: pais.map((dropdownstringitem) {
                    return DropdownMenuItem<DireccionEntities>(
                      child: Text(dropdownstringitem.descripcion),
                      value: dropdownstringitem,
                    );
                  }).toList(),
                  onChanged: (value) async {
                    final aux = await context
                        .read<AdminstatesCubit>()
                        .getDireccion('?codpais=' + value.cod.toString());
                    setState(() {
                      this.codpais = value.cod.toString();
                      this.paistit = value.descripcion;
                      prov = aux;
                    });
                  },
                ),
                //provincia
                DropdownButton<DireccionEntities>(
                  hint: Text(ciudadtit),
                  items: prov.map((dropdownstringitem) {
                    return DropdownMenuItem<DireccionEntities>(
                      child: Text(dropdownstringitem.descripcion),
                      value: dropdownstringitem,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      this.ciudadtit = value.descripcion;
                      this.codprov = value.cod.toString();
                    });
                  },
                  // value: "Ciudad",
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: Colors.grey),
                  width: size.width * 0.8,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: TextFormField(
                    controller: _referenciatextController,
                    decoration: InputDecoration(
                        labelText: "Dirección", icon: Icon(Icons.person)),
                    validator: (value) {
                      if (value.length > 0) {
                        return null;
                      } else {
                        return "Debe introducir una Dirección";
                      }
                    },
                  ),
                ),
                //tipo documento
                DropdownButton<String>(
                  hint: Text(tiposel),
                  items: tipo.map((dropdownstringitem) {
                    return DropdownMenuItem<String>(
                      child: Text(dropdownstringitem),
                      value: dropdownstringitem,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      tiposel = value;
                    });
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: Colors.grey),
                  width: size.width * 0.8,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: TextFormField(
                    controller: _numeraciontextController,
                    decoration: InputDecoration(
                        labelText: "Numeración", icon: Icon(Icons.person)),
                    validator: (value) {
                      if (value.length > 0) {
                        return null;
                      } else {
                        return "Debe introducir una numeración";
                      }
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      color: Colors.grey),
                  width: size.width * 0.8,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: TextFormField(
                    controller: _numeroteltextController,
                    decoration: InputDecoration(
                        labelText: "Número de Telefono",
                        icon: Icon(Icons.person)),
                    validator: (value) {
                      if (value.length > 0) {
                        return null;
                      } else {
                        return "Debe introducir un número";
                      }
                    },
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      final email = _emailtextController.text;
                      final password = _passwordtextController.text;
                      bool flag = true;
                      flag = await context
                          .read<AdminstatesCubit>()
                          .validateUsername(email);
                      if (flag) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Este usuario ya esta creado")));
                      } else {
                        final userEtity = UserEEntities(
                            nombre: _nombretextController.text,
                            apellido: _apellidotextController.text,
                            correo: email,
                            contrasena: password,
                            codpais: codpais,
                            pais: "un",
                            codciudad: codprov,
                            ciudad: "una",
                            coddir: "1",
                            direccion: _referenciatextController.text,
                            tipo: tiposel,
                            numeracion: _numeraciontextController.text,
                            numerotelf: _numeroteltextController.text,
                            codcli: null);
                        await context
                            .bloc<AdminstatesCubit>()
                            .createUser(userEtity);
                        context
                            .bloc<AdminstatesCubit>()
                            .setUser(email, password);
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/menu', (_) => false);
                      }
                      _nombretextController.clear();
                      _emailtextController.clear();
                      _passwordtextController.clear();
                      _referenciatextController.clear();
                      _apellidotextController.clear();
                      _numeraciontextController.clear();
                      _numeroteltextController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
