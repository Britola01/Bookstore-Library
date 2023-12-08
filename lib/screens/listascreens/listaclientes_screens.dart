import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/edits/editclientes.dart';
import 'package:flutter_application_1/model/clientes.dart';

class ListaClientesScreen extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Clientes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('clientes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erro ao carregar a lista de clientes.');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var cliente = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(cliente['nome']),
                subtitle: Text('${cliente['cpf']}\nBairro: ${cliente['bairro'] ?? 'Não informado'}\nRua: ${cliente['rua'] ?? 'Não informado'}\nNúmero: ${cliente['numeroCasa'] ?? 'Não informado'}'),
                isThreeLine: true,  
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Clientes clienteParaEditar = Clientes(
                          id: docs[index].id,
                          nome: cliente['nome'],
                          cpf: cliente['cpf'],
                          bairro: cliente['bairro'] ?? '',  
                          rua: cliente['rua'] ?? '',        
                          numeroCasa: cliente['numeroCasa'] ?? '',  
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EdicaoClienteScreen(cliente: clienteParaEditar),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _excluirCliente(docs[index].id, context);
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

  void _excluirCliente(String docId, BuildContext context) {
    firestore.collection('clientes').doc(docId).delete().then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Cliente excluído com sucesso.')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao excluir cliente: $error')));
    });
  }
}
