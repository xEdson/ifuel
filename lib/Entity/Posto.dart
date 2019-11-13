import 'package:ifuel/Entity/Endereco.dart';

class Posto{

  String id;
  String _nome;
  String _bandeira;
  double _latitude;
  double _longitude;
  double _nota;
  double _precoGasolina;
  Endereco endereco;

  double get precoGasolina => _precoGasolina;

  set precoGasolina(double value) {
    _precoGasolina = value;
  }

  double _precoAlcool;

  Posto(this.id, this._nome, this._bandeira, this._latitude, this._longitude,
      this._nota, this._precoAlcool, this._precoGasolina);

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get bandeira => _bandeira;

  double get nota => _nota;

  set nota(double value) {
    _nota = value;
  }

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  set bandeira(String value) {
    _bandeira = value;
  }

  double get precoAlcool => _precoAlcool;

  set precoAlcool(double value) {
    _precoAlcool = value;
  }

  Posto.fromMap(Map map) {
    id = map['id'];
    nome = map['nome'];
    bandeira = map['bandeira'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    nota = map['nota'];
    precoAlcool = map['precoAlcool'];
    precoGasolina = map['precoGasolina'];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      'nome': nome,
      'latitude': latitude,
      'longitude': longitude,
      'nota': nota,
      'precoAlcool': precoAlcool,
      'precoGasolina': precoGasolina,

    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Posto(id: $id, nome: $nome, nota: $nota, preco gasolina: $precoGasolina, preco alcool: $precoAlcool)";
  }

}