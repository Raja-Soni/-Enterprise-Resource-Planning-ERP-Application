import 'package:erp_mini_app/model/sales_order.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final String TABLE_NAME = "sales_orders";
  static final String COLUMN_NAME_ID = "id";
  static final String COLUMN_NAME_CUSTOMER = "customer";
  static final String COLUMN_NAME_AMOUNT = "amount";
  static final String COLUMN_NAME_STATUS = "status";
  static final String COLUMN_NAME_DATE = "date";
  Database? _db;
  static final DBHelper dbhInstance = DBHelper._();
  DBHelper._();
  final List<Map<String, dynamic>> data = [
    {
      "customer": "Reliance Retail",
      "amount": 12000,
      "status": "Pending",
      "date": "2025-07-31",
    },
    {
      "customer": "Tata Steel",
      "amount": 8000,
      "status": "Delivered",
      "date": "2025-07-29",
    },
  ];

  final List<String> groceryList = [
    "Select Item",
    "Rice",
    "Milk",
    "Bread",
    "Eggs",
    "Tomatoes",
    "Sugar",
  ];

  Future<Database> getDatabase() async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, 'sales_orders.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $TABLE_NAME(
        $COLUMN_NAME_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_NAME_CUSTOMER TEXT,
        $COLUMN_NAME_AMOUNT REAL,
        $COLUMN_NAME_STATUS TEXT,
        $COLUMN_NAME_DATE TEXT
      )
    ''');
    for (var order in data) {
      await db.insert('sales_orders', order);
    }
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await getDatabase();
    return await db.query(TABLE_NAME, orderBy: '$COLUMN_NAME_DATE DESC');
  }

  Future<void> addOrder(SalesOrder order) async {
    Map<String, dynamic> newOrder = {
      "customer": order.customer,
      "amount": order.amount,
      "status": order.status,
      "date": order.date,
    };
    final db = await getDatabase();
    await db.insert(TABLE_NAME, newOrder);
  }

  deleleAll() async {
    final db = await getDatabase();
    await db.delete(TABLE_NAME);
  }
}
