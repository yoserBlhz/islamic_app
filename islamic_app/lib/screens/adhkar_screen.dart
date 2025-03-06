import 'package:flutter/material.dart';
import 'package:islamic_app/screens/adhkarListPage.dart';

class AdhkarPage extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {"title": "Morning Adhkar", "icon": Icons.wb_sunny},
    {"title": "Evening Adhkar", "icon": Icons.nights_stay},
    {"title": "Prayers for the dead", "icon": Icons.account_circle},
    {"title": "Prophets Adhkar", "icon": Icons.menu_book},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Adhkar') , titleTextStyle: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            fontFamily: 'Amiri',
            color: Color(0xFF2A86BF)
          ),  
        backgroundColor: Color(0xFF020659),

      ),
      body: Stack(
        children: [
          // Arrière-plan
          Positioned.fill(
            child: Image.asset(
              'assets/b.jpg', // Image de fond
              fit: BoxFit.cover,
            ),
          ),
          // Liste des catégories
          ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white.withOpacity(0.8), // Légère opacité pour lisibilité
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: Icon(
                    categories[index]["icon"],
                    size: 40,
                    color: Colors.blue,
                  ),
                  title: Text(
                    categories[index]["title"],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AdhkarListPage(category: categories[index]["title"]),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
