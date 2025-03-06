// import 'package:flutter/material.dart';
// import 'package:islamic_app/controllers/videoPlayerPage.dart';
// import 'package:islamic_app/controllers/youtube_service.dart';

// class VideoPage extends StatefulWidget {
//   @override
//   _VideoPageState createState() => _VideoPageState();
// }

// class _VideoPageState extends State<VideoPage> {
//   late Future<List<Map<String, String>>> videos;
//   final YouTubeService _youtubeService = YouTubeService();
//   final String channelId = 'UCpPZKwayH_pWPF20Ls0hgVw';

//   @override
//   void initState() {
//     super.initState();
//     videos = _youtubeService.getVideosFromChannel(channelId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Videos' ) , titleTextStyle: TextStyle(
//             fontSize: 21,
//             fontWeight: FontWeight.bold,
//             fontFamily: 'Amiri',
//             color: Color(0xFF2A86BF)
//           ),  
//         backgroundColor: Color(0xFF020659),

//       ),
//       body: FutureBuilder<List<Map<String, String>>>(
//         future: videos,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Erreur : ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('Aucune vidéo trouvée.'));
//           }

//           return Stack(
//             children: [
//               // Image de fond
//               Positioned.fill(
//                 child: Image.asset(
//                   'assets/b.jpg', 
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Positioned.fill(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: ListView.builder(
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index) {
//                       final video = snapshot.data![index];
//                       return Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15.0),
//                         ),
//                         elevation: 5,
//                         margin: EdgeInsets.only(bottom: 16),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(15.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Image de la miniature de la vidéo
//                               Image.network(
//                                 video['thumbnail']!,
//                                 width: double.infinity,
//                                 height: 200,
//                                 fit: BoxFit.cover,
//                               ),
//                               // Contenu de la carte
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       video['title']!,
//                                       style: TextStyle(
//                                           fontSize: 18, fontWeight: FontWeight.bold),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Text(
//                                       video['description']!,
//                                       style: TextStyle(color: Colors.grey[700]),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:islamic_app/controllers/videoPlayerPage.dart';
import 'package:islamic_app/controllers/youtube_service.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late Future<List<Map<String, String>>> videos;
  final YouTubeService _youtubeService = YouTubeService();
  final String channelId = 'UCpPZKwayH_pWPF20Ls0hgVw';

  @override
  void initState() {
    super.initState();
    videos = _youtubeService.getVideosFromChannel(channelId);
  }

  // Méthode de navigation vers la page VideoPlayerPage
  void _navigateToVideoPlayer(String videoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(videoId: videoId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
        titleTextStyle: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.bold,
          fontFamily: 'Amiri',
          color: Color(0xFF2A86BF),
        ),
        backgroundColor: Color(0xFF020659),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: videos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune vidéo trouvée.'));
          }

          return Stack(
            children: [
              // Image de fond
              Positioned.fill(
                child: Image.asset(
                  'assets/b.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final video = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          // Appel à la fonction de navigation lors du clic
                          _navigateToVideoPlayer(video['videoId']!); // Passe l'ID de la vidéo
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.only(bottom: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image de la miniature de la vidéo
                                Image.network(
                                  video['thumbnail']!,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                                // Contenu de la carte
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        video['title']!,
                                        style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        video['description']!,
                                        style: TextStyle(color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
