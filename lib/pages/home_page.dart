import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:prova/pages/abastecimentos/abastecimento_list_page.dart';
import 'package:prova/pages/abastecimentos/abastecimento_form_page.dart';
import 'package:prova/pages/veiculos_list_page.dart';
import 'package:prova/pages/grafico_custos_page.dart';

import '../services/auth_service.dart';
import 'login_pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Página Inicial")),

      drawer: Drawer(
        child: Container(
          color: Colors.grey.shade100,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.lightBlueAccent],
                  ),
                ),
                accountName: Text(
                  user?.email ?? "Usuário",
                  style: const TextStyle(fontSize: 18),
                ),
                accountEmail: const Text("Bem-vindo ao sistema!"),
                currentAccountPicture: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    user?.email != null ? user!.email![0].toUpperCase() : "?",
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),

              _menuButton(
                context,
                color: Colors.blue.shade400,
                icon: Icons.car_repair,
                text: "Meus Veículos",
                page: VeiculosListPage(),
              ),

              _menuButton(
                context,
                color: Colors.green.shade500,
                icon: Icons.local_gas_station,
                text: "Registrar Abastecimento",
                page: const AbastecimentoFormPage(),
              ),

              _menuButton(
                context,
                color: Colors.purple.shade400,
                icon: Icons.receipt_long,
                text: "Histórico de Abastecimentos",
                page: const AbastecimentoListPage(),
                fontSize: 16,
              ),

              _menuButton(
                context,
                color: Colors.orange.shade400,
                icon: Icons.bar_chart,
                text: "Gráfico de Custos",
                page: const GraficoCustosPorVeiculo(),
              ),

              const SizedBox(height: 20),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Material(
                  color: Colors.red.shade500,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      await AuthService().signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                        (_) => false,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: const [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(width: 15),
                          Text(
                            "Sair",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fundo3.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            "Olá ${user?.email ?? "Usuário"}!\nUse o menu lateral para navegar.",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 8,
                  color: Colors.black,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuButton(
    BuildContext context, {
    required Color color,
    required IconData icon,
    required String text,
    required Widget page,
    double fontSize = 18,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => page));
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 15),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
