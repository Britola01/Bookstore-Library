
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/livros.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EdicaoLivrosScreen extends StatefulWidget {
  final Livros livro;

  EdicaoLivrosScreen({required this.livro});

  @override
  _EdicaoLivrosScreenState createState() => _EdicaoLivrosScreenState();
}

class _EdicaoLivrosScreenState extends State<EdicaoLivrosScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tituloController.text = widget.livro.titulo;
    _generoController.text = widget.livro.genero;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _generoController.dispose();
    super.dispose();
  }

  void _atualizarLivro() {
    firestore.collection('livros').doc(widget.livro.id).update({
      'titulo': _tituloController.text,
      'genero': _generoController.text,
    }).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Livro atualizado com sucesso.')));
      Navigator.of(context).pop();
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao atualizar livro: $error')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar livro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'titulo'),
            ),
            TextField(
              controller: _generoController,
              decoration: InputDecoration(labelText: 'genero'),
            ),
            ElevatedButton(
              child: Text('Salvar Alterações'),
              onPressed: _atualizarLivro,
            ),
          ],
        ),
      ),
    );
  }
}