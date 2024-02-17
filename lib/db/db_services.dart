import 'package:diva/model/contacts_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // Import path package for joining paths

class DatabaseHelper {
  // Table and column names
  static String contactTable = 'contact_table';
  static String colId = 'id';
  static String colContactName = 'name';
  static String colContactNumber = 'number';

  // Private constructor to create an instance of DatabaseHelper Class
  DatabaseHelper._createInstance();

  // Singleton instance of DatabaseHelper
  static DatabaseHelper? _databaseHelper;

  // Singleton factory constructor
  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  // Database instance
  static Database? _database;

  // Get method for accessing the database
  Future<Database?> get database async {
    _database ??= await initializeDatabase();
    return _database;
  }

  // Method to initialize database
  Future<Database> initializeDatabase() async {
    // Get the directory path for storing databases
    String databasesPath = await getDatabasesPath();
    // Join the path with the database file name
    String dbPath = join(databasesPath, 'contact.db');

    // Open the database or create if it doesn't exist
    var contactDatabase =
        await openDatabase(dbPath, version: 1, onCreate: _createDbTable);
    return contactDatabase;
  }

  // Method to create the database table
  void _createDbTable(Database db, int newVersion) async {
    // Execute SQL to create the table with columns
    await db.execute('''
      CREATE TABLE $contactTable(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $colContactName TEXT, 
        $colContactNumber TEXT)
    ''');
  }

  // Method to get list of contact maps from database
  Future<List<Map<String, dynamic>>?> getContactMapList() async {
    Database? db = await database;
    // Raw query to select all columns from contact table
    List<Map<String, dynamic>>? result =
        await db?.rawQuery('SELECT * FROM $contactTable ORDER BY $colId ASC');
    return result;
  }

  // Method to insert a contact into database
  Future<int?> insertContact(TContact contact) async {
    Database? db = await database;
    // Insert the contact into database
    var result = await db?.insert(contactTable, contact.toMap());
    return result;
  }

  // Method to update a contact in database
  Future<int?> updateContact(TContact contact) async {
    Database? db = await database;
    // Update the contact in database
    var result = await db?.update(contactTable, contact.toMap(),
        where: '$colId = ?', whereArgs: [contact.id]);
    return result;
  }

  // Method to delete a contact from database
  Future<int?> deleteContact(int id) async {
    Database? db = await database;
    // Delete the contact from database
    int? result =
        await db?.rawDelete('DELETE FROM $contactTable WHERE $colId = ?', [id]);
    return result;
  }

  // Method to get total number of contacts in database
  Future<int> getCount() async {
    Database? db = await database;
    // Raw query to get count of all rows in contact table
    List<Map<String, dynamic>>? x =
        await db?.rawQuery('SELECT COUNT (*) FROM $contactTable');
    int result = Sqflite.firstIntValue(x!)!;
    return result;
  }

  // Method to get list of contacts from database
  Future<List<TContact>> getContactList() async {
    var contactMapList = await getContactMapList();
    int count = contactMapList!.length;

    List<TContact> contactList = [];
    for (int i = 0; i < count; i++) {
      contactList.add(TContact.fromMapObject(contactMapList[i]));
    }
    return contactList;
  }
}
