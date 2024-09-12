import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CadastroEspecieScreen extends StatefulWidget {
  @override
  _CadastroEspecieScreenState createState() => _CadastroEspecieScreenState();
}

class _CadastroEspecieScreenState extends State<CadastroEspecieScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeEspecieController = TextEditingController();

  Future<void> _cadastrarEspecie() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/especies/'), // Substitua pela URL da sua API
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nome_especie': _nomeEspecieController.text,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Espécie cadastrada com sucesso!')),
        );
        _nomeEspecieController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao cadastrar espécie.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Espécie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeEspecieController,
                decoration: InputDecoration(labelText: 'Nome da Espécie'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da espécie';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _cadastrarEspecie,
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
