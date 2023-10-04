import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import '../navigation/nav_bar.dart';
import '../paper/paper.dart';
import '../pathway/pathway.dart';
import '../pathway/pathway_state.dart';

class DegreesPointsScreen extends StatelessWidget {
  const DegreesPointsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<PathwayState>(context, listen: false);

    return Scaffold(
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        title: const Text('Points'),
        backgroundColor: const Color(0xFF10428C),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: state.savedPathways.length,
              itemBuilder: (context, index) {
                final pathway = state.savedPathways[index];
                final dataMap = <String, double>{};
                double totalPoints = 0;

                // Calculate total points for the current pathway
                for (var major in pathway.majors) {
                  List<Paper> allPapers = [];
                  pathway.selectedPapers.forEach((level, papers) {
                    allPapers.addAll(papers);
                  });

                  for (var paper in allPapers) {
                    totalPoints += paper.points;
                  }
                  dataMap[major.name] = totalPoints;
                }

                // Calculate remaining points for the current pathway
                dataMap["Remaining Points"] = (360 - totalPoints);

                // Return a PieChart for the current pathway
                return Container(
                  padding: const EdgeInsets.only(top: 48, bottom: 16),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
