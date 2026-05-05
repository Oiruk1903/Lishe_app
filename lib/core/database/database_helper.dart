import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  bool _isInitializing = false;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Prevent multiple simultaneous initializations
    while (_isInitializing) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (_database != null) return _database!;
    }

    _isInitializing = true;
    try {
      _database = await _initDatabase();
      return _database!;
    } finally {
      _isInitializing = false;
    }
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DatabaseConstants.databaseName);

    return await openDatabase(
      path,
      version: DatabaseConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create tables first (fast)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseConstants.tableUsers} (
        ${DatabaseConstants.columnId} TEXT PRIMARY KEY,
        ${DatabaseConstants.columnFullName} TEXT NOT NULL,
        ${DatabaseConstants.columnEmail} TEXT UNIQUE NOT NULL,
        ${DatabaseConstants.columnPhoneNumber} TEXT,
        ${DatabaseConstants.columnDateOfBirth} TEXT NOT NULL,
        ${DatabaseConstants.columnGender} TEXT NOT NULL,
        ${DatabaseConstants.columnCohort} TEXT,
        ${DatabaseConstants.columnProfileImage} TEXT,
        ${DatabaseConstants.columnHeight} REAL,
        ${DatabaseConstants.columnTargetWeight} REAL,
        ${DatabaseConstants.columnPreferredLanguage} TEXT DEFAULT 'sw',
        ${DatabaseConstants.columnCreatedAt} TEXT NOT NULL,
        ${DatabaseConstants.columnUpdatedAt} TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseConstants.tableFoodItems} (
        ${DatabaseConstants.columnId} TEXT PRIMARY KEY,
        ${DatabaseConstants.columnNameSw} TEXT NOT NULL,
        ${DatabaseConstants.columnNameEn} TEXT,
        ${DatabaseConstants.columnCategory} TEXT,
        ${DatabaseConstants.columnCaloriesPer100g} REAL,
        ${DatabaseConstants.columnProteinPer100g} REAL,
        ${DatabaseConstants.columnCarbsPer100g} REAL,
        ${DatabaseConstants.columnFatPer100g} REAL,
        ${DatabaseConstants.columnFiberPer100g} REAL DEFAULT 0,
        ${DatabaseConstants.columnStandardServingSize} REAL,
        ${DatabaseConstants.columnServingUnit} TEXT,
        ${DatabaseConstants.columnZone} TEXT,
        ${DatabaseConstants.columnIsLocal} INTEGER DEFAULT 1,
        ${DatabaseConstants.columnImageUrl} TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseConstants.tableMealLogs} (
        ${DatabaseConstants.columnId} TEXT PRIMARY KEY,
        ${DatabaseConstants.columnUserId} TEXT NOT NULL,
        ${DatabaseConstants.columnFoodItemId} TEXT NOT NULL,
        ${DatabaseConstants.columnMealPeriod} TEXT NOT NULL,
        ${DatabaseConstants.columnQuantity} REAL NOT NULL,
        ${DatabaseConstants.columnUnit} TEXT NOT NULL,
        ${DatabaseConstants.columnLoggedAt} TEXT NOT NULL,
        ${DatabaseConstants.columnSynced} INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseConstants.tableWeightEntries} (
        ${DatabaseConstants.columnId} TEXT PRIMARY KEY,
        ${DatabaseConstants.columnUserId} TEXT NOT NULL,
        ${DatabaseConstants.columnWeight} REAL NOT NULL,
        ${DatabaseConstants.columnRecordedAt} TEXT NOT NULL,
        ${DatabaseConstants.columnNote} TEXT,
        ${DatabaseConstants.columnSynced} INTEGER DEFAULT 0
      )
    ''');

    // Insert food data in a non-blocking way
    await _insertFoodDataAsync(db);
  }

  Future<void> _insertFoodDataAsync(Database db) async {
    // Check if data already exists
    final count = Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM ${DatabaseConstants.tableFoodItems}'));

    if (count != null && count > 0) return; // Already populated

    final batch = db.batch();

    // Only insert a few essential items for faster loading
    final essentialFoods = [
      {
        'id': 'ugali',
        'name_sw': 'Ugali',
        'name_en': 'Stiff Porridge',
        'category': 'carbohydrates',
        'calories_per_100g': 150.0,
        'protein_per_100g': 2.5,
        'carbs_per_100g': 33.0,
        'fat_per_100g': 0.3,
        'fiber_per_100g': 1.5,
        'standard_serving_size': 250.0,
        'serving_unit': 'vijiko vya kulia',
        'zone': 'all',
        'is_local': 1
      },
      {
        'id': 'wali',
        'name_sw': 'Wali',
        'name_en': 'Rice',
        'category': 'carbohydrates',
        'calories_per_100g': 130.0,
        'protein_per_100g': 2.4,
        'carbs_per_100g': 28.0,
        'fat_per_100g': 0.3,
        'fiber_per_100g': 0.4,
        'standard_serving_size': 200.0,
        'serving_unit': 'vijiko vya kulia',
        'zone': 'all',
        'is_local': 1
      },
      {
        'id': 'maharage',
        'name_sw': 'Maharage',
        'name_en': 'Beans',
        'category': 'protein',
        'calories_per_100g': 347.0,
        'protein_per_100g': 21.0,
        'carbs_per_100g': 63.0,
        'fat_per_100g': 1.2,
        'fiber_per_100g': 15.0,
        'standard_serving_size': 150.0,
        'serving_unit': 'vijiko vya kulia',
        'zone': 'all',
        'is_local': 1
      },
      {
        'id': 'samaki',
        'name_sw': 'Samaki',
        'name_en': 'Fish',
        'category': 'protein',
        'calories_per_100g': 206.0,
        'protein_per_100g': 22.0,
        'carbs_per_100g': 0.0,
        'fat_per_100g': 12.0,
        'fiber_per_100g': 0.0,
        'standard_serving_size': 150.0,
        'serving_unit': 'kipande',
        'zone': 'lake_coastal',
        'is_local': 1
      },
      {
        'id': 'mchicha',
        'name_sw': 'Mchicha',
        'name_en': 'Spinach',
        'category': 'vegetables',
        'calories_per_100g': 23.0,
        'protein_per_100g': 2.9,
        'carbs_per_100g': 3.6,
        'fat_per_100g': 0.4,
        'fiber_per_100g': 2.2,
        'standard_serving_size': 100.0,
        'serving_unit': 'vijiko vya kulia',
        'zone': 'all',
        'is_local': 1
      },
      {
        'id': 'chungwa',
        'name_sw': 'Chungwa',
        'name_en': 'Orange',
        'category': 'fruits',
        'calories_per_100g': 47.0,
        'protein_per_100g': 0.9,
        'carbs_per_100g': 11.8,
        'fat_per_100g': 0.1,
        'fiber_per_100g': 2.4,
        'standard_serving_size': 130.0,
        'serving_unit': 'chungwa',
        'zone': 'all',
        'is_local': 1
      },
      {
        'id': 'maziwa',
        'name_sw': 'Maziwa',
        'name_en': 'Milk',
        'category': 'dairy',
        'calories_per_100g': 61.0,
        'protein_per_100g': 3.2,
        'carbs_per_100g': 4.8,
        'fat_per_100g': 3.3,
        'fiber_per_100g': 0.0,
        'standard_serving_size': 250.0,
        'serving_unit': 'ml',
        'zone': 'all',
        'is_local': 1
      },
      {
        'id': 'nyama_kuku',
        'name_sw': 'Nyama ya Kuku',
        'name_en': 'Chicken',
        'category': 'protein',
        'calories_per_100g': 239.0,
        'protein_per_100g': 27.0,
        'carbs_per_100g': 0.0,
        'fat_per_100g': 14.0,
        'fiber_per_100g': 0.0,
        'standard_serving_size': 120.0,
        'serving_unit': 'vipande',
        'zone': 'all',
        'is_local': 1
      },
      {
        'id': 'mayai',
        'name_sw': 'Mayai',
        'name_en': 'Eggs',
        'category': 'protein',
        'calories_per_100g': 155.0,
        'protein_per_100g': 13.0,
        'carbs_per_100g': 1.1,
        'fat_per_100g': 11.0,
        'fiber_per_100g': 0.0,
        'standard_serving_size': 100.0,
        'serving_unit': 'mayai',
        'zone': 'all',
        'is_local': 1
      },
      {
        'id': 'ndizi',
        'name_sw': 'Ndizi',
        'name_en': 'Banana',
        'category': 'carbohydrates',
        'calories_per_100g': 89.0,
        'protein_per_100g': 1.1,
        'carbs_per_100g': 22.8,
        'fat_per_100g': 0.3,
        'fiber_per_100g': 2.6,
        'standard_serving_size': 150.0,
        'serving_unit': 'ndizi',
        'zone': 'all',
        'is_local': 1
      },
      {
        'id': 'nyanya',
        'name_sw': 'Nyanya',
        'name_en': 'Tomatoes',
        'category': 'vegetables',
        'calories_per_100g': 18.0,
        'protein_per_100g': 0.9,
        'carbs_per_100g': 3.9,
        'fat_per_100g': 0.2,
        'fiber_per_100g': 1.2,
        'standard_serving_size': 100.0,
        'serving_unit': 'nyanya',
        'zone': 'all',
        'is_local': 1
      },
    ];

    for (var food in essentialFoods) {
      batch.insert(
        DatabaseConstants.tableFoodItems,
        food,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle migrations
  }
}
