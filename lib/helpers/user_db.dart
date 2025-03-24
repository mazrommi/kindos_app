// Tambahkan di initDB
await db.execute('''
  CREATE TABLE user (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL,
    password TEXT NOT NULL)
    ''');

//fungsi insert userr (misalnya user admin awal)
Future<void> insertUser(User user) async {
  final db = await database;
  await db.insert('user', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
}

// Fungsi login
Future<User?> loginUser(String email, String password) async {
  final db = await database;
  final result = await db.query(
  'user',
  where: 'email = ? AND password = ?',
  whereArgs: [email, password]
  );

  if (result.isNotEmpty) {
    return User.fromMap(result.first);
  }
  return null;
  }
