import 'package:flutter/material.dart';
//import 'package:listacontatos/pages/contato_detalhes_page.dart';
import 'package:listacontatos/routes/app_routes.dart';
import 'pages/contato_page.dart';
import 'pages/detalhes_contato_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      //home: const ContatoPage(),
      routes: {
        AppRoutes.home: (_) => const ContatoPage(),
        AppRoutes.userForm: (_) => const DetalhesContatoPage(),
      },
    );
  }
}
