class Veiculo {
  String nome;
  String marca;
  int categoria;
  String modelo;
  int ano;
  String combustivel;

  Veiculo(
      {this.nome,
        this.marca,
        this.categoria,
        this.modelo,
        this.ano,
        this.combustivel});

  Veiculo.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    marca = json['marca'];
    categoria = json['categoria'];
    modelo = json['modelo'];
    ano = json['ano'];
    combustivel = json['combustivel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['marca'] = this.marca;
    data['categoria'] = this.categoria;
    data['modelo'] = this.modelo;
    data['ano'] = this.ano;
    data['combustivel'] = this.combustivel;
    return data;
  }
}