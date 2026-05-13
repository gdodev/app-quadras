import 'package:flutter/material.dart';

class TelaFatiasHorariosFuncionamento extends StatefulWidget {
  const TelaFatiasHorariosFuncionamento({super.key});

  @override
  State<TelaFatiasHorariosFuncionamento> createState() => _TelaFatiasHorariosFuncionamentoState();
}

class _TelaFatiasHorariosFuncionamentoState extends State<TelaFatiasHorariosFuncionamento> {
  var horarioInicio = 0;
  var horarioFim = 6;
  var selecionandoHorarioInicio = true;

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
                        return GestureDetector(
                          onTap: () {
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
                              //.
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: horaInteiro >= horarioInicio ? Colors.green : Colors.red,
                              ),
                              child: Text(hora),
                            ),
                          ),
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              color: horaInteiro >= horarioInicio ? Colors.green : Colors.red,
                            ),
                            child: Text(hora),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
