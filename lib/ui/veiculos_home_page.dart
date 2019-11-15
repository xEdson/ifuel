import 'dart:io';

import 'package:ifuel/helpers/contact_help.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helpers/contact_help.dart';
import '../helpers/contact_help.dart';
import 'veiculos_page.dart';

enum OrderOption { orderaz, orderza }

class VeiculosHome extends StatefulWidget {
  @override
  _VeiculosState createState() => _VeiculosState();
}

class _VeiculosState extends State<VeiculosHome> {
  ContactHelper helper = ContactHelper();

  List<Veiculo> veiculos = List();



  @override
  void initState() {
    super.initState();
    _getAllVeiculos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Veículos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          Container(
            width: 100.0,
            height: 100.0,
            child: Image(
              image: AssetImage("images/logotipo.jpg"),
            ),
          ),
          PopupMenuButton<OrderOption>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOption>>[
              const PopupMenuItem<OrderOption>(
                child: Text("Ordenar A-Z"),
                value: OrderOption.orderaz,
              ),
              const PopupMenuItem<OrderOption>(
                child: Text("Ordenar Z-A"),
                value: OrderOption.orderza,
              ),
            ],
            onSelected: _orderList,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showVeiculosPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: veiculos.length,
          itemBuilder: (context, index) {
            return _VeiculoCard(context, index);
          }),
    );
  }

  Widget _VeiculoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/carro.png"),
                        fit: BoxFit.cover)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Nome: "+veiculos[index].nome ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Marca: "+veiculos[index].marca ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                     "Categoria: "+ veiculos[index].categoria ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Modelo: "+ veiculos[index].modelo ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Ano: "+ veiculos[index].ano ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      "Combustível: "+ veiculos[index].combustivel ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showVeiculosPage(veiculo: veiculos[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          helper.deleteVeiculo(veiculos[index].id);
                          setState(() {
                            veiculos.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }


  Future _showVeiculosPage({Veiculo veiculo}) async {
    final recVeiculo = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VeiculoPage(
                  veiculo: veiculo,
                )));
    if (recVeiculo != null) {
      if (veiculo != null) {
        await helper.updateVeiculo(recVeiculo);
      } else {
        await helper.saveVeiculo(recVeiculo);
      }
    }
    _getAllVeiculos();
  }

  void _getAllVeiculos() {
    helper.getAllVeiculos().then((list) {
      setState(() {
        veiculos = list;
      });
    });
  }

  void _orderList(OrderOption result) {
    switch (result) {
      case OrderOption.orderaz:
        veiculos.sort((a, b) {
          return null;
        });
        break;
      case OrderOption.orderza:
        veiculos.sort((a, b) {
          return null;
        });
        break;
    }

    setState(() {});
  }
}
