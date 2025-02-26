// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:audio_service/audio_service.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:newmusicappmachado/Controller/BaseController.dart';
// import 'package:newmusicappmachado/Controller/HomeController.dart';
// import 'package:flutter/services.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:get/get.dart';
// import 'package:just_audio_background/just_audio_background.dart';
// import 'package:newmusicappmachado/main.dart';
// import 'package:path_provider/path_provider.dart';
//
// class PlayerService extends GetxService {
//   static final PlayerService _singleton = PlayerService._internal();
//
//   factory PlayerService() => _singleton;
//
//   PlayerService._internal();
//
//   static PlayerService get instance => _singleton;
//
//   AudioPlayer audioPlayer = AudioPlayer(); // Audio player instance
//   final List<AudioSource> playlist = []; // Playlist
//   int currentSongIndex = 0; // Current song index
//
//   /// Creates and initializes the playlist
//   Future<void> createPlaylist(dynamic data,
//       {int? index, id, String type = 'song'}) async {
//     if (audioPlayer.sequenceState?.currentSource?.tag.id.toString() ==
//         id.toString()) {
//       return;
//     }
//     try {
//       _resetPlaylist();
//       final List<dynamic> decodedData = jsonDecode(jsonEncode(data));
//
//       if (decodedData.isEmpty) {
//         log('Error: No data found to create a playlist.');
//         return;
//       }
//
//       log('Playlist Type: $type');
//       log(decodedData.toString());
//
//       // Map data to AudioSource list
//       playlist.addAll(decodedData.map((item) => _mapToAudioSource(item, type)));
//
//       currentSongIndex = index ?? 0; // Update current index
//       await _initializePlayer(index ?? 0); // Initialize player
//     } catch (e) {
//       log('Error creating playlist: $e');
//     }
//   }
//
//   /// Resets the playlist and audio player
//   void _resetPlaylist() {
//     playlist.clear();
//     audioPlayer.stop();
//     audioPlayer.dispose();
//   }
//
//   /// Maps a data item to an AudioSource object
//   AudioSource _mapToAudioSource(Map<String, dynamic> item, String type) {
//     switch (type) {
//       case 'song':
//         return AudioSource.uri(Uri.parse(item['song'] ?? ''),
//             tag: MediaItem(
//               id: item['song_id'].toString(),
//               title: item['song_name'],
//               artUri: Uri.tryParse(item['song_image']),
//               artist: item['song_artist'] ?? item['artist_name'],
//             ));
//       case 'radio':
//         return AudioSource.uri(
//           Uri.parse(item['trendingsradio_url'] ?? ''),
//           tag: MediaItem(
//             isLive: true,
//             id: item['trendingsradio_id'].toString(),
//             title: item['trendingsradio_name'],
//             artUri: Uri.tryParse(item['trendingsradio_image']),
//           ),
//         );
//       default:
//         func();
//         return AudioSource.file(item['file_path'],
//             tag: MediaItem(
//               id: item['song_id'].toString(),
//               title: item['song_name'],
//               artUri: artUri,
//               artist: item['song_artist'] ?? item['artist_name'],
//             ));
//     }
//   }
//
//   Future<Uri> _getAssetImageUri(String assetPath) async {
//     // Get the temporary directory
//     final tempDir = await getTemporaryDirectory();
//     final filePath = '${tempDir.path}/song_image.png';
//
//     // Load the asset and write it to a temporary file
//     final ByteData data = await rootBundle.load(assetPath);
//     final buffer = data.buffer.asUint8List();
//     final file = File(filePath);
//     await file.writeAsBytes(buffer);
//
//     // Return the URI to the file
//     return Uri.file(filePath);
//   }
//
//   Uri? artUri;
//   Future<Uri> func() async {
//     artUri = await _getAssetImageUri("assets/image/placeholder.png");
//     return artUri ?? Uri();
//   }
//
//   /// Initializes the audio player
//   Future<void> _initializePlayer(int index) async {
//     try {
//       if (playlist.isEmpty) {
//         log('Error: Playlist is empty.');
//         return;
//       }
//       audioPlayer=AudioPlayer();
//       Get.find<BaseController>().showMusicMenu.value = true;
//       await audioPlayer.setAudioSource(
//         ConcatenatingAudioSource(children: playlist),
//         initialIndex: index,
//       );
//       audioPlayer.setLoopMode(LoopMode.all);
//       listenToSongChanges();
//       Get.find<BaseController>().connectivityResult[0] !=
//               ConnectivityResult.none
//           ? await Get.find<HomeController>()
//               .songDetailsDataApi(
//               songId: int.tryParse(
//                       audioPlayer.sequenceState?.currentSource?.tag.id) ??
//                   0,
//             )
//               .then((_) async {
//               await _logButtonClick(
//                       songId: audioPlayer.sequenceState?.currentSource?.tag.id,
//                       songName:
//                           audioPlayer.sequenceState?.currentSource?.tag.title)
//                   .then((_) {
//                 print("Button click event logged");
//               });
//             })
//           : null;
//       await audioPlayer.play();
//
//       log("Player initialized and song started.");
//     } catch (e) {
//       log('Error initializing player: $e');
//     }
//   }
//
//   Future<void> _logButtonClick({String? songName, String? songId}) async {
//     await MyApp.analytics.logEvent(
//       name: 'song_detail',
//       parameters: {
//         'song_name': songName ?? "",
//         'song_id': songId ?? "",
//       },
//     ).then((_) {
//       print("Button click event logged: $songName, $songId");
//     });
//   }
//
//   /// Plays the current song
//   Future<void> play() async {
//     try {
//       await audioPlayer.play();
//     } catch (e) {
//       log('Error playing audio: $e');
//     }
//   }
//
//   /// Pauses the current song
//   Future<void> pause() async {
//     try {
//       await audioPlayer.pause();
//     } catch (e) {
//       log('Error pausing audio: $e');
//     }
//   }
//
//   /// Stops the current song
//   Future<void> stop() async {
//     try {
//       await audioPlayer.stop();
//     } catch (e) {
//       log('Error stopping audio: $e');
//     }
//   }
//
//   Future<void> autoSongPlay() async {
//     if (currentSongIndex > 0) {
//       await _initializePlayer(currentSongIndex);
//     }
//   }
//
//   /// Skips to the next song
//   Future<void> nextSong() async {
//     try {
//       if (currentSongIndex < playlist.length - 1) {
//         currentSongIndex++;
//       } else {
//         currentSongIndex = 0; // Loop back to the first song
//       }
//       await _initializePlayer(currentSongIndex);
//       play();
//     } catch (e) {
//       log('Error skipping to next song: $e');
//     }
//   }
//
//   /// Skips to the previous song
//   Future<void> previousSong() async {
//     try {
//       if (currentSongIndex > 0) {
//         currentSongIndex--;
//       } else {
//         currentSongIndex = playlist.length - 1; // Loop to the last song
//       }
//       await _initializePlayer(currentSongIndex);
//       play();
//     } catch (e) {
//       log('Error skipping to previous song: $e');
//     }
//   }
//
//   /// Retrieves metadata of the current song
//   Map<String, dynamic>? getCurrentSongMetadata() {
//     try {
//       final currentSource = audioPlayer.sequenceState?.currentSource;
//       return currentSource?.tag as Map<String, dynamic>?;
//     } catch (e) {
//       log('Error fetching song metadata: $e');
//       return null;
//     }
//   }
//   void listenToSongChanges() {
//     audioPlayer.currentIndexStream.listen((index) {
//       if (index != null && playlist.isNotEmpty) {
//         final currentSong = playlist[index];
//         final currentSource = audioPlayer.sequenceState?.currentSource;
//         final songId = currentSource?.tag.id;
//         // Call the API to update song details
//         Get.find<HomeController>().songDetailsDataApi(songId: int.tryParse(songId) ?? 0).then((_){
//           Get.find<BaseController>().update();
//           Get.find<HomeController>().update();
//         });
//         //Optional: Log event
//         _logButtonClick(
//           songId: songId,
//           songName: currentSource?.tag.title,
//         );
//       }
//     });
//   }
// }

// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:audio_service/audio_service.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:newmusicappmachado/Controller/BaseController.dart';
// import 'package:newmusicappmachado/Controller/HomeController.dart';
// import 'package:flutter/services.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:get/get.dart';
// import 'package:just_audio_background/just_audio_background.dart';
// import 'package:newmusicappmachado/main.dart';
// import 'package:path_provider/path_provider.dart';
//
// class PlayerService extends GetxService {
//   // ✅ Singleton pattern to ensure only one instance exists
//   static final PlayerService _singleton = PlayerService._internal();
//
//   factory PlayerService() => _singleton;
//
//   PlayerService._internal();
//
//   static PlayerService get instance => _singleton;
//
//   // ✅ Ensure only one AudioPlayer instance exists
//    AudioPlayer audioPlayer = AudioPlayer();
//   final List<AudioSource> playlist = [];
//   int currentSongIndex = 0;
//
//   /// ✅ Creates and initializes the playlist
//   Future<void> createPlaylist(dynamic data,
//       {int? index, id, String type = 'song'}) async {
//     if (audioPlayer.sequenceState?.currentSource?.tag.id.toString() ==
//         id.toString()) {
//       return;
//     }
//     try {
//       _resetPlaylist();
//       final List<dynamic> decodedData = jsonDecode(jsonEncode(data));
//
//       if (decodedData.isEmpty) {
//         log('Error: No data found to create a playlist.');
//         return;
//       }
//
//       log('Playlist Type: $type');
//       log(decodedData.toString());
//
//       // Map data to AudioSource list
//       playlist.addAll(decodedData.map((item) => _mapToAudioSource(item, type)));
//
//       currentSongIndex = index ?? 0;
//       await _initializePlayer(index ?? 0);
//     } catch (e) {
//       log('Error creating playlist: $e');
//     }
//   }
//
//   /// ✅ Resets the playlist (DO NOT call dispose() to avoid multiple instances)
//   void _resetPlaylist() {
//     playlist.clear();
//     audioPlayer.stop();
//     audioPlayer.dispose();
//   }
//
//   /// ✅ Maps a data item to an AudioSource object
//   AudioSource _mapToAudioSource(Map<String, dynamic> item, String type) {
//     switch (type) {
//       case 'song':
//         return AudioSource.uri(Uri.parse(item['song'] ?? ''),
//             tag: MediaItem(
//               id: item['song_id'].toString(),
//               title: item['song_name'],
//               artUri: Uri.tryParse(item['song_image']),
//               artist: item['song_artist'] ?? item['artist_name'],
//             ));
//       case 'radio':
//         return AudioSource.uri(
//           Uri.parse(item['trendingsradio_url'] ?? ''),
//           tag: MediaItem(
//             isLive: true,
//             id: item['trendingsradio_id'].toString(),
//             title: item['trendingsradio_name'],
//             artUri: Uri.tryParse(item['trendingsradio_image']),
//           ),
//         );
//       default:
//         return AudioSource.file(item['file_path'],
//             tag: MediaItem(
//               id: item['song_id'].toString(),
//               title: item['song_name'],
//               artUri: Uri.tryParse("assets/image/placeholder.png"),
//               artist: item['song_artist'] ?? item['artist_name'],
//             ));
//     }
//   }
//
//   /// ✅ Initializes the audio player without creating a new instance
//   Future<void> _initializePlayer(int index) async {
//     try {
//       if (playlist.isEmpty) {
//         log('Error: Playlist is empty.');
//         return;
//       }
//
//       Get.find<BaseController>().showMusicMenu.value = true;
//       audioPlayer =AudioPlayer();
//
//       await audioPlayer.setAudioSource(
//         ConcatenatingAudioSource(children: playlist),
//         initialIndex: index,
//       );
//       audioPlayer.setLoopMode(LoopMode.all);
//       listenToSongChanges();
//       if (Get.find<BaseController>().connectivityResult[0] != ConnectivityResult.none) {
//         await Get.find<HomeController>()
//             .songDetailsDataApi(
//           songId: int.tryParse(audioPlayer.sequenceState?.currentSource?.tag.id) ?? 0,
//         )
//             .then((_) async {
//           await _logButtonClick(
//             songId: audioPlayer.sequenceState?.currentSource?.tag.id,
//             songName: audioPlayer.sequenceState?.currentSource?.tag.title,
//           ).then((_) {
//             print("Button click event logged");
//           });
//         });
//       }
//
//       await audioPlayer.play();
//
//       log("Player initialized and song started.");
//     } catch (e) {
//       log('Error initializing player: $e');
//     }
//   }
//
//   /// ✅ Logs the song play event
//   Future<void> _logButtonClick({String? songName, String? songId}) async {
//     await MyApp.analytics.logEvent(
//       name: 'song_detail',
//       parameters: {
//         'song_name': songName ?? "",
//         'song_id': songId ?? "",
//       },
//     ).then((_) {
//       print("Button click event logged: $songName, $songId");
//     });
//   }
//
//   /// ✅ Plays the current song
//   Future<void> play() async {
//     try {
//       await audioPlayer.play();
//     } catch (e) {
//       log('Error playing audio: $e');
//     }
//   }
//
//   /// ✅ Pauses the current song
//   Future<void> pause() async {
//     try {
//       await audioPlayer.pause();
//     } catch (e) {
//       log('Error pausing audio: $e');
//     }
//   }
//
//   /// ✅ Stops the current song (but does not dispose of the player)
//   Future<void> stop() async {
//     try {
//       await audioPlayer.stop();
//     } catch (e) {
//       log('Error stopping audio: $e');
//     }
//   }
//
//   /// ✅ Moves to the next song
//   Future<void> nextSong() async {
//     try {
//       if (currentSongIndex < playlist.length - 1) {
//         currentSongIndex++;
//       } else {
//         currentSongIndex = 0;
//       }
//       await _initializePlayer(currentSongIndex);
//       play();
//     } catch (e) {
//       log('Error skipping to next song: $e');
//     }
//   }
//
//   /// ✅ Moves to the previous song
//   Future<void> previousSong() async {
//     try {
//       if (currentSongIndex > 0) {
//         currentSongIndex--;
//       } else {
//         currentSongIndex = playlist.length - 1;
//       }
//       await _initializePlayer(currentSongIndex);
//       play();
//     } catch (e) {
//       log('Error skipping to previous song: $e');
//     }
//   }
//
//   /// ✅ Retrieves metadata of the current song
//   Map<String, dynamic>? getCurrentSongMetadata() {
//     try {
//       final currentSource = audioPlayer.sequenceState?.currentSource;
//       return currentSource?.tag as Map<String, dynamic>?;
//     } catch (e) {
//       log('Error fetching song metadata: $e');
//       return null;
//     }
//   }
//
//   /// ✅ Listens for song changes and updates UI
//   void listenToSongChanges() {
//     audioPlayer.currentIndexStream.listen((index) {
//       if (index != null && playlist.isNotEmpty) {
//         final currentSource = audioPlayer.sequenceState?.currentSource;
//         final songId = currentSource?.tag.id;
//
//         Get.find<HomeController>().songDetailsDataApi(songId: int.tryParse(songId) ?? 0).then((_){
//           Get.find<BaseController>().update();
//           Get.find<HomeController>().update();
//         });
//
//         _logButtonClick(
//           songId: songId,
//           songName: currentSource?.tag.title,
//         );
//       }
//     });
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:newmusicappmachado/main.dart';
import 'package:path_provider/path_provider.dart';

