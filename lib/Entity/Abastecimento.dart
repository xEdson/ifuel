import 'package:http/http.dart';

final String abastecTable = "abastecimentoTable";
final String idColumn = "idColumn";
final String litrosColumn = "litrosColumn";
final String valorCombustivelColumn = "valorCombustivelColumn";
final String totalColumn = "totalColumn";
final String notaColumn = "notaColumn";
final String usuarioColumn = "usuarioColumn";
final String veiculoColumn = "veiculoColumn";
final String postoColumn = "postoColumn";

class Abastecimento {
  String posto;
  String usuario;
  String nota;
  String veiculo;
  String litrCombustivel;
  String total;
  String valorComustivel;
  int id;

  Abastecimento(
      {this.posto,
        this.usuario,
        this.nota,
        this.veiculo,
        this.litrCombustivel,
        this.total,
        this.valorComustivel});

  Abastecimento.fromJson(Map<String, dynamic> json) {
    posto = json['posto'];
    usuario = json['usuario'];
    nota = json['nota'];
    veiculo = json['veiculo'];
    litrCombustivel = json['litr_combustivel'];
    total = json['total'];
    valorComustivel = json['valor_combustivel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['posto'] = this.posto;
    data['usuario'] = this.usuario;
    data['nota'] = this.nota;
    data['veiculo'] = this.veiculo;
    data['litr_combustivel'] = this.litrCombustivel;
    data['total'] = this.total;
    data['valor_combustivel'] = this.valorComustivel;
    return data;
  }

  Abastecimento.fromMap(Map map) {
    id = map[idColumn];
    litrCombustivel = map[litrosColumn];
    valorComustivel = map[valorCombustivelColumn];
    total = map[totalColumn];
    posto = map[postoColumn];
    usuario = map[usuarioColumn];
    nota = map[notaColumn];
    veiculo = map[veiculoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      litrosColumn: litrCombustivel,
      valorCombustivelColumn: valorComustivel,
      totalColumn: total,
      postoColumn: posto,
      usuarioColumn: usuario,
      notaColumn: nota,
      veiculoColumn: veiculo
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

}