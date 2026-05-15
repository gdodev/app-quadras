import 'package:app_quadras/horario_funcionamento.dart';
import 'package:app_quadras/tela_fatias_horarios_funcionamento.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TelaHorariosFuncionamento extends StatefulWidget {
  const TelaHorariosFuncionamento({super.key});

  @override
  State<TelaHorariosFuncionamento> createState() => _TelaHorariosFuncionamentoState();
}

class _TelaHorariosFuncionamentoState extends State<TelaHorariosFuncionamento> {
  final List<String> diasSemana = [
    "Domingo",
    "Segunda",
    "Terça",
    "Quarta",
    "Quinta",
    "Sexta",
    "Sábado",
  ];
  var horariosFuncionamento = <HorarioFuncionamento>[];
  var estaCarregando = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    consultarHorariosFuncionamento();
  }

  void consultarHorariosFuncionamento() async {
    setState(() {
      estaCarregando = true;
    });
    horariosFuncionamento.clear();
    final supabase = Supabase.instance.client;
    var registrosSupabase = await supabase.from("horario_funcionamento").select();
    setState(() {
      horariosFuncionamento = registrosSupabase.map(
        (e) {
          return HorarioFuncionamento(
            id: e['id'],
            descricao: e['descricao'],
            horarioInicio: e['horario_inicio'],
            horarioFim: e['horario_fim'],
          );
        },
      ).toList();
      estaCarregando = false;
    });
  }

  bool verificarHorariosCadastrados(String descricaoDia) {
    return horariosFuncionamento.indexWhere((element) => element.descricao == descricaoDia) != -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Horários Funcionamento'),
      ),
      body: estaCarregando
          ? Center(
              child: Column(
                children: [
                  CircularProgressIndicator.adaptive(),
                  Text('Seus dados estão sendo carregados...'),
                ],
              ),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              child: ListView.builder(
                itemCount: diasSemana.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      var i = horariosFuncionamento.indexWhere((element) => element.descricao == diasSemana[index]);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return TelaFatiasHorariosFuncionamento(
                              descricaoDia: diasSemana[index],
                              horarioFuncionamento: i != -1 ? horariosFuncionamento[i] : null,
                            );
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: verificarHorariosCadastrados(diasSemana[index]) ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 8,
                          children: [
                            Text(
                              diasSemana[index],
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            verificarHorariosCadastrados(diasSemana[index]) ? Icon(Icons.check) : Icon(Icons.cancel),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
