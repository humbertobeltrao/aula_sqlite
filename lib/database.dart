import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlite/pessoa.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'pessoas.db'),
      onCreate: (database, version) async {
        await database.execute(
            "CREATE TABLE Pessoas(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT NOT NULL, idade TEXT NOT NULL, endereco TEXT NOT NULL)");
      },
      version: 1,
    );
  }

  //INSERT
  Future<void> insert(Pessoa p) async {
    final db = await initializeDB();
    await db.insert(
      'pessoas',
      p.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  //SELECT
  Future<List<Pessoa>> listarPessoas() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('Pessoas');
    return List.generate(queryResult.length, (i) {
      return Pessoa(
        id: queryResult[i]['id'],
        nome: queryResult[i]['nome'],
        idade: queryResult[i]['idade'],
        endereco: queryResult[i]['endereco'],
      );
    });
  }

  //UPDATE
  Future<void> update(Pessoa p) async {
    final Database db = await initializeDB();
    db.update(
      'Pessoas',
      p.toMap(),
      where: 'id = ?',
      whereArgs: [p.id],
    );
  }

  //DELETE
  Future<void> delete(int id) async {
    final Database db = await initializeDB();
    db.delete(
      'Pessoas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
