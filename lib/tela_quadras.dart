import 'package:app_quadras/cadastro_esporte.dart';
import 'package:app_quadras/esporte.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TelaQuadras extends StatefulWidget {
  const TelaQuadras({super.key});

  @override
  State<TelaQuadras> createState() => _TelaQuadrasState();
}

class _TelaQuadrasState extends State<TelaQuadras> {
  List<Esporte> esportes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    consultarEsportes();
  }

  void consultarEsportes() async {
    final supabase = Supabase.instance.client;
    final esportesSupabase = await supabase
        .from("esporte") //
        .select();
    print("esportes: $esportesSupabase");
    setState(() {
      esportes = esportesSupabase.map(
        (e) {
          print("id: $e");
          print("${e["id"]}");
          print("${e["descricao"]}");
          print("${e["numero_jogadores"]}");
          return Esporte(
            descricao: e["descricao"],
            numeroJogadores: e["numero_jogadores"],
          );
        },
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela Esportes"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 500,
          ),
          child: ListView.builder(
            itemCount: esportes.length,
            itemBuilder: (context, index) {
              final Esporte esporteCorrente = esportes[index];
              return Card(
                elevation: 8.0,
                child: ListTile(
                  leading: Icon(Icons.sports_basketball),
                  title: Text(esporteCorrente.descricao),
                  subtitle: Text("Nº de jogadores: ${esporteCorrente.numeroJogadores}"),
                  trailing: Text(index.toString()),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) {
                    return CadastroEsporte();
                  },
                ),
              )
              .then(
                (value) {
                  if (value != null) {
                    print("value: $value");
                  }
                  consultarEsportes();
                },
              );
        },
      ),
    );
  }
}
