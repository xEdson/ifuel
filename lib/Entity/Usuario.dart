class Usuario {
  String login;
  String nome;
  int senha;
  int nivel;

  Usuario({this.nome, this.login, this.senha, this.nivel});

  Usuario.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    nome = json['nome'];
    senha = json['senha'];
    nivel = json['nivel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['nome'] = this.nome;
    data['senha'] = this.senha;
    data['nivel'] = this.nivel;
    return data;
  }
}