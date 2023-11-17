
import 'dart:ui'; 
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/main.dart'; 
class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _passwordVisible = false;
  bool _isFieldFocused = false;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _nameFocusNode.addListener(() {
      setState(() {
        _isFieldFocused = _nameFocusNode.hasFocus || _emailFocusNode.hasFocus || _passwordFocusNode.hasFocus;
      });
    });

    _emailFocusNode.addListener(() {
      setState(() {
        _isFieldFocused = _nameFocusNode.hasFocus || _emailFocusNode.hasFocus || _passwordFocusNode.hasFocus;
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        _isFieldFocused = _nameFocusNode.hasFocus || _emailFocusNode.hasFocus || _passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool validarEmail(String email) {
    return email.endsWith('@gmail.com') || email.endsWith('@hotmail.com') || email.endsWith('@outlook.com') || email.endsWith('@yahoo.com') || email.endsWith('@uol.com');
  }

  bool validarSenha(String senha) {
    bool temLetraMaiuscula = senha.contains(RegExp(r'[A-Z]'));
    bool temNumero = senha.contains(RegExp(r'[0-9]'));
    bool temCaractereEspecial = senha.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return temLetraMaiuscula && temNumero && temCaractereEspecial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fundo_login.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (_isFieldFocused)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(color: Colors.black.withOpacity(0)),
            ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      focusNode: _nameFocusNode,
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nome Completo',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      focusNode: _emailFocusNode,
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.0),
                      TextField(
                        focusNode: _passwordFocusNode,
                        controller: passwordController,
                        obscureText: !_passwordVisible, 
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible; 
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
              ElevatedButton(
              onPressed: () async {
                String email = emailController.text;
                String password = passwordController.text;

                if (validarEmail(email) && validarSenha(password)) {
                  try {
                    
                    await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  } on FirebaseAuthException catch (e) {
                    
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(e.message ?? 'Erro ao realizar o cadastro.'),
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Por favor, insira um e-mail válido e uma senha com pelo menos um caractere especial, um número e uma letra maiúscula.'),
                  ));
                }
              },
              child: Text('Cadastrar'),
            ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
