import 'package:flutter/material.dart';

class TasbihPage extends StatefulWidget {
  @override
  _TasbihPageState createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> {
  List<String> tasbihList = [
    'سبحان الله', 
    'الحمد لله',  
    'الله أكبر',  
    'لا إله إلا الله',
    'سبحان الله وبحمده سبحان الله العظيم' ,
    'لا إله إلا أنت سبحانك إني كنت من الظالمين',
    'لا إله إلا الله، وحده لا شريك له، له الملك، وله الحمد، وهو على كل شيء قدير',
  ];

  int tasbihIndex = 0; // Index de la phrase actuelle
  int counter = 0; // Compteur de tasbih
  final int maxCount = 1000; // Maximum avant reset

  void incrementCounter() {
    setState(() {
      if (counter < maxCount) {
        counter++;
      } else {
        counter = 0; // Reset du compteur après 100
      }
    });
  }

  void changeTasbih() {
    setState(() {
      tasbihIndex = (tasbihIndex + 1) % tasbihList.length;
      counter = 0; // Reset le compteur quand on change le texte
    });
  }

  void addTasbih() {
    TextEditingController tasbihController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Tasbih",style: TextStyle(color: Colors.blue[800]),),
          content: TextField(
            controller: tasbihController,
            textAlign: TextAlign.right, // Alignement pour l'arabe
            decoration: InputDecoration(hintText: "Your Tasbih..."),
          ),
          actions: [
            TextButton(
              child: Text("Cancel",style: TextStyle(color: Colors.blue[800]),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Add",style: TextStyle(color: Colors.blue[800]),),
              onPressed: () {
                setState(() {
                  if (tasbihController.text.isNotEmpty) {
                    tasbihList.add(tasbihController.text);
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = counter / maxCount; // Progression de la Sebha

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "أَلا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Amiri', 
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl, 
        ),
        centerTitle: true, 
        backgroundColor: Colors.blue[800],
      ),
      body: GestureDetector(
        onTap: incrementCounter, // Incrémenter en tapant sur l'écran
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/b.jpg', // Image de fond
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cercle de progression
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 10,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                      Text(
                        "$counter",
                        style: TextStyle(
                          fontSize: 40, 
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2A86BF),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Affichage du texte de Tasbih
                  Text(
                    tasbihList[tasbihIndex],
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Amiri',
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(height: 30),
                 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: changeTasbih,
                        child: Text("Change Tasbih"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          textStyle: TextStyle(fontSize: 18),
                          backgroundColor: Color(0xFF2A86BF),
                        ),
                      ),
                      SizedBox(width: 10), // Espace entre les boutons
                      ElevatedButton(
                        onPressed: addTasbih,
                        child: Icon(Icons.add, size: 28), // Icône "+"
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(14),
                          backgroundColor: Color(0xFF2A86BF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
