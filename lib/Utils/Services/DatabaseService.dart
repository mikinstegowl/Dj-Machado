import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SongDatabaseService {
  // Singleton instance
  static final SongDatabaseService _instance = SongDatabaseService._internal();
  factory SongDatabaseService() => _instance;

  SongDatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'music.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create Albums table
        await db.execute('''
          CREATE TABLE albums ( 
            album_id INTEGER PRIMARY KEY,
            album_name TEXT NOT NULL,
            imageUrl TEXT,
            song_id TEXT
          )
        ''');

        // Create Songs table
        await db.execute('''
          CREATE TABLE songs (
            song_id INTEGER PRIMARY KEY,
            song_name TEXT NOT NULL,
            artist_name TEXT,
            file_path TEXT,
            imageUrl TEXT,
            isDownloaded INTEGER,
            favourite INTEGER
          )
        ''');

        // Create Playlists table
        await db.execute('''
          CREATE TABLE playlists ( 
            playlist_id INTEGER PRIMARY KEY,
            playlist_name TEXT NOT NULL,
            imageUrl TEXT,
            song_id TEXT
          )
        ''');
      },
    );
  }

  // Insert a new album
  Future<int> insertAlbum(Map<String, dynamic> album) async {
    final db = await database;
    return await db.insert('albums', album);
  }

  // Insert a new song
  Future<int> insertSong(Map<String, dynamic> song) async {
    final db = await database;
    return await db.insert('songs', song);
  }

  // Insert a new playlist
  Future<int> insertPlaylist(Map<String, dynamic> playlist) async {
    final db = await database;
    return await db.insert('playlists', playlist);
  }

  // Get all albums
  Future<List<Map<String, dynamic>>> getAlbums() async {
    final db = await database;
    return await db.query('albums');
  }

  // Get all songs
  Future<List<Map<String, dynamic>>> getSongs() async {
    final db = await database;
    return await db.query('songs');
  }

  // Get all playlists
  Future<List<Map<String, dynamic>>> getPlaylists() async {
    final db = await database;
    return await db.query('playlists');
  }

  // Get songs for a specific album by album ID
  Future<List<Map<String, dynamic>>> getSongsByAlbum(int albumId) async {
    final db = await database;

    // Fetch the album
    final albumResult = await db.query(
      'albums',
      columns: ['song_id'],
      where: 'album_id = ?',
      whereArgs: [albumId],
    );

    if (albumResult.isNotEmpty) {
      // Parse song IDs from album
      String songIdsJson = albumResult.first['song_id'] as String;
      List<int> songIds = List<int>.from(jsonDecode(songIdsJson));

      // Fetch songs matching the IDs
      final songsResult = await db.rawQuery(
          'SELECT * FROM songs WHERE song_id IN (${songIds.join(",")})'
      );
      return songsResult;
    }

    return [];
  }

  // Get songs in a specific playlist by playlist ID
  Future<List<Map<String, dynamic>>> getSongsByPlaylist(int playlistId) async {
    final db = await database;

    // Fetch the playlist
    final playlistResult = await db.query(
      'playlists',
      columns: ['song_ids'],
      where: 'playlist_id = ?',
      whereArgs: [playlistId],
    );

    if (playlistResult.isNotEmpty) {
      // Parse song IDs from playlist
      String songIdsJson = playlistResult.first['song_ids'] as String;
      List<int> songIds = List<int>.from(jsonDecode(songIdsJson));

      // Fetch songs matching the IDs
      final songsResult = await db.rawQuery(
          'SELECT * FROM songs WHERE song_id IN (${songIds.join(",")})'
      );
      return songsResult;
    }

    return [];
  }

  // Get a song by ID
  Future<Map<String, dynamic>?> getSongById(int songId) async {
    final db = await database;
    final result = await db.query(
      'songs',
      where: 'song_id = ?',
      whereArgs: [songId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Delete an album by ID
  Future<void> deleteAlbum(int albumId) async {
    final db = await database;
    await db.delete('albums', where: 'album_id = ?', whereArgs: [albumId]);
  }

  // Delete a song by ID
  Future<void> deleteSong(int songId) async {
    final db = await database;
    await db.delete('songs', where: 'song_id = ?', whereArgs: [songId]);
  }

  // Delete a playlist by ID
  Future<void> deletePlaylist(int playlistId) async {
    final db = await database;
    await db.delete('playlists', where: 'playlist_id = ?', whereArgs: [playlistId]);
  }

  // Update an album
  Future<void> updateAlbum(int albumId, Map<String, dynamic> album) async {
    final db = await database;
    await db.update(
      'albums',
      album,
      where: 'album_id = ?',
      whereArgs: [albumId],
    );
  }

  // Update a song
  Future<void> updateSong(int songId, Map<String, dynamic> song) async {
    final db = await database;
    await db.update(
      'songs',
      song,
      where: 'song_id = ?',
      whereArgs: [songId],
    );
  }

  // Update a playlist
  Future<void> updatePlaylist(int playlistId, Map<String, dynamic> playlist) async {
    final db = await database;
    await db.update(
      'playlists',
      playlist,
      where: 'playlist_id = ?',
      whereArgs: [playlistId],
    );
  }

  // Add a song to a playlist
  Future<void> addSongToPlaylist(int playlistId, int songId) async {
    final db = await database;

    // Fetch the playlist
    final playlistResult = await db.query(
      'playlists',
      columns: ['song_ids'],
      where: 'playlist_id = ?',
      whereArgs: [playlistId],
    );

    if (playlistResult.isNotEmpty) {
      // Update song IDs
      String songIdsJson = playlistResult.first['song_ids'] as String;
      List<int> songIds = List<int>.from(jsonDecode(songIdsJson));
      if (!songIds.contains(songId)) {
        songIds.add(songId);
      }

      // Save updated playlist
      await db.update(
        'playlists',
        {'song_ids': jsonEncode(songIds)},
        where: 'playlist_id = ?',
        whereArgs: [playlistId],
      );
    }
  }

  // Remove a song from a playlist
  Future<void> removeSongFromPlaylist(int playlistId, int songId) async {
    final db = await database;

    // Fetch the playlist
    final playlistResult = await db.query(
      'playlists',
      columns: ['song_ids'],
      where: 'playlist_id = ?',
      whereArgs: [playlistId],
    );

    if (playlistResult.isNotEmpty) {
      // Update song IDs
      String songIdsJson = playlistResult.first['song_ids'] as String;
      List<int> songIds = List<int>.from(jsonDecode(songIdsJson));
      songIds.remove(songId);

      // Save updated playlist
      await db.update(
        'playlists',
        {'song_ids': jsonEncode(songIds)},
        where: 'playlist_id = ?',
        whereArgs: [playlistId],
      );
    }
  }
}
