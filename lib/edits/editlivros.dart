
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/livros.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/crud/cadastro_autor_screen.dart'; 


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

  String? selectedAutorId;

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

void _atualizarLivro() async {
  try {
    await firestore.collection('livros').doc(widget.livro.id).update({
      'titulo': _tituloController.text,
      'genero': _generoController.text,
      'autorId': selectedAutorId, 
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Livro atualizado com sucesso.')));
    Navigator.of(context).pop();
  } catch (error) {
    print('Erro ao atualizar livro: $error');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Erro ao atualizar livro: $error')));
  }
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
                        StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('autores').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                List<DropdownMenuItem<String>> autorItems = snapshot.data!.docs
                  .map((doc) => DropdownMenuItem<String>(
                        child: Text(doc['nome']),
                        value: doc.id,
                      ))
                  .toList();
                return Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedAutorId,
                        hint: Text('Selecione um Autor'),
                        onChanged: (value) {
                          setState(() {
                            selectedAutorId = value;
                          });
                        },
                        items: autorItems,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CadastroAutorScreen()),
                        );
                      },
                    ),
                  ],
                );
              },
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