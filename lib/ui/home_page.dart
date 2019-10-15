import 'dart:io';

import 'package:ifuel/helpers/contact_help.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'contact_page.dart';

enum OrderOption { orderaz, orderza }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ContactHelper helper = ContactHelper();

  List<Abastecimento> abastecimentos = List();



  @override
  void initState() {
    super.initState();
    _getAllAbastecimentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Abastecimentos"),
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
          _showAbastecimentoPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: abastecimentos.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
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
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("images/logotipo.jpg"),
                        fit: BoxFit.cover)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Litros: "+abastecimentos[index].litros ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Valor Combustivel: "+abastecimentos[index].valorComustivel ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                     "Valor Total: "+ abastecimentos[index].valorTotal ?? "",
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
                          "Ligar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showAbastecimentoPage(abascetimento: abastecimentos[index]);
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
                          helper.deleteContact(abastecimentos[index].id);
                          setState(() {
                            abastecimentos.removeAt(index);
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


  Future _showAbastecimentoPage({Abastecimento abascetimento}) async {
    final recAbastecimento = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AbastecimentoPage(
                  abastecimento: abascetimento,
                )));
    if (recAbastecimento != null) {
      if (abascetimento != null) {
        await helper.updateAbastecimento(recAbastecimento);
      } else {
        await helper.saveAbastecimento(recAbastecimento);
      }
    }
    _getAllAbastecimentos();
  }

  void _getAllAbastecimentos() {
    helper.getAllAbascetimento().then((list) {
      setState(() {
        abastecimentos = list;
      });
    });
  }

  void _orderList(OrderOption result) {
    switch (result) {
      case OrderOption.orderaz:
        abastecimentos.sort((a, b) {
          return null;
        });
        break;
      case OrderOption.orderza:
        abastecimentos.sort((a, b) {
          return null;
        });
        break;
    }

    setState(() {});
  }
}
