import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _InitDatabase();
    return _database!;
  }

  Future<Database> _InitDatabase() async {
    final path = join(await getDatabasesPath(), 'database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db,version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT,
            password TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE clients(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            address TEXT,
            email TEXT,
            phone TEXT,
            name TEXT,
            u_id INTEGER,
            FOREIGN KEY (u_id) REFERENCES users (id) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          CREATE TABLE services(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            servico TEXT,
            desc TEXT,
            valor REAL,
            u_id INTEGER,
            FOREIGN KEY (u_id) REFERENCES users (id) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          CREATE TABLE orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            equipment TEXT,
            brand TEXT,
            model TEXT,
            sn TEXT,
            problem TEXT,
            status TEXT,
            open_date TEXT,
            close_date TEXT,
            value REAL,
            u_id INTEGER,
            client_id INTEGER,
            FOREIGN KEY (u_id) REFERENCES users (id) ON DELETE CASCADE,
            FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE CASCADE
          )
        ''');
      }
    );
  }
}