class PlayerService extends GetxService {
  // ✅ Singleton pattern to ensure only one instance exists
  static final PlayerService _singleton = PlayerService._internal();

  factory PlayerService() => _singleton;
  Rx<String?> currentSong = Rx<String?>(null);

  PlayerService._internal();

  static PlayerService get instance => _singleton;

  // ✅ Ensure only one AudioPlayer instance exists
   AudioPlayer audioPlayer = AudioPlayer();
  final List<AudioSource> playlist = [];
  int currentSongIndex = 0;

  void setCurrentSong(String songTitle) {
    currentSong.value = songTitle;
    Get.find<BaseController>().update();
    Get.find<HomeController>().update();
  }
  /// ✅ Creates and initializes the playlist
  Future<void> createPlaylist(dynamic data,
      {int? index, id, String type = 'song'}) async {
    print("this is data ${data}");
    if (audioPlayer.sequenceState?.currentSource?.tag.id.toString() ==
        id.toString()) {
      return;
    }
    try {
      _resetPlaylist();
      final List<dynamic> decodedData = jsonDecode(jsonEncode(data));

      if (decodedData.isEmpty) {
        log('Error: No data found to create a playlist.');
        return;
      }

      log('Playlist Type: $type');
      log(decodedData.toString());

      // Map data to AudioSource list
      playlist.addAll(decodedData.map((item) => _mapToAudioSource(item, type)));

      currentSongIndex = index ?? 0;
      await _initializePlayer(index ?? 0);
    } catch (e) {
      log('Error creating playlist: $e');
    }
  }

