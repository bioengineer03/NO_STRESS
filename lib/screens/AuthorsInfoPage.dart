// ignore: file_names
import 'package:flutter/material.dart';
import 'package:no_stress/models/author.dart';

final List<Author> authors = [
  Author(
    name: "Campara Sofia",
    description: "Nata a Mantova il 9 febbraio 2002. Laureata in ingegneria Biomedica presso Unipd",
  ),
];

class AuthorsInfoPage extends StatelessWidget {
  const AuthorsInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info Autori'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: authors.length,
          separatorBuilder: (_, __) => Divider(height: 32),
          itemBuilder: (context, index) {
            final author = authors[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/sofia.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        author.name,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        author.description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
