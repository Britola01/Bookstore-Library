import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/model/autor.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

class CadastroAutorScreen extends StatelessWidget {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController nacionalidadeController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Autor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome do Autor'),
            ),
            TextField(
              controller: nacionalidadeController,
              decoration: InputDecoration(labelText: 'Nacionalidade do Autor'),
            ),
            ElevatedButton(
              child: Text('Salvar Autor'),
              onPressed: () {
                final String nome = nomeController.text;
                final String nacionalidade = nacionalidadeController.text;
                if (nome.isNotEmpty && nacionalidade.isNotEmpty) {
                  salvarAutor(nome, nacionalidade, context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void salvarAutor(String nome, String nacionalidade, BuildContext context) {
    final Autor novoAutor = Autor(id: '', nome: nome, nacionalidade: nacionalidade);
    firestore.collection('autores').add(novoAutor.toMap()).then((_) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Autor salvo com sucesso.')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar autor: $error')));
    });
  }
}
