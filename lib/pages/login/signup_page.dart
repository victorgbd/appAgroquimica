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

  int _indexstep = 0;
  bool complete = false;
  void goTo(int step) {
    setState(() {
      _indexstep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
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

    List<Step> steps = [
      Step(
          title: Text("USUARIO"),
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20.0),
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
                SizedBox(height: 20.0),
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
                SizedBox(height: 20.0),
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
                        labelText: "Email", icon: Icon(Icons.email)),
                    validator: (value) {
                      if (value.length > 0) {
                        return null;
                      } else {
                        return "Debe introducir un Email";
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
                        labelText: "Password", icon: Icon(Icons.lock)),
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
                SizedBox(height: 20.0),
              ],
            ),
          )),
      Step(
          title: Text("DIRECCIÓN"),
          content: Form(
            key: _formKey,
            child: Column(
              children: [
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
                SizedBox(height: 20.0),
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
                SizedBox(height: 20.0),
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
                        labelText: "Dirección", icon: Icon(Icons.map)),
                    validator: (value) {
                      if (value.length > 0) {
                        return null;
                      } else {
                        return "Debe introducir una Dirección";
                      }
                    },
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          )),
      Step(
          title: Text("FINAL"),
          state: StepState.complete,
          content: Form(
            key: _formKey,
            child: Column(
              children: [
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
                SizedBox(height: 20.0),
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
                        labelText: "Numeración", icon: Icon(Icons.credit_card)),
                    validator: (value) {
                      if (value.length > 0) {
                        return null;
                      } else {
                        return "Debe introducir una numeración";
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
                    controller: _numeroteltextController,
                    decoration: InputDecoration(
                        labelText: "Número de Telefono",
                        icon: Icon(Icons.phone_android)),
                    validator: (value) {
                      if (value.length > 0) {
                        return null;
                      } else {
                        return "Debe introducir un número";
                      }
                    },
                  ),
                ),
                SizedBox(height: 20.0),
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
                            codcli: '1');
                        await context
                            .read<AdminstatesCubit>()
                            .createUser(userEtity);
                        context
                            .read<AdminstatesCubit>()
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: Text("Aceptar"),
                  padding:
                      EdgeInsets.symmetric(horizontal: 44.0, vertical: 14.0),
                )
              ],
            ),
          )),
    ];
    return Stepper(
      steps: steps,
      type: StepperType.horizontal,
      currentStep: _indexstep,
      onStepTapped: (value) => goTo(value),
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: RaisedButton(
                    onPressed: () async {
                      if (_indexstep + 1 != steps.length) {
                        //if (_formKey.currentState.validate()) {
                        goTo(_indexstep + 1);
                        //}
                      } else {
                        setState(() => complete = true);
                      }
                      if (_indexstep == 2) {}
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: Text("Siguiente"),
                    padding:
                        EdgeInsets.symmetric(horizontal: 44.0, vertical: 14.0),
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
                    child: Text("Atras"),
                    padding:
                        EdgeInsets.symmetric(horizontal: 44.0, vertical: 14.0),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
