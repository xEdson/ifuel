
import 'package:ifuel/Entity/Abastecimento.dart';
import 'package:ifuel/Entity/Usuario.dart';
import 'package:test/test.dart';
import '../Control/ControlaAbastecimento.dart';
import '../Control/generateMd5.dart';

void main() {
  Usuario usuario = new Usuario();
  Abastecimento abastecimento = new Abastecimento();
  ControlaAbastecimento controlaAbastecimento= new ControlaAbastecimento();

  test('Cadastrar Abastecimento', () {
    expect(controlaAbastecimento.cadastrar(), equals(true));
  });
  test('Editar abastecimento', () {
    expect(controlaAbastecimento.editar(), equals(true));
  });
  test('Ver historico abastecimento', () {
    expect(controlaAbastecimento.remover(), equals(true));
  });
  test('Remover abastecimento', () {
    expect(controlaAbastecimento.remover(), equals(true));
  });
}