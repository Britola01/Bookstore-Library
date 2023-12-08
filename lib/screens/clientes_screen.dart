import 'package:flutter/material.dart';
import 'package:flutter_application_1/crud/cadastro_cliente_screen.dart';
import 'package:flutter_application_1/screens/listascreens/listaclientes_screens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:ui';

FirebaseDatabase database = FirebaseDatabase.instance;

class ClientesScreen extends StatefulWidget {
  @override
  _ClientesScreenState createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/fundo_clientes.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                        labelText: 'Buscar Cliente',
                        hintText: 'Digite o nome do Cliente',
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
                  child: Text('   Cadastro Cliente   '),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CadastroClienteScreen()),
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
                  child: Text('Alterações Clientes'),
                  onPressed: () {
                    _listarClientes(context);
                  },
                ),
              ),
                Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _searchStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Erro ao carregar clientes');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
                    return ListView.separated(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var cliente = docs[index].data() as Map<String, dynamic>;
                        return InkWell(
                          onTap: () => _mostrarDetalhesDoCliente(cliente),
                          child: Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: ListTile(
                            title: Text(cliente['nome']),
                            subtitle: Text(cliente['cpf']),
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

  void _mostrarDetalhesDoCliente(Map<String, dynamic> cliente) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(cliente['nome']),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('CPF: ${cliente['cpf']}'),
                Text('Bairro: ${cliente['bairro'] ?? ''}'),
                Text('Rua: ${cliente['rua'] ?? ''}'),
                Text('Número: ${cliente['numeroCasa'] ?? ''}'),
                
              ],
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

bool _isCPF(String query) {
  return RegExp(r'^\d{11}$').hasMatch(query) ||
         RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$').hasMatch(query); 
}

String _formatCPF(String cpf) {
  return cpf.replaceAll(RegExp(r'[\.\-]'), '');
}

Stream<QuerySnapshot> _searchStream() {
  var query = searchController.text.trim();
  if (query.isEmpty) {
    return firestore.collection('clientes').snapshots();
  }

  if (_isCPF(query)) {
    String formattedCPF = _formatCPF(query);
    return firestore.collection('clientes')
      .where('cpf', isEqualTo: formattedCPF)
      .snapshots();
  } else {
    return firestore.collection('clientes')
      .where('nome', isGreaterThanOrEqualTo: query)
      .where('nome', isLessThanOrEqualTo: query + '\uf8ff')
      .snapshots();
  }
}


  void _listarClientes(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ListaClientesScreen(),
      ),
    );
  }
}