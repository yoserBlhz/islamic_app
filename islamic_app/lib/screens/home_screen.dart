import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = '';
  String city = '';
  String country = '';
  String gregorianDate = '';
  String hijriDate = '';
  List<Map<String, String>> prayers = [];
  int? countdownEndTime;

  @override
  void initState() {
    super.initState();
    _getLocationAndPrayerTimes();
  }

  // Fonction pour obtenir l'emplacement GPS, la ville, le pays et les horaires de prière
Future<void> _getLocationAndPrayerTimes() async {
  try {
    // Vérifier et demander les permissions de localisation
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
      if (!status.isGranted) {
        throw Exception('Location permissions are denied');
      }
    }

    // Obtenir la position GPS
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Convertir les coordonnées en adresse
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      city = placemarks.first.locality ?? "Unknown City";
      country = placemarks.first.country ?? "Unknown Country";
      location = '$city, $country';
    });

    // Récupérer les horaires de prière depuis l'API backend
    await _getPrayerTimes(city, country);
  } catch (e) {
    print('Erreur de récupération de la localisation ou des horaires : $e');
  }
}

  // Récupérer les horaires de prière depuis l'API backend
  Future<void> _getPrayerTimes(String city, String country) async {
    try {
        final url = 'http://192.168.100.8:3001/prayer-times/today?city=$city&country=$country&method=2';
     // final url = 'http://192.168.1.21:3001/prayer-times/today?city=$city&country=$country&method=2';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() async {
          // Mettre à jour les horaires des prières
          prayers = [
            {'name': 'Fajr', 'time': data['Fajr']},
            {'name': 'Dhuhr', 'time': data['Dhuhr']},
            {'name': 'Asr', 'time': data['Asr']},
            {'name': 'Maghrib', 'time': data['Maghrib']},
            {'name': 'Isha', 'time': data['Isha']},
          ];

          // Date Hijri et grégorienne
          final now = DateTime.now();
          gregorianDate = DateFormat('dd-MM-yyyy').format(now);

          // Obtenir la date Hijri
          hijriDate = await _getHijriDate(now);

          // Calculer le countdown pour la prochaine prière
          _setCountdown();
        });
      } else {
        throw Exception('Failed to load prayer times');
      }
    } catch (e) {
      print('Erreur de récupération des horaires : $e');
    }
  }


  Future<String> _getHijriDate(DateTime date) async {
  try {
    // Convertir la date grégorienne en date Hijri
    HijriCalendar hijriDate = HijriCalendar.fromDate(date);

    // Formater la date Hijri comme souhaité (par exemple, "12 Rabi' al-Awwal 1446")
    String hijriFormattedDate = '${hijriDate.hDay} ${hijriDate.longMonthName} ${hijriDate.hYear}';

    return hijriFormattedDate;  // Retourner la date Hijri formatée
  } catch (e) {
    return 'Hijri date not available';
  }
}

  // Fonction pour calculer le countdown pour la prochaine prière
  void _setCountdown() {
    final now = DateTime.now();
    for (var prayer in prayers) {
      final prayerTime = _convertToDateTime(prayer['time']!);
      if (prayerTime.isAfter(now)) {
        setState(() {
          countdownEndTime = prayerTime.millisecondsSinceEpoch;
        });
        break;
      }
    }
  }

  // Fonction pour convertir l'heure de prière au format String en DateTime
  DateTime _convertToDateTime(String prayerTime) {
    final parts = prayerTime.split(':');
    return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, int.parse(parts[0]), int.parse(parts[1]));
  }

  IconData getPrayerIcon(String prayerName) {
  switch (prayerName) {
    case 'Fajr':
      return Icons.wb_twilight; // Icône pour l'aube
    case 'Dhuhr':
      return Icons.wb_sunny; // Icône pour midi
    case 'Asr':
      return Icons.wb_cloudy; // Icône pour l'après-midi
    case 'Maghrib':
      return Icons.nightlight; // Icône pour le coucher du soleil
    case 'Isha':
      return Icons.nights_stay; // Icône pour la nuit
    default:
      return Icons.access_time; // Icône par défaut
  }
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        // Image de fond générale
        Positioned.fill(
          child: Image.asset(
            'assets/b.jpg',  // Remplace avec ton image de fond générale
            fit: BoxFit.cover,
          ),
        ),
        // Contenu au-dessus de l'image
        Column(
          children: [

            Stack(
  children: [
    // Ombre sous la vague pour effet 3D
  Positioned(
  top: 2,
  left: 0,
  right: 0,
  child: SizedBox(
    height: 15, 
    child: ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        width: double.infinity,
        color: Colors.blue.shade900.withOpacity(0.5), // Ombre en arrière
      ),
    ),
  ),
),

// Vague principale avec effet 3D
SizedBox(
  height: 170, // Assure que ClipPath a une hauteur définie
  width: double.infinity,
  child: ClipPath(
    clipper: WaveClipperTwo(), // Vérifie si c'est bien le clipper voulu
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade600], // Dégradé 3D
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          "إِنَّ الصَّلَاةَ كَانَتْ عَلَى الْمُؤْمِنِينَ كِتَابًا مَوْقُوتًا", // Correction du texte pour refléter le clipper utilisé
          style: TextStyle(color:  Color(0xFF04065B), fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  ),
),

  ],
),











            //aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
            Container(
 // margin: EdgeInsets.all(20),
 margin: EdgeInsets.only(top: 22, left: 5, right: 5, bottom: 10),
  decoration: BoxDecoration(
    //color: Colors.blue[300],
    // borderRadius: BorderRadius.only(
    //    topLeft: Radius.circular(90), 
    //    topRight: Radius.circular(90),
    //   bottomLeft: Radius.circular(90),
    //   bottomRight: Radius.circular(90),
    // ),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Padding(
    padding: EdgeInsets.all(25.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          hijriDate,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.blue[800]),
        ),
        SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 18, color: Color(0xFF2A86BF)),
            SizedBox(width: 5),
            Text(
              location,
              style: TextStyle(fontSize: 13,color:Color(0xFF2A86BF)),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text('Next Prayer Countdown', style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF2A86BF), )),
        if (countdownEndTime != null)
          CountdownTimer(
            endTime: countdownEndTime!,
            widgetBuilder: (_, time) {
              if (time == null) {
                return Text('It\'s time for prayer!');
              }
              return Text(
                '- ${time.hours ?? '00'}:${time.min ?? '00'}:${time.sec ?? '00'}',
                style: TextStyle(fontSize: 24,color: Colors.red[800]),
              );
            },
          ),
      ],
    ),
  ),
),

           //aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

           
           
            Container(
              margin: EdgeInsets.all(20),
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage('assets/b.jpg'),  // Remplace avec ton image de fond spécifique pour la liste des prières
              //     fit: BoxFit.cover, // Pour s'assurer que l'image couvre tout le conteneur
              //   ),
              //   borderRadius: BorderRadius.circular(12),
              // ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Prayer Times', style: TextStyle(fontSize:20,fontWeight: FontWeight.bold, color:Color(0xFF2A86BF))),
                    ...prayers.map((prayer) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                       child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        Icon(getPrayerIcon(prayer['name']!), color: Color(0xFF2A86BF), size: 23), // Ajout de l'icône
        SizedBox(width: 8), // Espacement entre l'icône et le texte
        Text(
          prayer['name']!,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    ),
    Text(
      prayer['time']!,
      style: TextStyle(fontSize: 18, color: Colors.white),
    ),
  ],
),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            //  SizedBox(height: 5), // Espace avant le texte
          
          ],
          
        ),
    
      ],
    ),
  );
}

}