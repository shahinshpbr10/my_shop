import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChatMyBuild extends StatelessWidget {
  final List<dynamic> weeklySummary;

  const BarChatMyBuild({
    super.key,
    required this.weeklySummary,
  });

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      sunAmount: weeklySummary[0],
      monAmount: weeklySummary[1],
      tueAmount: weeklySummary[2],
      wedAmount: weeklySummary[3],
      thursAmount: weeklySummary[4],
      friAmount: weeklySummary[5],
      satAmount: weeklySummary[6],
    );
    myBarData.initializeBarData();

    return Column(
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: BarChart(
            BarChartData(
              maxY: 100,
              minY: 0,
              gridData: const FlGridData(
                show: false,
              ),
              titlesData: const FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getBottomTitles,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: myBarData.barData
                  .map(
                    (data) => BarChartGroupData(
                      x: data.x,
                      barRods: [
                        BarChartRodData(
                          toY: data.barRods[0].toY, // Corrected line
                          width: 15,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 100,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Weekly",
        ),
      ],
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text(
        "S",
        style: style,
      );
      break;
    case 1:
      text = const Text(
        "M",
        style: style,
      );
      break;
    case 2:
      text = const Text(
        "T",
        style: style,
      );
      break;
    case 3:
      text = const Text(
        "W",
        style: style,
      );
      break;
    case 4:
      text = const Text(
        "T",
        style: style,
      );
      break;
    case 5:
      text = const Text(
        "F",
        style: style,
      );
      break;
    case 6:
      text = const Text(
        "S",
        style: style,
      );
      break;
    default:
      text = const Text(
        "",
        style: style,
      );
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

class BarData {
  int sunAmount;
  int monAmount;
  int tueAmount;
  int wedAmount;
  int thursAmount;
  int friAmount;
  int satAmount;

  List<BarChartGroupData> barData = [];

  BarData({
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thursAmount,
    required this.friAmount,
    required this.satAmount,
  });

  void initializeBarData() {
    barData = [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: sunAmount.toDouble(),
            width: 15,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: monAmount.toDouble(),
            width: 15,
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            toY: tueAmount.toDouble(),
            width: 15,
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
            toY: wedAmount.toDouble(),
            width: 15,
          ),
        ],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [
          BarChartRodData(
            toY: thursAmount.toDouble(),
            width: 15,
          ),
        ],
      ),
      BarChartGroupData(
        x: 5,
        barRods: [
          BarChartRodData(
            toY: friAmount.toDouble(),
            width: 15,
          ),
        ],
      ),
      BarChartGroupData(
        x: 6,
        barRods: [
          BarChartRodData(
            toY: satAmount.toDouble(),
            width: 15,
          ),
        ],
      ),
    ];
  }
}
