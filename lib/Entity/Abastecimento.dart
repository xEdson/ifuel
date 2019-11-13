class Abastecimento {
  String posto;
  String usuario;
  int nota;
  int veiculo;
  int preco;
  int quilometro;
  int litrCombustivel;
  int total;

  Abastecimento(
      {this.posto,
        this.usuario,
        this.nota,
        this.veiculo,
        this.preco,
        this.quilometro,
        this.litrCombustivel,
        this.total});

  Abastecimento.fromJson(Map<String, dynamic> json) {
    posto = json['posto'];
    usuario = json['usuario'];
    nota = json['nota'];
    veiculo = json['veiculo'];
    preco = json['preco'];
    quilometro = json['quilometro'];
    litrCombustivel = json['litr_combustivel'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['posto'] = this.posto;
    data['usuario'] = this.usuario;
    data['nota'] = this.nota;
    data['veiculo'] = this.veiculo;
    data['preco'] = this.preco;
    data['quilometro'] = this.quilometro;
    data['litr_combustivel'] = this.litrCombustivel;
    data['total'] = this.total;
    return data;
  }
}