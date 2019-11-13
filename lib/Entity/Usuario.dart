class Usuario {
  String nome;
  String login;
  int senha;
  int nivel;

  Usuario({this.nome, this.login, this.senha, this.nivel});

  Usuario.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    login = json['login'];
    senha = json['senha'];
    nivel = json['nivel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['login'] = this.login;
    data['senha'] = this.senha;
    data['nivel'] = this.nivel;
    return data;
  }
}