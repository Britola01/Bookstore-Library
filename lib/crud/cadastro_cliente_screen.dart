import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/clientes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

Future<void> adicionarCliente(String nome, String cpf, String bairro, String rua, String numeroCasa) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('clientes').add({
      'nome': nome,
      'cpf': cpf,
      'bairro': bairro,
      'rua': rua,
      'numeroCasa': numeroCasa,
    });
  } catch (e) {
    print('Erro ao adicionar cliente: $e');
    throw e;  
  }
}

class CadastroClienteScreen extends StatefulWidget {
  @override
  _CadastroClienteScreenState createState() => _CadastroClienteScreenState();
}

class _CadastroClienteScreenState extends State<CadastroClienteScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController numeroCasaController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  @override
  void initState() {
    super.initState();
    cpfController.addListener(() {
      final text = cpfController.text;
      cpfController.value = cpfController.value.copyWith(
        text: formatarCPF(text),
        selection: TextSelection.collapsed(offset: formatarCPF(text).length),
      );
    });
  }

  String formatarCPF(String cpf) {
    String novoCPF = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (novoCPF.length > 3) novoCPF = novoCPF.substring(0, 3) + '.' + novoCPF.substring(3);
    if (novoCPF.length > 7) novoCPF = novoCPF.substring(0, 7) + '.' + novoCPF.substring(7);
    if (novoCPF.length > 11) novoCPF = novoCPF.substring(0, 11) + '-' + novoCPF.substring(11, 13);
    return novoCPF;
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome do Cliente'),
            ),
            TextField(
              controller: cpfController,
              decoration: InputDecoration(labelText: 'CPF do Cliente'),
            ),
            TextField(
              controller: bairroController,
              decoration: InputDecoration(labelText: 'Bairro'),
            ),
            TextField(
              controller: ruaController,
              decoration: InputDecoration(labelText: 'Rua'),
            ),
            TextField(
              controller: numeroCasaController,
              decoration: InputDecoration(labelText: 'Número da Casa'),
            ),
            ElevatedButton(
              child: Text('Salvar Cliente'),
              onPressed: () async {
                final String nome = nomeController.text;
                final String cpf = cpfController.text;
                final String bairro = bairroController.text;
                final String rua = ruaController.text;
                final String numeroCasa = numeroCasaController.text;

                if (nome.isNotEmpty && cpf.isNotEmpty && bairro.isNotEmpty && rua.isNotEmpty && numeroCasa.isNotEmpty) {
                  try {
                    await adicionarCliente(nome, cpf, bairro, rua, numeroCasa);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cliente salvo com sucesso!')),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao salvar cliente: $e')),
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