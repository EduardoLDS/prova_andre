import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoCustosPorVeiculo extends StatelessWidget {
  const GraficoCustosPorVeiculo({super.key});

  Future<Map<String, double>> _getCustos() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return {};

    final query = await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(user.uid)
        .collection("abastecimentos")
        .get();

    Map<String, double> somaPorVeiculo = {};

    for (var doc in query.docs) {
      final data = doc.data();

      final String veiculoId = data["veiculoId"]?.toString() ?? "Sem ID";

      final dynamic bruto = data["valorPago"];
      double valor = 0;

      if (bruto is int)
        valor = bruto.toDouble();
      else if (bruto is double)
        valor = bruto;
      else if (bruto is String)
        valor = double.tryParse(bruto.replaceAll(",", ".")) ?? 0;

      somaPorVeiculo[veiculoId] = (somaPorVeiculo[veiculoId] ?? 0) + valor;
    }

    return somaPorVeiculo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gráfico de Custos por Veículo")),
      body: FutureBuilder<Map<String, double>>(
        future: _getCustos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final dados = snapshot.data!;
          final veiculos = dados.keys.toList();
          final valores = dados.values.toList();

          if (veiculos.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum abastecimento encontrado.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 350,
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipPadding: const EdgeInsets.all(10),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${veiculos[groupIndex]}\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'R\$ ${valores[groupIndex].toStringAsFixed(2)}',
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index < 0 || index >= veiculos.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              veiculos[index],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(
                    veiculos.length,
                    (i) => BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: valores[i],
                          width: 22,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
