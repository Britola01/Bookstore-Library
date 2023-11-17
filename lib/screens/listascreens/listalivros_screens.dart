import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/edits/editlivros.dart';
import 'package:flutter_application_1/model/livros.dart';

class ListaLivrosScreen extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Livros'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('livros').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erro ao carregar a lista de livros.');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var livroData = docs[index].data() as Map<String, dynamic>;
              Livros livro = Livros(id: docs[index].id, titulo: livroData['titulo'], genero: livroData['genero']);
              return ListTile(
                title: Text(livro.titulo),
                subtitle: Text(livro.genero),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EdicaoLivrosScreen(livro: livro),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _excluirLivro(docs[index].id, context);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _excluirLivro(String docId, BuildContext context) {
    firestore.collection('livros').doc(docId).delete().then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Livro excluído com sucesso.')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao excluir livro: $error')));
    });
  }
}
