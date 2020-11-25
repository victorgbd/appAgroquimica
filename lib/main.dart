import 'package:agroquimica/pages/login/welcome_page.dart';
import 'package:agroquimica/pages/menu_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:agroquimica/dependencies_injection.dart' as dependencies;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/adminstates_cubit.dart';

void main() async {
  await dependencies.init();

  runApp(MyApp());
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => dependencies.sl<AdminstatesCubit>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Agroquimica",
        theme: ThemeData(
          primaryColor: Colors.green,
          secondaryHeaderColor: Color.fromARGB(255, 229, 80, 0),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: WelcomePage(),
        //home: MenuPage(),
        routes: {
          "/menu": (_) => MenuPage(),
          "/welcome": (_) => WelcomePage(),
        },
      ),
    );
  }
}
