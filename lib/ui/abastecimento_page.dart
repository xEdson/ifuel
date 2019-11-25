import 'dart:io';

import 'package:ifuel/Entity/Abastecimento.dart';
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
  //Combos box
  final _postolController = TextEditingController();
  final _veiculoController = TextEditingController();
  final _tipoCombustivelController = TextEditingController();


  final _litrosFocus = FocusNode();

  Abastecimento _editedAbastecimento;

  double valorCombustivel=1;
  void _litrosChanged(String text) {
    double litros = double.parse(text);
    _totalController.text =
        (litros * valorCombustivel).toStringAsFixed(2);
    setState(() {
      _editedAbastecimento.litrCombustivel = text;
      _editedAbastecimento.total = _totalController.text;

    });
  }

  void _totalChanged(String text) {
    double total = double.parse(text);
    _litrosController.text =
        (total /valorCombustivel).toStringAsFixed(2);
    setState(() {
      _editedAbastecimento.total = text;

    });
  }

  void _valorChanged(String text) {
    valorCombustivel = double.parse(text);
    double total = double.parse(_litrosController.text);
    _totalController.text = (total * valorCombustivel).toStringAsFixed(2);
    setState(() {
      _editedAbastecimento.valorComustivel=text;
      _editedAbastecimento.total = _totalController.text;

    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.abastecimento == null) {
      _editedAbastecimento = Abastecimento();
    } else {
      _editedAbastecimento = Abastecimento.fromMap(widget.abastecimento.toMap());
      _litrosController.text = _editedAbastecimento.litrCombustivel;
      _valorCombustivelController.text = _editedAbastecimento.valorComustivel;
      _totalController.text = _editedAbastecimento.total;
    }
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
            if (_editedAbastecimento.litrCombustivel != null && _editedAbastecimento.valorComustivel.isNotEmpty) {
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
              buildTextFieldNumber("Litros", "", _litrosController, _litrosChanged),
              Divider(),
              buildTextFieldNumber("Preço Combustivel", "", _valorCombustivelController, _valorChanged),
              Divider(),
              buildTextFieldNumber("Total", "", _totalController, _totalChanged),
              Divider(),
              DropdownButton(),
              Divider(),
              buildTextFieldNumber("Veiculo", "", _veiculoController, _totalChanged),
              Divider(),
              buildTextFieldNumber("Tipo Combustivel", "", _tipoCombustivelController, _totalChanged),
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
}
