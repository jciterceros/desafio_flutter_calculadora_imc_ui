import 'dart:io';

class ConsoleView {
  String lerEntrada(String mensagem) {
    print(mensagem);
    return stdin.readLineSync()!;
  }

  void exibirMensagem(String mensagem) {
    print(mensagem);
  }
}