  /// ✅ Resets the playlist without disposing of the player instance
  void _resetPlaylist() {
    playlist.clear();
    audioPlayer.stop();
  }

  /// ✅ Maps a data item to an AudioSource object
  AudioSource _mapToAudioSource(Map<String, dynamic> item, String type) {
    switch (type) {
      case 'song':
        return AudioSource.uri(Uri.parse(item['song'] ?? ''),
            tag: MediaItem(
              id: item['song_id'].toString(),
              title: item['song_name'],
              artUri: Uri.tryParse(item['song_image']),
              artist: item['song_artist'] ?? item['artist_name'],
            ));
      case 'radio':
        return AudioSource.uri(
          Uri.parse(item['trendingsradio_url'] ?? ''),
          tag: MediaItem(
            isLive: true,
            id: item['trendingsradio_id'].toString(),
            title: item['trendingsradio_name'],
            artUri: Uri.tryParse(item['trendingsradio_image']),
          ),
        );
      default:
        return AudioSource.file(item['file_path'],
            tag: MediaItem(
              id: item['song_id'].toString(),
              title: item['song_name'],
              artUri: Uri.tryParse("assets/image/placeholder.png"),
              artist: item['song_artist'] ?? item['artist_name'],
            ));
    }
  }

  /// ✅ Initializes the audio player
  Future<void> _initializePlayer(int index) async {
    try {
      if (playlist.isEmpty) {
        log('Error: Playlist is empty.');
        return;
      }

      Get.find<BaseController>().showMusicMenu.value = true;

      audioPlayer = AudioPlayer();
      await audioPlayer.setAudioSource(
        ConcatenatingAudioSource(children: playlist),
        initialIndex: index,
      );
      audioPlayer.setLoopMode(LoopMode.all);
      listenToSongChanges();
      // listenToSongChanges1();
      if (Get.find<BaseController>().connectivityResult[0] != ConnectivityResult.none) {
        await Get.find<HomeController>()
            .songDetailsDataApi(
          songId: int.tryParse(audioPlayer.sequenceState?.currentSource?.tag.id) ?? 0,
        )
            .then((_) async {
          await _logButtonClick(
            songId: audioPlayer.sequenceState?.currentSource?.tag.id,
            songName: audioPlayer.sequenceState?.currentSource?.tag.title,
          ).then((_) {
            print("Button click event logged");
          });
        });
      }

      await audioPlayer.play();

      log("Player initialized and song started.");
    } catch (e) {
      log('Error initializing player: $e');
    }
  }

