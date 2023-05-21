import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/app_bar_widget.dart';

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
  late List<Visits> chartData;
  late TooltipBehavior _tooltipBehavior;
  int visitsCounter = 0;
  late int minVisitsNum;
  int maxVisitsNum = 0;
  num average = 0;
  String minVisitsDay = '';
  String maxVisitsDay = '';
  String mostVisitsLicensePlate = '';
  var mostVisitsStudentId;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context)!.chart,
        appBar: AppBar(),
        backFunction: () => Navigator.of(context).pop(),
      ),
      body: FutureBuilder(
          future: getChartData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Center(child: SizedBox(
                  height: sizeHeight * 25,
                    width: sizeHeight * 25,
                    child: CircularProgressIndicator())),
              );
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                AppLocalizations.of(context)!.fetch_failed,
                style: TextStyle(
                    color: Theme.of(context).textTheme.displayLarge?.color,
                    fontSize: sizeHeight * 4,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ));
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: sizeHeight * 50,
                      child: SfCartesianChart(
                        title: ChartTitle(
                          text: AppLocalizations.of(context)!.last_month_visits,
                          textStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.displayLarge?.color,
                              fontSize: sizeHeight * 3),
                        ),
                        tooltipBehavior: _tooltipBehavior,
                        series: <ChartSeries>[
                          LineSeries<Visits, String>(
                              name: AppLocalizations.of(context)!.visits,
                              dataSource: chartData,
                              xValueMapper: (Visits visits, _) => visits.day,
                              yValueMapper: (Visits visits, _) => visits.visits,
                              enableTooltip: true,
                              color: Colors.orange)
                        ],
                        primaryXAxis: CategoryAxis(arrangeByIndex: true),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.data_sheet,
                      style: TextStyle(
                          fontSize: sizeHeight * 3,
                          color: Theme.of(context).textTheme.displayLarge?.color),
                    ),
                    SizedBox(
                      height: sizeHeight,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        color: Theme.of(context).drawerTheme.backgroundColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: sizeHeight * 0.6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.most_visits} - ${AppLocalizations.of(context)!.license_plate}:',
                                style: TextStyle(
                                    fontSize: sizeHeight * 2,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color),
                              ),
                              Text(
                                mostVisitsLicensePlate,
                                style: TextStyle(
                                    fontSize: sizeHeight * 2,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        color: Theme.of(context).drawerTheme.backgroundColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: sizeHeight * 0.6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.most_visits} - ${AppLocalizations.of(context)!.index.toLowerCase()}:',
                                style: TextStyle(
                                    fontSize: sizeHeight * 2,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color),
                              ),
                              Text(
                                mostVisitsStudentId.toString(),
                                style: TextStyle(
                                    fontSize: sizeHeight * 2,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        color: Theme.of(context).drawerTheme.backgroundColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: sizeHeight * 0.6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.most_visits} - ${AppLocalizations.of(context)!.day}:',
                                style: TextStyle(
                                    fontSize: sizeHeight * 2,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color),
                              ),
                              Text(
                                maxVisitsDay,
                                style: TextStyle(
                                    fontSize: sizeHeight * 2,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        color: Theme.of(context).drawerTheme.backgroundColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: sizeHeight * 0.6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.least_visits} - ${AppLocalizations.of(context)!.day}:',
                                style: TextStyle(
                                    fontSize: sizeHeight * 2,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color),
                              ),
                              Text(
                                minVisitsDay,
                                style: TextStyle(
                                    fontSize: sizeHeight * 2,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        color: Theme.of(context).drawerTheme.backgroundColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: sizeHeight * 0.6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.avg_per_day}:',
                                style: TextStyle(
                                    fontSize: sizeHeight * 2,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color),
                              ),
                              Text(
                                average.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: sizeHeight * 2,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  getChartData() async {
    String key = await rootBundle.loadString('assets/api-key.txt');
    String month = (DateFormat.MMM().format(DateTime.now())).toUpperCase();
    String year = (DateFormat.y().format(DateTime.now())).toString();
    var requestBody = jsonEncode({"period": "${month + year}"});
    var response = await http.post(
        Uri.parse('http://130.61.192.162:8069/api/v1/logs/entries/month'),
        headers: {'x-api-key': '$key'},
        body: requestBody);
    var decodedResponse = jsonDecode(response.body);
    int endDate = DateTime.now().day;
    var startDate = DateFormat('dd').format(
        DateTime.now().subtract(Duration(days: DateTime.now().day - 1)));
    // debugPrint(decodedResponse.toString());
    String formattedDay;
    String formattedMonth;
    for (int i = int.parse(startDate); i <= endDate; i++) {
      try {
        if (int.parse(decodedResponse[i - 1]['dataPrzyjazdu'].substring(8)) != i) {
          formattedDay = i.toString().length == 1 ? '0$i' : i.toString();
          formattedMonth = DateTime.now().month.toString().length == 1
              ? '0${DateTime.now().month}'
              : DateTime.now().month.toString();
          decodedResponse.insert(i - 1, {
            'dataPrzyjazdu': '${DateTime.now().year}-$formattedMonth-$formattedDay',
            'count': 0
          });
        }
      } catch (e) {
        formattedDay = i.toString().length == 1 ? '0$i' : i.toString();
        formattedMonth = DateTime.now().month.toString().length == 1
            ? '0${DateTime.now().month}'
            : DateTime.now().month.toString();
        decodedResponse.add({'dataPrzyjazdu': '${DateTime.now().year}-$formattedMonth-$formattedDay',
          'count': 0});
      }
    }
    // debugPrint(decodedResponse.toString());
    visitsCounter = 0; // control set
    minVisitsNum = decodedResponse[0]['count'];
    minVisitsDay = "${decodedResponse[0]['dataPrzyjazdu'].substring(8)}"
        "-${decodedResponse[0]['dataPrzyjazdu'].substring(5, 7)}"
        "-${decodedResponse[0]['dataPrzyjazdu'].substring(0, 4)}";
    for (int i = 0; i < decodedResponse.length; i++) {
      visitsCounter += decodedResponse[i]['count'] as int;
      if (decodedResponse[i]['count'] > maxVisitsNum) {
        maxVisitsNum = decodedResponse[i]['count'];
        maxVisitsDay = "${decodedResponse[i]['dataPrzyjazdu'].substring(8)}"
            "-${decodedResponse[i]['dataPrzyjazdu'].substring(5, 7)}"
            "-${decodedResponse[i]['dataPrzyjazdu'].substring(0, 4)}";
      }
      if (decodedResponse[i]['count'] < minVisitsNum) {
        minVisitsNum = decodedResponse[i]['count'];
        minVisitsDay = "${decodedResponse[i]['dataPrzyjazdu'].substring(8)}"
            "-${decodedResponse[i]['dataPrzyjazdu'].substring(5, 7)}"
            "-${decodedResponse[i]['dataPrzyjazdu'].substring(0, 4)}";
      }
    }
    average = visitsCounter / endDate;
    chartData = List.generate(
        decodedResponse.length,
        (index) => Visits(
            "${decodedResponse[index]['dataPrzyjazdu'].substring(8)}-${decodedResponse[index]['dataPrzyjazdu'].substring(5, 7)}",
            decodedResponse[index]['count']));

    requestBody = jsonEncode({"period": "${month + year}"});
    response = await http.post(
        Uri.parse('http://130.61.192.162:8069/api/v1/logs/entries/month/top'),
        headers: {'x-api-key': '$key'},
        body: requestBody);
    decodedResponse = jsonDecode(response.body);
    mostVisitsLicensePlate = decodedResponse[0]['rejestracja'];

    requestBody = jsonEncode({"licenseplate": "$mostVisitsLicensePlate"});
    response = await http.post(
        Uri.parse(
            'http://130.61.192.162:8069/api/v1/vehicles/licenseplates/checkone'),
        headers: {'x-api-key': '$key'},
        body: requestBody);
    decodedResponse = jsonDecode(response.body);
    mostVisitsStudentId = decodedResponse[0]['numer_albumu'];
    return chartData;
  }
}

class Visits {
  String day;
  int visits;

  Visits(this.day, this.visits);
}
