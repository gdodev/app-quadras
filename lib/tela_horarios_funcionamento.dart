import 'package:app_quadras/tela_fatias_horarios_funcionamento.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Horários Funcionamento'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width * 0.35,
        child: ListView.builder(
          itemCount: diasSemana.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return TelaFatiasHorariosFuncionamento();
                    },
                  ),
                );
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Card(
                  child: Center(
                    child: Text(
                      diasSemana[index],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
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
