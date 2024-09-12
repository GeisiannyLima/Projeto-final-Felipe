import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CadastroClienteScreen extends StatefulWidget {
  @override
  _CadastroClienteScreenState createState() => _CadastroClienteScreenState();
}

class _CadastroClienteScreenState extends State<CadastroClienteScreen> {
  int _currentStep = 0;

  // Controllers para os formulários
  final _clienteFormKey = GlobalKey<FormState>();
  final _especieFormKey = GlobalKey<FormState>();
  final _animalFormKey = GlobalKey<FormState>();
  final _veterinarioFormKey = GlobalKey<FormState>(); // Formulário do veterinário
  final _tratamentoFormKey = GlobalKey<FormState>();
  final _exameFormKey = GlobalKey<FormState>();
  final _consultaFormKey = GlobalKey<FormState>();

  // Controllers de texto para Cliente
  final TextEditingController _nomeClienteController = TextEditingController();
  final TextEditingController _enderecoClienteController =
      TextEditingController();
  final TextEditingController _cepClienteController = TextEditingController();
  final TextEditingController _telefoneClienteController =
      TextEditingController();
  final TextEditingController _emailClienteController = TextEditingController();

  // Controllers de texto para Espécie
  final TextEditingController _nomeEspecieController = TextEditingController();

  // Controllers de texto para Animal
  final TextEditingController _nomeAnimalController = TextEditingController();
  final TextEditingController _idadeAnimalController = TextEditingController();
  String _sexoAnimal = 'Macho'; // Valor inicial para o dropdown

  // Controllers de texto para Veterinário
  final TextEditingController _nomeVeterinarioController = TextEditingController();
  final TextEditingController _enderecoVeterinarioController = TextEditingController();
  final TextEditingController _cepVeterinarioController = TextEditingController();
  final TextEditingController _telefoneVeterinarioController = TextEditingController();
  final TextEditingController _emailVeterinarioController = TextEditingController();

  // Controllers de texto para Tratamento
  final TextEditingController _dataInicialTratamentoController =
      TextEditingController();
  final TextEditingController _dataFinalTratamentoController =
      TextEditingController();

  // Controllers de texto para Exame
  final TextEditingController _descricaoExameController = TextEditingController();

  // Controllers de texto para Consulta
  final TextEditingController _dataConsultaController = TextEditingController();
  final TextEditingController _relatoConsultaController = TextEditingController();

  // IDs de referência para associar os dados nas requisições
  int? _clienteId;
  int? _especieId;
  int? _animalId;
  int? _veterinarioId; // ID do veterinário
  int? _tratamentoId;
  int? _exameId;

