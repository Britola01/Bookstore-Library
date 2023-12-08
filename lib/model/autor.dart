import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Autor {
  String id;
  String nome;
  String nacionalidade;

  Autor({required this.id, required this.nome, required this.nacionalidade});

  factory Autor.fromSnapshot(DocumentSnapshot snapshot) {
    return Autor(
      id: snapshot.id,
      nome: snapshot['nome'] ?? '',
      nacionalidade: snapshot['nacionalidade'] ?? '',
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'nacionalidade': nacionalidade,
    };
  }
}

FirebaseDatabase database = FirebaseDatabase.instance;