class Esporte {
  final String descricao;
  final int numeroJogadores;

  Esporte({
    required this.descricao,
    required this.numeroJogadores,
  });

  @override
  String toString() {
    return "descricao: $descricao - nr_jogadores: $numeroJogadores";
  }
}
