class Esporte {
  final int id;
  final String descricao;
  final int numeroJogadores;

  Esporte({
    required this.id,
    required this.descricao,
    required this.numeroJogadores,
  });

  @override
  String toString() {
    return "descricao: $descricao - nr_jogadores: $numeroJogadores";
  }
}
