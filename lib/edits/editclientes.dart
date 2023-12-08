import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/clientes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/crud/cadastro_cliente_screen.dart';

class EdicaoClienteScreen extends StatefulWidget {
  final Clientes cliente;

  EdicaoClienteScreen({required this.cliente});

  @override
  _EdicaoClienteScreenState createState() => _EdicaoClienteScreenState();
}

class _EdicaoClienteScreenState extends State<EdicaoClienteScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController(); 
  final TextEditingController _ruaController = TextEditingController();    
  final TextEditingController _numeroCasaController = TextEditingController(); 

  String formatarCPF(String cpf) {
    String novoCPF = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (novoCPF.length > 3) novoCPF = novoCPF.substring(0, 3) + '.' + novoCPF.substring(3);
    if (novoCPF.length > 7) novoCPF = novoCPF.substring(0, 7) + '.' + novoCPF.substring(7);
    if (novoCPF.length > 11) novoCPF = novoCPF.substring(0, 11) + '-' + novoCPF.substring(11, 13);
    return novoCPF;
  }


  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.cliente.nome;
    _cpfController.text = widget.cliente.cpf;
    _bairroController.text = widget.cliente.bairro; 
    _ruaController.text = widget.cliente.rua;      
    _numeroCasaController.text = widget.cliente.numeroCasa; 
     _cpfController.addListener(() {
      final text = _cpfController.text;
      _cpfController.value = _cpfController.value.copyWith(
        text: formatarCPF(text),
        selection: TextSelection.collapsed(offset: formatarCPF(text).length),
      );
    });
  }


  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _bairroController.dispose(); 
    _ruaController.dispose();    
    _numeroCasaController.dispose(); 
    super.dispose();
  }

  void _atualizarCliente() {
    firestore.collection('clientes').doc(widget.cliente.id).update({
      'nome': _nomeController.text,
      'cpf': _cpfController.text,
      'bairro': _bairroController.text, 
      'rua': _ruaController.text,       
      'numeroCasa': _numeroCasaController.text, 
    }).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Cliente atualizado com sucesso.')));
      Navigator.of(context).pop();
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao atualizar cliente: $error')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Cliente'),
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
              controller: _cpfController,
              decoration: InputDecoration(labelText: 'CPF'),
            ),
            TextField(
              controller: _bairroController,
              decoration: InputDecoration(labelText: 'Bairro'), 
            ),
            TextField(
              controller: _ruaController,
              decoration: InputDecoration(labelText: 'Rua'), 
            ),
            TextField(
              controller: _numeroCasaController,
              decoration: InputDecoration(labelText: 'Número da Casa'), 
            ),
            ElevatedButton(
              child: Text('Salvar Alterações'),
              onPressed: _atualizarCliente,
            ),
          ],
        ),
      ),
    );
  }
}
