import 'package:ifuel/Entity/Abastecimento.dart';
import 'package:ifuel/Entity/Usuario.dart';
import 'package:ifuel/models/posto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String usuarioTable = "usuarioTable";
final String abastecTable = "abastecimentoTable";
final String postTable = "postoTable";
final String veiculoTable = "veiculoTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";
final String litrosColumn = "litrosColumn";
final String valorCombustivelColumn = "valorCombustivelColumn";
final String totalColumn = "totalColumn";



final String anoColumn = "ano";
final String combustivelColumn = "combustivel";
final String marcaColumn = "marca";
final String modeloColumn = "modelo";
final String tipoColumn = "carro";
final String nomeColumn = "nome";


class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contacts.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $usuarioTable(login TEXT PRIMARY KEY, nome TEXT, senha INTEGER, nivel INTEGER)");
      await db.execute(
          "CREATE TABLE $abastecTable(idColumn INTEGER PRIMARY KEY, litrosColumn TEXT, valorCombustivelColumn TEXT, totalColumn TEXT, usuarioColumn TEXT, veiculoColumn TEXT, postoColumn TEXT, tipoCombustivelColum TEXT)");
      await db.execute(
          "CREATE TABLE $postTable(id TEXT PRIMARY KEY, nome TEXT , bandeira TEXT, latitude DOUBLE, longitude DOUBLE , nota DOUBLE ,precoGasolina DOUBLE ,precoAlcool DOUBLE, tipoCombustivel TEXT)");
      await db.execute(
          "CREATE TABLE $veiculoTable($idColumn INTEGER PRIMARY KEY, $anoColumn TEXT, $combustivelColumn TEXT, $marcaColumn TEXT, $modeloColumn TEXT, $tipoColumn TEXT, $nomeColumn TEXT)");
    });
  }

  saveUsuario(Usuario usuario) async {
    Database dbContact = await db;
    await dbContact.insert(usuarioTable, usuario.toJson());
    return usuario;
  }
  saveAbastecimento(Abastecimento abastecimento) async {
    Database dbContact = await db;
    abastecimento.id = await dbContact.insert(abastecTable, abastecimento.toMap());
    return abastecimento;
  }
  savePosto(Posto posto) async {
    Database dbContact = await db;
    await dbContact.insert(postTable, posto.toMap());
    return posto;
  }
  saveVeiculo(Veiculo veiculo) async {
    Database dbContact = await db;
    await dbContact.insert(veiculoTable, veiculo.toMap());
    return veiculo;
  }

  Future<Usuario> getUsuario(String login) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(usuarioTable,
        columns: ['login', 'nome', 'senha', 'nivel'],
        where: "login = ?",
        whereArgs: [login]);
    if (maps.length > 0) {
      return Usuario.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteUsuario(String login) async {
    Database dbContact = await db;
    return await dbContact
        .delete(usuarioTable, where: "login = ?", whereArgs: [login]);
  }

  Future<int> deleteAbastecimento(int id) async {
    Database dbContact = await db;
    return await dbContact
        .delete(abastecTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> deleteVeiculo(int id) async {
    Database dbContact = await db;
    return await dbContact
        .delete(veiculoTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateUsuario(Usuario usuario) async {
    Database dbContact = await db;
    return await dbContact.update(usuarioTable, usuario.toJson(),
        where: "login = ?", whereArgs: [usuario.login]);
  }
  Future<int> updateAbastecimento(Abastecimento abastecimento) async {
    Database dbContact = await db;
    return await dbContact.update(abastecTable, abastecimento.toMap(),
        where: "$idColumn = ?", whereArgs: [abastecimento.id]);
  }
  Future<int> updatePosto(Posto posto) async {
    Database dbContact = await db;
    return await dbContact.update(postTable, posto.toMap(),
        where: "id = ?", whereArgs: [posto.id]);
  }

  Future<int> updateVeiculo(Veiculo veiculo) async {
    Database dbContact = await db;
    return await dbContact.update(veiculoTable, veiculo.toMap(),
        where: "$idColumn = ?", whereArgs: [veiculo.id]);
  }

  Future<List> getAllUsuarios() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $usuarioTable");
    List<Usuario> listUsuarios = List();
    for (Map m in listMap) {
      listUsuarios.add(Usuario.fromJson(m));
    }
    return listUsuarios;
  }

  Future<List> getAllAbascetimento() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $abastecTable");
    List<Abastecimento> listAbastecimento = List();
    for (Map m in listMap) {
      listAbastecimento.add(Abastecimento.fromMap(m));
    }
    return listAbastecimento;
  }

  Future<List> getAllPostos() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $postTable");
    List<Posto> listPosto = List();
    for (Map m in listMap) {
      listPosto.add(Posto.fromMap(m));
    }
    return listPosto;
  }

  Future<List> getAllVeiculos() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $veiculoTable");
    List<Veiculo> listVeiculo = List();
    for (Map m in listMap) {
      listVeiculo.add(Veiculo.fromMap(m));
    }
    return listVeiculo;
  }


  getNumber() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(
        await dbContact.rawQuery("SELECT COUNT(*) FROM $usuarioTable"));
  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }
}

class Veiculo {
  int id;
  String nome;
  String marca;
  String modelo;
  String ano;
  String categoria;
  String combustivel;

  Veiculo();

  Veiculo.fromMap(Map map) {
    id = map[idColumn];
    marca = map[marcaColumn];
    ano = map[anoColumn];
    categoria = map[tipoColumn];
    combustivel = map[combustivelColumn];
    modelo = map[modeloColumn];
    nome = map[nomeColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idColumn: id,
      marcaColumn: marca,
      anoColumn: ano,
      tipoColumn: categoria,
      combustivelColumn: combustivel,
      modeloColumn: modelo,
      nomeColumn: nome
    };
    return map;
  }

}