  /// ✅ Logs the song play event
  Future<void> _logButtonClick({String? songName, String? songId}) async {
    await MyApp.analytics.logEvent(
      name: 'song_detail',
      parameters: {
        'song_name': songName ?? "",
        'song_id': songId ?? "",
      },
    ).then((_) {
      print("Button click event logged: $songName, $songId");
    });
  }

  /// ✅ Plays the current song
  Future<void> play() async {
    try {
      await audioPlayer.play();
    } catch (e) {
      log('Error playing audio: $e');
    }
  }

  /// ✅ Pauses the current song
  Future<void> pause() async {
    try {
      await audioPlayer.pause();
    } catch (e) {
      log('Error pausing audio: $e');
    }
  }

  /// ✅ Stops the current song
  Future<void> stop() async {
    try {
      await audioPlayer.stop();
    } catch (e) {
      log('Error stopping audio: $e');
    }
  }

  /// ✅ Moves to the next song without reinitializing the player
  Future<void> nextSong() async {
    try {
      if (audioPlayer.hasNext) {
        await audioPlayer.seekToNext();
        // _initializePlayer(currentSongIndex++);
        // currentSongIndex++;
      }
    } catch (e) {
      log('Error skipping to next song: $e');
    }
  }

  /// ✅ Moves to the previous song without reinitializing the player
  Future<void> previousSong() async {
    try {
      if (audioPlayer.hasPrevious) {
        await audioPlayer.seekToPrevious();
        // _initializePlayer(currentSongIndex--);
        // currentSongIndex--;
      } else {
        await audioPlayer.seek(Duration.zero);
        // _initializePlayer(currentSongIndex--);
        // currentSongIndex--;// Restart the current song if no previous exists
      }
    } catch (e) {
      log('Error skipping to previous song: $e');
    }
  }

