import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prova/pages/abastecimentos/abastecimento_list_page.dart';
import 'package:prova/pages/abastecimentos/abastecimento_form_page.dart';
import 'package:prova/pages/veiculos_list_page.dart';

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

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Material(
                  color: Colors.blue.shade400,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => VeiculosListPage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: const [
                          Icon(Icons.car_repair, color: Colors.white),
                          SizedBox(width: 15),
                          Text(
                            "Meus Veículos",
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

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Material(
                  color: Colors.green.shade500,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AbastecimentoFormPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: const [
                          Icon(Icons.local_gas_station, color: Colors.white),
                          SizedBox(width: 15),
                          Text(
                            "Registrar Abastecimento",
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

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Material(
                  color: Colors.purple.shade400,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AbastecimentoListPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: const [
                          Icon(Icons.receipt_long, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Historico de Abastecimentos",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
}
