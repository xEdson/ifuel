import 'dart:io';

import 'package:ifuel/Entity/Abastecimento.dart';
import 'package:ifuel/Entity/Usuario.dart';
import 'package:ifuel/helpers/contact_help.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _nomeController = TextEditingController();
  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();
  final _nivelController = TextEditingController();

  Usuario _usuario = Usuario();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Novo Abastecimento"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_nomeController.text.isNotEmpty &&
                _loginController.text.isNotEmpty &&
                _senhaController.text.isNotEmpty &&
                _nivelController.text.isNotEmpty) {
              _usuario.nome = _nomeController.text;
              _usuario.login = _loginController.text;
              _usuario.senha = int.parse(_senhaController.text);
              _usuario.nivel = int.parse(_nivelController.text);
              Navigator.pop(context, _usuario);
            }else{
              _requestPop();

            }


          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              buildTextField("Nome", "", _nomeController),
              Divider(),
              buildTextField("Login", "", _loginController),
              Divider(),
              buildNumberField("Senha", "", _senhaController),
              Divider(),
              buildNumberField("Nivel", "", _nivelController),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, String prefix, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          border: OutlineInputBorder(),
          prefixText: prefix),
      style: TextStyle(color: Colors.black, fontSize: 25.0),
      keyboardType: TextInputType.text,
    );
  }

  Widget buildNumberField(
      String label, String prefix, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          border: OutlineInputBorder(),
          prefixText: prefix),
      style: TextStyle(color: Colors.black, fontSize: 25.0),
      keyboardType: TextInputType.number,
    );
  }

  Future<bool> _requestPop() {

      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Campos obrigatorios"),
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
