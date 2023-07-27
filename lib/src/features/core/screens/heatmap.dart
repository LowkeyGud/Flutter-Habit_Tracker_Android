import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class Heatmap extends StatelessWidget {
  final Stream<List<DateTime>> completedDatesStream;
  final Map<int, Color> colorThresholds;

  const Heatmap({
    super.key,
    required this.completedDatesStream,
    required this.colorThresholds,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DateTime>>(
      stream: completedDatesStream,
      builder: (BuildContext context, AsyncSnapshot<List<DateTime>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final completedDates = snapshot.data ?? [];

        final Map<DateTime, int> heatmapData = {};
        for (var date in completedDates) {
          heatmapData[date] = 1;
        }

        return HeatMapCalendar(
          showColorTip: false,
          textColor: Colors.black,
          datasets: heatmapData,
          colorsets: colorThresholds,
        );
      },
    );
  }
}