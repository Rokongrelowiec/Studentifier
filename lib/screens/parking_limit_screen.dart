import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../widgets/app_bar_widget.dart';

class ParkingLimitScreen extends StatelessWidget {
  static const routeName = '/registered-license-plates-screen';

  const ParkingLimitScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? GenerateParkingLimitScreen()
      : SafeArea(
          child: GenerateParkingLimitScreen(),
        );
}

class GenerateParkingLimitScreen extends StatefulWidget {
  const GenerateParkingLimitScreen({Key? key}) : super(key: key);

  @override
  State<GenerateParkingLimitScreen> createState() =>
      _GenerateParkingLimitScreenState();
}

class _GenerateParkingLimitScreenState
    extends State<GenerateParkingLimitScreen> {
  final formKey = GlobalKey<FormState>();
  int parkingLimit = 0;
  int occupiedPlaces = 0;
  double percents = 0.0;

  TextEditingController limitController = TextEditingController();

  Future getData() async {
    final String apiKey =
        await DefaultAssetBundle.of(context).loadString('assets/api-key.txt');
    var response = await http.get(
      Uri.parse('http://130.61.192.162:8069/api/v1/parking_spots'),
      headers: {'x-api-key': apiKey},
    );
    var decodedResponse = jsonDecode(response.body);
    parkingLimit = decodedResponse[0]['limit'];

    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String month =
        (DateFormat.MMM().format(DateTime.now())).toUpperCase();
    final String year = (DateFormat.y().format(DateTime.now())).toString();
    dynamic requestBody =
        jsonEncode({'slice': '${month + year}', 'day': today});
    response = await http.post(
      Uri.parse('http://130.61.192.162:8069/api/v1/logs/entries/day'),
      headers: {'x-api-key': apiKey},
      body: requestBody,
    );
    decodedResponse = jsonDecode(response.body);
    // debugPrint(decodedResponse.toString());
    occupiedPlaces = decodedResponse.length;
    // debugPrint(occupiedPlaces.toString());
    percents = occupiedPlaces / parkingLimit;
    // debugPrint(percents.toString());
    limitController.text = parkingLimit.toString();
    setState(() {});
  }

  setCarParkingLimit() async {
    final String apiKey =
        await DefaultAssetBundle.of(context).loadString('assets/api-key.txt');
    var requestBody = jsonEncode({'limit': limitController.text});
    await http.post(
      Uri.parse('http://130.61.192.162:8069/api/v1/parking_spots/set'),
      headers: {'x-api-key': apiKey},
      body: requestBody,
    );
    await getData();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context)!.parking_limit,
        appBar: AppBar(),
        backFunction: () => Navigator.of(context).pop(),
      ),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onRefresh: getData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 3, vertical: sizeHeight),
                child: Text(
                  AppLocalizations.of(context)!.parking_description,
                  style: TextStyle(
                    fontSize: sizeHeight * 4,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline1?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: AssetImage('assets/images/car_parking.jpg'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: sizeHeight),
                child: Text(
                  AppLocalizations.of(context)!.parking_occupancy,
                  style: TextStyle(
                    fontSize: sizeHeight * 3,
                    color: Theme.of(context).textTheme.headline1?.color,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    sizeHeight, sizeHeight, sizeHeight, sizeHeight * 2),
                child: LinearPercentIndicator(
                  animation: true,
                  lineHeight: sizeHeight * 3,
                  animationDuration: 1200,
                  percent: percents,
                  center: Text('${(percents * 100).toStringAsFixed(2)}%'),
                  progressColor: Colors.orange,
                  barRadius: Radius.circular(20),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: sizeHeight, bottom: sizeHeight, right: 2, left: 2),
                child: Text(
                  '${AppLocalizations.of(context)!.current_limit}:'
                  ' $parkingLimit ${AppLocalizations.of(context)!.parking_spaces}',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline1?.color,
                    fontSize: sizeHeight * 3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      contentPadding: EdgeInsets.all(sizeHeight * 2),
                      buttonPadding: EdgeInsets.all(sizeHeight),
                      backgroundColor:
                          Theme.of(context).drawerTheme.backgroundColor,
                      title: Text(
                        AppLocalizations.of(context)!.change_limit,
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline1?.color,
                            fontSize: sizeHeight * 2.5),
                      ),
                      content: Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                            autofocus: true,
                            controller: limitController,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1?.color,
                              fontSize: sizeHeight * 2.5,
                            ),
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.onetwothree,
                                  color: Theme.of(context).iconTheme.color,
                                  size: sizeHeight * 4,
                                ),
                                labelText: 'Limit',
                                labelStyle: TextStyle(
                                  fontSize: sizeHeight * 3,
                                ),
                                contentPadding: EdgeInsets.all(
                                  sizeHeight * 2,
                                ),
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value == null ||
                                  int.tryParse(value) == null) {
                                return AppLocalizations.of(context)!
                                    .invalid_value;
                              }
                              if (int.parse(value) < occupiedPlaces) {
                                return AppLocalizations.of(context)!
                                    .limit_exceeded;
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              FilteringTextInputFormatter.deny(RegExp("^0")),
                            ],
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (String? newVal) async {
                              final isValidForm =
                                  formKey.currentState!.validate();
                              if (isValidForm) {
                                await setCarParkingLimit();
                                Navigator.of(context).pop();
                              }
                            }),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: TextStyle(
                              fontSize: sizeHeight * 2,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final isValidForm =
                                formKey.currentState!.validate();
                            if (isValidForm) {
                              await setCarParkingLimit();
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              fontSize: sizeHeight * 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.change_limit,
                  style: TextStyle(
                    fontSize: sizeHeight * 2.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      //   }
      // }),
    );
  }
}
