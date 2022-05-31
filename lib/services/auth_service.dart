import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyBYxvu39V_HV3KBB-PkRbHif4gWAfpOWH0';

  final storage = FlutterSecureStorage();

  //Si devolvemos algo será un error, si no nada
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken,
    });

    final response = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodeResponse = json.decode(response.body);

    if (decodeResponse.containsKey('idToken')) {
      //Tengo que grabar el token en el Secure Storage
      await storage.write(key: 'idToken', value: decodeResponse['idToken']);
      return null;
    } else {
      return decodeResponse['error']['message'];
    }
  } //createUser

  Future<String?> loginUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken,
    });

    final response = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodeResponse = json.decode(response.body);

    if (decodeResponse.containsKey('idToken')) {
      //Tengo que grabar el token en el Secure Storage
      await storage.write(key: 'idToken', value: decodeResponse['idToken']);
      return null;
    } else {
      return decodeResponse['error']['message'];
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'idToken');
  }

  Future<String> readToken() async {
    return await storage.read(key: 'idToken') ?? '';
  }
}