  // Função para avançar a etapa do formulário
  void _nextStep() {
    if (_currentStep < 5) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  // Função para voltar à etapa anterior do formulário
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  // Função para cadastrar o Cliente
  Future<void> _cadastrarCliente() async {
    if (_clienteFormKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/clientes/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome_cliente': _nomeClienteController.text,
          'endereco_cliente': _enderecoClienteController.text,
          'cep_cliente': int.tryParse(_cepClienteController.text),
          'telefone_cliente': _telefoneClienteController.text,
          'email_cliente': _emailClienteController.text,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          _clienteId = json.decode(response.body)['id'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cliente cadastrado com sucesso!')),
        );
        _nextStep();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar cliente: ${response.body}')),
        );
      }
    }
  }

  // Função para cadastrar a Espécie
  Future<void> _cadastrarEspecie() async {
    if (_especieFormKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/especies/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome_especie': _nomeEspecieController.text,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          _especieId = json.decode(response.body)['id'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Espécie cadastrada com sucesso!')),
        );
        _nextStep();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar espécie: ${response.body}')),
        );
      }
    }
  }

  // Função para cadastrar o Veterinário
  Future<void> _cadastrarVeterinario() async {
    if (_veterinarioFormKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/veterinarios/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome_veterinario': _nomeVeterinarioController.text,
          'endereco_veterinario': _enderecoVeterinarioController.text,
          'cep_veterinario': int.tryParse(_cepVeterinarioController.text),
          'telefone_veterinario': _telefoneVeterinarioController.text,
          'email_veterinario': _emailVeterinarioController.text,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          _veterinarioId = json.decode(response.body)['id'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veterinário cadastrado com sucesso!')),
        );
        _nextStep();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar veterinário: ${response.body}')),
        );
      }
    }
  }

  // Função para cadastrar o Animal
  Future<void> _cadastrarAnimal() async {
    if (_animalFormKey.currentState!.validate() && _clienteId != null) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/animais/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome_animal': _nomeAnimalController.text,
          'idade_animal': int.tryParse(_idadeAnimalController.text),
          'sexo_animal': _sexoAnimal == 'Macho' ? 1 : 2,
          'cliente': _clienteId,
          'especie': _especieId,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          _animalId = json.decode(response.body)['id'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Animal cadastrado com sucesso!')),
        );
        _nextStep();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar animal: ${response.body}')),
        );
      }
    }
  }

  // Função para cadastrar o Tratamento
  Future<void> _cadastrarTratamento() async {
    if (_tratamentoFormKey.currentState!.validate() && _animalId != null) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/tratamentos/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'data_inicial_tratamento': _dataInicialTratamentoController.text,
          'data_final_tratamento': _dataFinalTratamentoController.text,
          'animal': _animalId,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          _tratamentoId = json.decode(response.body)['id'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tratamento cadastrado com sucesso!')),
        );
        _nextStep();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar tratamento: ${response.body}')),
        );
      }
    }
  }

  // Função para cadastrar o Exame
  Future<void> _cadastrarExame() async {
    if (_exameFormKey.currentState!.validate() && _tratamentoId != null) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/exames/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'descricao_exame': _descricaoExameController.text,
          'tratamento': _tratamentoId,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          _exameId = json.decode(response.body)['id'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exame cadastrado com sucesso!')),
        );
        _nextStep();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar exame: ${response.body}')),
        );
      }
    }
  }

  // Função para cadastrar a Consulta
  Future<void> _cadastrarConsulta() async {
    if (_consultaFormKey.currentState!.validate() && _exameId != null) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/consultas/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'data_consulta': _dataConsultaController.text,
          'relato_consulta': _relatoConsultaController.text,
          'exame': [_exameId],
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Consulta cadastrada com sucesso!')),
        );
        _nextStep();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar consulta: ${response.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Cliente e Relacionados'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0) {
            _cadastrarCliente();
          } else if (_currentStep == 1) {
            _cadastrarEspecie();
          } else if (_currentStep == 2) {
            _cadastrarVeterinario(); // Adicionado para a 3ª etapa
          } else if (_currentStep == 3) {
            _cadastrarAnimal();
          } else if (_currentStep == 4) {
            _cadastrarTratamento();
          } else if (_currentStep == 5) {
            _cadastrarExame();
          } else if (_currentStep == 6) {
            _cadastrarConsulta();
          }
        },
        onStepCancel: _previousStep,
        steps: [
          Step(
            title: Text('Cadastro de Cliente'),
            content: Form(
              key: _clienteFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeClienteController,
                    decoration: InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome do cliente';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _enderecoClienteController,
                    decoration: InputDecoration(labelText: 'Endereço'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o endereço do cliente';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cepClienteController,
                    decoration: InputDecoration(labelText: 'CEP'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o CEP do cliente';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Por favor, insira um CEP válido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _telefoneClienteController,
                    decoration: InputDecoration(labelText: 'Telefone'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o telefone do cliente';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailClienteController,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o email do cliente';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Por favor, insira um email válido';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: Text('Cadastro de Espécie'),
            content: Form(
              key: _especieFormKey,
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
                ],
              ),
            ),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: Text('Cadastro de Veterinário'),
            content: Form(
              key: _veterinarioFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeVeterinarioController,
                    decoration: InputDecoration(labelText: 'Nome do Veterinário'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome do veterinário';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _enderecoVeterinarioController,
                    decoration: InputDecoration(labelText: 'Endereço do Veterinário'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o endereço do veterinário';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cepVeterinarioController,
                    decoration: InputDecoration(labelText: 'CEP do Veterinário'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o CEP do veterinário';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Por favor, insira um CEP válido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _telefoneVeterinarioController,
                    decoration: InputDecoration(labelText: 'Telefone do Veterinário'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o telefone do veterinário';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailVeterinarioController,
                    decoration: InputDecoration(labelText: 'Email do Veterinário'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o email do veterinário';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Por favor, insira um email válido';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 2,
          ),
          Step(
            title: Text('Cadastro de Animal'),
            content: Form(
              key: _animalFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeAnimalController,
                    decoration: InputDecoration(labelText: 'Nome do Animal'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome do animal';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _idadeAnimalController,
                    decoration: InputDecoration(labelText: 'Idade do Animal'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a idade do animal';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Por favor, insira uma idade válida';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _sexoAnimal,
                    onChanged: (newValue) {
                      setState(() {
                        _sexoAnimal = newValue!;
                      });
                    },
                    items: ['Macho', 'Fêmea'].map((sexo) {
                      return DropdownMenuItem(
                        value: sexo,
                        child: Text(sexo),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: 'Sexo do Animal'),
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 3,
          ),
          Step(
            title: Text('Cadastro de Tratamento'),
            content: Form(
              key: _tratamentoFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _dataInicialTratamentoController,
                    decoration:
                        InputDecoration(labelText: 'Data Inicial do Tratamento'),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a data inicial do tratamento';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _dataFinalTratamentoController,
                    decoration:
                        InputDecoration(labelText: 'Data Final do Tratamento'),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a data final do tratamento';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 4,
          ),
          Step(
            title: Text('Cadastro de Exame'),
            content: Form(
              key: _exameFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _descricaoExameController,
                    decoration: InputDecoration(labelText: 'Descrição do Exame'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a descrição do exame';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 5,
          ),
          Step(
            title: Text('Cadastro de Consulta'),
            content: Form(
              key: _consultaFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _dataConsultaController,
                    decoration: InputDecoration(labelText: 'Data da Consulta'),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a data da consulta';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _relatoConsultaController,
                    decoration: InputDecoration(labelText: 'Relato da Consulta'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o relato da consulta';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 6,
          ),
        ],
      ),
    );
  }
}
