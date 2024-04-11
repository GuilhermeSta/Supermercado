import 'package:flutter/material.dart';
import 'package:trabalho/view/tela_principal.dart';
import 'package:trabalho/view/tela_cadastro.dart';

class Login extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Simulando uma lista de usuários cadastrados
  final List<Map<String, String>> _registeredUsers = [
    {"email": "gui@gmail.com", "password": "123456"},
    {"email": "joao@gmail.com", "password": "123"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60, left: 40, right: 40),
        color: Color.fromARGB(255, 231, 231, 229),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 250,
              height: 250,
              child: Image.asset("assets/images/unaerp.png"),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(
                  color: Color.fromARGB(95, 233, 41, 41),
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(
                  color: const Color.fromARGB(96, 153, 33, 33),
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 1],
                  colors: [
                    Color.fromARGB(255, 60, 232, 245),
                    Color.fromARGB(255, 191, 236, 66),
                  ],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: SizedBox.expand(
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        child: SizedBox(
                          height: 28,
                          width: 28,
                        ),
                      )
                    ],
                  ),
                  onPressed: () {
                    _login(context);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 40,
              child: TextButton(
                child: Text(
                  "Cadastre-se",
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaCadastro(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login(BuildContext context) {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Verifica se os campos de e-mail e senha não estão vazios
    if (email.isNotEmpty && password.isNotEmpty) {
      // Verifica se as credenciais correspondem a um usuário cadastrado
      if (_isRegisteredUser(email, password)) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TelaPrincipal(),
          ),
        );
      } else {
        // Exibe um diálogo de erro se as credenciais estiverem incorretas
        _showErrorDialog(context, "E-mail ou senha incorretos");
      }
    } else {
      // Exibe um diálogo de erro se os campos estiverem vazios
      _showErrorDialog(context, "Por favor, preencha todos os campos");
    }
  }

  bool _isRegisteredUser(String email, String password) {
    // Verifica se existe um usuário com o e-mail e senha fornecidos na lista de usuários cadastrados
    for (var user in _registeredUsers) {
      if (user["email"] == email && user["password"] == password) {
        return true;
      }
    }
    return false;
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Erro"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}