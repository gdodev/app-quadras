import 'package:app_quadras/esporte.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CadastroQuadra extends StatefulWidget {
  const CadastroQuadra({super.key});

  @override
  State<CadastroQuadra> createState() => _CadastroQuadraState();
}

class _CadastroQuadraState extends State<CadastroQuadra> {
  List<Esporte> esportes = [];
  TextEditingController descricaoController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // List<int> esportesHabilitados = [];
  Map<Esporte, bool> esportesHabilitados = {};

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
    esportesHabilitados.clear();
    for (var esp in esportes) {
      esportesHabilitados[esp] = false;
    }
    print("esportesHabilitados: $esportesHabilitados");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro Quadra"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Descrição",
              ),
              controller: descricaoController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Campo obrigatório";
                }
                return null;
              },
            ),
            ...esportes.map(
              (e) {
                return Row(
                  children: [
                    Checkbox.adaptive(
                      value: esportesHabilitados[e],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            esportesHabilitados[e] = value;
                          });
                          print("esportesHabilitados: $esportesHabilitados");
                        }
                      },
                    ),
                    Text(e.descricao),
                  ],
                );
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final supabase = await Supabase.instance.client;
                  supabase.from("quadra").insert({
                    "descricao": descricaoController.text,
                  });
                  var registros =
                      await supabase //
                          .from("quadra")
                          .select()
                          .eq("descricao", descricaoController.text);
                  var idQuadra = registros.first["id"];
                  for (var esporte in esportesHabilitados.entries.where((element) => element.value)) {
                    supabase.from("quadra_esporte").insert({"quadra_id": idQuadra, "esporte_id": esporte});
                  }
                }
              },
              child: Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
