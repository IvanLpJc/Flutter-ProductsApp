import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  static const String routeName = 'CheckAuthScreen';
  const CheckAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: authService.readToken(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (!snapshot.hasData) return Text('Espere');

              //Como el builder tiene que devolver un widget, vamos a usar
              //este microtask para ejecutar algo tan pronto como el Future termina
              //de construirse
              if (snapshot.data == '') {
                Future.microtask(() {
                  //Con el pushReplacement podemos modificar el tipo de transición
                  //utilizando un PageRouteBuilder (el famoso Route<T>) añadiendo
                  //una transición 'personalizada'
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const LoginScreen(),
                        transitionDuration: const Duration(seconds: 0),
                      ));
                });
              } else {
                Future.microtask(() {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const HomeScreen(),
                        transitionDuration: const Duration(seconds: 0),
                      ));
                });
              }

              return Container();
            }),
      ),
    );
  }
}
