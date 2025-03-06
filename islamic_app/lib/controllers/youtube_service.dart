
import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  final String apiKey = 'AIzaSyDlVpLVIHXL1uByNJ4oLruO3VBFh5lUpto';  // Remplacez avec votre clé API
  Future<List<Map<String, String>>> getVideosFromChannel(String channelId) async {
    final searchUrl =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&maxResults=10&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(searchUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Map<String, String>> videos = [];
        
        for (var item in data['items']) {
          String? videoId = item['id']['videoId'];
          String title = item['snippet']['title'];
          String description = item['snippet']['description'];
          String thumbnailUrl = item['snippet']['thumbnails']['high']['url'];
          
          if (videoId != null) {
            videos.add({
              'videoId': videoId,
              'title': title,
              'description': description,
              'thumbnail': thumbnailUrl,
            });
          }
        }
        return videos;
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
