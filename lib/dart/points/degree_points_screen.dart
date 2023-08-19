import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart'; // Import the pie chart package
import '../degree/degree.dart';
import '../navigation/nav_bar.dart';

class DegreesPointsScreen extends StatelessWidget {
  final List<Degree> degrees;

  const DegreesPointsScreen({Key? key, required this.degrees}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data for pie chart. Replace this with your actual data.
    final dataMap = <String, double>{
      "Comp Sci": 90,
      "Finance": 54,
      "Music": 36,
      "Psych": 18,
    };

    return Scaffold(
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        title: const Text('Points'),
        backgroundColor: const Color(0xFF10428C),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: PieChart(
              dataMap: dataMap,
              chartType: ChartType.ring,
              chartRadius: MediaQuery.of(context).size.width / 2.5,
              ringStrokeWidth: 32,
              chartValuesOptions: const ChartValuesOptions(
                showChartValuesOutside: true,
                showChartValuesInPercentage: false,
              ),
              legendOptions: const LegendOptions(
                legendPosition: LegendPosition.bottom,
                showLegendsInRow: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}