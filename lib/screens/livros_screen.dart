
import 'package:flutter/material.dart';
import 'package:flutter_application_1/crud/cadastro_livro_screen.dart';
import 'package:flutter_application_1/screens/listascreens/listalivros_screens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:ui';

FirebaseDatabase database = FirebaseDatabase.instance;

class LivrosScreen extends StatefulWidget {
  @override
  _LivrosScreenState createState() => _LivrosScreenState();
}

class _LivrosScreenState extends State<LivrosScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/fundo_livros.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Gerenciamento de Livros'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRect(  
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), 
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        filled: true, 
                        fillColor: Colors.grey.withOpacity(0.5),
                        labelText: 'Buscar Livros',
                        hintText: 'Digite o nome do Livro',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () => setState(() {}),
                        ),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: Text('   Cadastro Livro    '),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CadastroLivrosScreen()),
                  );
                  setState(() {}); 
                },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: Text('Alterações Livros'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListaLivrosScreen()),
                  );
                },
                ),
              ),
               Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection('livros')
                      .where('titulo', isGreaterThanOrEqualTo: searchController.text)
                      .where('titulo', isLessThan: searchController.text + '\uf8ff')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Erro ao carregar livros');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
                    return ListView.separated(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var livro = docs[index].data() as Map<String, dynamic>;
                        return FutureBuilder<DocumentSnapshot>(
                          future: firestore.collection('autores').doc(livro['autorId']).get(),
                          builder: (context, snapshotAutor) {
                            if (!snapshotAutor.hasData) return SizedBox();
                            var autor = snapshotAutor.data!.data() as Map<String, dynamic>;
                            return Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              child: ListTile(
                                title: Text(livro['titulo']),
                                subtitle: Text(autor['nome']), 
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}