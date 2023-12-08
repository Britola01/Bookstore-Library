import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/model/autor.dart';
import 'package:flutter_application_1/edits/editautors.dart'; 

class ListaAutoresScreen extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Autores'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('autores').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erro ao carregar a lista de autores.');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var autorData = docs[index].data() as Map<String, dynamic>;
              Autor autor = Autor(id: docs[index].id, nome: autorData['nome'], nacionalidade: autorData['nacionalidade']);
              return ListTile(
                title: Text(autor.nome),
                subtitle: Text(autor.nacionalidade),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EdicaoAutoresScreen(autor: autor),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _excluirAutor(docs[index].id, context);
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

  void _excluirAutor(String docId, BuildContext context) {
    firestore.collection('autores').doc(docId).delete().then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Autor excluído com sucesso.')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao excluir autor: $error')));
    });
  }
}
