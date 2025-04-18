class Pessoa {
  final String nome;
  final double peso;
  final double altura;
  late final double imc;

  Pessoa(this.nome, this.peso, this.altura) {
    imc = peso / (altura * altura);
  }

  @override
  String toString() {
    return 'Nome: $nome, Peso: $peso, Altura: $altura, IMC: ${imc.toStringAsFixed(2)}';
  }
}
