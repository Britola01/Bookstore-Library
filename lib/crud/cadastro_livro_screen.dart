import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/livros.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/crud/cadastro_autor_screen.dart'; 

FirebaseDatabase database = FirebaseDatabase.instance;

Future<void> adicionarLivro(String titulo, String genero, String autorId) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('livros').add({
      'titulo': titulo,
      'genero': genero,
      'autorId': autorId, 
    });
  } catch (e) {
    print('Erro ao adicionar livro: $e');
    throw e;  
  }
}

class CadastroLivrosScreen extends StatefulWidget {
  @override
  _CadastroLivrosScreenState createState() => _CadastroLivrosScreenState();
}

class _CadastroLivrosScreenState extends State<CadastroLivrosScreen> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController generoController = TextEditingController();
  String? selectedAutorId; 

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Livro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: tituloController,
              decoration: InputDecoration(labelText: 'Título do Livro'),
            ),
            TextField(
              controller: generoController,
              decoration: InputDecoration(labelText: 'Gênero do Livro'),
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
              child: Text('Salvar Livros'),
              onPressed: () async {
                final String titulo = tituloController.text;
                final String genero = generoController.text;
                if (titulo.isNotEmpty && genero.isNotEmpty && selectedAutorId != null) {
                  try {
                    await adicionarLivro(titulo, genero, selectedAutorId!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Livro salvo com sucesso!')),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao salvar Livro: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, preencha todos os campos')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
