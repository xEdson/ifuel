import 'dart:io';
import 'dart:math';

import 'package:ifuel/Entity/Abastecimento.dart';
import 'package:ifuel/Entity/Estrelas.dart';
import 'package:ifuel/Entity/Nota.dart';
import 'package:ifuel/helpers/contact_help.dart';
import 'package:flutter/material.dart';
import 'package:ifuel/models/posto.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class PostoPage extends StatefulWidget {
  final Posto posto;

  PostoPage({this.posto});

  @override
  _PostoPageState createState() => _PostoPageState();
}

class _PostoPageState extends State<PostoPage> {
  ContactHelper helper = ContactHelper();
  Posto posto;
  NumberFormat formatter = NumberFormat("0.00");
  double media = 0;

  int _currentIndex = 1;

  List<Estrelas> _group = [
    Estrelas(
      nota: 1,
      index: 1,
    ),
    Estrelas(
      nota: 2,
      index: 2,
    ),
    Estrelas(
      nota: 3,
      index: 3,
    ),
    Estrelas(
      nota: 4,
      index: 4,
    ),
    Estrelas(
      nota: 5,
      index: 4,
    ),
  ];

  @override
  void initState() {
    super.initState();
    this.posto = widget.posto;
    _getNota();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Posto de abastecimento"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Icon(Icons.map),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(posto.nome,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  )),
              Divider(),
              Text("Gasolina: R\$' " + posto.precoGasolina.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  )),
              Divider(),
              Text("Alcool: R\$' " + posto.precoAlcool.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  )),
              Divider(),
              Divider(),
              Text("Avaliaçao",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  )),
              _buildRow(),
              Divider(),
              Text("Combustivel com melhor custo benefício nesse posto: ${calcularCombustivel()} ")
            ],
          ),
        ),
      ),
    );
  }

  String calcularCombustivel(){

    var divisao = posto.precoAlcool/posto.precoGasolina;

    if(divisao<=0.7){
      return "Alcool";
    }else{
      return "Gasolina";
    }
  }


  Row _buildRow() {
    var colorBlack = Colors.black;
    var colorYellow = Colors.yellow;
    var color1 = colorBlack;
    var color2 = colorBlack;
    var color3 = colorBlack;
    var color4 = colorBlack;
    var color5 = colorBlack;

    if (posto.nota >= 1) {
      color1 = colorYellow;
    }
    if (posto.nota >= 2) {
      color2 = colorYellow;
    }
    if (posto.nota >= 3) {
      color3 = colorYellow;
    }
    if (posto.nota >= 4) {
      color4 = colorYellow;
    }
    if (posto.nota >= 5) {
      color5 = colorYellow;
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: getIcon(color1),
          onPressed: () {
            setState(() {
              _saveNota(1);
            });
          },
        ),
        IconButton(
          icon: getIcon(color2),
          onPressed: () {
            setState(() {
              _saveNota(2);
            });
          },
        ),
        IconButton(
          icon: getIcon(color3),
          onPressed: () {
            setState(() {
              _saveNota(3);
            });
          },
        ),
        IconButton(
          icon: getIcon(color4),
          onPressed: () {
            setState(() {
              _saveNota(4);
            });
          },
        ),
        IconButton(
          icon: getIcon(color5),
          onPressed: () {
            setState(() {
              _saveNota(5);
            });
          },
        ),
        Text("Nota : ${posto.nota}")
      ],
    );
  }

  Future _saveNota(double nota) async {
    var nota1 = Nota(Random().nextInt(1000), nota, posto.id);
    await helper.saveNota(nota1);
    _getNota();
  }

  Future _getNota() async {
    helper.getNota(posto.id).then((list) {
      if (list.isNotEmpty) {
        for (int i = 0; i < list.length; i++) {
          media += list[i].nota;
        }
        media = media / list.length;
        setState(() {
          posto.nota = double.parse(formatter.format(media));
          media = 0;
        });
      }
    });
  }

  Icon getIcon(color) {
    return Icon(
      Icons.star,
      color: color,
    );
  }
}
