import 'package:app_quadras/cadastro_quadra.dart';
import 'package:app_quadras/tela_esportes.dart';
import 'package:app_quadras/tela_quadras.dart';
import 'package:flutter/material.dart';

class TelaPrincipalAdm extends StatefulWidget {
  const TelaPrincipalAdm({super.key});

  @override
  State<TelaPrincipalAdm> createState() => _TelaPrincipalAdmState();
}

class _TelaPrincipalAdmState extends State<TelaPrincipalAdm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela principal Adm"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Text("Nome do usuário"),
                  Text("Nível de acesso"),
                ],
              ),
            ),
            ListTile(
              title: Text("Quadras"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return TelaQuadras();
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Esportes"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return TelaEsportes();
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Horários de funcionamento"),
            ),
            ListTile(
              title: Text("Relatórios"),
            ),
          ],
        ),
      ),
    );
  }
}
