import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Clientes {
  String id;
  String nome;
  String cpf;
  String bairro;
  String rua; 
  String numeroCasa; 

  Clientes({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.bairro, 
    required this.rua, 
    required this.numeroCasa, 
  });

  factory Clientes.fromSnapshot(DocumentSnapshot snapshot) {
    return Clientes(
      id: snapshot.id,
      nome: snapshot['nome'] ?? '',
      cpf: snapshot['cpf'] ?? '',
      bairro: snapshot['bairro'] ?? '', 
      rua: snapshot['rua'] ?? '', 
      numeroCasa: snapshot['numeroCasa'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cpf': cpf,
      'bairro': bairro, 
      'rua': rua, 
      'numeroCasa': numeroCasa, 
    };
  }
}

FirebaseDatabase database = FirebaseDatabase.instance;
