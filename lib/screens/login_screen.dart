import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/screens/home_screen.dart';
import 'package:productos_app/ui/ui.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  static String routeName = 'Login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              CardContainer(
                child: Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ChangeNotifierProvider(
                    create: (_) => LoginFormProvider(),
                    child: const _LoginForm(),
                  ),
                ]),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Crear una nueva cuenta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginFormProvider>(context);
    return Form(
      key: loginFormProvider.formKey,
      autovalidateMode: AutovalidateMode
          .onUserInteraction, //valida conforme actuamos con el input
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'example@example.com',
              labelText: 'Email',
              prefixIcon: Icons.alternate_email_sharp,
            ),
            onChanged: (value) => loginFormProvider.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

              RegExp regExp = new RegExp(pattern);

              return regExp.hasMatch(value ?? '') ? null : 'Formato incorrecto';
            },
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '******',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline,
              ),
              onChanged: (value) => loginFormProvider.password = value,
              validator: (value) => value != null && value.length >= 6
                  ? null
                  : 'Logitud no válida'),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            onPressed: loginFormProvider.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    if (!loginFormProvider.isValidForm()) return;

                    loginFormProvider.isLoading = true;

                    await Future.delayed(Duration(seconds: 2));

                    //Todo Validar
                    loginFormProvider.isLoading = false;

                    Navigator.pushReplacementNamed(
                        context, HomeScreen.routeName);
                  },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            color: Colors.deepPurple,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(
                loginFormProvider.isLoading
                    ? 'Iniciando sesión...'
                    : 'Iniciar sesión',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
