import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifuel/helpers/contact_help.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../Entity/Usuario.dart';

class ControlaUsuario{
  Usuario usuario;
  ContactHelper contactHelper = ContactHelper();




  ControlaUsuario({this.usuario});

  void cadastrar(Usuario usuario){
    contactHelper.saveUsuario(usuario);
  }
  void editar(){}


  // ignore: missing_return
  Future<bool> login(String login, int senha, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await contactHelper.getUsuario(login).then((result){
      if(result!=null){
        if(result.senha==senha){
          prefs.setString("Usuario", login);
          prefs.setString("Status", 'logado');
          print('logado');
          Navigator.pop(context);
          Toast.show("Bem vindo $login", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

          return true;
        }else{
          _requestPop(context);
          return false;
        }
      }else{
        _requestPop(context);
        return false;
      }
    });
  }
  void logout(){}


  Future<bool> _requestPop(context) {

    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("login ou senha invalido"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed:(){
                  Navigator.pop(context);
                } ,
              ),

            ],
          );
        });
    return Future.value(false);
  }

}