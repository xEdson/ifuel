import 'dart:io';

import 'package:ifuel/helpers/contact_help.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VeiculoPage extends StatefulWidget {
  final Veiculo veiculo;

  VeiculoPage({this.veiculo});

  @override
  _VeiculoPageState createState() => _VeiculoPageState();
}

class _VeiculoPageState extends State<VeiculoPage> {
  final _nomeController = TextEditingController();
  final _marcaController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _anoController = TextEditingController();
  final _combustivelController = TextEditingController();
  final _modeloController = TextEditingController();

  final _nomeFocus = FocusNode();

  bool _userEdited = false;

  Veiculo _editedVeiculo;

  @override
  void initState() {
    super.initState();
    if (widget.veiculo == null) {
      _editedVeiculo = Veiculo();
    } else {
      _editedVeiculo = Veiculo.fromMap(widget.veiculo.toMap());
      _nomeController.text = _editedVeiculo.nome;
      _marcaController.text = _editedVeiculo.marca;
      _anoController.text = _editedVeiculo.ano;
      _categoriaController.text = _editedVeiculo.categoria;
      _combustivelController.text = _editedVeiculo.combustivel;
      _modeloController.text = _editedVeiculo.modelo;
    }
  }

  void _insertVeiculo() {
    _editedVeiculo.nome = _nomeController.text ;
    _editedVeiculo.marca = _marcaController.text;
    _editedVeiculo.ano = _anoController.text;
    _editedVeiculo.categoria = _categoriaController.text;
    _editedVeiculo.combustivel = _combustivelController.text;
    _editedVeiculo.modelo = _modeloController.text;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Novo Veículo"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _insertVeiculo();
            if (_editedVeiculo.nome != null) {
              Navigator.pop(context, _editedVeiculo);
            } else {
              FocusScope.of(context).requestFocus(_nomeFocus);
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
              buildTextField("Marca", "", _marcaController),
              Divider(),
              buildTextField("Modelo", "", _modeloController),
              Divider(),
              buildTextField("Ano", "", _anoController),
              Divider(),
              buildTextField("Categoria", "", _categoriaController),
              Divider(),
              buildTextField("Combustível", "", _combustivelController),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
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
}
