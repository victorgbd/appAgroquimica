import 'package:agroquimica/cubit/adminstates_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerificacionPage extends StatefulWidget {
  final String email;
  final String password;

  const VerificacionPage({Key key, this.email, this.password})
      : super(key: key);

  @override
  VerificacionPageState createState() => VerificacionPageState();
}

class VerificacionPageState extends State<VerificacionPage> {
  User user;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    user.sendEmailVerification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              verificationEmail();
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Se ha enviado un correo de confirmacion"),
      ),
    );
  }

  Future<void> verificationEmail() async {
    user = FirebaseAuth.instance.currentUser;
    await user.reload();
    if (user.emailVerified) {
      context.read<AdminstatesCubit>().setUser(widget.email, widget.password);
      Navigator.pushNamedAndRemoveUntil(context, '/menu', (_) => false);
    }
  }
}
