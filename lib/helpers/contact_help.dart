import 'package:ifuel/Entity/Abastecimento.dart';
import 'package:ifuel/models/posto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String contactTable = "contactTable";
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
          "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)");
      await db.execute(
          "CREATE TABLE $abastecTable($idColumn INTEGER PRIMARY KEY, $litrosColumn TEXT, $valorCombustivelColumn TEXT, $totalColumn TEXT)");
      await db.execute(
          "CREATE TABLE $postTable(id TEXT PRIMARY KEY, nome TEXT , bandeira TEXT, latitude DOUBLE, longitude DOUBLE , nota DOUBLE ,precoGasolina DOUBLE ,precoAlcool DOUBLE)");
      await db.execute(
          "CREATE TABLE $veiculoTable($idColumn INTEGER PRIMARY KEY, $anoColumn TEXT, $combustivelColumn TEXT, $marcaColumn TEXT, $modeloColumn TEXT, $tipoColumn TEXT, $nomeColumn TEXT)");
    });
  }

  saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
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

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(contactTable,
        columns: [idColumn, nameColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact
        .delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> deleteVeiculo(int id) async {
    Database dbContact = await db;
    return await dbContact
        .delete(veiculoTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;
    return await dbContact.update(contactTable, contact.toMap(),
        where: "$idColumn = ?", whereArgs: [contact.id]);
  }
  Future<int> updateAbastecimento(Abastecimento abastecimento) async {
    Database dbContact = await db;
    return await dbContact.update(abastecTable, abastecimento.toMap(),
        where: "$idColumn = ?", whereArgs: [abastecimento.id]);
  }
  Future<int> updateVeiculo(Veiculo veiculo) async {
    Database dbContact = await db;
    return await dbContact.update(veiculoTable, veiculo.toMap(),
        where: "$idColumn = ?", whereArgs: [veiculo.id]);
  }

  Future<List> getAllContacts() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = List();
    for (Map m in listMap) {
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
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
        await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }
}

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}

class Abastecimento {
  int id;
  String litros;
  String valorComustivel;
  String valorTotal;

  Abastecimento();

  Abastecimento.fromMap(Map map) {
    id = map[idColumn];
    litros = map[litrosColumn];
    valorComustivel = map[valorCombustivelColumn];
    valorTotal = map[totalColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      litrosColumn: litros,
      valorCombustivelColumn: valorComustivel,
      totalColumn: valorTotal,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Abastecimento(id: $id, Litros: $litros, Valor Combustivel: $valorComustivel, Valor Total: $valorTotal)";
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