  /// ✅ Retrieves metadata of the current song
  Map<String, dynamic>? getCurrentSongMetadata() {
    try {
      final currentSource = audioPlayer.sequenceState?.currentSource;
      return currentSource?.tag as Map<String, dynamic>?;
    } catch (e) {
      log('Error fetching song metadata: $e');
      return null;
    }
  }

  /// ✅ Listens for song changes and updates UI
  void listenToSongChanges() {
    audioPlayer.currentIndexStream.listen((index) {
      if (index != null && playlist.isNotEmpty) {
        final currentSource = audioPlayer.sequenceState?.currentSource;
        final songId = currentSource?.tag.id;

        Get.find<BaseController>().connectivityResult[0] ==
            ConnectivityResult.none? null:  Get.find<HomeController>().songDetailsDataApi(songId: int.tryParse(songId) ?? 0).then((_){
          Get.find<BaseController>().update();
          Get.find<HomeController>().update();
          currentSongIndex++;
        });

        Get.find<BaseController>().update();
        Get.find<HomeController>().update();
        setCurrentSong(currentSource?.tag.title);
        _logButtonClick(
          songId: songId,
          songName: currentSource?.tag.title,
        );
        // if (state.processingState == ProcessingState.completed) {
        //   // Current song has finished, play the next song
        //   final nextIndex = audioPlayer.currentIndex! + 1;
        //   if (nextIndex < playlist.length) {
        //     // Proceed to next song in the list
        //     audioPlayer.seek(Duration.zero, index: nextIndex);
        //     audioPlayer.play();
        //   }
        // }
      }
    });
  }
  void listenToSongChanges1() {
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        // Current song has finished, play the next song
        final nextIndex = audioPlayer.currentIndex! + 1;
        if (nextIndex < playlist.length) {
          // Proceed to next song in the list
          audioPlayer.seek(audioPlayer.sequenceState?.currentSource?.duration, index: nextIndex);
          // audioPlayer.play();
        }
      }
    });
  }
}
