import 'dart:io';

import 'package:ifuel/helpers/contact_help.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AbastecimentoPage extends StatefulWidget {
  final Abastecimento abastecimento;

  AbastecimentoPage({this.abastecimento});

  @override
  _AbastecimentoPageState createState() => _AbastecimentoPageState();
}

class _AbastecimentoPageState extends State<AbastecimentoPage> {
  final _litrosController = TextEditingController();
  final _valorCombustivelController = TextEditingController();
  final _totalController = TextEditingController();

  final _litrosFocus = FocusNode();

  bool _userEdited = false;

  Abastecimento _editedAbastecimento;

  double valorCombustivel=1;
  void _litrosChanged(String text) {
    _userEdited = true;
    double litros = double.parse(text);
    _totalController.text =
        (litros * valorCombustivel).toStringAsFixed(2);
    setState(() {
      _editedAbastecimento.litros = text;
      _editedAbastecimento.valorTotal = _totalController.text;

    });
  }

  void _totalChanged(String text) {
    _userEdited = true;
    double total = double.parse(text);
    _litrosController.text =
        (total /valorCombustivel).toStringAsFixed(2);
    setState(() {
      _editedAbastecimento.valorTotal = text;

    });
  }

  void _valorChanged(String text) {
    _userEdited = true;
    valorCombustivel = double.parse(text);
    double total = double.parse(_litrosController.text);
    _totalController.text = (total * valorCombustivel).toStringAsFixed(2);
    setState(() {
      _editedAbastecimento.valorComustivel=text;
      _editedAbastecimento.valorTotal = _totalController.text;

    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.abastecimento == null) {
      _editedAbastecimento = Abastecimento();
    } else {
      _editedAbastecimento = Abastecimento.fromMap(widget.abastecimento.toMap());
      _litrosController.text = _editedAbastecimento.litros;
      _valorCombustivelController.text = _editedAbastecimento.valorComustivel;
      _totalController.text = _editedAbastecimento.valorTotal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Novo Abastecimento"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedAbastecimento.litros != null && _editedAbastecimento.valorComustivel.isNotEmpty) {
              Navigator.pop(context, _editedAbastecimento);
            } else {
              FocusScope.of(context).requestFocus(_litrosFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              buildTextField("Litros", "", _litrosController, _litrosChanged),
              Divider(),
              buildTextField("Preço Combustivel", "", _valorCombustivelController, _valorChanged),
              Divider(),
              buildTextField("Total", "", _totalController, _totalChanged),
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
      TextEditingController controller, Function function) {
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
      onChanged: function,
      keyboardType: TextInputType.number,
    );
  }
}
