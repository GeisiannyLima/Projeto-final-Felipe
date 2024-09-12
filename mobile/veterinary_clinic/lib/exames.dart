import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListaExamesScreen extends StatefulWidget {
  @override
  _ListaExamesScreenState createState() => _ListaExamesScreenState();
}

class _ListaExamesScreenState extends State<ListaExamesScreen> {
  List<Exame> exames = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExames();
  }

  Future<void> fetchExames() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/exames/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        exames = data.map((item) => Exame.fromJson(item)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Trate o erro de acordo
    }
  }

  Future<void> deleteExame(int id) async {
    final response = await http.delete(Uri.parse('http://127.0.0.1:8000/exames/$id/'));
    if (response.statusCode == 204) {
      setState(() {
        exames.removeWhere((exame) => exame.id == id);
      });
    } else {
      // Tratar erro ao deletar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar o exame')),
      );
    }
  }

  void editarExame(Exame exame) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarExameScreen(exame: exame),
      ),
    ).then((value) {
      if (value != null && value) {
        // Atualiza a lista de exames após edição
        fetchExames();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Exames'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: exames.length,
              itemBuilder: (context, index) {
                final exame = exames[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 4.0,
                  child: ListTile(
                    title: Text(
                      exame.descricao,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            editarExame(exame); // Função para editar exame
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.verified, color: Colors.green),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Confirmação'),
                                content: Text('Tem certeza que deseja Concluir este exame?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancelar'),
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
                                  TextButton(
                                    child: Text('Concluir'),
                                    onPressed: () {
                                      deleteExame(exame.id);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExameDetalheScreen(exameId: exame.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class ExameDetalheScreen extends StatefulWidget {
  final int exameId;

  ExameDetalheScreen({required this.exameId});

  @override
  _ExameDetalheScreenState createState() => _ExameDetalheScreenState();
}

class _ExameDetalheScreenState extends State<ExameDetalheScreen> {
  Map<String, dynamic>? exameDetalhes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExameDetalhes();
  }

  Future<void> fetchExameDetalhes() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/exames/${widget.exameId}/'));

    if (response.statusCode == 200) {
      setState(() {
        exameDetalhes = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Trate o erro de acordo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Exame'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : exameDetalhes == null
              ? Center(child: Text('Erro ao carregar detalhes.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Descrição:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        exameDetalhes!['descricao_exame'] ?? 'N/A',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class EditarExameScreen extends StatefulWidget {
  final Exame exame;

  EditarExameScreen({required this.exame});

  @override
  _EditarExameScreenState createState() => _EditarExameScreenState();
}

class _EditarExameScreenState extends State<EditarExameScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descricaoController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController(text: widget.exame.descricao);
  }

  Future<void> atualizarExame() async {
  setState(() {
    isLoading = true;
  });

  final response = await http.put(
    Uri.parse('http://127.0.0.1:8000/exames/${widget.exame.id}/'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'descricao_exame': _descricaoController.text}),
  );

  setState(() {
    isLoading = false;
  });

  if (response.statusCode == 200) {
    Navigator.pop(context, true);
  } else {
    // Aqui mostramos a resposta do erro
    print('Erro: ${response.body}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao atualizar o exame: ${response.body}')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Exame'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição do Exame'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          atualizarExame(); // Chama a função para atualizar
                        }
                      },
                      child: Text('Salvar Alterações'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// Modelo de Exame
class Exame {
  final int id;
  final String descricao;

  Exame({required this.id, required this.descricao});

  factory Exame.fromJson(Map<String, dynamic> json) {
    return Exame(
      id: json['id'],
      descricao: json['descricao_exame'],
    );
  }
}
