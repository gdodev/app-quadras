import 'package:app_quadras/cadastro_esporte.dart';
import 'package:app_quadras/cadastro_quadra.dart';
import 'package:app_quadras/esporte.dart';
import 'package:app_quadras/quadra.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TelaQuadras extends StatefulWidget {
  const TelaQuadras({super.key});

  @override
  State<TelaQuadras> createState() => _TelaQuadrasState();
}

class _TelaQuadrasState extends State<TelaQuadras> {
  List<Quadra> quadras = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    consultarQuadras();
  }

  void consultarQuadras() async {
    quadras.clear();
    final supabase = Supabase.instance.client;
    var quadrasSupabase = await supabase.from("quadra").select();
    for (var quadra in quadrasSupabase) {
      var idsEsportesHabilitados = await supabase.from("quadra_esporte").select().eq("quadra_id", quadra["id"]);
      // print("descrição quadra: ${quadra["descricao"]} - ids esportes habilitados: $idsEsportesHabilitados");
      var esportesQuadra = <Esporte>[];
      for (var esporteHabilitado in idsEsportesHabilitados) {
        var registros = await supabase.from("esporte").select().eq("id", esporteHabilitado["esporte_id"]);
        esportesQuadra.add(
          Esporte(
            id: registros.first["id"],
            descricao: registros.first["descricao"],
            numeroJogadores: registros.first["numero_jogadores"],
          ),
        );
      }
      setState(() {
        quadras.add(
          Quadra(
            id: quadra["id"],
            descricao: quadra["descricao"],
            esportesHabilitados: esportesQuadra,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela Quadras"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 500,
          ),
          child: ListView.builder(
            itemCount: quadras.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return CadastroQuadra(
                          quadra: quadras[index],
                        );
                      },
                    ),
                  );
                },
                child: Card(
                  elevation: 8,
                  child: ListTile(
                    title: Text(quadras[index].descricao),
                    subtitle: Text("Esportes habilitados: ${quadras[index].esportesHabilitados.length}"),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) {
                    return CadastroQuadra();
                  },
                ),
              )
              .then(
                (value) {
                  if (value != null) {
                    print("value: $value");
                  }
                  consultarQuadras();
                },
              );
        },
      ),
    );
  }
}
