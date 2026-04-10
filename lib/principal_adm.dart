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
    );
  }
}
