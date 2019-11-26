import 'dart:io';

import 'package:ifuel/Entity/Abastecimento.dart';
import 'package:ifuel/helpers/contact_help.dart';
import 'package:flutter/material.dart';
import 'package:ifuel/models/posto.dart';
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

  @override
  void initState() {
    super.initState();
    this.posto = widget.posto;
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
              Text("Alcool: R\$' " + posto.precoGasolina.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
