import 'dart:io';

import 'package:ifuel/helpers/contact_help.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

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

  String _combustivelSelecionado;
  List<DropdownMenuItem<String>> _dropDownCombustiveisItems;
  List _combustiveis = ["Alcool", "Gasolina", "Diesel", "GNV", "Gasolina Aditivada"];

  final _nomeFocus = FocusNode();

  bool _userEdited = false;

  Veiculo _editedVeiculo;

  @override
  void initState() {
    _dropDownCombustiveisItems = getDropDownCombustiveisItems();
    _combustivelSelecionado = _dropDownCombustiveisItems[0].value;
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
    _editedVeiculo.combustivel = _combustivelSelecionado;
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
            if (_editedVeiculo.nome == ""
                || _editedVeiculo.ano == ""
                || _editedVeiculo.modelo == ""
                || _editedVeiculo.categoria == ""
                || _editedVeiculo.combustivel == ""
                || _editedVeiculo.marca == "") {
              FocusScope.of(context).requestFocus(_nomeFocus);
              Toast.show("Existem campos em branco", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
            } else {
              Navigator.pop(context, _editedVeiculo);
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
              new Text("Selecione um tipo de combustível"),
              Container(
                width: 400.0,
                height: 60.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    border: Border.all(color: Colors.blueGrey)),
                child: DropdownButton(
                  value: _combustivelSelecionado,
                  isExpanded: true,
                  items: _dropDownCombustiveisItems,
                  onChanged: changedDropDownItem,
                  style: TextStyle(color: Colors.black, fontSize: 25.0),
                ),
              ),
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

  void changedDropDownItem(String combustivelSelecionado) {
    setState(() {
      _combustivelSelecionado = combustivelSelecionado;
    });
  }

  List<DropdownMenuItem<String>> getDropDownCombustiveisItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String c in _combustiveis) {
      items.add(new DropdownMenuItem(
          value: c,
          child: new Text(c)
      ));
    }
    return items;
  }
}
