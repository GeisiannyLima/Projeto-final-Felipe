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

  Future<List<Especie>> fetchEspecies() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/especies/'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Especie.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar espécies');
    }
  }

  Future<List<Animal>> fetchAnimais() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/animais/'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Animal.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar animais');
    }
  }

  Future<List<Tratamento>> fetchTratamentos() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/tratamentos/'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Tratamento.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar tratamentos');
    }
  }

  Future<List<Veterinario>> fetchVeterinarios() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/veterinarios/'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Veterinario.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar veterinários');
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
      body: ListView(
        children: [
          buildSection('Clientes', fetchClientes(), (cliente) => _buildClienteInfo(cliente)),
          buildSection('Animais', fetchAnimais(), (animal) => _buildAnimalInfo(animal)),
          buildSection('Tratamentos', fetchTratamentos(), (tratamento) => _buildTratamentoInfo(tratamento)),
          buildSection('Veterinários', fetchVeterinarios(), (veterinario) => _buildVeterinarioInfo(veterinario)),
        ],
      ),
    );
  }

  Widget buildSection<T>(String title, Future<List<T>> future, Widget Function(T) itemBuilder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
        ),
        FutureBuilder<List<T>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}', style: TextStyle(color: Colors.red)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Nenhum dado encontrado.'));
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  T item = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: itemBuilder(item),
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildClienteInfo(Cliente cliente) {
    return ListTile(
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
          Text("Endereço: ${cliente.enderecoCliente}"),
          Text("CEP: ${cliente.cepCliente}"),
          Text("Telefone: ${cliente.telefoneCliente}"),
          Text("Email: ${cliente.emailCliente}"),
        ],
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
      onTap: () {
        // Ação ao clicar no item
      },
    );
  }

  Widget _buildAnimalInfo(Animal animal) {
    return ListTile(
      contentPadding: EdgeInsets.all(16.0),
      title: Text(
        animal.nomeAnimal,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Idade: ${animal.idadeAnimal} anos"),
          Text("Sexo: ${animal.sexoAnimal == 1 ? 'Macho' : 'Fêmea'}"),
          Text("Cliente: ${animal.clienteNome}"),
          Text("Espécie: ${animal.especieNome}"),
        ],
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
      onTap: () {
        // Ação ao clicar no item
      },
    );
  }

  Widget _buildTratamentoInfo(Tratamento tratamento) {
    return ListTile(
      contentPadding: EdgeInsets.all(16.0),
      title: Text(
        tratamento.animalNome,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Data Inicial: ${tratamento.dataInicialTratamento}"),
          Text("Data Final: ${tratamento.dataFinalTratamento}"),
        ],
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
      onTap: () {
        // Ação ao clicar no item
      },
    );
  }

  Widget _buildVeterinarioInfo(Veterinario veterinario) {
    return ListTile(
      contentPadding: EdgeInsets.all(16.0),
      title: Text(
        veterinario.nomeVeterinario,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Endereço: ${veterinario.enderecoVeterinario}"),
          Text("CEP: ${veterinario.cepVeterinario}"),
          Text("Telefone: ${veterinario.telefoneVeterinario}"),
          Text("Email: ${veterinario.emailVeterinario}"),
        ],
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
      onTap: () {
        // Ação ao clicar no item
      },
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

class Especie {
  final String nomeEspecie;

  Especie({
    required this.nomeEspecie,
  });

  factory Especie.fromJson(Map<String, dynamic> json) {
    return Especie(
      nomeEspecie: json['nome_especie'] ?? 'Espécie não disponível',
    );
  }
}

class Animal {
  final String nomeAnimal;
  final int? idadeAnimal;
  final int? sexoAnimal;
  final String clienteNome;
  final String especieNome;

  Animal({
    required this.nomeAnimal,
    this.idadeAnimal,
    this.sexoAnimal,
    required this.clienteNome,
    required this.especieNome,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      nomeAnimal: json['nome_animal'] ?? 'Animal não disponível',
      idadeAnimal: json['idade_animal'],
      sexoAnimal: json['sexo_animal'],
      clienteNome: json['cliente_nome'] ?? 'Cliente não disponível',
      especieNome: json['especie_nome'] ?? 'Espécie não disponível',
    );
  }
}

class Tratamento {
  final String? dataInicialTratamento;
  final String? dataFinalTratamento;
  final String animalNome;

  Tratamento({
    this.dataInicialTratamento,
    this.dataFinalTratamento,
    required this.animalNome,
  });

  factory Tratamento.fromJson(Map<String, dynamic> json) {
    return Tratamento(
      dataInicialTratamento: json['data_inicial_tratamento'] ?? 'Data inicial não disponível',
      dataFinalTratamento: json['data_final_tratamento'] ?? 'Data final não disponível',
      animalNome: json['animal_nome'] ?? 'Animal não disponível',
    );
  }
}

class Veterinario {
  final String nomeVeterinario;
  final String enderecoVeterinario;
  final int? cepVeterinario;
  final String telefoneVeterinario;
  final String emailVeterinario;

  Veterinario({
    required this.nomeVeterinario,
    required this.enderecoVeterinario,
    this.cepVeterinario,
    required this.telefoneVeterinario,
    required this.emailVeterinario,
  });

  factory Veterinario.fromJson(Map<String, dynamic> json) {
    return Veterinario(
      nomeVeterinario: json['nome_veterinario'] ?? 'Nome não disponível',
      enderecoVeterinario: json['endereco_veterinario'] ?? 'Endereço não disponível',
      cepVeterinario: json['cep_veterinario'],
      telefoneVeterinario: json['telefone_veterinario'] ?? 'Telefone não disponível',
      emailVeterinario: json['email_veterinario'] ?? 'Email não disponível',
    );
  }
}
