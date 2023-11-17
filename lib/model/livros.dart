import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Livros {
  String id;
  String titulo;
  String genero;

  Livros({required this.id, required this.titulo, required this.genero});


  factory Livros.fromSnapshot(DocumentSnapshot snapshot) {
    return Livros(
      id: snapshot.id,
      titulo: snapshot['titulo'] ?? '',
      genero: snapshot['genero'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'genero': genero,
    };
  }
}

FirebaseFirestore firestore = FirebaseFirestore.instance;
