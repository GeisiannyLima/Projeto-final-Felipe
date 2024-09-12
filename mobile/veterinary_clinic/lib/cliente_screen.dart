import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:veterinary_clinic/cadastro_client.dart';
import 'package:veterinary_clinic/exames.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clinica Veterinária',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    CadastroClienteScreen(),
    ListaDadosScreen(),
    ListaExamesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Cadastro Cliente',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Listas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Exames',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ListaDadosScreen extends StatefulWidget {
  @override
  _ListaDadosScreenState createState() => _ListaDadosScreenState();
}

class _ListaDadosScreenState extends State<ListaDadosScreen> {
  Future<List<Cliente>> fetchClientes() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/clientes/'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Cliente.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar clientes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listas de Dados'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Cliente>>(
        future: fetchClientes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum dado encontrado.'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Cliente cliente = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      cliente.nomeCliente,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text("Endereço: ${cliente.enderecoCliente}"),
                        Text("Telefone: ${cliente.telefoneCliente}"),
                        Text("Email: ${cliente.emailCliente}"),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                    onTap: () {
                      // Ação ao clicar no item, como abrir detalhes
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Modelos para parsear os dados da API
class Cliente {
  final String nomeCliente;
  final String enderecoCliente;
  final int? cepCliente;
  final String telefoneCliente;
  final String emailCliente;

  Cliente({
    required this.nomeCliente,
    required this.enderecoCliente,
    this.cepCliente,
    required this.telefoneCliente,
    required this.emailCliente,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      nomeCliente: json['nome_cliente'] ?? 'Nome não disponível',
      enderecoCliente: json['endereco_cliente'] ?? 'Endereço não disponível',
      cepCliente: json['cep_cliente'],
      telefoneCliente: json['telefone_cliente'] ?? 'Telefone não disponível',
      emailCliente: json['email_cliente'] ?? 'Email não disponível',
    );
  }
}
