import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HealthInsightsPanel extends StatefulWidget {
  final DateTime selectedDate;
  final Function(Map<String, dynamic>) onUpdateHealthMetrics;

  const HealthInsightsPanel({
    super.key,
    required this.selectedDate,
    required this.onUpdateHealthMetrics,
  });

  @override
  State<HealthInsightsPanel> createState() => _HealthInsightsPanelState();
}

class _HealthInsightsPanelState extends State<HealthInsightsPanel> {
  final Map<String, dynamic> _healthMetrics = {
    'weight': 70.0,
    'height': 175.0,
    'activityLevel': 'moderate',
    'sleepHours': 7.5,
    'stressLevel': 'low',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Health Insights',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildHealthMetricsCard(),
          const SizedBox(height: 16),
          _buildNutritionChart(),
          const SizedBox(height: 16),
          _buildHealthTips(),
        ],
      ),
    );
  }

  Widget _buildHealthMetricsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Metrics',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildMetricRow('Weight', '${_healthMetrics['weight']} kg'),
            _buildMetricRow('Height', '${_healthMetrics['height']} cm'),
            _buildMetricRow('Activity Level', _healthMetrics['activityLevel']),
            _buildMetricRow('Sleep', '${_healthMetrics['sleepHours']} hours'),
            _buildMetricRow('Stress Level', _healthMetrics['stressLevel']),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildNutritionChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Nutrition Overview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 3),
                        const FlSpot(1, 4),
                        const FlSpot(2, 3.5),
                        const FlSpot(3, 5),
                        const FlSpot(4, 4),
                        const FlSpot(5, 4.5),
                        const FlSpot(6, 4),
                      ],
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthTips() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Tips',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTipItem(
              'Stay Hydrated',
              'Drink at least 8 glasses of water daily',
              Icons.water_drop,
            ),
            _buildTipItem(
              'Get Moving',
              'Aim for 30 minutes of physical activity',
              Icons.directions_run,
            ),
            _buildTipItem(
              'Mindful Eating',
              'Take time to enjoy your meals',
              Icons.psychology,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
