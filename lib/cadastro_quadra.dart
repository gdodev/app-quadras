import 'package:app_quadras/esporte.dart';
import 'package:app_quadras/quadra.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CadastroQuadra extends StatefulWidget {
  const CadastroQuadra({super.key, this.quadra});

  final Quadra? quadra;

  @override
  State<CadastroQuadra> createState() => _CadastroQuadraState();
}

class _CadastroQuadraState extends State<CadastroQuadra> {
  List<Esporte> esportes = [];
  late TextEditingController descricaoController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<Esporte, bool> esportesHabilitados = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    descricaoController = TextEditingController();
    if (widget.quadra != null) {
      descricaoController = TextEditingController(text: widget.quadra!.descricao);
    }
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
            id: e["id"],
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
    if (widget.quadra != null) {
      for (var esp in esportesHabilitados.entries) {
        print("quadra ${widget.quadra!.descricao} contém esporte ${esp.key}? ${widget.quadra!.esportesHabilitados.contains(esp.key)}");
        if (widget.quadra!.esportesHabilitados.contains(esp.key)) {
          esportesHabilitados[esp.key] = true;
        }
      }
      setState(() {});
    }
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
                  try {
                    final supabase = Supabase.instance.client;
                    await supabase.from("quadra").insert({
                      "descricao": descricaoController.text,
                    });
                    List<Map<String, dynamic>> registros =
                        await supabase //
                            .from("quadra")
                            .select()
                            .eq("descricao", descricaoController.text);
                    var idQuadra = registros.first["id"];
                    for (var entry in esportesHabilitados.entries) {
                      print("${entry.key.id}, ${entry.key.descricao}, marcado: ${entry.value}");
                    }
                    for (var esporte in esportesHabilitados.entries.where((element) => element.value)) {
                      await supabase.from("quadra_esporte").insert({
                        "quadra_id": idQuadra,
                        "esporte_id": esporte.key.id,
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Cadastro realizado com sucesso!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Ocorreu um erro durante o cadastro"),
                        backgroundColor: Colors.red,
                      ),
                    );
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
