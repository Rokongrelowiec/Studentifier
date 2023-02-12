import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ChartScreen extends StatelessWidget {
  static const routeName = '/chart';

  const ChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Platform.isIOS
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
  int visitsCounter=0;
  late int minVisitsNum;
  int maxVisitsNum=0;
  num average=0;
  String minVisitsDay='';
  String maxVisitsDay='';
  String mostVisitsLicensePlate='';
  var mostVisitsStudentId;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chart',
          style: TextStyle(color: Theme
              .of(context)
              .textTheme
              .headline1
              ?.color),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme
                .of(context)
                .iconTheme
                .color,
          ),
        ),
      ),
      body: FutureBuilder(
          future: getChartData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                    'Sorry\nCould not fetch the data',
                    style: TextStyle(
                        color: Theme
                            .of(context)
                            .textTheme
                            .headline1
                            ?.color,
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ));
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 400,
                      // width: 400,
                      child: SfCartesianChart(
                        title: ChartTitle(
                          text: 'Visits in last month',
                          textStyle: TextStyle(
                              color:
                              Theme
                                  .of(context)
                                  .textTheme
                                  .headline1
                                  ?.color,
                              fontSize: 20),
                        ),
                        tooltipBehavior: _tooltipBehavior,
                        series: <ChartSeries>[
                          LineSeries<Visits, String>(
                              name: 'Visits',
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
                      'Data Sheet',
                      style: TextStyle(
                          fontSize: 22,
                          color: Theme
                              .of(context)
                              .textTheme
                              .headline1
                              ?.color),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        color: Theme
                            .of(context)
                            .drawerTheme
                            .backgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Most visits - license plate:',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .headline1
                                        ?.color),
                              ),
                              Text(
                                mostVisitsLicensePlate,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .headline1
                                        ?.color),
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
                        color: Theme
                            .of(context)
                            .drawerTheme
                            .backgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Most visits - index:',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .headline1
                                        ?.color),
                              ),
                              Text(
                                mostVisitsStudentId.toString(),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .headline1
                                        ?.color),
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
                        color: Theme
                            .of(context)
                            .drawerTheme
                            .backgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Most visits - day:',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .headline1
                                        ?.color),
                              ),
                              Text(
                                maxVisitsDay,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .headline1
                                        ?.color),
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
                        color: Theme
                            .of(context)
                            .drawerTheme
                            .backgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Least visits - day:',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .headline1
                                        ?.color),
                              ),
                              Text(
                                minVisitsDay,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .headline1
                                        ?.color),
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
                        color: Theme
                            .of(context)
                            .drawerTheme
                            .backgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Average of visits per day:',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .headline1
                                        ?.color),
                              ),
                              Text(
                                average.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .headline1
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

    // }
    // );
  }

  getChartData() async {
    String key = await rootBundle.loadString('assets/api-key.txt');
    var requestBody = jsonEncode({"period": "FEB2023"});
    var response = await http.post(
        Uri.parse('http://130.61.192.162:8069/api/v1/logs/entries/month'),
        headers: {'x-api-key': '$key'},
        body: requestBody);
    var decodedResponse = jsonDecode(response.body);
    visitsCounter = 0; // control set
    minVisitsNum = decodedResponse[0]['count'];
    minVisitsDay = "${decodedResponse[0]['dataPrzyjazdu'].substring(8)}"
        "-${decodedResponse[0]['dataPrzyjazdu'].substring(5, 7)}"
        "-${decodedResponse[0]['dataPrzyjazdu'].substring(0, 4)}";
    for (int i=0; i<decodedResponse.length; i++) {
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
    int date = DateTime.now().day;
    average = visitsCounter / date;
    chartData = List.generate(
        decodedResponse.length,
            (index) =>
            Visits(
                "${decodedResponse[index]['dataPrzyjazdu'].substring(
                    8)}-${decodedResponse[index]['dataPrzyjazdu'].substring(
                    5, 7)}",
                decodedResponse[index]['count']));

    requestBody = jsonEncode({"period": "FEB2023"});
    response = await http.post(
        Uri.parse('http://130.61.192.162:8069/api/v1/logs/entries/month/top'),
        headers: {'x-api-key': '$key'},
        body: requestBody);
    decodedResponse = jsonDecode(response.body);
    mostVisitsLicensePlate = decodedResponse[0]['rejestracja'];

    requestBody = jsonEncode({"licenseplate": "$mostVisitsLicensePlate"});
    response = await http.post(
        Uri.parse('http://130.61.192.162:8069/api/v1/vehicles/licenseplates/checkone'),
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
