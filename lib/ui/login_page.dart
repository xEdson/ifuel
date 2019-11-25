import 'dart:io';

import 'package:ifuel/Control/ControlaUsuario.dart';
import 'package:ifuel/Entity/Abastecimento.dart';
import 'package:ifuel/Entity/Usuario.dart';
import 'package:ifuel/helpers/contact_help.dart';
import 'package:flutter/material.dart';
import 'package:ifuel/ui/cadastro_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {


  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();
  ContactHelper helper = ContactHelper();
  ControlaUsuario controlaUsuario = new ControlaUsuario();
  bool logado;
  SharedPreferences preferences;

 @override
  void initState() {
    super.initState();
    _carregarSession();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Login"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              buildTextField("Login","",_loginController),
              Divider(),
              buildNumberField("Senha", "", _senhaController),
              Divider(),
              Row(
                children: <Widget>[
                  FlatButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,child: Text("Logar"),
                    onPressed: (){
                      logar();

                    },),
                  FlatButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,child: Text("Cadastrar"),
                    onPressed: (){
                      _showCadastro();
                    },)

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future _carregarSession() async {
    preferences = await SharedPreferences.getInstance();

  }
  Future logar() async {

    if(_loginController.text.isNotEmpty && _senhaController.text.isNotEmpty){
       logado = await controlaUsuario.login(_loginController.text, int.parse(_senhaController.text), context);
    }
  }

  Widget buildTextField(String label, String prefix,
      TextEditingController controller) {
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

  Widget buildNumberField(String label, String prefix,
      TextEditingController controller) {
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


  Future _showCadastro() async {
    final recUsuario = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroPage(
            )));
    if (recUsuario != null) {
        await helper.saveUsuario(recUsuario);
    }
  }


}
