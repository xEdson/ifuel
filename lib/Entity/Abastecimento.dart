import 'package:http/http.dart';

final String abastecTable = "abastecimentoTable";
final String idColumn = "idColumn";
final String litrosColumn = "litrosColumn";
final String valorCombustivelColumn = "valorCombustivelColumn";
final String totalColumn = "totalColumn";
final String usuarioColumn = "usuarioColumn";
final String veiculoColumn = "veiculoColumn";
final String postoColumn = "postoColumn";
final String tipoCombustivelColum = "tipoCombustivelColum";

class Abastecimento {
  String posto;
  String usuario;
  String veiculo;
  String litrCombustivel;
  String total;
  String valorComustivel;
  String tipoCombustivel;
  int id;

  Abastecimento(
      {this.posto,
        this.usuario,
        this.veiculo,
        this.litrCombustivel,
        this.total,
        this.valorComustivel,
      this.tipoCombustivel});

  Abastecimento.fromJson(Map<String, dynamic> json) {
    posto = json['posto'];
    usuario = json['usuario'];
    veiculo = json['veiculo'];
    litrCombustivel = json['litr_combustivel'];
    total = json['total'];
    valorComustivel = json['valor_combustivel'];
    tipoCombustivel = json['tipo_combustivel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['posto'] = this.posto;
    data['usuario'] = this.usuario;
    data['veiculo'] = this.veiculo;
    data['litr_combustivel'] = this.litrCombustivel;
    data['total'] = this.total;
    data['valor_combustivel'] = this.valorComustivel;
    data['tipo_combustivel'] = this.tipoCombustivel;
    return data;
  }

  Abastecimento.fromMap(Map map) {
    id = map[idColumn];
    litrCombustivel = map[litrosColumn];
    valorComustivel = map[valorCombustivelColumn];
    total = map[totalColumn];
    posto = map[postoColumn];
    usuario = map[usuarioColumn];
    veiculo = map[veiculoColumn];
    tipoCombustivel = map[tipoCombustivelColum];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      litrosColumn: litrCombustivel,
      valorCombustivelColumn: valorComustivel,
      totalColumn: total,
      postoColumn: posto,
      usuarioColumn: usuario,
      veiculoColumn: veiculo
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

}