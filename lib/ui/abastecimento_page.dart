import 'dart:io';

import 'package:ifuel/Entity/Abastecimento.dart';
import 'package:ifuel/helpers/contact_help.dart';
import 'package:flutter/material.dart';
import 'package:ifuel/models/posto.dart';
import 'package:image_picker/image_picker.dart';

class AbastecimentoPage extends StatefulWidget {
  final Abastecimento abastecimento;

  AbastecimentoPage({this.abastecimento});

  @override
  _AbastecimentoPageState createState() => _AbastecimentoPageState();
}

class _AbastecimentoPageState extends State<AbastecimentoPage> {
  ContactHelper helper = ContactHelper();
  final _litrosController = TextEditingController();
  final _valorCombustivelController = TextEditingController();
  final _totalController = TextEditingController();

  List<Posto> postos = List();
  List<Veiculo> veiculos = List();
  List _tiposCombustiveis = ["Gasolina", "Alcool"];
  String _combustivelSelecionado;
  String _postoSelecionado;
  String _veiculoSelecionado;

  List<DropdownMenuItem<String>> _dropDownCombustiveisItems;
  List<DropdownMenuItem<String>> _dropDownPostosItems;
  List<DropdownMenuItem<String>> _dropDownVeiculosItems;

  final _litrosFocus = FocusNode();

  Abastecimento _editedAbastecimento;

  double valorCombustivel = 1;

  void _litrosChanged(String text) {
    double litros = double.parse(text);
    _totalController.text = (litros * valorCombustivel).toStringAsFixed(2);
    setState(() {
      _editedAbastecimento.litrCombustivel = text;
      _editedAbastecimento.total = _totalController.text;
    });
  }

  void _totalChanged(String text) {
    double total = double.parse(text);
    _litrosController.text = (total / valorCombustivel).toStringAsFixed(2);
    setState(() {
      _editedAbastecimento.total = text;
    });
  }

  void _valorChanged(String text) {
    valorCombustivel = double.parse(text);
    double total = double.parse(_litrosController.text);
    _totalController.text = (total * valorCombustivel).toStringAsFixed(2);
    setState(() {
      _editedAbastecimento.valorComustivel = text;
      _editedAbastecimento.total = _totalController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.abastecimento == null) {
      _editedAbastecimento = Abastecimento();
    } else {
      _editedAbastecimento =
          Abastecimento.fromMap(widget.abastecimento.toMap());
      _litrosController.text = _editedAbastecimento.litrCombustivel;
      _valorCombustivelController.text = _editedAbastecimento.valorComustivel;
      _totalController.text = _editedAbastecimento.total;
      _veiculoSelecionado = _editedAbastecimento.veiculo;
      _postoSelecionado = _editedAbastecimento.posto;
      _combustivelSelecionado = _editedAbastecimento.tipoCombustivel;
    }
    _getAllPostos();
    _getAllVeiculos();
    _dropDownCombustiveisItems = getDropDownCombustiveisItems();
  }

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
            if (_editedAbastecimento.litrCombustivel != null &&
                _editedAbastecimento.valorComustivel!=null &&
                _veiculoSelecionado!=null &&
                _combustivelSelecionado!=null &&
                _postoSelecionado!=null) {
              _editedAbastecimento.posto=_postoSelecionado;
              _editedAbastecimento.veiculo = _veiculoSelecionado;
              _editedAbastecimento.tipoCombustivel=_combustivelSelecionado;
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
              buildTextFieldNumber(
                  "Litros", "", _litrosController, _litrosChanged),
              Divider(),
              buildTextFieldNumber("Preço Combustivel", "",
                  _valorCombustivelController, _valorChanged),
              Divider(),
              buildTextFieldNumber(
                  "Total", "", _totalController, _totalChanged),
              Divider(),
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
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
              ),
              Divider(),
              Container(
                width: 400.0,
                height: 60.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    border: Border.all(color: Colors.blueGrey)),
                child: DropdownButton(
                  value: _postoSelecionado,
                  isExpanded: true,
                  items: _dropDownPostosItems,
                  onChanged: changedDropDownPostos,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
              ),
              Divider(),
              Container(
                width: 400.0,
                height: 60.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    border: Border.all(color: Colors.blueGrey)),
                child: DropdownButton(
                  value: _veiculoSelecionado,
                  isExpanded: true,
                  items: _dropDownVeiculosItems,
                  onChanged: changedDropDownVeiculos,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldNumber(String label, String prefix,
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
      keyboardType: TextInputType.text,
    );
  }

  List<DropdownMenuItem<String>> getDropDownCombustiveisItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _tiposCombustiveis) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }

  void changedDropDownItem(String combustivelSelecionado) {
    setState(() {
      _combustivelSelecionado = combustivelSelecionado;
    });
  }

  void _getAllPostos() async {
    helper.getAllPostos().then((list) {
      setState(() {
        postos = list;
        getDropDownPostosItems();
      });
    });
  }

  void getDropDownPostosItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (Posto posto in postos) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(
          new DropdownMenuItem(value: posto.nome, child: new Text(posto.nome)));
    }
    _dropDownPostosItems = items;
  }

  void _getAllVeiculos() async {
    helper.getAllVeiculos().then((list) {
      setState(() {
        veiculos = list;
        getDropDownVeiculosItems();
      });
    });
  }

  void getDropDownVeiculosItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (Veiculo veiculo in veiculos) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: veiculo.nome, child: new Text(veiculo.nome)));
    }
    if (items.isEmpty) {
      items.add(new DropdownMenuItem(
          value: "Sem veiculos", child: new Text("Sem veiculos")));
    }
    _dropDownVeiculosItems = items;
  }

  void changedDropDownPostos(String postoSelecionado) {
    setState(() {
      _postoSelecionado = postoSelecionado;
    });
  }

  void changedDropDownVeiculos(String veiculoSelecionado) {
    setState(() {
      _veiculoSelecionado = veiculoSelecionado;
    });
  }
}
