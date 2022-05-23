import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  //Refercias a keys
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool isLoading = false;

  bool isValidForm() {
    //Con esto comprobamos si el formulario es válido, devolviendo true o false,
    //pero este currentState puede que aún no se haya asociado a nada y por eso
    //puede ser nulo, por eso el ?, en tal caso, devolvemos false
    return formKey.currentState?.validate() ?? false;
  }
}
