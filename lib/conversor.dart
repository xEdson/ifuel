//import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'dart:async';
//import 'dart:convert';
//
//
//class ConversorMoedas extends StatefulWidget {
//
//  @override
//  _ConversorMoedas createState() => _ConversorMoedas();
//}
//
//class _ConversorMoedas extends State<ConversorMoedas> {
//  final litrosController = TextEditingController();
//  final valorCombustivelController = TextEditingController();
//  final valorTotalController = TextEditingController();
//
//  double litros;
//  double valorCombustivel;
//
//
//  void _litrosChanged(String text) {
//    double litros = double.parse(text);
//    valorCombustivelController.text = (litros * valorCombustivel).toStringAsFixed(2);
//    valorTotalController.text = (litros *valorCombustivel).toStringAsFixed(2);
//  }
//
//  void _valorCombustivelChanged(String text) {
//    double dolar = double.parse(text);
//    litrosController.text = (litros * valorCombustivel).toStringAsFixed(2);
//    valorTotalController.text = (litros * valorCombustivel).toStringAsFixed(2);
//  }
//
//  void _valorTotalChanged(String text) {
//    double euro = double.parse(text);
//    litrosController.text = (litros * valorCombustivel).toStringAsFixed(2);
//    valorCombustivelController.text = (litros * valorCombustivel).toStringAsFixed(2);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        backgroundColor: Colors.black,
//        appBar: AppBar(
//          title: Text("\$ Conversor \$"),
//          backgroundColor: Colors.amber,
//          centerTitle: true,
//        ),
//        body: FutureBuilder<Map>(
//            future: getData(),
//            // ignore: missing_return
//            builder: (context, snapshot) {
//              switch (snapshot.connectionState) {
//                case ConnectionState.none:
//                case ConnectionState.waiting:
//                default:
//                  if (snapshot.hasError) {
//                    return Center(
//                        child: Text(
//                      "ERRO ao Carregando Dados...=(",
//                      style: TextStyle(
//                        color: Colors.amber,
//                        fontSize: 25.0,
//                      ),
//                      textAlign: TextAlign.center,
//                    ));
//                  } else {
//                    dolar =
//                        snapshot.data["results"]["currencies"]["USD"]["buy"];
//                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
//                    print(dolar);
//                    print(euro);
//
//                    return SingleChildScrollView(
//                      padding: EdgeInsets.all(10.0),
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.stretch,
//                        children: <Widget>[
//                          Icon(Icons.monetization_on,
//                              size: 150.0, color: Colors.amber),
//                          buildTextField(
//                              "Reais", "R\$ ", litrosController, _litrosChanged),
//                          Divider(),
//                          buildTextField("Dolares", "US\$ ", valorCombustivelController,
//                              _valorCombustivelChanged),
//                          Divider(),
//                          buildTextField(
//                              "Euros", "€ ", valorTotalController, _valorTotalChanged)
//                        ],
//                      ),
//                    );
//                  }
//              }
//            }));
//  }
//}
//
//Widget buildTextField(String label, String prefix,
//    TextEditingController controller, Function function) {
//  return TextField(
//    controller: controller,
//    decoration: InputDecoration(
//        labelText: label,
//        labelStyle: TextStyle(color: Colors.amber),
//        enabledBorder:
//            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
//        border: OutlineInputBorder(),
//        prefixText: prefix),
//    style: TextStyle(color: Colors.amber, fontSize: 25.0),
//    onChanged: function,
//    keyboardType: TextInputType.number,
//  );
//}
