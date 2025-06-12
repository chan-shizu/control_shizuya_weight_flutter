import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_shizuya_weight_flutter/api/models/weight_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<WeightModel> weights = [];
  late FirebaseFirestore firestore;
  late CollectionReference<Map<String, dynamic>> collection;

  Future<void> fetchWeights() async {
    final snapshot = await collection.get();
    setState(() {
      weights = snapshot.docs
          .map((doc) => WeightModel.fromFirestore(doc))
          .toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    });
  }

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    collection = firestore.collection('weight');
    fetchWeights();
  }

  Widget _buildWeightChart() {
    if (weights.isEmpty) {
      return const Center(
        child: Text('データがありません'),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade100,
              strokeWidth: 0.5,
              dashArray: [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              interval: 5,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    value.toStringAsFixed(0),
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: weights.length > 10 ? 2 : 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < weights.length) {
                  final date = weights[value.toInt()].createdAt;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${date.month}/${date.day}',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        minY: 60,
        maxY: 80,
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: weights.asMap().entries.map((entry) {
              return FlSpot(
                entry.key.toDouble(),
                entry.value.weight,
              );
            }).toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.8),
                Theme.of(context).primaryColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            barWidth: 3.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4.5,
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 2.5,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.2),
                  Theme.of(context).primaryColor.withOpacity(0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.shade800.withOpacity(0.9),
            tooltipRoundedRadius: 8,
            tooltipPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final date = weights[spot.x.toInt()].createdAt;
                return LineTooltipItem(
                  '${date.month}/${date.day}\n${spot.y.toStringAsFixed(1)}kg',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
          touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
            // タッチイベントの処理を追加できます
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
      ),
      body: Column(
        children: [
          // グラフを表示
          Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: _buildWeightChart(),
          ),
          // グラフとリストの間の区切り線
          const SizedBox(height: 32),
          // 体重記録リスト
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final item = weights[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${item.createdAt.year}年${item.createdAt.month}月${item.createdAt.day}日',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${item.weight}kg',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: weights.length,
            ),
          ),
        ],
      ),
    );
  }
}
