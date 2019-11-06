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

import 'data/error.dart';
import 'data/place_response.dart';
import 'data/result.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

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

  List<Marker> markers = <Marker>[];

  void searchNearby(double latitude, double longitude) async {
    setState(() {
      markers.clear();
    });
    String url =
        '$baseUrl?key=$_API_KEY&location=$latitude,$longitude&radius=1000&keyword=${widget.keyword}';
    print(url);
//    final response = await http.get(url);
//    if (response.statusCode == 200) {
    if (true) {
      data = responseMock;

        _handleResponse(data);

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
                  markers: Set<Marker>.of(markers),
                );
              }
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          searchNearby(latitude, longitude); // 2
        },
        label: Text('Places Nearby'), // 3
        icon: Icon(Icons.place), // 4
      ),
    );
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

        for (int i = 0; i < places.length; i++) {
          markers.add(
            Marker(
              markerId: MarkerId(places[i].placeId),
              position: LatLng(places[i].geometry.location.lat,
                  places[i].geometry.location.long),
              infoWindow: InfoWindow(
                  title: places[i].name,
                  snippet:  "Gasolina: $preGasolina, Alcool: $preAlcool"),
              onTap: () {
                _showOptions(context);
              },
            ),
          );
        }
      });
    } else {
      print(data);
    }
  }

  Future _setLocation() async {
    var location = new Location();
    var currentLocation = await location.getLocation();
//    latitude = currentLocation.latitude;
//    longitude = currentLocation.longitude;
    latitude = -22.562594;
    longitude = -47.4235437;
  }

  void _showOptions(BuildContext context) {
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
                          showEditPreco(context);
                          Navigator.pop(context);
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

  void showEditPreco(BuildContext context) {
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
                              preAlcool = double.parse(_alcoolController.text);
                              preGasolina =
                                  double.parse(_gasolinaController.text);
                              setState(() {
                                markers.clear();
                              });
                              _handleResponse(data);
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
}
