import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ChartScreen extends StatelessWidget {
  static const routeName = '/chart';

  const ChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? GenerateChartScreen()
      : SafeArea(child: GenerateChartScreen());
}

class GenerateChartScreen extends StatefulWidget {
  const GenerateChartScreen({Key? key}) : super(key: key);

  @override
  State<GenerateChartScreen> createState() => _GenerateChartScreenState();
}

class _GenerateChartScreenState extends State<GenerateChartScreen> {
  late List<Visits> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chart',
          style: TextStyle(color: Theme.of(context).textTheme.headline1?.color),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              // width: 400,
              child: SfCartesianChart(
                title: ChartTitle(
                  text: 'Visits in last month',
                  textStyle: TextStyle(
                      color: Theme.of(context).textTheme.headline1?.color,
                      fontSize: 20),
                ),
                tooltipBehavior: _tooltipBehavior,
                series: <ChartSeries>[
                  LineSeries<Visits, String>(
                      name: 'Visits',
                      dataSource: _chartData,
                      xValueMapper: (Visits visits, _) => visits.day,
                      yValueMapper: (Visits visits, _) => visits.visits,
                      enableTooltip: true,
                      color: Colors.orange)
                ],
                primaryXAxis: CategoryAxis(arrangeByIndex: true),
              ),
            ),
            Text(
              'Data Sheet',
              style: TextStyle(
                  fontSize: 22,
                  color: Theme.of(context).textTheme.headline1?.color),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                color: Theme.of(context).drawerTheme.backgroundColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Most visits - license plate:',
                        style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                      ),
                      Text(
                        'WE 116E2',
                        style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                color: Theme.of(context).drawerTheme.backgroundColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Most visits - index:',
                        style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                      ),
                      Text(
                        '27980',
                        style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                color: Theme.of(context).drawerTheme.backgroundColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Most visits - day:',
                        style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                      ),
                      Text(
                        '12-11-2022',
                        style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                color: Theme.of(context).drawerTheme.backgroundColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Least visits - day:',
                        style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                      ),
                      Text(
                        '11-11-2022',
                        style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                color: Theme.of(context).drawerTheme.backgroundColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Average of visits per day:',
                        style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                      ),
                      Text(
                        4.32312341.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Visits> getChartData() {
  final today = DateTime.now();
  final List<Visits> chartData = List.generate(
      30,
      (index) => Visits(
          DateFormat('dd-MM')
              .format(today.subtract(Duration(days: 29 - index))),
          Random().nextInt(300)));
  return chartData;
}

class Visits {
  String day;
  int visits;

  Visits(this.day, this.visits);
}
