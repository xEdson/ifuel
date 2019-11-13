class Endereco {
  String rua;
  String bairro;
  int numero;
  String cidade;
  String cep;

  Endereco({this.rua, this.bairro, this.numero, this.cidade, this.cep});

  Endereco.fromJson(Map<String, dynamic> json) {
    rua = json['rua'];
    bairro = json['bairro'];
    numero = json['numero'];
    cidade = json['cidade'];
    cep = json['cep'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rua'] = this.rua;
    data['bairro'] = this.bairro;
    data['numero'] = this.numero;
    data['cidade'] = this.cidade;
    data['cep'] = this.cep;
    return data;
  }
}