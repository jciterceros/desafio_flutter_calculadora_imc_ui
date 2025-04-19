import 'package:desafio_flutter_calculadora_imc_ui/controllers/pessoa_controller.dart';
import 'package:desafio_flutter_calculadora_imc_ui/models/pessoa.dart';
import 'package:desafio_flutter_calculadora_imc_ui/services/classificacao_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final PessoaController pessoaController = PessoaController(
    ClassificacaoSaude(),
  );

  static const Color primaryColor = Color(0xFF6200EE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora IMC'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextField(
                controller: nomeController,
                label: 'Digite seu Nome',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: pesoController,
                label: 'Digite seu Peso (kg)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: alturaController,
                label: 'Digite sua Altura (cm)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 16.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: _calcularIMC,
                child: const Text('Calcular IMC'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        keyboardType: keyboardType,
        controller: controller,
      ),
    );
  }

  void _calcularIMC() {
    try {
      final String nome = nomeController.text;
      final String peso = pesoController.text;
      final String altura = alturaController.text;

      final resultado = pessoaController.calcularIMC(nome, peso, altura);
      final Pessoa pessoa = resultado['pessoa'];
      final String classificacao = resultado['classificacao'];

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              '${pessoa.nome}, seu IMC = ${pessoa.imc.toStringAsFixed(2)}',
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  _buildIMCTable(),
                  const SizedBox(height: 16),
                  Text(
                    'Classificação atual: $classificacao',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Fechar'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Fechar'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildIMCTable() {
    final classificacoes = [
      {'range': '< 16', 'label': 'Magreza grave'},
      {'range': '16 a < 17', 'label': 'Magreza moderada'},
      {'range': '17 a < 18,5', 'label': 'Magreza leve'},
      {'range': '18,5 a < 25', 'label': 'Saudável'},
      {'range': '25 a < 30', 'label': 'Sobrepeso'},
      {'range': '30 a < 35', 'label': 'Obesidade Grau I'},
      {'range': '35 a < 40', 'label': 'Obesidade Grau II (severa)'},
      {'range': '>= 40', 'label': 'Obesidade Grau III (mórbida)'},
    ];

    return Table(
      border: TableBorder.all(),
      columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[300]),
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'IMC',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Classificação',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        ...classificacoes.map((item) {
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(item['range']!, textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(item['label']!, textAlign: TextAlign.center),
              ),
            ],
          );
        }),
      ],
    );
  }
}
