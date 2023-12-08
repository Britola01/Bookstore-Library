
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/autor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EdicaoAutoresScreen extends StatefulWidget {
  final Autor autor;

  EdicaoAutoresScreen({required this.autor});

  @override
  _EdicaoAutoresScreenState createState() => _EdicaoAutoresScreenState();
}

class _EdicaoAutoresScreenState extends State<EdicaoAutoresScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _nacionalidadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.autor.nome;
    _nacionalidadeController.text = widget.autor.nacionalidade;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _nacionalidadeController.dispose();
    super.dispose();
  }

  void _atualizarAutor() {
    firestore.collection('autors').doc(widget.autor.id).update({
      'nome': _nomeController.text,
      'nacionalidade': _nacionalidadeController.text,
    }).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('autor atualizado com sucesso.')));
      Navigator.of(context).pop();
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao atualizar autor: $error')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar autor'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _nacionalidadeController,
              decoration: InputDecoration(labelText: 'nacionalidade'),
            ),
            ElevatedButton(
              child: Text('Salvar Alterações'),
              onPressed: _atualizarAutor,
            ),
          ],
        ),
      ),
    );
  }
}