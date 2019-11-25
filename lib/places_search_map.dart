/*
 * Copyright (c) 2019 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
import 'dart:async';
import 'dart:convert';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/error.dart';
import 'data/place_response.dart';
import 'data/result.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'helpers/contact_help.dart';
import 'models/posto.dart';
import 'response_maps.dart';

class PlacesSearchMapSample extends StatefulWidget {
  final String keyword;

  PlacesSearchMapSample(this.keyword);

  @override
  State<PlacesSearchMapSample> createState() {
    return _PlacesSearchMapSample();
  }
}

class _PlacesSearchMapSample extends State<PlacesSearchMapSample> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    _getAllPostos();
  }

  ContactHelper helper = ContactHelper();
  List<Posto> postos = List();
  static const String _API_KEY = 'AIzaSyCBb1wj-pYLxWDDKU3MCU1sOvavdDWR6Q8';
  double preGasolina = 4.00;
  double preAlcool = 2.79;
  Map data;
  final _gasolinaController = TextEditingController();
  final _alcoolController = TextEditingController();

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _myLocation = CameraPosition(
    // 1
    target: LatLng(latitude, longitude),
    // 2
    zoom: 15,
    bearing: 15.0,
    tilt: 75.0,
  );

  void searchNearby(double latitude, double longitude) async {
    setState(() {
      markers.clear();
    });
    String url =
        '$baseUrl?key=$_API_KEY&location=$latitude,$longitude&radius=1000&keyword=${widget.keyword}';
    print(url);
    http.Response response = await http.get(
        "https://iron-wave-256918.firebaseio.com/-LtQtiSKIuEnLTGnFrIm/.json");

    if (response.statusCode == 200) {
      _handleResponse(json.decode(response.body));
      _preencherPostos();
      _getAllPostos();
      _preencherPostosByBd(postos);
    } else {
      throw Exception('An error occurred getting places nearby');
    }
    setState(() {
      searching = false; // 6
    });
  }

  static double latitude = 0;
  static double longitude = 0;
  static const String baseUrl =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json";

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/maps_style.json');
    controller.setMapStyle(value);
  }

  Error error;
  List<Result> places;
  bool searching = true;
  String keyword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: _setLocation(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  "Carregando Dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "ERRO ao Carregando Dados...=(",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  return GoogleMap(
                    initialCameraPosition: _myLocation,
                    mapType: MapType.normal,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      _setStyle(controller);
                    },
                    markers: Set<Marker>.of(markers.values),
                  );
                }
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.red,
          onPressed: () {
            searchNearby(latitude, longitude);
          },
          label: Text('Postos proximos'),
          icon: Icon(Icons.place),
        ));
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _handleResponse(data) {
    // bad api key or otherwise
    if (data['status'] == "REQUEST_DENIED") {
      setState(() {
        error = Error.fromJson(data);
      });
    } else if (data['status'] == "OK") {
      setState(() {
        places = PlaceResponse.parseResults(data['results']);
      });
    } else {
      print(data);
    }
  }

  void _preencherPostosByBd(List<Posto> list) {
    if (list.isEmpty) {
      setState(() {
        error = new Error(errorMessage: "Postos não encontrados");
      });
    } else {
      setState(() {
        for (int i = 0; i < list.length; i++) {
          addMarker(list[i]);
        }
      });
    }
  }

  void addMarker(Posto posto) {
    var markerIdVal = posto.id;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(posto.latitude, posto.longitude),
      infoWindow: InfoWindow(
          title: posto.nome,
          snippet:
              "Gasolina: +${posto.precoGasolina} Alcool: ${posto.precoAlcool}"),
      onTap: () {
        _showOptions(context, markerId);
      },
    );
    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  Future _setLocation() async {
    var location = new Location();
    var currentLocation = await location.getLocation();
//    latitude = currentLocation.latitude;
//    longitude = currentLocation.longitude;
    latitude = -22.562594;
    longitude = -47.4235437;
    Marker(
      markerId: MarkerId("Meu Local"),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: "Localização atual"),
      onTap: () {},
    );
  }

  void _showOptions(BuildContext context, MarkerId markerId) {
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
                          "Editar valor!",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          showEditPreco(context, markerId);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Ranking",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          filterByGas(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Ir para o local",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          var posto;
                          // ignore: unrelated_type_equality_checks
                          for (int i = 0; i < postos.length; i++) {
                            if (postos[i].id == markerId.value) {
                              posto = postos[i];
                              break;
                            }
                          }
                          var url = "https://www.google.com.br/maps/dir/" +
                              latitude.toString() +
                              "," +
                              longitude.toString() +
                              "/" +
                              posto.latitude.toString() +
                              "," +
                              posto.longitude.toString() +
                              "/data=!3m1!4b1!4m2!4m1!3e0";
                          _launchURL(url);
                          Navigator.pop(context);
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

  void filterByGas(BuildContext context) {
     showModalBottomSheet(
        context: context,
        builder: (context) {
          return Row(
            children: <Widget>[
              FlatButton(
                child: Text("Filtrar por preço alcool"),
                onPressed: () {
                  _orderPosto(1);
                  _openListPost(context);
                },
              ),
              FlatButton(
                child: Text("Filtrar por preço gasolina"),
                onPressed: () {
                  _orderPosto(0);
                  _openListPost(context);
                },
              )
            ],
          );
        });
  }

  void showEditPreco(BuildContext context, MarkerId markerId) {
    showDialog(
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
                        child: TextField(
                            controller: _gasolinaController,
                            decoration: InputDecoration(labelText: "Gasolina"),
                            onChanged: (text) {
                              setState(() {
                                preGasolina = text as double;
                              });
                            },
                            keyboardType: TextInputType.number),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextField(
                            controller: _alcoolController,
                            decoration: InputDecoration(labelText: "Alcool"),
                            onChanged: (text) {
                              setState(() {
                                preAlcool = text as double;
                              });
                            },
                            keyboardType: TextInputType.number),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text(
                            "Salvar",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                          onPressed: () {
                            setState(() {
                              for (int i = 0; i < postos.length; i++) {
                                if (postos[i].id == markerId.value) {
                                  postos[i].precoAlcool =
                                      double.parse(_alcoolController.text);
                                  postos[i].precoGasolina =
                                      double.parse(_gasolinaController.text);
                                  updatePostos(i);
                                  break;
                                }
                              }
                              setState(() {
                                markers.clear();
                              });
                              _preencherPostosByBd(postos);
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  Future updatePostos(int i) async {
    await helper.updatePosto(postos[i]);
  }

  void _preencherPostos() async {
    List<Posto> postosBanco = List();
    var existe = false;
    for (int i = 0; i < places.length; i++) {
      var posto = new Posto(
          places[i].id,
          places[i].name,
          "",
          places[i].geometry.location.lat,
          places[i].geometry.location.long,
          0,
          preAlcool,
          preGasolina);
      for (int j = 0; j < postos.length; j++) {
        if (postos[j].id == posto.id) {
          existe = true;
        }
      }

      if (!existe) {
        postosBanco.add(posto);
        postos.add(posto);
      }
      existe = false;
    }
    for (int i = 0; i < postosBanco.length; i++) {
      await helper.savePosto(postosBanco[i]);
    }
  }

  void _getAllPostos() async {
    helper.getAllPostos().then((list) {
      setState(() {
        postos = list;
      });
    });
  }

  void _openListPost(BuildContext context) {
    setState(() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return ListView.builder(
                itemCount: postos == null ? 0 : postos.length,
                itemBuilder: (BuildContext context, int index) {
                  return new GestureDetector(
                    onTap: () {
                      var url = "https://www.google.com.br/maps/dir/" +
                          latitude.toString() +
                          "," +
                          longitude.toString() +
                          "/" +
                          postos[index].latitude.toString() +
                          "," +
                          postos[index].longitude.toString() +
                          "/data=!3m1!4b1!4m2!4m1!3e0";
                      _launchURL(url);
                    },
                    child: new Card(
                      //I am the clickable child
                      child: new Column(
                        children: <Widget>[
                          //new Image.network(video[index]),
                          new Padding(padding: new EdgeInsets.all(3.0)),
                          new Text(
                            postos[index].nome,
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          });
    });
  }

  void _orderPosto(int combustivel) {
    switch (combustivel) {
      case 0:
        postos.sort((a, b) {
          return a.precoGasolina.compareTo(b.precoGasolina);
        });
        break;
      case 1:
        postos.sort((a, b) {
          return a.precoAlcool.compareTo(b.precoAlcool);
        });
        break;
    }
  }
}
