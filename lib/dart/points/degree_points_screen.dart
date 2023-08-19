import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart'; // Import the pie chart package
import 'package:provider/provider.dart';
import '../degree/degree.dart';
import '../navigation/nav_bar.dart';
import '../pathway/pathway_state.dart';

class DegreesPointsScreen extends StatelessWidget {
  final List<Degree> degrees;

  const DegreesPointsScreen({Key? key, required this.degrees}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<PathwayState>(context, listen: false);


    // Calculate the total points from all majors
    final dataMap = <String, double>{};
    double totalPoints = 0;
    for (var pathway in state.savedPathways) {
    var degree = pathway.degree;
      for (var major in pathway.majors) {
        for(var papers in pathway.papers) {
          totalPoints += papers.points;
        }
        dataMap[major.name] = totalPoints;
      }
    }

    // Create the data map for the pie chart
 /*   final dataMap = <String, double>{};
    for (var degree in degrees) {
      for (var major in degree.majors) {
        dataMap[major.name] = major.totalPoints;
      }
    } */
    dataMap["Remaining Points"] = (360 - totalPoints);

    return Scaffold(
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        title: const Text('Points'),
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