/// Forward hatch pattern bar chart example.
///
/// The second series of bars is rendered with a pattern by defining a
/// fillPatternFn mapping function.
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:frappe_app/model/bao_cao_loi_nhuan_response.dart';

class ProfitReportBarChart extends StatelessWidget {
  final List<BaoCaoLoiNhuan> listProfitReport;

  const ProfitReportBarChart({
    Key? key,
    required this.listProfitReport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      handleData(),
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      vertical: false,
    );
  }

  /// Create series list with multiple series
  List<charts.Series<BaoCaoLoiNhuan, String>> handleData() {
    return [
      new charts.Series<BaoCaoLoiNhuan, String>(
          id: 'Incoming',
          domainFn: (BaoCaoLoiNhuan report, _) => report.date,
          measureFn: (BaoCaoLoiNhuan report, _) => report.profit,
          data: listProfitReport,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault),
    ];
  }
}
