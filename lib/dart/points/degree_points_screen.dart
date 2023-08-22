import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart'; // Import the pie chart package
import 'package:provider/provider.dart';
import '../navigation/nav_bar.dart';
import '../pathway/pathway.dart';
import '../pathway/pathway_state.dart';

class DegreesPointsScreen extends StatelessWidget {
  const DegreesPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<PathwayState>(context, listen: false);

    // Calculate the total points from all majors
    final dataMap = <String, double>{};
  
    double totalPoints = 0;
    if (state.savedPathways.isNotEmpty) {
      Pathway pathway = state.savedPathways[0];
      for (var major in pathway.majors) {
        totalPoints = 0;
        for (var paper in pathway.papers) {
          totalPoints += paper.points;
        }
        dataMap[major.name] = totalPoints;
      }
    }    

    // Calculate the remaining points
    dataMap["Remaining Points"] = (360 - totalPoints);
    
    return Scaffold(
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        title: const Text('Points'),
        backgroundColor: const Color(0xFF10428C),
      ),
      body: Column(
        children: [
          Expanded( // Wrap the PieChart with an Expanded widget
            child: Container(
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
          ),
        ],
      ),
    );
  }
}