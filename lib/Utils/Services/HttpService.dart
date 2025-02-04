import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Constants/CustomSnackBar.dart';
import 'package:newmusicappmachado/Utils/Services/DatabaseService.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://your-api-url.com/'; // Your API's base URL

  // Singleton pattern to create a single instance of ApiService
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // GET request - Fetch data from the API
  Future<int?> getRequest({String? downloadSongUrl, filePath,int? index,Map<String , dynamic>? song}) async {
    try {
      final response = await http.Client().send(http.Request('GET', Uri.parse(downloadSongUrl??"")));
      if (response.statusCode == 200) {
        final file = File(filePath);
         final  sink = file.openWrite();
         final total  = response.contentLength?? 0;
        int bytesReceived = 0;
        Get.find<BaseController>().progress.addIf(true, {"song_Id":song?['song_id'],"progress":0});
        response.stream.listen(
              (List<int> chunk) {
                bytesReceived += chunk.length;
            sink.add(chunk);
                Get.find<BaseController>().progress.firstWhere((v)=>v['song_Id']==song?['song_id']);
             Get.find<BaseController>().progress.firstWhere((v)=>v['song_Id']==song?['song_id'])['progress'] = ((bytesReceived / total)*100).toStringAsFixed(0);
                Get.find<BaseController>().update();
                Get.find<ArtistsController>().update();
          },
          onDone: () async {
            await sink.flush();
            await sink.close();
           final p =  Get.find<BaseController>().progress.firstWhere((v)=>v['song_Id']== song?['song_id']);
           if(p['progress'] == "100"){
            final  updatedSong = {
              ...song ?? {}, // Keep all existing fields
              "isDownloaded": 1, // Update the status to 1
            };
            await SongDatabaseService().updateSong(song?['song_id'],updatedSong??{}).then((_){
              Get.find<BaseController>().fetchDatabaseSong();
            });
              }
            Get.find<BaseController>().isDownloading.value = false;
            Get.find<BaseController>().connectivityResult[0] == ConnectivityResult.none ? Get.find<BaseController>().progress.clear():null;
            Get.find<BaseController>().progress.removeWhere((v)=>v['progress']=="100");
            Get.find<BaseController>().update();
          },
          onError: (e) {
            Get.find<BaseController>().connectivityResult[0] != ConnectivityResult.none ? Get.find<BaseController>().progress.clear():null;
            Get.find<BaseController>().isDownloading.value = false;
            Get.find<BaseController>().downloadProgress.value = 0.0;
            Get.find<BaseController>().update();
          },
        );
         // json.decode(response.body);
         return response.contentLength;

      } else {
        Utility.showSnackBar("Failed to download song",isError: true);
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Utility.showSnackBar("$e",isError: true);
      throw Exception('Error: $e');
    }
  }
  // Future<int?> getRequest({
  //   String? downloadSongUrl,
  //   required String filePath,
  //   int? index,
  //   Map<String, dynamic>? song,
  // }) async {
  //   try {
  //     final response = await http.Client().send(http.Request('GET', Uri.parse(downloadSongUrl ?? "")));
  //     if (response.statusCode == 200) {
  //       final file = File(filePath);
  //       final sink = file.openWrite();
  //       final total = response.contentLength ?? 0;
  //       int bytesReceived = 0;
  //
  //       // Initialize progress tracking
  //       Get.find<BaseController>().progress.addIf(
  //         true,
  //         {"song_Id": song?['song_id'], "progress": 0},
  //       );
  //
  //       // Listen to response stream
  //       response.stream.listen(
  //             (List<int> chunk) {
  //           bytesReceived += chunk.length;
  //           sink.add(chunk);
  //
  //           // Update progress for the current song
  //           var progressItem = Get.find<BaseController>().progress.firstWhere(
  //                 (v) => v['song_Id'] == song?['song_id'],
  //             orElse: () => {"progress": "0"}, // Return a default value if not found
  //           );
  //
  //           if (progressItem.isNotEmpty) {
  //             progressItem['progress'] = ((bytesReceived / total) * 100).toStringAsFixed(0);
  //             print("Progress: ${progressItem['progress']}%");
  //             Get.find<BaseController>().update();
  //             Get.find<ArtistsController>().update();
  //           }
  //         },
  //         onDone: () async {
  //           // Finish writing the file
  //           await sink.flush();
  //           await sink.close();
  //
  //           // Update song metadata after download is complete
  //           var progressItem = Get.find<BaseController>().progress.firstWhere(
  //                 (v) => v['song_Id'] == song?['song_id'],
  //             orElse: () => {"progress": "0"}, // Return a default value if not found
  //           );
  //
  //           if (progressItem.isNotEmpty) {
  //             final updatedSong = {
  //               ...song ?? {},
  //               "isDownloaded": 1,
  //             };
  //             await SongDatabaseService().updateSong(song?['song_id'], updatedSong).then((_) {
  //               Get.find<BaseController>().fetchDatabaseSong();
  //             });
  //
  //             // Remove completed progress tracking
  //             Get.find<BaseController>().progress.removeWhere((v) => v['song_Id'] == song?['song_id']);
  //           }
  //
  //           // Handle connectivity and finalize download
  //           Get.find<BaseController>().isDownloading.value = false;
  //           if (Get.find<BaseController>().connectivityResult[0] != ConnectivityResult.none) {
  //             Get.find<BaseController>().progress.clear();
  //           }
  //
  //           Get.find<BaseController>().update();
  //         },
  //         onError: (e) {
  //           // Handle errors during download
  //           print("Download error: $e");
  //           Get.find<BaseController>().isDownloading.value = false;
  //           Get.find<BaseController>().downloadProgress.value = 0.0;
  //           Get.find<BaseController>().update();
  //         },
  //       );
  //       return response.contentLength;
  //     } else {
  //       Utility.showSnackBar("Failed to download song", isError: true);
  //       throw Exception('Failed to load data. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     Utility.showSnackBar("Error: $e", isError: true);
  //     throw Exception('Error: $e');
  //   }
  // }


  // POST request - Send data to the API
  Future<Map<String, dynamic>> postRequest(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers ?? {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // PUT request - Update data on the API
  Future<Map<String, dynamic>> putRequest(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers ?? {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // DELETE request - Remove data from the API
  Future<Map<String, dynamic>> deleteRequest(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to delete data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
