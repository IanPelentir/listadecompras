import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '/models/item.dart';

class DatabaseService {
  static Database? _database;

  // Acessa ou cria o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa o banco de dados
  _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'lista_compras.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            quantidade INTEGER,
            comprado INTEGER
          )
        ''');
      },
    );
  }

  // Adiciona um item no banco de dados
  Future<void> addItem(Item item) async {
    final db = await database;
    await db.insert('items', item.toMap());
  }

  // Atualiza o status de um item
  Future<void> updateItem(Item item) async {
    final db = await database;
    await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  // Obtém todos os itens do banco de dados
  Future<List<Item>> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }
}
