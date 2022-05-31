import 'package:flutter/material.dart';

class NotificationsService {
  //Con esto mantenemos la referencia a un widget especial que contiene
  //el widget MaterialApp, que es un scaffold
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
      style: TextStyle(color: Colors.white, fontSize: 20),
    ));

    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
