import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/crud/cadastro_autor_screen.dart';
import 'package:flutter_application_1/screens/listascreens/listaautores_screens.dart';
import 'package:flutter_application_1/model/autor.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:ui';

FirebaseDatabase database = FirebaseDatabase.instance;

class AutoresScreen extends StatefulWidget {
  @override
  _AutoresScreenState createState() => _AutoresScreenState();
}

class _AutoresScreenState extends State<AutoresScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/fundo_autores.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Gerenciamento de Autores'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                        labelText: 'Buscar Autor',
                        hintText: 'Digite o nome do Autor',
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
                  child: Text('   Cadastro Autor     '),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CadastroAutorScreen()),
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
                  child: Text('Alterações Autores'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListaAutoresScreen()),
                    );
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _searchStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Erro ao carregar autores');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
            return ListView.separated(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                Autor autor = Autor.fromSnapshot(docs[index]);
                return InkWell(
                  onTap: () => _mostrarLivrosDoAutor(autor.id, autor.nome),
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: ListTile(
                      title: Text(autor.nome),
                      subtitle: Text(autor.nacionalidade),
                    ),
                  ),
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

  void _mostrarLivrosDoAutor(String autorId, String nomeAutor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Livros de $nomeAutor'),
          content: Container(
            width: double.maxFinite,
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('livros')
                  .where('autorId', isEqualTo: autorId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                var livros = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: livros.length,
                  itemBuilder: (context, index) {
                    var livro = livros[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(livro['titulo']),
                      subtitle: Text(livro['genero']),
                    );
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Stream<QuerySnapshot> _searchStream() {
    var query = searchController.text.trim();
    if (query.isEmpty) {
      return firestore.collection('autores').snapshots();
    }
    return firestore.collection('autores')
      .where('nome', isGreaterThanOrEqualTo: query)
      .where('nome', isLessThanOrEqualTo: query + '\uf8ff')
      .snapshots();
  }
}
