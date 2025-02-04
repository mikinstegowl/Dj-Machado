import 'dart:convert';
import 'dart:io';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Constants/CustomSnackBar.dart';
import 'package:newmusicappmachado/Utils/Services/DatabaseService.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https:///your-api-url.com/'; /// Your API's base URL

  /// Singleton pattern to create a single instance of ApiService
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// Sends a GET request to download a song file, tracks the download progress,
  /// and updates the download status in the database once completed.
  ///
  /// [downloadSongUrl] - URL of the song file to be downloaded.
  /// [filePath] - Path to save the downloaded file.
  /// [index] - Optional index to track specific download.
  /// [song] - Map of song details for progress tracking and updating the song metadata after download.
  ///
  /// Returns the total content length of the downloaded file.
  Future<int?> getRequest({
    String? downloadSongUrl,
    required String filePath,
    int? index,
    Map<String, dynamic>? song,
  }) async {
    try {
      /// Send GET request to the provided URL
      final response = await http.Client().send(http.Request('GET', Uri.parse(downloadSongUrl ?? "")));

      /// If response is successful (status code 200)
      if (response.statusCode == 200) {
        final file = File(filePath);
        final sink = file.openWrite();
        final total = response.contentLength ?? 0;
        int bytesReceived = 0;

        /// Add initial progress for the song download
        Get.find<BaseController>().progress.addIf(true, {"song_Id": song?['song_id'], "progress": 0});

        /// Listen to response stream and update progress
        response.stream.listen(
              (List<int> chunk) {
            bytesReceived += chunk.length;
            sink.add(chunk);

            /// Update download progress
            var progressItem = Get.find<BaseController>().progress.firstWhere(
                  (v) => v['song_Id'] == song?['song_id'],
              orElse: () => {"progress": "0"},
            );
            if (progressItem.isNotEmpty) {
              progressItem['progress'] = ((bytesReceived / total) * 100).toStringAsFixed(0);
              Get.find<BaseController>().update();
            }
          },
          onDone: () async {
            /// Finish writing the file after download
            await sink.flush();
            await sink.close();

            /// After download, update song metadata
            var progressItem = Get.find<BaseController>().progress.firstWhere(
                  (v) => v['song_Id'] == song?['song_id'],
              orElse: () => {"progress": "0"},
            );
            if (progressItem.isNotEmpty && progressItem['progress'] == "100") {
              final updatedSong = {
                ...song ?? {},
                "isDownloaded": 1,
              };
              await SongDatabaseService().updateSong(song?['song_id'], updatedSong).then((_) {
                Get.find<BaseController>().fetchDatabaseSong();
              });
            }

            /// Clear download progress and state
            Get.find<BaseController>().isDownloading.value = false;
            Get.find<BaseController>().progress.removeWhere((v) => v['progress'] == "100");
            Get.find<BaseController>().update();
          },
          onError: (e) {
            /// Handle errors during download
            Get.find<BaseController>().isDownloading.value = false;
            Get.find<BaseController>().downloadProgress.value = 0.0;
            Get.find<BaseController>().update();
          },
        );

        return response.contentLength;
      } else {
        /// Show error if request fails
        Utility.showSnackBar("Failed to download song", isError: true);
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      /// Show error in case of an exception
      Utility.showSnackBar("$e", isError: true);
      throw Exception('Error: $e');
    }
  }

  /// Sends a POST request to the API with the provided [body] data and headers,
  /// then returns the response data.
  ///
  /// [endpoint] - The endpoint to send the POST request to.
  /// [body] - The body of the request, typically in JSON format.
  /// [headers] - Optional headers for the request, default is `Content-Type: application/json`.
  ///
  /// Returns the response data from the API.
  Future<Map<String, dynamic>> postRequest(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers ?? {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      /// Check if POST request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Sends a PUT request to the API to update data at the specified [endpoint],
  /// and returns the updated response data.
  ///
  /// [endpoint] - The endpoint to send the PUT request to.
  /// [body] - The updated data to send in the request body.
  /// [headers] - Optional headers for the request, default is `Content-Type: application/json`.
  ///
  /// Returns the updated response data from the API.
  Future<Map<String, dynamic>> putRequest(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers ?? {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      /// Check if PUT request was successful
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Sends a DELETE request to the API to remove data at the specified [endpoint],
  /// and returns the response data after deletion.
  ///
  /// [endpoint] - The endpoint to send the DELETE request to.
  /// [headers] - Optional headers for the request.
  ///
  /// Returns the response data after deletion from the API.
  Future<Map<String, dynamic>> deleteRequest(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers,
      );

      /// Check if DELETE request was successful
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
