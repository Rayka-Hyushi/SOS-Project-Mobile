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
      version: 3,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          // Simplest way for development: drop and recreate. 
          // For production, you'd use ALTER TABLE or migrate data.
          await db.execute('DROP TABLE IF EXISTS order_services');
          await db.execute('DROP TABLE IF EXISTS orders');
          await db.execute('DROP TABLE IF EXISTS services');
          await db.execute('DROP TABLE IF EXISTS clients');
          await db.execute('DROP TABLE IF EXISTS users');
          await _createTables(db);
        }
      }
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE users(
        uid INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT,
        name TEXT,
        email TEXT,
        password TEXT,
        photo TEXT,
        photoType TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE clients(
        cid INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT,
        address TEXT,
        email TEXT,
        phone TEXT,
        name TEXT,
        u_id INTEGER,
        FOREIGN KEY (u_id) REFERENCES users (uid) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE services(
        sid INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT,
        service TEXT,
        description TEXT,
        value REAL,
        u_id INTEGER,
        FOREIGN KEY (u_id) REFERENCES users (uid) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE orders(
        osid INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT,
        device TEXT,
        description TEXT,
        status TEXT,
        opendate TEXT,
        closedate TEXT,
        extras REAL,
        discount REAL,
        total REAL,
        cliente_uuid TEXT,
        u_id INTEGER,
        FOREIGN KEY (u_id) REFERENCES users (uid) ON DELETE CASCADE
      )
    ''');
    // Join table for Many-to-Many relationship between Orders and Services
    await db.execute('''
      CREATE TABLE order_services(
        os_id INTEGER,
        service_id INTEGER,
        PRIMARY KEY (os_id, service_id),
        FOREIGN KEY (os_id) REFERENCES orders (osid) ON DELETE CASCADE,
        FOREIGN KEY (service_id) REFERENCES services (sid) ON DELETE CASCADE
      )
    ''');
  }
}
