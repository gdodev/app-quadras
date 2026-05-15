import 'package:app_quadras/componente_horario.dart';
import 'package:app_quadras/horario_funcionamento.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TelaFatiasHorariosFuncionamento extends StatefulWidget {
  const TelaFatiasHorariosFuncionamento({super.key, required this.descricaoDia, this.horarioFuncionamento});

  final String descricaoDia;
  final HorarioFuncionamento? horarioFuncionamento;

  @override
  State<TelaFatiasHorariosFuncionamento> createState() => _TelaFatiasHorariosFuncionamentoState();
}

class _TelaFatiasHorariosFuncionamentoState extends State<TelaFatiasHorariosFuncionamento> {
  var horarioInicio = 0;
  var horarioFim = 23;
  var selecionandoHorarioInicio = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.horarioFuncionamento != null) {
      setState(() {
        horarioInicio = widget.horarioFuncionamento!.horarioInicio;
        horarioFim = widget.horarioFuncionamento!.horarioFim;
      });
    }
  }

  void selecionarHorario(int horaInteiro) {
    if (selecionandoHorarioInicio) {
      if (horaInteiro < horarioFim) {
        setState(() {
          horarioInicio = horaInteiro;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog.adaptive(
              title: Text('Atenção'),
              content: Text('Horário de início não pode ser superior ao horário de fim.'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Fechar'),
                ),
              ],
            );
          },
        );
      }
    } else {
      if (horaInteiro > horarioInicio) {
        setState(() {
          horarioFim = horaInteiro;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog.adaptive(
              title: Text('Atenção'),
              content: Text('Horário de fim não pode ser inferior ao horário de início.'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Fechar'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Color? getHorarioColor(int horaInteiro) {
    return horaInteiro >= horarioInicio && horaInteiro <= horarioFim ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final horarios = <String>[];

    for (var i = 0; i < 24; i++) {
      horarios.add('${i.toString().padLeft(2, '0')}:00');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Fatias Horários Funcionamento'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selecionandoHorarioInicio = true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: selecionandoHorarioInicio ? Colors.amber : null,
                  ),
                  child: Text('Início'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selecionandoHorarioInicio = false;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: selecionandoHorarioInicio ? null : Colors.amber,
                  ),
                  child: Text('Fim'),
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.0,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                  child: ListView(
                    children: horarios.take(12).map(
                      (hora) {
                        // print('hora: "${hora.substring(0, 2)}"');
                        var horaInteiro = int.parse(hora.substring(0, 2));
                        return ComponenteHorario(
                          clickContainer: () {
                            selecionarHorario(horaInteiro);
                          },
                          textoHorario: '${horaInteiro.toString().padLeft(2, '0')}:00',
                          containerColor: getHorarioColor(horaInteiro),
                        );
                      },
                    ).toList(),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                  child: ListView(
                    children: horarios.getRange(12, 24).map(
                      (hora) {
                        // print('hora: "${hora.substring(0, 2)}"');
                        var horaInteiro = int.parse(hora.substring(0, 2));
                        return ComponenteHorario(
                          clickContainer: () {
                            selecionarHorario(horaInteiro);
                          },
                          textoHorario: '$horaInteiro:00',
                          containerColor: getHorarioColor(horaInteiro),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final supabase = Supabase.instance.client;
              if (widget.horarioFuncionamento != null) {
                // update
                await supabase
                    .from("horario_funcionamento")
                    .update({
                      "horario_inicio": horarioInicio,
                      "horario_fim": horarioFim,
                    })
                    .eq("id", widget.horarioFuncionamento!.id!);
              } else {
                await supabase
                    .from("horario_funcionamento") //
                    .insert({
                      'descricao': widget.descricaoDia,
                      'horario_inicio': horarioInicio,
                      'horario_fim': horarioFim,
                    });
              }
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
